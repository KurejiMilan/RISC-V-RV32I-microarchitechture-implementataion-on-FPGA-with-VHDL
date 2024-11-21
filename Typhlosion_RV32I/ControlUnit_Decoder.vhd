library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity ControlUnit_Decoder is
    Port ( 	-- this is used as the input for control
				uOp_in : in  STD_LOGIC_VECTOR (4 downto 0);
				current_instruction : in std_logic_vector(31 downto 0);
				instruction_cycle : in std_logic;													-- con
				data_in : in std_logic_vector(31 downto 0) := (others=>'Z');
				
				-- control unit outputs immediate data to the immediate register
				imm : out std_logic_vector(31 downto 0) := X"00000000";						
				
				
				-- control bus signals
				load_imm, enable_imm : out std_logic := '0';									-- immediate register
				load_ins : out std_logic_vector(3 downto 0) := X"0";                         -- instrution  register
				en_pc : out std_logic := '0';														-- program counter
				pc_clock : out std_logic := '0';
				ld_pc : out std_logic := '0';
				
				-- signal realted to ALU
				unsign_comp, sl, sr, arith, xor_sel, and_sel, or_sel, comp_sel, addr_add, equal : out std_logic := '0';					
				load_a, load_b , load_acc, enable_acc : out std_logic := '0';                                      -- registers
				
				reset_uOp : out std_logic := '0';	-- con																			-- uOp counter
				inc_ic : out std_logic := '0';		-- con																						-- instruction cycle counter
				
				-- signals related to register banks
				reg_address_sel : out std_logic_vector(1 downto 0) := (others => '0'); --con							-- register bank
				write_reg : out std_logic := '0';				-- con
				read_reg : out std_logic := '0';				-- con
				
				-- signal related to bus interface
				core_bus_enable : out std_logic := '0';		-- con																						-- external_bus_interface_module
				core_reg_data_in : out std_logic := '0';	-- con
				
				mem_reg_data_in : out std_logic_vector(3 downto 0) := (others=>'0');		-- con
				mem_bus_enable : out std_logic_vector(3 downto 0) := (others=>'0');			-- con
				
				-- signal related to memory operation
				mem_read : out std_logic := '0';
				mem_write : out std_logic := '0';
				mem_clock : out std_logic := '0';
				
				-- PC buffer register
				enable_pcbr, load_pcbr : out std_logic := '0'
				
			  );
end ControlUnit_Decoder;

architecture Behavioral of ControlUnit_Decoder is
	signal immediate_con_channel : std_logic_vector(31 downto 0) := (others => '0');
	signal data_in_reg : std_logic_vector(31 downto 0) := (others => '0');
