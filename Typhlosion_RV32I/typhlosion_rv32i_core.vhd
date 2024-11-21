----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Milan Rai
-- 
-- Create Date:    11:24:30 01/27/2023 
-- Design Name: 
-- Module Name:    rv32i_core - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity rv32i_core is
    Port ( input_clock : in  STD_LOGIC;
				memory_read : out std_logic;
				memory_write : out std_logic;
				memory_clock : out std_logic;
				DATA_BUS : inout STD_LOGIC_VECTOR(7 downto 0);
				ADDRESS_BUS : out STD_LOGIC_VECTOR(31 DOWNTO 0));
end rv32i_core;

architecture Behavioral of rv32i_core is

	
	component imm_register is
    Port ( imm_in : in  STD_LOGIC_VECTOR (31 downto 0);
           imm_out : out  STD_LOGIC_VECTOR (31 downto 0);
           load_imm : in  STD_LOGIC;
			  enable_imm: in STD_LOGIC);
	end component imm_register;
	
	component instruction_register is
		 Port ( instruction_in : in  STD_LOGIC_VECTOR (7 downto 0);																		
				  load_instruction : in  STD_LOGIC_VECTOR (3 downto 0);
				  instruction : out  STD_LOGIC_VECTOR (31 downto 0) := (others=>'0'));
	end component instruction_register;


	component PC
   Port ( enable_pc : in  STD_LOGIC;
           pc_clk : in  STD_LOGIC;
			  load_pc : in STD_LOGIC;
			  pc_to_pcbr : out std_logic_vector(31 downto 0);				  	-- this is feed to the pc buffer register
           address_in : in std_logic_vector(31 downto 0);					--	this is used to load the address for jump and load data instruciton
			  address_out : out  STD_LOGIC_VECTOR (31 downto 0) := (others => 'Z')
			  );				-- while this is feed to the address bus
	end component PC;

	component ALU is
    Port ( a_in : in  STD_LOGIC_VECTOR (31 downto 0);
           b_in : in  STD_LOGIC_VECTOR (31 downto 0);
			  i_30 : in std_logic;																-- this is the 31th bit from the instuction register
           address_add : in std_logic;														-- control signal for addition of address
			  unsign_comp : in std_logic;														-- this is used for sign comparision operation, Control signal
			  sl : in  STD_LOGIC;																-- this is used as control signal
           sr : in  STD_LOGIC;																-- control signal to select the left shift
           arith : in  STD_LOGIC;															-- control signal to select the right shift
           xor_sel : in  STD_LOGIC;															-- control signal to select the xor_output
           and_sel : in  STD_LOGIC;															-- control signal to select the and  output
           or_sel : in  STD_LOGIC;															-- control signal to select the or output
			  comp_sel : in STD_LOGIC;															-- control signal to select the comparator output
           eql : in STD_LOGIC;
			  z_out : out  STD_LOGIC_VECTOR (31 downto 0));								-- this is connected to the accumulator 
	end component ALU;
	
	component a_register is
    Port ( a_in : in  STD_LOGIC_VECTOR (31 downto 0);
           a_out : out  STD_LOGIC_VECTOR (31 downto 0);
           load_a : in  STD_LOGIC);
	end component a_register;
	
	component b_register is
    Port ( b_in : in  STD_LOGIC_VECTOR (31 downto 0);
           b_out : out  STD_LOGIC_VECTOR (31 downto 0);
           load_b : in  STD_LOGIC);
	end component b_register;

	component acc_register is
    Port ( acc_in : in  STD_LOGIC_VECTOR (31 downto 0);
           acc_out : out  STD_LOGIC_VECTOR (31 downto 0);
           load_acc : in  STD_LOGIC;
			  enable_acc: in STD_LOGIC);
	end component acc_register;
	
	component micro_Operation_counter is
    Port ( clock : in  STD_LOGIC;
           uOp_stage : out  STD_LOGIC_VECTOR (4 downto 0);
           reset_uOp : in  STD_LOGIC);
	end component micro_Operation_counter;
	
	component instruction_cycle_counter is
    Port ( inc_IC : in  STD_LOGIC;
           Instruction_cycle : out  STD_LOGIC);
	end component instruction_cycle_counter;
	
	component register_bank is
    Port ( rs1 : in  STD_LOGIC_vector (4 downto 0);
           rs2 : in  STD_LOGIC_vector (4 downto 0);
           rd : in  STD_LOGIC_vector (4 downto 0);
           reg_address_sel : in  STD_LOGIC_VECTOR (1 downto 0);
           write_reg : in  STD_LOGIC;
           read_reg : in  STD_LOGIC;
           z_data : inout  STD_LOGIC_VECTOR (31 downto 0));
	end component register_bank;
		
	component external_bus_interface_module is
    Port ( core_bus : inout  STD_LOGIC_VECTOR (31 downto 0);
			  core_bus_enable : in std_logic;																	-- this is used to enable the bus towards the core side
			  core_reg_data_in : in std_logic;																	-- this is used to latch in the 32 bit word from the core bus
			  mem_bus : inout  STD_LOGIC_VECTOR (7 downto 0);												-- used to interface along the mem bus
			  mem_reg_data_in : in std_logic_vector(3 downto 0);											-- this is used to latch in 8 bit word one at a time from the 8 bit mem bus
			  mem_bus_enable : in std_logic_vector(3 downto 0)												-- this is used to enable the tristate towards the 8 bit bus
			  );											
	end component external_bus_interface_module;

	component program_counter_buffer is
		 Port ( enable_PCBr : in  STD_LOGIC;
				  load_PCBr : in  STD_LOGIC;
				  PCBr_AddressOut : out  STD_LOGIC_VECTOR (31 downto 0);
				  PCBr_AddressIn : in  STD_LOGIC_VECTOR (31 downto 0));
	end component program_counter_buffer;
	
component ControlUnit_Decoder is
    Port ( 	-- this is used as the input for control
				uOp_in : in  STD_LOGIC_VECTOR (4 downto 0);
				current_instruction : in std_logic_vector(31 downto 0);
				instruction_cycle : in std_logic;													-- con
				data_in : in std_logic_vector(31 downto 0) := (others=>'Z');
				
				-- control unit outputs immediate data to the immediate register
				imm : out std_logic_vector(31 downto 0);						
				
				
				-- control bus signals
				load_imm, enable_imm : out std_logic := '0';									-- immediate register
				load_ins : out std_logic_vector(3 downto 0);                         -- instrution  register
				en_pc : out std_logic := '0';														-- program counter
				pc_clock : out std_logic;
				ld_pc : out std_logic := '0';
				
				-- signal realted to ALU
				unsign_comp, sl, sr, arith, xor_sel, and_sel, or_sel, comp_sel, addr_add , equal: out std_logic := '0';					
				load_a, load_b , load_acc, enable_acc : out std_logic := '0';                                      -- registers
				
				reset_uOp : out std_logic := '0';	-- con																			-- uOp counter
				inc_ic : out std_logic;		-- con																						-- instruction cycle counter
				
				-- signals related to register banks
				reg_address_sel : out std_logic_vector(1 downto 0) := (others => '0'); --con							-- register bank
				write_reg : out std_logic;				-- con
				read_reg : out std_logic;				-- con
				
				-- signal related to bus interface
				core_bus_enable : out std_logic;		-- con																						-- external_bus_interface_module
				core_reg_data_in : out std_logic;	-- con
				
				mem_reg_data_in : out std_logic_vector(3 downto 0);		-- con
				mem_bus_enable : out std_logic_vector(3 downto 0);			-- con
				
				mem_read : out std_logic := '0';
				mem_write : out std_logic := '0';
				mem_clock : out std_logic := '0';
				-- PC buffer register
				enable_pcbr, load_pcbr : out std_logic := '0'
				
			  );
end component ControlUnit_Decoder;
	
	-- internal busses
	signal databus : std_logic_vector(31 downto 0) := (others=>'Z');
	signal addressbus : std_logic_vector(31 downto 0) := (others=>'Z');
	
	-- internal channels
	-- channels and connection differes as channels are bus while connection are not in this instance
	
	signal pc_to_pcbr_channel : std_logic_vector(31 downto 0);							-- program counter
	signal instruction_channel : std_logic_vector(31 downto 0);							-- instruction register
	signal imm_channel : std_logic_vector(31 downto 0);									-- immediate register
	signal a_channel , b_channel, acc_channel : std_logic_vector(31 downto 0);   	-- accumulator and alu
	signal uOp_channel: std_logic_vector(4 downto 0);
	
	-- control bus signals
	signal load_imm, enable_imm : std_logic := '0';									-- immediate register
	signal load_ins : std_logic_vector(3 downto 0);                         -- instrution  register
	-- program counter control bus
	signal en_pc : std_logic := '0';														-- program counter
	signal pc_clock : std_logic;
	signal load_pc_con : std_logic := '0';
	
	signal i_30 : std_logic ;																-- ALU
	signal address_add_con : std_logic;
	signal unsign_comp, sl, sr, arith, xor_sel, and_sel, or_sel, comp_sel, eql_con : std_logic := '0';
	signal load_a, load_b , load_acc, enable_acc : std_logic := '0';                                                     -- registers
	signal reset_uOp_con : std_logic := '0';																										-- uOp counter
	signal inc_ic_con : std_logic;																													-- instruction cycle counter
	signal instruction_cycle_con : std_logic;
	
	signal reg_address_sel_con : std_logic_vector(1 downto 0);																				-- register bank
	signal write_reg_con : std_logic;
	signal read_reg_con : std_logic;
	
	signal core_bus_enable_con : std_logic;																										-- external_bus_interface_module
	signal core_reg_data_in_con : std_logic;
	signal mem_reg_data_in_con : std_logic_vector(3 downto 0);
	signal mem_bus_enable_con : std_logic_vector(3 downto 0);
	
	signal mem_clock_con : std_logic;
	-- pc buffer signal
	signal enable_pcbr_con, load_pcbr_con : std_logic;
	