begin

	imm <= immediate_con_channel;
	
	-- PROCESS FOR DECODER
	
	Decoder_unit: process(uOp_in, instruction_cycle, current_instruction)
	begin
	
		case instruction_cycle is
			
			when '0' =>
				-- instruciton fetch cycle
				if uOp_in = "00000" then
					reset_uOp <= '0';
					inc_ic <= '0';
					en_pc <= '1';										-- enabling the PROGRAM COUNTER
					mem_read <= '0';
					
				elsif uOp_in = "00001" then
					mem_read <= '1';									-- control signal to perform read operation from the memory location pointed by the PC

				elsif uOp_in = "00010" then
					load_ins <= x"1";									-- load the LSB 8 bit
				
				elsif uOp_in = "00011" then
					load_ins <= x"0";									-- change control signal to 0
					mem_read <= '0';
					pc_clock <= '1';									-- increment the PC counter

				elsif uOp_in = "00100" then
					pc_clock <= '0';									-- change control signal to 0
					mem_read <= '1';
					
				elsif uOp_in = "00101" then
					load_ins <= x"2";	
					
				elsif uOp_in = "00110" then
					load_ins <= x"0";
					mem_read <= '0';
					pc_clock <= '1'; 									-- increment the PC counter
					
				elsif uOp_in = "00111" then
					pc_clock <= '0';									
					mem_read <= '1';
				
				elsif uOp_in = "01000" then
					load_ins <= x"4";									-- load in the next 8 bit instrctuion				
				
				elsif uOp_in = "01001" then
					load_ins <= x"0";									
					mem_read <= '0';
					pc_clock <= '1';
					
				elsif uOp_in = "01010" then
					pc_clock <= '0';
					mem_read <= '1';
				
				elsif uOp_in = "01011" then
					load_ins <= x"8";
					
				elsif uOp_in = "01100" then									
					load_ins <= x"0";									-- load the MSB 8 bit of instruction
					mem_read <= '0';
					en_pc <= '0';										-- disable program counter
					
				elsif uOp_in = "01101" then
					reset_uOp <= '1';
					inc_ic <= '1';                      		-- this sets up the instruction cycles to be in the decode and execute cycle
				end if;
				
			
			-- 
			--
			-- Instruction DECODE and EXECUTE cycle
			--
			--
			when others =>
			-- regardles of what instruciton is to be executed we need to set the reset_uOp to 0 and inc_ic to  0;
				if uOp_in = "00000" then
					reset_uOp <= '0';
					inc_ic <= '0';
				end if;
				
				case current_instruction(6 downto 0) is
					
					-- START OF DECODE AND EXECUTE R-TYPE INSTRUCTION
					when "0110011" => 
						if 	uOp_in = "00000" then
							reg_address_sel <= "10";                              -- select the source register R1
							read_reg <= '1';													-- outputing the data of source register
						elsif uOp_in = "00001" then
							load_a <= '1';														-- loading the content of R1 to register A
						elsif uOp_in = "00010" then
							reg_address_sel <= "11";										-- select the source register R2
							load_a <= '0';
						elsif uOp_in = "00011" then
							load_b <= '1';														-- loading the content of R2 to register B
						elsif uOp_in = "00100" then
							load_b <= '0';
							read_reg <= '0';
						elsif uOp_in = "00101" then
							
							case current_instruction(14 downto 12) is
								
								-- ADD or SUBB depending upon the instruction(30)
								when "000" =>
									arith <= '1';
								
								-- SLL
								when "001" =>
									sl <= '1';
								
								-- SLT
								when "010" =>
									comp_sel <= '1';
									
								-- SLTU
								when "011" =>
									comp_sel <= '1';
									unsign_comp <= '1';
									
								-- XOR
								when "100" =>
									xor_sel <= '1';
									
								-- SRL OR SRA
								when "101" =>
									sr <= '1';
 								-- OR
								when "110" =>
									or_sel <= '1';
									
								-- AND
								when "111" =>
									and_sel <= '1';
								
								when others =>
								-- do nothing
							end case;
							
						elsif uOp_in = "00110" then
							load_acc <= '1';												-- load the result
							enable_acc <= '1';											-- enable the accumulator to output the accumulator
							reg_address_sel <= "01";									-- select the destination register
						
						elsif uOp_in = "00111" then
							write_reg <= '1';
							
						elsif uOp_in = "01000" then
							load_acc <= '0';
							enable_acc <= '0';
							write_reg <= '0';
							reg_address_sel <= "00";
							pc_clock <= '1';
							case current_instruction(14 downto 12) is	
								-- ADD or SUBB depending upon the instruction(30)
								when "000" =>
									arith <= '0';
								-- SLL
								when "001" =>
									sl <= '0';
								-- SLT
								when "010" =>
									comp_sel <= '0';
								-- SLTU
								when "011" =>
									comp_sel <= '0';
									unsign_comp <= '0';
								-- XOR
								when "100" =>
									xor_sel <= '0';
								-- SRL OR SRA
								when "101" =>
									sr <= '0';
 								-- OR
								when "110" =>
									or_sel <= '0';
								-- AND
								when "111" =>
									and_sel <= '0';
								when others =>
									-- do nothing
							end case;

						elsif uOp_in = "01001" then
							load_pcbr <= '1';
							pc_clock <= '0';
						elsif uOp_in = "01010" then
							load_pcbr <= '0';
							reset_uOp <= '1';
							inc_ic <= '1';
						end if;
						
					-- END OF DECODE AND EXECUTE R-TYPE INSTRUCTION
					
					-- START DECODING OF I-TYPE ARITH AND LOGICAL INSTRUCTION
					
					when "0010011" =>
						case current_instruction(14 downto 12) is
							-- ADDI
							when "000"=>
								if uOp_in = 	"00000" then
									reg_address_sel <= "10";                              -- select the source register R1
									read_reg <= '1';													-- outputing the data of source register
								elsif uOp_in = "00001" then
									load_a <= '1';														-- load into reg A
								elsif uOp_in = "00010" then
									load_a <= '0';
									read_reg <= '0';													-- need to disable the register bank so that the output is high impedance
									immediate_con_channel <= current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)
																	&current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)
																	&current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)
																	&current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)
																	&current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)
																	&current_instruction(31 downto 20);
								elsif uOp_in = "00011" then
									load_imm <= '1';
									enable_imm <= '1';
								elsif uOp_in = "00100" then
									load_imm <= '0';
									load_b <= '1';
								elsif uOp_in = "00101" then
									load_b <= '0';
									enable_imm <= '0';
									arith <= '1';
									addr_add <= '1';
								elsif uOp_in = "00110" then
									load_acc <= '1';
								elsif uOp_in = "00111" then
									enable_acc <= '1';
									load_acc <= '0';
									addr_add <= '0';
									arith <= '0';
									reg_address_sel <= "01";									-- select the destination register
								elsif uOp_in = "01000" then
									write_reg <= '1';
								elsif uOp_in = "01001" then
									write_reg <= '0';
									reg_address_sel <= "00";
									enable_acc <= '0';
									pc_clock <= '1';
								elsif uOp_in = "01010" then
									load_pcbr <= '1';
									pc_clock <= '0';
								elsif uOp_in = "01011" then
									load_pcbr <= '0';
									reset_uOp <= '1';
									inc_ic <= '1';
								end if;
							
							-- SLTI
							when "010"=>
								if uOp_in = 	"00000" then
									reg_address_sel <= "10";                              -- select the source register R1
									read_reg <= '1';													-- outputing the data of source register
								elsif uOp_in = "00001" then
									load_a <= '1';														-- load into reg A
								elsif uOp_in = "00010" then
									load_a <= '0';
									read_reg <= '0';													-- need to disable the register bank so that the output is high impedance
									immediate_con_channel <= current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)
																	&current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)
																	&current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)
																	&current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)
																	&current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)
																	&current_instruction(31 downto 20);
								elsif uOp_in = "00011" then
									load_imm <= '1';
									enable_imm <= '1';
								elsif uOp_in = "00100" then
									load_imm <= '0';
									load_b <= '1';
								elsif uOp_in = "00101" then
									load_b <= '0';
									enable_imm <= '0';
									comp_sel <= '1';
									unsign_comp <= '0';
								elsif uOp_in = "00110" then
									load_acc <= '1';
								elsif uOp_in = "00111" then
									enable_acc <= '1';
									load_acc <= '0';
									comp_sel <= '0';
									reg_address_sel <= "01";									-- select the destination register
								elsif uOp_in = "01000" then
									write_reg <= '1';
								elsif uOp_in = "01001" then
									write_reg <= '0';
									enable_acc <= '0';
									pc_clock <= '1';
								elsif uOp_in = "01010" then
									load_pcbr <= '1';
									pc_clock <= '0';
								elsif uOp_in = "01011" then
									load_pcbr <= '0';
									reset_uOp <= '1';
									inc_ic <= '1';
								end if;
							
							-- SLTIU
							when "011"=>
								if uOp_in = 	"00000" then
									reg_address_sel <= "10";                              -- select the source register R1
									read_reg <= '1';													-- outputing the data of source register
								elsif uOp_in = "00001" then
									load_a <= '1';														-- load into reg A
								elsif uOp_in = "00010" then
									load_a <= '0';
									read_reg <= '0';													-- need to disable the register bank so that the output is high impedance
									immediate_con_channel <= current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)
																	&current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)
																	&current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)
																	&current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)
																	&current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)
																	&current_instruction(31 downto 20);
								elsif uOp_in = "00011" then
									load_imm <= '1';
									enable_imm <= '1';
								elsif uOp_in = "00100" then
									load_imm <= '0';
									load_b <= '1';
								elsif uOp_in = "00101" then
									load_b <= '0';
									enable_imm <= '0';
									comp_sel <= '1';
									unsign_comp <= '1';
								elsif uOp_in = "00110" then
									load_acc <= '1';
								elsif uOp_in = "00111" then
									enable_acc <= '1';
									load_acc <= '0';
									comp_sel <= '0';
									unsign_comp <= '0';
									reg_address_sel <= "01";									-- select the destination register
								elsif uOp_in = "01000" then
									write_reg <= '1';
								elsif uOp_in = "01001" then
									write_reg <= '0';
									enable_acc <= '0';
									pc_clock <= '1';
								elsif uOp_in = "01010" then
									load_pcbr <= '1';
									pc_clock <= '0';
								elsif uOp_in = "01011" then
									load_pcbr <= '0';
									reset_uOp <= '1';
									inc_ic <= '1';
								end if;			
							
							-- XORI
							when "100"=>
								if uOp_in = 	"00000" then
									reg_address_sel <= "10";                              -- select the source register R1
									read_reg <= '1';													-- outputing the data of source register
								elsif uOp_in = "00001" then
									load_a <= '1';														-- load into reg A
								elsif uOp_in = "00010" then
									load_a <= '0';
									read_reg <= '0';													-- need to disable the register bank so that the output is high impedance
									immediate_con_channel <= current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)
																	&current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)
																	&current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)
																	&current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)
																	&current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)
																	&current_instruction(31 downto 20);
								elsif uOp_in = "00011" then
									load_imm <= '1';
									enable_imm <= '1';
								elsif uOp_in = "00100" then
									load_imm <= '0';
									load_b <= '1';
								elsif uOp_in = "00101" then
									load_b <= '0';
									enable_imm <= '0';
									xor_sel <= '1';
								elsif uOp_in = "00110" then
									load_acc <= '1';
								elsif uOp_in = "00111" then
									enable_acc <= '1';
									load_acc <= '0';
									xor_sel <= '0';
									reg_address_sel <= "01";									-- select the destination register
								elsif uOp_in = "01000" then
									write_reg <= '1';
								elsif uOp_in = "01001" then
									write_reg <= '0';
									reg_address_sel <= "00";
									enable_acc <= '0';
									pc_clock <= '1';
								elsif uOp_in = "01010" then
									load_pcbr <= '1';
									pc_clock <= '0';
								elsif uOp_in = "01011" then
									load_pcbr <= '0';
									reset_uOp <= '1';
									inc_ic <= '1';
								end if;
							
							-- ORI
							when "110"=>
								if uOp_in = 	"00000" then
									reg_address_sel <= "10";                              -- select the source register R1
									read_reg <= '1';													-- outputing the data of source register
								elsif uOp_in = "00001" then
									load_a <= '1';														-- load into reg A
								elsif uOp_in = "00010" then
									load_a <= '0';
									read_reg <= '0';													-- need to disable the register bank so that the output is high impedance
									immediate_con_channel <= current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)
																	&current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)
																	&current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)
																	&current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)
																	&current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)
																	&current_instruction(31 downto 20);
								elsif uOp_in = "00011" then
									load_imm <= '1';
									enable_imm <= '1';
								elsif uOp_in = "00100" then
									load_imm <= '0';
									load_b <= '1';
								elsif uOp_in = "00101" then
									load_b <= '0';
									enable_imm <= '0';
									or_sel <= '1';
								elsif uOp_in = "00110" then
									load_acc <= '1';
								elsif uOp_in = "00111" then
									enable_acc <= '1';
									load_acc <= '0';
									or_sel <= '0';
									reg_address_sel <= "01";									-- select the destination register
								elsif uOp_in = "01000" then
									write_reg <= '1';
								elsif uOp_in = "01001" then
									write_reg <= '0';
									reg_address_sel <= "00";
									enable_acc <= '0';
									pc_clock <= '1';
								elsif uOp_in = "01010" then
									load_pcbr <= '1';
									pc_clock <= '0';
								elsif uOp_in = "01011" then
									load_pcbr <= '0';
									reset_uOp <= '1';
									inc_ic <= '1';
								end if;
							
							-- ANDI
							when "111"=>
								if uOp_in = 	"00000" then
									reg_address_sel <= "10";                              -- select the source register R1
									read_reg <= '1';													-- outputing the data of source register
								elsif uOp_in = "00001" then
									load_a <= '1';														-- load into reg A
								elsif uOp_in = "00010" then
									load_a <= '0';
									read_reg <= '0';													-- need to disable the register bank so that the output is high impedance
									immediate_con_channel <= current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)
																	&current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)
																	&current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)
																	&current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)
																	&current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)
																	&current_instruction(31 downto 20);
								elsif uOp_in = "00011" then
									load_imm <= '1';
									enable_imm <= '1';
								elsif uOp_in = "00100" then
									load_imm <= '0';
									load_b <= '1';
								elsif uOp_in = "00101" then
									load_b <= '0';
									enable_imm <= '0';
									and_sel <= '1';
								elsif uOp_in = "00110" then
									load_acc <= '1';
								elsif uOp_in = "00111" then
									enable_acc <= '1';
									load_acc <= '0';
									and_sel <= '0';
									reg_address_sel <= "01";									-- select the destination register
								elsif uOp_in = "01000" then
									write_reg <= '1';
								elsif uOp_in = "01001" then
									write_reg <= '0';
									reg_address_sel <= "00";
									enable_acc <= '0';
									pc_clock <= '1';
								elsif uOp_in = "01010" then
									load_pcbr <= '1';
									pc_clock <= '0';
								elsif uOp_in = "01011" then
									load_pcbr <= '0';
									reset_uOp <= '1';
									inc_ic <= '1';
								end if;	
						
							-- SLLI
							when "001"=>
								if uOp_in = 	"00000" then
									reg_address_sel <= "10";                              -- select the source register R1
									read_reg <= '1';													-- outputing the data of source register
								elsif uOp_in = "00001" then
									load_a <= '1';														-- load into reg A
								elsif uOp_in = "00010" then
									load_a <= '0';
									read_reg <= '0';													-- need to disable the register bank so that the output is high impedance
									immediate_con_channel <= current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)
																	&current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)
																	&current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)
																	&current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)
																	&current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)
																	&current_instruction(31 downto 20);
								elsif uOp_in = "00011" then
									load_imm <= '1';
									enable_imm <= '1';
								elsif uOp_in = "00100" then
									load_imm <= '0';
									load_b <= '1';
								elsif uOp_in = "00101" then
									load_b <= '0';
									enable_imm <= '0';
									sl <= '1';
								elsif uOp_in = "00110" then
									load_acc <= '1';
								elsif uOp_in = "00111" then
									enable_acc <= '1';
									load_acc <= '0';
									sl <= '0';
									reg_address_sel <= "01";									-- select the destination register
								elsif uOp_in = "01000" then
									write_reg <= '1';
								elsif uOp_in = "01001" then
									write_reg <= '0';
									reg_address_sel <= "00";
									enable_acc <= '0';
									pc_clock <= '1';
								elsif uOp_in = "01010" then
									load_pcbr <= '1';
									pc_clock <= '0';
								elsif uOp_in = "01011" then
									load_pcbr <= '0';
									reset_uOp <= '1';
									inc_ic <= '1';
								end if;		
							
							-- SRLI OR SRAI
							when "101"=>
								if uOp_in = 	"00000" then
									reg_address_sel <= "10";                              -- select the source register R1
									read_reg <= '1';													-- outputing the data of source register
								elsif uOp_in = "00001" then
									load_a <= '1';														-- load into reg A
								elsif uOp_in = "00010" then
									load_a <= '0';
									read_reg <= '0';													-- need to disable the register bank so that the output is high impedance
									immediate_con_channel <= current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)
																	&current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)
																	&current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)
																	&current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)
																	&current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)
																	&current_instruction(31 downto 20);
								elsif uOp_in = "00011" then
									load_imm <= '1';
									enable_imm <= '1';
								elsif uOp_in = "00100" then
									load_imm <= '0';
									load_b <= '1';
								elsif uOp_in = "00101" then
									load_b <= '0';
									enable_imm <= '0';
									sr <= '1';
								elsif uOp_in = "00110" then
									load_acc <= '1';
								elsif uOp_in = "00111" then
									enable_acc <= '1';
									load_acc <= '0';
									sr <= '0';
									reg_address_sel <= "01";									-- select the destination register
								elsif uOp_in = "01000" then
									write_reg <= '1';
								elsif uOp_in = "01001" then
									write_reg <= '0';
									reg_address_sel <= "00";
									enable_acc <= '0';
									pc_clock <= '1';
								elsif uOp_in = "01010" then
									load_pcbr <= '1';
									pc_clock <= '0';
								elsif uOp_in = "01011" then
									load_pcbr <= '0';
									reset_uOp <= '1';
									inc_ic <= '1';
								end if;						
							when others =>
							-- do nothing
						end case;
					-- END DECODING OF ARITH AND LOGICAL I-TYPE INSTRUCTION
				
					--
					--
					-- START DECODING OF LOAD I-TYPE INSTRUCTION
					
					when "0000011" =>
						case current_instruction(14 downto 12) is
							-- LB
							when "000"=>
								if		uOp_in = "00000" then
									reg_address_sel <= "10";                              -- select the source register R1
									read_reg <= '1';													-- outputing the data of source register				
								elsif uOp_in = "00001" then
									load_a <= '1';
									immediate_con_channel <= current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)
																	&current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)
																	&current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)
																	&current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)
																	&current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)
																	&current_instruction(31 downto 20);
								elsif uOp_in = "00010" then
									load_a <= '0';
									read_reg <= '0';													-- puts the data bus into Z state
									load_imm <= '1';
								elsif uOp_in = "00011" then
									load_imm <= '0';
									enable_imm <= '1';												-- outputing the immediate data on the core data bus
									immediate_con_channel <= (others => '0');
								elsif uOp_in = "00100" then
									load_b <= '1';
								elsif uOp_in = "00101" then
									load_b <= '0';
									enable_imm <= '0';
								elsif uOp_in = "00110" then
									pc_clock <= '1';
									addr_add <= '1';
									arith <= '1';
								elsif uOp_in = "00111" then
									pc_clock <= '0';
									load_pcbr <= '1';
									load_acc <= '1';
								elsif uOp_in = "01000" then
									arith <= '0';
									addr_add <= '0';
									load_acc <= '0';
									load_pcbr <= '0';
									enable_acc <= '1';
								elsif uOp_in = "01001" then
									ld_pc <= '1';
								elsif uOp_in = "01010" then
									ld_pc <= '0';
									enable_acc <= '0';
									en_pc <= '1';
								elsif uOp_in = "01011" then
									mem_read <= '1';
								elsif uOp_in = "01100" then
									mem_reg_data_in <= X"1";
								elsif uOp_in = "01101" then
									core_bus_enable <= '1';
									mem_reg_data_in <= x"0";
									mem_read <= '0';
									en_pc <= '0';
								elsif uOp_in = "01110" then
									immediate_con_channel <= data_in(7)&data_in(7)&data_in(7)&data_in(7)&data_in(7)&data_in(7)&data_in(7)&data_in(7)
																	 &data_in(7)&data_in(7)&data_in(7)&data_in(7)&data_in(7)&data_in(7)&data_in(7)&data_in(7)
																	 &data_in(7)&data_in(7)&data_in(7)&data_in(7)&data_in(7)&data_in(7)&data_in(7)&data_in(7)
																	 &data_in(7 downto 0);
								elsif uOp_in = "01111" then
									load_imm <= '1';
								elsif uOp_in = "10000" then
									core_bus_enable <= '0';
									load_imm <= '0';
									enable_imm <= '1';
									reg_address_sel <= "01";
								elsif uOp_in = "10001" then
									write_reg <= '1';
								elsif uOp_in = "10010" then
									write_reg <= '0';
									enable_imm <= '0';
								elsif uOp_in = "10011" then
									enable_pcbr <= '1';
								elsif uOp_in = "10100" then
									ld_pc <= '1';
								elsif uOp_in = "10101" then
									ld_pc <= '0';
									enable_pcbr <= '0';
									reset_uOp <= '1';
									inc_ic <= '1';
								end if;
							
							-- LH
							when "001"=>
								if		uOp_in = "00000" then
									reg_address_sel <= "10";                              -- select the source register R1
									read_reg <= '1';													-- outputing the data of source register				
								elsif uOp_in = "00001" then
									load_a <= '1';
									immediate_con_channel <= current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)
																	&current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)
																	&current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)
																	&current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)
																	&current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)
																	&current_instruction(31 downto 20);
								elsif uOp_in = "00010" then
									load_a <= '0';
									read_reg <= '0';													-- puts the data bus into Z state
									load_imm <= '1';
								elsif uOp_in = "00011" then
									load_imm <= '0';
									enable_imm <= '1';												-- outputing the immediate data on the core data bus
									immediate_con_channel <= (others => '0');
								elsif uOp_in = "00100" then
									load_b <= '1';
								elsif uOp_in = "00101" then
									load_b <= '0';
									enable_imm <= '0';
								elsif uOp_in = "00110" then
									pc_clock <= '1';
									addr_add <= '1';
									arith <= '1';
								elsif uOp_in = "00111" then
									pc_clock <= '0';
									load_pcbr <= '1';
									load_acc <= '1';
								elsif uOp_in = "01000" then
									arith <= '0';
									addr_add <= '0';
									load_acc <= '0';
									load_pcbr <= '0';
									enable_acc <= '1';
								elsif uOp_in = "01001" then
									ld_pc <= '1';
								elsif uOp_in = "01010" then
									ld_pc <= '0';
									enable_acc <= '0';
									en_pc <= '1';
								elsif uOp_in = "01011" then
									mem_read <= '1';
								elsif uOp_in = "01100" then
									mem_read <= '0';
									mem_reg_data_in <= X"1";
								elsif uOp_in = "01101" then
									pc_clock <= '1';
									mem_reg_data_in <= x"0";
								elsif uOp_in = "01110" then
									pc_clock <= '0';
									mem_read <= '1';
									
								elsif uOp_in = "01111" then
									mem_reg_data_in <= x"2";
									core_bus_enable <= '1';
									mem_read <= '0';
									
								elsif uOp_in = "10000" then
									mem_reg_data_in <= x"0";
									en_pc <= '0';
									immediate_con_channel <= data_in(7)&data_in(7)&data_in(7)&data_in(7)&data_in(7)&data_in(7)&data_in(7)&data_in(7)
																	 &data_in(7)&data_in(7)&data_in(7)&data_in(7)&data_in(7)&data_in(7)&data_in(7)&data_in(7)
																	 &data_in(15 downto 0);
								elsif uOp_in = "10001" then
									load_imm <= '1';
								elsif uOp_in = "10010" then
									core_bus_enable <= '0';
									load_imm <= '0';
									enable_imm <= '1';
									reg_address_sel <= "01";
								elsif uOp_in = "10011" then
									write_reg <= '1';
								elsif uOp_in = "10100" then
									write_reg <= '0';
									enable_imm <= '0';
								elsif uOp_in = "10101" then
									enable_pcbr <= '1';
								elsif uOp_in = "10110" then
									ld_pc <= '1';
								elsif uOp_in = "10111" then
									ld_pc <= '0';
									enable_pcbr <= '0';
									reset_uOp <= '1';
									inc_ic <= '1';
								end if;	
							
							-- LW
							when "010"=>
								if		uOp_in = "00000" then
									reg_address_sel <= "10";                              -- select the source register R1
									read_reg <= '1';													-- outputing the data of source register				
								elsif uOp_in = "00001" then
									load_a <= '1';
									immediate_con_channel <= current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)
																	&current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)
																	&current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)
																	&current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)
																	&current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)
																	&current_instruction(31 downto 20);
								elsif uOp_in = "00010" then
									load_a <= '0';
									read_reg <= '0';													-- puts the data bus into Z state
									load_imm <= '1';
								elsif uOp_in = "00011" then
									load_imm <= '0';
									enable_imm <= '1';												-- outputing the immediate data on the core data bus
									immediate_con_channel <= (others => '0');
								elsif uOp_in = "00100" then
									load_b <= '1';
								elsif uOp_in = "00101" then
									load_b <= '0';
									enable_imm <= '0';
								elsif uOp_in = "00110" then
									pc_clock <= '1';					-- 1st pulse
									addr_add <= '1';
									arith <= '1';
								elsif uOp_in = "00111" then
									pc_clock <= '0';
									load_pcbr <= '1';
									load_acc <= '1';
								elsif uOp_in = "01000" then
									arith <= '0';
									addr_add <= '0';
									load_acc <= '0';
									load_pcbr <= '0';
									enable_acc <= '1';
								elsif uOp_in = "01001" then
									ld_pc <= '1';
								elsif uOp_in = "01010" then
									ld_pc <= '0';
									enable_acc <= '0';
									en_pc <= '1';
								elsif uOp_in = "01011" then
									mem_read <= '1';
								elsif uOp_in = "01100" then
									mem_reg_data_in <= X"1";
								elsif uOp_in = "01101" then
									mem_read <= '0';
									pc_clock <= '1';						-- 2nd pulse
								elsif uOp_in = "01110" then
									pc_clock <= '0';
									mem_read <= '1';
								elsif uOp_in = "01111" then
									mem_reg_data_in <= x"2";
								elsif uOp_in = "10000" then
									mem_read <= '0';
									pc_clock <= '1';					-- 3rd pulse
									
								elsif uOp_in = "10001" then
									pc_clock <= '0';
									mem_read <= '1';
								elsif uOp_in = "10010" then
									mem_reg_data_in <= x"4";
									
								elsif uOp_in = "10011" then
									mem_read <= '0';
									pc_clock <= '1';					-- 4th pulse
								
								elsif uOp_in = "10100" then
									pc_clock <= '0';
									mem_read <= '1';
								
								elsif uOp_in = "10101" then
									mem_reg_data_in <= x"8";
									
								elsif uOp_in = "10110" then
									core_bus_enable <= '1';
									mem_reg_data_in <= x"0";
									mem_read <= '0';
									en_pc <= '0';
									
								elsif uOp_in = "10111" then
									immediate_con_channel <= data_in;
								elsif uOp_in = "11000" then
									load_imm <= '1';
								elsif uOp_in = "11001" then
									immediate_con_channel <= x"00000000";
									core_bus_enable <= '0';
									load_imm <= '0';
									enable_imm <= '1';
									reg_address_sel <= "01";
								elsif uOp_in = "11010" then
									write_reg <= '1';
								elsif uOp_in = "11011" then
									write_reg <= '0';
									enable_imm <= '0';
								elsif uOp_in = "11100" then
									enable_pcbr <= '1';
								elsif uOp_in = "11101" then
									ld_pc <= '1';
								elsif uOp_in = "11111" then
									ld_pc <= '0';
									enable_pcbr <= '0';
									reset_uOp <= '1';
									inc_ic <= '1';
								end if;	
							
							-- LBU
							when "100"=>
								if		uOp_in = "00000" then
									reg_address_sel <= "10";                              -- select the source register R1
									read_reg <= '1';													-- outputing the data of source register				
								elsif uOp_in = "00001" then
									load_a <= '1';
									immediate_con_channel <= current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)
																	&current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)
																	&current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)
																	&current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)
																	&current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)
																	&current_instruction(31 downto 20);
								elsif uOp_in = "00010" then
									load_a <= '0';
									read_reg <= '0';													-- puts the data bus into Z state
									load_imm <= '1';
								elsif uOp_in = "00011" then
									load_imm <= '0';
									enable_imm <= '1';												-- outputing the immediate data on the core data bus
									immediate_con_channel <= (others => '0');
								elsif uOp_in = "00100" then
									load_b <= '1';
								elsif uOp_in = "00101" then
									load_b <= '0';
									enable_imm <= '0';
								elsif uOp_in = "00110" then
									pc_clock <= '1';
									addr_add <= '1';
									arith <= '1';
									
								elsif uOp_in = "00111" then
									pc_clock <= '0';
									load_pcbr <= '1';
									load_acc <= '1';
								elsif uOp_in = "01000" then
									arith <= '0';
									addr_add <= '0';
									load_acc <= '0';
									load_pcbr <= '0';
									enable_acc <= '1';
								elsif uOp_in = "01001" then
									ld_pc <= '1';
								elsif uOp_in = "01010" then
									ld_pc <= '0';
									enable_acc <= '0';
									en_pc <= '1';
								elsif uOp_in = "01011" then
									mem_read <= '1';
								elsif uOp_in = "01100" then
									mem_reg_data_in <= X"1";
								elsif uOp_in = "01101" then
									mem_reg_data_in <= x"0";
									core_bus_enable <= '1';
									mem_read <= '0';
									en_pc <= '0';
								elsif uOp_in = "01110" then
									immediate_con_channel <= X"000000"&data_in(7 downto 0);
								elsif uOp_in = "01111" then
									load_imm <= '1';
								elsif uOp_in = "10000" then
									core_bus_enable <= '0';
									immediate_con_channel <= (others => '0');
									load_imm <= '0';
									enable_imm <= '1';
									reg_address_sel <= "01";
								elsif uOp_in = "10001" then
									write_reg <= '1';
								elsif uOp_in = "10010" then
									write_reg <= '0';
									enable_imm <= '0';
								elsif uOp_in = "10011" then
									enable_pcbr <= '1';
								elsif uOp_in = "10100" then
									ld_pc <= '1';
								elsif uOp_in = "10101" then
									ld_pc <= '0';
									enable_pcbr <= '0';
									reset_uOp <= '1';
									inc_ic <= '1';
								end if;				
							
							-- LHU
							when "101" =>							
								if		uOp_in = "00000" then
									reg_address_sel <= "10";                              -- select the source register R1
									read_reg <= '1';													-- outputing the data of source register				
								elsif uOp_in = "00001" then
									load_a <= '1';
									immediate_con_channel <= current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)
																	&current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)
																	&current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)
																	&current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)
																	&current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)
																	&current_instruction(31 downto 20);
								elsif uOp_in = "00010" then
									load_a <= '0';
									read_reg <= '0';													-- puts the data bus into Z state
									load_imm <= '1';
								elsif uOp_in = "00011" then
									load_imm <= '0';
									enable_imm <= '1';												-- outputing the immediate data on the core data bus
									immediate_con_channel <= (others => '0');
								elsif uOp_in = "00100" then
									load_b <= '1';
								elsif uOp_in = "00101" then
									load_b <= '0';
									enable_imm <= '0';
								elsif uOp_in = "00110" then
									pc_clock <= '1';
									addr_add <= '1';
									arith <= '1';
								elsif uOp_in = "00111" then
									
									pc_clock <= '0';
									load_pcbr <= '1';
									load_acc <= '1';
									
								elsif uOp_in = "01000" then
									arith <= '0';
									addr_add <= '0';
									load_acc <= '0';
									load_pcbr <= '0';
									enable_acc <= '1';
								elsif uOp_in = "01001" then
									ld_pc <= '1';
								elsif uOp_in = "01010" then
									ld_pc <= '0';
									enable_acc <= '0';
									en_pc <= '1';
								elsif uOp_in = "01011" then
									mem_read <= '1';
								elsif uOp_in = "01100" then
									mem_reg_data_in <= X"1";
								elsif uOp_in = "01101" then
									pc_clock <= '1';
									mem_read <= '0';
									mem_reg_data_in <= x"0";
								elsif uOp_in = "01110" then
									pc_clock <= '0';
									mem_read <= '1';
								elsif uOp_in = "01111" then
									mem_reg_data_in <= x"2";
								
								elsif uOp_in = "10000" then
									core_bus_enable <= '1';
									mem_reg_data_in <= x"0";
									mem_read <= '0';
									en_pc <= '0';
								
								elsif uOp_in = "10001" then
									immediate_con_channel <= x"0000"&data_in(15 downto 0);
								elsif uOp_in = "10010" then
									load_imm <= '1';
								elsif uOp_in = "10011" then
									core_bus_enable <= '0';
									load_imm <= '0';
									enable_imm <= '1';
									reg_address_sel <= "01";
								elsif uOp_in = "10100" then
									write_reg <= '1';
								elsif uOp_in = "10101" then
									write_reg <= '0';
									enable_imm <= '0';
								elsif uOp_in = "10110" then
									enable_pcbr <= '1';
								elsif uOp_in = "10111" then
									ld_pc <= '1';
								elsif uOp_in = "11000" then
									ld_pc <= '0';
									enable_pcbr <= '0';
									reset_uOp <= '1';
									inc_ic <= '1';
								end if;	
						when others=>
						-- do nothing
						end case;
					-- STOP DECODING OF LOAD I-TYPE INSTRUCTION
					--
					--
					-- START DECODING OF JUMP I-TYPE INSTRUCTION
					when "1100111" =>
						if 	uOp_in = "00000" then
							pc_clock <= '1';
						
						elsif uOp_in = "00001" then
							en_pc <= '1';
							pc_clock <= '0';
						
						elsif uOp_in = "00010" then
							load_pcbr <= '1';
						
						elsif uOp_in = "00011" then
							en_pc <= '0';
							load_pcbr <= '0';
							enable_pcbr <= '1';
							reg_address_sel <= "01";
							immediate_con_channel <= current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)
															&current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)
															&current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)
															&current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)
															&current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)
															&current_instruction(31 downto 20);
						
						elsif uOp_in = "00100" then
							write_reg <= '1';
							load_imm <= '1';
						
						elsif uOp_in = "00101" then
							load_imm <= '0';
							write_reg <= '0';
							immediate_con_channel <= (others=>'0');
							enable_pcbr <= '0';
							reg_address_sel <= "00";

						elsif uOp_in = "00110" then
							enable_imm <= '1';
						
						elsif uOp_in = "00111" then
							load_a <= '1';
						
						elsif uOp_in = "01000" then
							enable_imm <= '0';
							load_a <= '0';
							reg_address_sel <= "10";                              -- select the source register R1
							read_reg <= '1';													-- outputing the data of source register
						
						elsif uOp_in = "01001" then
							load_b <= '1';
						
						elsif uOp_in = "01010" then
							load_b <= '0';
							reg_address_sel <= "00";
							read_reg <= '0';
							arith <= '1';
						
						elsif uOp_in = "01011" then
							load_acc <= '1';
						
						elsif uOp_in = "01100" then
							arith <= '0';
							load_acc <= '0';
							enable_acc <= '1'; 
						
						elsif uOp_in = "01101" then
							ld_pc <= '1';
							
						elsif uOp_in = "01110" then
							ld_pc <= '0';
							enable_acc <= '0';
							load_pcbr <= '1';
							
						elsif uOp_in = "01111" then
							load_pcbr <= '0';
							reset_uOp <= '1';
							inc_ic <= '1';
							
						end if;
					-- STOP DECODING OF JUMP I-TYPE INSTRUCTION
					
					
					--
					--
					-- START DECODING OF LUI U-TYPE INSTRUCTION
					when "0110111" =>
						if 	uOp_in = "00000" then
							immediate_con_channel <= current_instruction(31 downto 12)&X"000";
						
						elsif uOp_in = "00001" then
							load_imm <= '1';
						
						elsif uOp_in = "00010" then
							immediate_con_channel <= (others=>'0');
							load_imm <= '0';
							enable_imm <= '1';
							reg_address_sel <= "01";
						
						elsif uOp_in = "00011" then
							write_reg <= '1';
						
						elsif uOp_in = "00100" then
							write_reg <= '0';
							reg_address_sel <= "00";
							enable_imm <= '0';
							pc_clock <= '1';
							
						elsif uOp_in = "00101" then
							load_pcbr <= '1';
							pc_clock <= '0';
								
						elsif uOp_in = "00110" then
							load_pcbr <= '0';
							reset_uOp <= '1';
							inc_ic <= '1';
							
						end if;
					-- STOP DECODING OF LUI-TYPE INSTRUCTION
					
			
					--
					--
					-- START DECODING OF AUIPC U-TYPE INSTRUCTION
					when "0010111" =>
						if 	uOp_in = "00000" then
							immediate_con_channel <= current_instruction(31 downto 12)&X"000";
						
						elsif uOp_in = "00001" then
							load_imm <= '1';
						
						elsif uOp_in = "00010" then
							immediate_con_channel <= (others=>'0');
							load_imm <= '0';
							enable_imm <= '1';
							
						elsif uOp_in = "00011" then
							load_a <='1';
							
						elsif uOp_in = "00100" then
							load_a <= '0';
							enable_imm <= '0';
							enable_pcbr <= '1';
							
						elsif uOp_in = "00101" then
							load_b <= '1';
						
						elsif uOp_in = "00110" then
							enable_pcbr <= '0';
							load_b <= '0';
							arith <= '1';
							addr_add <= '1';
						
						elsif uOp_in = "00111" then
							load_acc <= '1';
							
						elsif uOp_in = "01000" then
							arith <= '0';
							addr_add <= '0';
							load_acc <= '0';
							enable_acc <= '1';
							reg_address_sel <= "01";
							
						elsif uOp_in = "01001" then
							write_reg <= '1';
							
						elsif uOp_in = "01010" then
							enable_acc <= '0';
							reg_address_sel <= "00";
							write_reg <= '0';
							pc_clock <= '1';
							
						elsif uOp_in = "01011" then
							pc_clock <= '0';
							load_pcbr <= '1';
						
						elsif uOp_in = "01100" then
							load_pcbr <= '0';
							reset_uOp <= '1';
							inc_ic <= '1';
							
						end if;
					-- STOP DECODING OF AUIPC-TYPE INSTRUCTION

					
					--
					--
					-- START DECODING OF JAL J-TYPE INSTRUCTION
					when "1101111" =>
						if 	uOp_in = "00000" then
							immediate_con_channel <= current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)
															&current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)
															&current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)
															&current_instruction(19 downto 12)&current_instruction(20)&current_instruction(30 downto 21)&'0';
						

						elsif uOp_in = "00001" then
							load_imm <= '1';
						
						elsif uOp_in = "00010" then
							load_imm <= '0';
							immediate_con_channel <= (others=>'0');
							enable_imm <= '1';
						
						elsif uOp_in = "00011" then
							load_a <= '1';

						elsif uOp_in = "00100" then
							load_a <= '0';
							enable_imm <= '0';
							enable_pcbr <= '1';
						
						elsif uOp_in = "00101" then
							load_b <= '1';
						
						elsif uOp_in = "00110" then
							load_b <= '0';
							enable_pcbr <= '0';
							arith <= '1';
							addr_add <= '1';
							
						elsif uOp_in = "00111" then
							load_acc <= '1';
						
						elsif uOp_in = "01000" then
							arith <= '0';
							addr_add <= '0';
							load_acc <= '0';
						
						elsif uOp_in = "01001" then
							pc_clock <= '1';
						
						elsif uOp_in = "01010" then
							pc_clock <= '0';
							load_pcbr <= '1';
						
						
						elsif	uOp_in = "01011" then
							load_pcbr <= '0';
							enable_pcbr <= '1';
							reg_address_sel <= "01";
						
						elsif uOp_in = "01100" then
							write_reg <= '1';
							
						elsif uOp_in = "01101" then
							enable_acc <= '1';
							enable_pcbr <= '0';
							write_reg <= '0';
							reg_address_sel <= "00";
							
						elsif uOp_in = "01110" then
							ld_pc <= '1';
						
						elsif uOp_in = "01111" then
							enable_acc <= '0';
							ld_pc <= '0';
							load_pcbr <= '1';
							
						elsif uOp_in = "10000" then
							load_pcbr <= '0';
							reset_uOp <= '1';
							inc_ic <= '1';
						
						end if;
					-- STOP DECODING OF JAl J-TYPE INSTRUCTION

					--
					--
					--
					-- START OF DECODE AND EXECUTE B-TYPE INSTRUCTION
					when "1100011" => 
						case current_instruction(14 downto 12) is
							
							-- BEQ
							when "000" =>
								if 	uOp_in = "00000" then
									reg_address_sel <= "10";                              -- select the source register R1
									read_reg <= '1';													-- outputing the data of source register
								
								elsif uOp_in = "00001" then
									load_a <= '1';														-- loading the content of R1 to register A
								
								elsif uOp_in = "00010" then
									reg_address_sel <= "11";										-- select the source register R2
									load_a <= '0';
								
								elsif uOp_in = "00011" then
									load_b <= '1';														-- loading the content of R2 to register B
								
								elsif uOp_in = "00100" then
									load_b <= '0';
									read_reg <= '0';
									reg_address_sel <= "00";
									
								elsif uOp_in = "00101" then
									equal <= '1';
								
								elsif uOp_in = "00110" then
									load_acc <= '1';												-- load the result
									enable_acc <= '1';											-- enable the accumulator to output the accumulator
									
								elsif uOp_in = "00111" then
									data_in_reg <= data_in;
									load_acc <= '0';
									equal <= '0';
			
									
									
									if data_in = x"00000001" then
										immediate_con_channel <= current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)
																		&current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)
																		&current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)
																		&current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)
																		&current_instruction(7)&current_instruction(30 downto 25)&current_instruction(11 downto 8)&'0';
									else
										pc_clock <= '1';
										enable_acc <= '0';
									end if;
									
								elsif uOp_in = "01000" then
									
									if data_in_reg = x"00000001" then
										load_imm <= '1';
										enable_acc <= '0';
									else
										pc_clock <= '0';
										load_pcbr <= '1';
									end if;


								elsif uOp_in = "01001" then
									if data_in_reg = x"00000001" then
										load_imm <= '0';
										enable_imm <= '1';
									else
										load_pcbr <= '0';
										inc_ic <= '1';
										reset_uOp <= '1';
									end if;
								
								elsif uOp_in = "01010" then
									load_a <= '1';
								
								elsif uOp_in = "01011" then
									load_a <= '0';
									enable_imm <= '0';
									enable_pcbr <= '1';
									
								elsif uOp_in = "01100" then
									load_b <= '1';
									
								elsif uOp_in = "01101" then
									enable_pcbr <= '0';
									load_b <= '0';
									arith <= '1';
									addr_add <= '1';
									
								elsif uOp_in = "01110" then
									load_acc <= '1';
								
								elsif uOp_in = "01111" then
									arith <= '0';
									addr_add <= '0';
									load_acc <= '0';
									enable_acc <='1';
								
								elsif uOp_in = "10000" then
									ld_pc <= '1';
								
								elsif uOp_in = "10001" then
									ld_pc <= '0';
									enable_acc <= '0';
									
								elsif uOp_in = "10010" then
									load_pcbr <= '1';
									
								elsif uOp_in = "10011" then
									load_pcbr <= '0';
									reset_uOp <= '1';
									inc_ic <= '1';
								end if;
							
							-- BNE
							when "001" =>
								if 	uOp_in = "00000" then
									reg_address_sel <= "10";                              -- select the source register R1
									read_reg <= '1';													-- outputing the data of source register
								
								elsif uOp_in = "00001" then
									load_a <= '1';														-- loading the content of R1 to register A
								
								elsif uOp_in = "00010" then
									reg_address_sel <= "11";										-- select the source register R2
									load_a <= '0';
								
								elsif uOp_in = "00011" then
									load_b <= '1';														-- loading the content of R2 to register B
								
								elsif uOp_in = "00100" then
									load_b <= '0';
									read_reg <= '0';
									reg_address_sel <= "00";
									
								elsif uOp_in = "00101" then
									equal <= '1';
								
								elsif uOp_in = "00110" then
									load_acc <= '1';												-- load the result
									enable_acc <= '1';											-- enable the accumulator to output the accumulator
				
								elsif uOp_in = "00111" then
									data_in_reg <= data_in;
									load_acc <= '0';
									equal <= '0';
			
									
									
									if data_in = x"00000000" then
										immediate_con_channel <= current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)
																		&current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)
																		&current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)
																		&current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)
																		&current_instruction(7)&current_instruction(30 downto 25)&current_instruction(11 downto 8)&'0';
									else
										pc_clock <= '1';
										enable_acc <= '0';
									end if;
									
								elsif uOp_in = "01000" then
									
									if data_in_reg = x"00000000" then
										load_imm <= '1';
										enable_acc <= '0';
									else
										pc_clock <= '0';
										load_pcbr <= '1';
									end if;


								elsif uOp_in = "01001" then
									if data_in_reg = x"00000000" then
										load_imm <= '0';
										enable_imm <= '1';
									else
										load_pcbr <= '0';
										inc_ic <= '1';
										reset_uOp <= '1';
									end if;
								
								elsif uOp_in = "01010" then
									load_a <= '1';
								
								elsif uOp_in = "01011" then
									load_a <= '0';
									enable_imm <= '0';
									enable_pcbr <= '1';
									
								elsif uOp_in = "01100" then
									load_b <= '1';
									
								elsif uOp_in = "01101" then
									enable_pcbr <= '0';
									load_b <= '0';
									arith <= '1';
									addr_add <= '1';
									
								elsif uOp_in = "01110" then
									load_acc <= '1';
								
								elsif uOp_in = "01111" then
									arith <= '0';
									addr_add <= '0';
									load_acc <= '0';
									enable_acc <='1';
								
								elsif uOp_in = "10000" then
									ld_pc <= '1';
								
								elsif uOp_in = "10001" then
									ld_pc <= '0';
									enable_acc <= '0';
									
								elsif uOp_in = "10010" then
									load_pcbr <= '1';
									
								elsif uOp_in = "10011" then
									load_pcbr <= '0';
									reset_uOp <= '1';
									inc_ic <= '1';
								end if;	
							
							-- BLT
							when "100"=>
								if 	uOp_in = "00000" then
									reg_address_sel <= "10";                              -- select the source register R1
									read_reg <= '1';													-- outputing the data of source register
								
								elsif uOp_in = "00001" then
									load_a <= '1';														-- loading the content of R1 to register A
								
								elsif uOp_in = "00010" then
									reg_address_sel <= "11";										-- select the source register R2
									load_a <= '0';
								
								elsif uOp_in = "00011" then
									load_b <= '1';														-- loading the content of R2 to register B
								
								elsif uOp_in = "00100" then
									load_b <= '0';
									read_reg <= '0';
									reg_address_sel <= "00";
									
								elsif uOp_in = "00101" then
									comp_sel <= '1';
								
								elsif uOp_in = "00110" then
									load_acc <= '1';												-- load the result
									enable_acc <= '1';											-- enable the accumulator to output the accumulator
				
								elsif uOp_in = "00111" then
									data_in_reg <= data_in;
									load_acc <= '0';
									comp_sel <= '0';
			
									
									
									if data_in = x"00000001" then
										immediate_con_channel <= current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)
																		&current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)
																		&current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)
																		&current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)
																		&current_instruction(7)&current_instruction(30 downto 25)&current_instruction(11 downto 8)&'0';
									else
										pc_clock <= '1';
										enable_acc <= '0';
									end if;
									
								elsif uOp_in = "01000" then
									
									if data_in_reg = x"00000001" then
										load_imm <= '1';
										enable_acc <= '0';
									else
										pc_clock <= '0';
										load_pcbr <= '1';
									end if;


								elsif uOp_in = "01001" then
									if data_in_reg = x"00000001" then
										load_imm <= '0';
										enable_imm <= '1';
									else
										load_pcbr <= '0';
										inc_ic <= '1';
										reset_uOp <= '1';
									end if;
								
								elsif uOp_in = "01010" then
									load_a <= '1';
								
								elsif uOp_in = "01011" then
									load_a <= '0';
									enable_imm <= '0';
									enable_pcbr <= '1';
									
								elsif uOp_in = "01100" then
									load_b <= '1';
									
								elsif uOp_in = "01101" then
									enable_pcbr <= '0';
									load_b <= '0';
									arith <= '1';
									addr_add <= '1';
									
								elsif uOp_in = "01110" then
									load_acc <= '1';
								
								elsif uOp_in = "01111" then
									arith <= '0';
									addr_add <= '0';
									load_acc <= '0';
									enable_acc <='1';
								
								elsif uOp_in = "10000" then
									ld_pc <= '1';
								
								elsif uOp_in = "10001" then
									ld_pc <= '0';
									enable_acc <= '0';
									
								elsif uOp_in = "10010" then
									load_pcbr <= '1';
									
								elsif uOp_in = "10011" then
									load_pcbr <= '0';
									reset_uOp <= '1';
									inc_ic <= '1';
								end if;							
							
							-- BGE
							when "101" =>
								if 	uOp_in = "00000" then
									reg_address_sel <= "10";                              -- select the source register R1
									read_reg <= '1';													-- outputing the data of source register
								
								elsif uOp_in = "00001" then
									load_a <= '1';														-- loading the content of R1 to register A
								
								elsif uOp_in = "00010" then
									reg_address_sel <= "11";										-- select the source register R2
									load_a <= '0';
								
								elsif uOp_in = "00011" then
									load_b <= '1';														-- loading the content of R2 to register B
								
								elsif uOp_in = "00100" then
									load_b <= '0';
									read_reg <= '0';
									reg_address_sel <= "00";
									
								elsif uOp_in = "00101" then
									comp_sel <= '1';
								
								elsif uOp_in = "00110" then
									load_acc <= '1';												-- load the result
									enable_acc <= '1';											-- enable the accumulator to output the accumulator
				
								elsif uOp_in = "00111" then
									load_acc <= '0';
									comp_sel <= '0';
									data_in_reg <= data_in;
					
									if data_in = x"00000000" then
										immediate_con_channel <= current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)
																		&current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)
																		&current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)
																		&current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)
																		&current_instruction(7)&current_instruction(30 downto 25)&current_instruction(11 downto 8)&'0';
									else
										pc_clock <= '1';
										enable_acc <= '0';
									end if;
									
								elsif uOp_in = "01000" then
									
									if data_in_reg = x"00000000" then
										load_imm <= '1';
										enable_acc <= '0';
									else
										pc_clock <= '0';
										load_pcbr <= '1';
									end if;


								elsif uOp_in = "01001" then
									if data_in_reg = x"00000000" then
										load_imm <= '0';
										enable_imm <= '1';
									else
										load_pcbr <= '0';
										inc_ic <= '1';
										reset_uOp <= '1';
									end if;
								
								elsif uOp_in = "01010" then
									load_a <= '1';
								
								elsif uOp_in = "01011" then
									load_a <= '0';
									enable_imm <= '0';
									enable_pcbr <= '1';
									
								elsif uOp_in = "01100" then
									load_b <= '1';
									
								elsif uOp_in = "01101" then
									enable_pcbr <= '0';
									load_b <= '0';
									arith <= '1';
									addr_add <= '1';
									
								elsif uOp_in = "01110" then
									load_acc <= '1';
								
								elsif uOp_in = "01111" then
									arith <= '0';
									addr_add <= '0';
									load_acc <= '0';
									enable_acc <='1';
								
								elsif uOp_in = "10000" then
									ld_pc <= '1';
								
								elsif uOp_in = "10001" then
									ld_pc <= '0';
									enable_acc <= '0';
									
								elsif uOp_in = "10010" then
									load_pcbr <= '1';
									
								elsif uOp_in = "10011" then
									load_pcbr <= '0';
									reset_uOp <= '1';
									inc_ic <= '1';
								end if;
							
							-- BLTU
							when "110" =>
								if 	uOp_in = "00000" then
									reg_address_sel <= "10";                              -- select the source register R1
									read_reg <= '1';													-- outputing the data of source register
								
								elsif uOp_in = "00001" then
									load_a <= '1';														-- loading the content of R1 to register A
								
								elsif uOp_in = "00010" then
									reg_address_sel <= "11";										-- select the source register R2
									load_a <= '0';
								
								elsif uOp_in = "00011" then
									load_b <= '1';														-- loading the content of R2 to register B
								
								elsif uOp_in = "00100" then
									load_b <= '0';
									read_reg <= '0';
									reg_address_sel <= "00";
									
								elsif uOp_in = "00101" then
									comp_sel <= '1';
									unsign_comp <= '1';
								
								elsif uOp_in = "00110" then
									load_acc <= '1';												-- load the result
									enable_acc <= '1';											-- enable the accumulator to output the accumulator
				
								elsif uOp_in = "00111" then
									load_acc <= '0';
									comp_sel <= '0';
									unsign_comp <= '0';
									
									data_in_reg <= data_in;
					
									if data_in = x"00000001" then
										immediate_con_channel <= current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)
																		&current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)
																		&current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)
																		&current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)
																		&current_instruction(7)&current_instruction(30 downto 25)&current_instruction(11 downto 8)&'0';
									else
										pc_clock <= '1';
										enable_acc <= '0';
									end if;
									
								elsif uOp_in = "01000" then
									
									if data_in_reg = x"00000001" then
										load_imm <= '1';
										enable_acc <= '0';
									else
										pc_clock <= '0';
										load_pcbr <= '1';
									end if;


								elsif uOp_in = "01001" then
									if data_in_reg = x"00000001" then
										load_imm <= '0';
										enable_imm <= '1';
									else
										load_pcbr <= '0';
										inc_ic <= '1';
										reset_uOp <= '1';
									end if;
								
								elsif uOp_in = "01010" then
									load_a <= '1';
								
								elsif uOp_in = "01011" then
									load_a <= '0';
									enable_imm <= '0';
									enable_pcbr <= '1';
									
								elsif uOp_in = "01100" then
									load_b <= '1';
									
								elsif uOp_in = "01101" then
									enable_pcbr <= '0';
									load_b <= '0';
									arith <= '1';
									addr_add <= '1';
									
								elsif uOp_in = "01110" then
									load_acc <= '1';
								
								elsif uOp_in = "01111" then
									arith <= '0';
									addr_add <= '0';
									load_acc <= '0';
									enable_acc <='1';
								
								elsif uOp_in = "10000" then
									ld_pc <= '1';
								
								elsif uOp_in = "10001" then
									ld_pc <= '0';
									enable_acc <= '0';
									
								elsif uOp_in = "10010" then
									load_pcbr <= '1';
									
								elsif uOp_in = "10011" then
									load_pcbr <= '0';
									reset_uOp <= '1';
									inc_ic <= '1';
								end if;
							
							-- BGEU
							when "111" =>
								if 	uOp_in = "00000" then
									reg_address_sel <= "10";                              -- select the source register R1
									read_reg <= '1';													-- outputing the data of source register
								
								elsif uOp_in = "00001" then
									load_a <= '1';														-- loading the content of R1 to register A
								
								elsif uOp_in = "00010" then
									reg_address_sel <= "11";										-- select the source register R2
									load_a <= '0';
								
								elsif uOp_in = "00011" then
									load_b <= '1';														-- loading the content of R2 to register B
								
								elsif uOp_in = "00100" then
									load_b <= '0';
									read_reg <= '0';
									reg_address_sel <= "00";
									
								elsif uOp_in = "00101" then
									comp_sel <= '1';
									unsign_comp <= '1';
								
								elsif uOp_in = "00110" then
									load_acc <= '1';												-- load the result
									enable_acc <= '1';											-- enable the accumulator to output the accumulator
				
								elsif uOp_in = "00111" then
									load_acc <= '0';
									comp_sel <= '0';
									unsign_comp <= '0';
									
									data_in_reg <= data_in;
					
									if data_in = x"00000000" then
										immediate_con_channel <= current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)
																		&current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)
																		&current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)
																		&current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)
																		&current_instruction(7)&current_instruction(30 downto 25)&current_instruction(11 downto 8)&'0';
									else
										pc_clock <= '1';
										enable_acc <= '0';
									end if;
									
								elsif uOp_in = "01000" then
									
									if data_in_reg = x"00000000" then
										load_imm <= '1';
										enable_acc <= '0';
									else
										pc_clock <= '0';
										load_pcbr <= '1';
									end if;


								elsif uOp_in = "01001" then
									if data_in_reg = x"00000000" then
										load_imm <= '0';
										enable_imm <= '1';
									else
										load_pcbr <= '0';
										inc_ic <= '1';
										reset_uOp <= '1';
									end if;
								
								elsif uOp_in = "01010" then
									load_a <= '1';
								
								elsif uOp_in = "01011" then
									load_a <= '0';
									enable_imm <= '0';
									enable_pcbr <= '1';
									
								elsif uOp_in = "01100" then
									load_b <= '1';
									
								elsif uOp_in = "01101" then
									enable_pcbr <= '0';
									load_b <= '0';
									arith <= '1';
									addr_add <= '1';
									
								elsif uOp_in = "01110" then
									load_acc <= '1';
								
								elsif uOp_in = "01111" then
									arith <= '0';
									addr_add <= '0';
									load_acc <= '0';
									enable_acc <='1';
								
								elsif uOp_in = "10000" then
									ld_pc <= '1';
								
								elsif uOp_in = "10001" then
									ld_pc <= '0';
									enable_acc <= '0';
									
								elsif uOp_in = "10010" then
									load_pcbr <= '1';
									
								elsif uOp_in = "10011" then
									load_pcbr <= '0';
									reset_uOp <= '1';
									inc_ic <= '1';
								end if;
							
							when others=>
									-- do nothing
						end case;
						
					-- END OF DECODE AND EXECUTE B-TYPE INSTRUCTION
					--
					--
					
					-- START OF DECODE AND EXECUTE OF S TYPE INSTRUCTION
					when "0100011" => 
						case current_instruction(14 downto 12) is
						-- sb
						when "000"=>
							if 	uOp_in = "00000" then
								reg_address_sel <= "10";                              -- select the source register R1
								read_reg <= '1';													-- outputing the data of source register
							
							elsif uOp_in = "00001" then
								load_a <= '1';
							
							elsif uOp_in = "00010" then
								load_a <= '0';
								read_reg <= '0';
								immediate_con_channel <= current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)
																		&current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)
																		&current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)
																		&current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)
																		&current_instruction(31 downto 25)&current_instruction(11 downto 8)&'0';
							
							elsif uOp_in = "00011" then
								load_imm <= '1';
							
							elsif uOp_in = "00100" then
								enable_imm <= '1';
								load_imm <= '0';
								immediate_con_channel <= x"00000000";
							
							elsif uOp_in = "00101" then
								load_b <= '1';
								pc_clock <= '1';
							
							elsif uOp_in = "00110" then
								pc_clock <= '0';
								load_pcbr <= '1';
								
								load_b <= '0';
								enable_imm <= '0';
								arith <= '1';
								addr_add <= '1';
								
							elsif uOp_in = "00111" then
								load_pcbr <= '0';
								load_acc <= '1';
								enable_acc <= '1';
							
							elsif uOp_in = "01000" then
								arith <= '0';
								addr_add <= '0';
								ld_pc <= '1';
								load_acc <= '0';
								
								
							elsif uOp_in = "01001" then
								ld_pc <= '0';
								enable_acc <= '0';
								reg_address_sel <= "11";
								read_reg <= '1';

							elsif uOp_in = "01010" then
								core_reg_data_in <= '1';
							
							elsif uOp_in = "01011" then
								core_reg_data_in <= '0';
								read_reg <= '0';
								reg_address_sel <= "00";
								en_pc <= '1';
								mem_bus_enable <= x"1";
								--
								--
								
							elsif uOp_in = "01100" then
								
								mem_write <= '1';
								
							elsif uOp_in = "01101" then
								mem_clock <= '1';
								
							elsif uOp_in = "01110" then
								mem_clock <= '0';
								mem_write <= '0';
								en_pc <= '0';
								mem_bus_enable <= x"0";
								
							elsif uOp_in = "10000" then
								enable_pcbr <= '1';
							
							elsif uOp_in = "10001" then
								ld_pc <= '1';
							
							elsif uOp_in = "10010" then
								enable_pcbr <= '0';
								ld_pc <= '0';
								reset_uOp <= '1';
								inc_ic <= '1';
							
							end if;
						
						-- sh
						when "001"=>
							if 	uOp_in = "00000" then
								reg_address_sel <= "10";                              -- select the source register R1
								read_reg <= '1';													-- outputing the data of source register
							
							elsif uOp_in = "00001" then
								load_a <= '1';
							
							elsif uOp_in = "00010" then
								load_a <= '0';
								read_reg <= '0';
								immediate_con_channel <= current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)
																		&current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)
																		&current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)
																		&current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)
																		&current_instruction(31 downto 25)&current_instruction(11 downto 8)&'0';
							
							elsif uOp_in = "00011" then
								load_imm <= '1';
							
							elsif uOp_in = "00100" then
								enable_imm <= '1';
								load_imm <= '0';
								immediate_con_channel <= x"00000000";
							
							elsif uOp_in = "00101" then
								load_b <= '1';
								pc_clock <= '1';
							
							elsif uOp_in = "00110" then
								pc_clock <= '0';
								load_pcbr <= '1';
								
								load_b <= '0';
								enable_imm <= '0';
								arith <= '1';
								addr_add <= '1';
								
							elsif uOp_in = "00111" then
								load_pcbr <= '0';
								load_acc <= '1';
								enable_acc <= '1';
							
							elsif uOp_in = "01000" then
								arith <= '0';
								addr_add <= '0';
								ld_pc <= '1';
								load_acc <= '0';
								
								
							elsif uOp_in = "01001" then
								ld_pc <= '0';
								enable_acc <= '0';
								reg_address_sel <= "11";
								read_reg <= '1';

							elsif uOp_in = "01010" then
								core_reg_data_in <= '1';
							
							elsif uOp_in = "01011" then
								core_reg_data_in <= '0';
								read_reg <= '0';
								reg_address_sel <= "00";
								en_pc <= '1';
								mem_bus_enable <= x"1";
								--
								--
								
							elsif uOp_in = "01100" then
								
								mem_write <= '1';
								
							elsif uOp_in = "01101" then
								mem_clock <= '1';
							
							elsif uOp_in = "01110" then
								mem_clock <= '0';
								pc_clock <= '1';
								mem_bus_enable <= x"2";
							
							elsif uOp_in = "01111" then
								pc_clock <= '0';
								mem_clock <= '1';
								
							elsif uOp_in = "10000" then
								mem_clock <= '0';
								mem_write <= '0';
								en_pc <= '0';
								mem_bus_enable <= x"0";
								
							elsif uOp_in = "10001" then
								enable_pcbr <= '1';
							
							elsif uOp_in = "10010" then
								ld_pc <= '1';
							
							elsif uOp_in = "10011" then
								enable_pcbr <= '0';
								ld_pc <= '0';
								reset_uOp <= '1';
								inc_ic <= '1';
							
							end if;
						
						-- sw
						when "010"=>
							if 	uOp_in = "00000" then
								reg_address_sel <= "10";                              -- select the source register R1
								read_reg <= '1';													-- outputing the data of source register
							
							elsif uOp_in = "00001" then
								load_a <= '1';
							
							elsif uOp_in = "00010" then
								load_a <= '0';
								read_reg <= '0';
								immediate_con_channel <= current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)
																		&current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)
																		&current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)
																		&current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)&current_instruction(31)
																		&current_instruction(31 downto 25)&current_instruction(11 downto 8)&'0';
							
							elsif uOp_in = "00011" then
								load_imm <= '1';
							
							elsif uOp_in = "00100" then
								enable_imm <= '1';
								load_imm <= '0';
								immediate_con_channel <= x"00000000";
							
							elsif uOp_in = "00101" then
								load_b <= '1';
								pc_clock <= '1';
							
							elsif uOp_in = "00110" then
								pc_clock <= '0';
								load_pcbr <= '1';
								
								load_b <= '0';
								enable_imm <= '0';
								arith <= '1';
								addr_add <= '1';
								
							elsif uOp_in = "00111" then
								load_pcbr <= '0';
								load_acc <= '1';
								enable_acc <= '1';
							
							elsif uOp_in = "01000" then
								arith <= '0';
								addr_add <= '0';
								ld_pc <= '1';
								load_acc <= '0';
								
								
							elsif uOp_in = "01001" then
								ld_pc <= '0';
								enable_acc <= '0';
								reg_address_sel <= "11";
								read_reg <= '1';

							elsif uOp_in = "01010" then
								core_reg_data_in <= '1';
							
							elsif uOp_in = "01011" then
								core_reg_data_in <= '0';
								read_reg <= '0';
								reg_address_sel <= "00";
								en_pc <= '1';
								mem_bus_enable <= x"1";
								--
								--
								
							elsif uOp_in = "01100" then
								
								mem_write <= '1';
								
							elsif uOp_in = "01101" then
								mem_clock <= '1';
							
							elsif uOp_in = "01110" then
								mem_clock <= '0';
								pc_clock <= '1';
								mem_bus_enable <= x"2";
							
							elsif uOp_in = "01111" then
								pc_clock <= '0';
								mem_clock <= '1';
							
							elsif uOp_in = "10000" then
								mem_clock <= '0';
								pc_clock <= '1';
								mem_bus_enable <= x"4";
							
							elsif uOp_in = "10001" then
								pc_clock <= '0';
								mem_clock <= '1';
								
							elsif uOp_in = "10010" then
								mem_clock <= '0';
								pc_clock <= '1';
								mem_bus_enable <= x"8";
							
							elsif uOp_in = "10011" then
								pc_clock <= '0';
								mem_clock <= '1';			
			
							elsif uOp_in = "10100" then
								mem_clock <= '0';
								mem_write <= '0';
								en_pc <= '0';
								mem_bus_enable <= x"0";
								
							elsif uOp_in = "10101" then
								enable_pcbr <= '1';
							
							elsif uOp_in = "10110" then
								ld_pc <= '1';
							
							elsif uOp_in = "10111" then
								enable_pcbr <= '0';
								ld_pc <= '0';
								reset_uOp <= '1';
								inc_ic <= '1';
							
							end if;
						
						when others=>
							-- do nothing
						end case;
					-- END OF DECODE AND EXECUTE OF S TYPE INSTRUCTION
					
					when others =>
					-- do nothing
					
					
					
				end case;
				-- END CASE for INSTRUCTION DECODE AND EXECUTE
			
		end case;
		-- END INSTRUCTION CYCLE case
		
	end process;
end Behavioral;