begin
	memory_clock <= mem_clock_con;
	address_bus <= addressbus;
	Decoder : ControlUnit_Decoder port map( 
				uOp_in => uOp_channel,
				current_instruction => instruction_channel,
				instruction_cycle => instruction_cycle_con,												
				data_in => databus, 
				imm => imm_channel,						
				load_imm => load_imm, 
				enable_imm => enable_imm,
				load_ins => load_ins,
				en_pc => en_pc,
				pc_clock => pc_clock,
				ld_pc => load_pc_con,
				unsign_comp => unsign_comp, 
				sl => sl, 
				sr => sr, 
				arith => arith, 
				xor_sel => xor_sel, 
				and_sel => and_sel, 
				or_sel => or_sel,
				equal => eql_con,
				comp_sel => comp_sel, 
				addr_add => address_add_con,					
				load_a => load_a, 
				load_b => load_b, 
				load_acc => load_acc, 
				enable_acc => enable_acc, 
				reset_uOp => reset_uOp_con,
				inc_ic => inc_ic_con,
				reg_address_sel=> reg_address_sel_con,
				write_reg => write_reg_con,
				read_reg => read_reg_con,	
				core_bus_enable => core_bus_enable_con, 																							
				core_reg_data_in => core_reg_data_in_con, 	
				mem_reg_data_in => mem_reg_data_in_con,
				mem_bus_enable => mem_bus_enable_con,
				mem_read => memory_read,
				mem_write => memory_write,
				mem_clock => mem_clock_con,
				enable_pcbr => enable_pcbr_con,
				load_pcbr => load_pcbr_con
			  );
	
	bus_interface : external_bus_interface_module port map (core_bus => databus, core_bus_enable => core_bus_enable_con, core_reg_data_in=> core_reg_data_in_con,
							mem_bus => data_bus, mem_reg_data_in => mem_reg_data_in_con, mem_bus_enable=> mem_bus_enable_con);
							
	reg_bank : register_bank port map(rs1 => instruction_channel(19 downto 15), rs2 => instruction_channel(24 downto 20), 
													rd => instruction_channel(11 downto 7) , reg_address_sel => reg_address_sel_con, write_reg => write_reg_con,
													read_reg => read_reg_con, z_data => databus);
													
	uOp_counter : micro_Operation_counter port map(clock => input_clock, uOp_stage => uOp_channel, reset_uOp => reset_uOp_con);
	ins_cycle_counter : instruction_cycle_counter port map (inc_IC => inc_ic_con, instruction_cycle => instruction_cycle_con);
	a_reg : a_register port map(a_in => databus, a_out=> a_channel, load_a => load_a);
	b_reg : b_register port map(b_in => databus, b_out => b_channel, load_b => load_b);
	acc_reg : acc_register port map(acc_in=> acc_channel, acc_out => databus, load_acc => load_acc, enable_acc => enable_acc);
	
	ALU_sub_module : ALU Port map( 	a_in => a_channel,
												b_in => b_channel ,
												i_30 	=> instruction_channel(30),														
												address_add =>  address_add_con,
												unsign_comp => unsign_comp, 														
												sl => sl,												
												sr => sr,																
												arith	=> arith,														
												xor_sel => xor_sel,													
												and_sel => and_sel,											
												or_sel => or_sel,											
												comp_sel => comp_sel,
												eql => eql_con,
												z_out => acc_channel);								

	program_counter : PC Port map( enable_pc => en_pc,  pc_clk => pc_clock, load_pc => load_pc_con,address_in => databus,pc_to_pcbr => pc_to_pcbr_channel, address_out => addressbus);						
												
	counter_buffer : program_counter_buffer Port map( enable_PCBr => enable_pcbr_con, load_PCBr => load_pcbr_con, PCBr_AddressOut => databus,  PCBr_AddressIn => pc_to_pcbr_channel);
	
	ins_reg : instruction_register port map(instruction_in => DATA_BUS, load_instruction => load_ins, instruction => instruction_channel);  -- done
	immediate : imm_register port map(imm_in => imm_channel, imm_out=> databus, load_imm => load_imm, enable_imm => enable_imm);				-- done
end Behavioral;

