----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    04:52:37 02/05/2023 
-- Design Name: 
-- Module Name:    register_bank - Behavioral 
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


entity register_bank is
    Port ( rs1 : in  STD_LOGIC_vector (4 downto 0);
           rs2 : in  STD_LOGIC_vector (4 downto 0);
           rd : in  STD_LOGIC_vector (4 downto 0);
           reg_address_sel : in  STD_LOGIC_VECTOR (1 downto 0);
           write_reg : in  STD_LOGIC;
           read_reg : in  STD_LOGIC;
           z_data : inout  STD_LOGIC_VECTOR (31 downto 0));
end register_bank;

architecture Behavioral of register_bank is

	component register32 is
		 Port ( input : in  STD_LOGIC_VECTOR (31 downto 0);
				  enable : in  STD_LOGIC;
				  store : in  STD_LOGIC;
				  fetch : in  STD_LOGIC;
				  output : out  STD_LOGIC_VECTOR (31 downto 0) := (others=>'Z'));
	end component;
	
	-- this register address multiplexer
	signal register_address_mux : std_logic_vector(4 downto 0);
	-- this is for deocder
	signal decoder_out : std_logic_vector(31 downto 0);
	
	-- for R0 register
	constant R0 : std_logic_vector(31 downto 0) := (others=> '0');
	signal R0_intermediate : std_logic_vector(31 downto 0);
	
begin
	-- creating instance of register
	R1 : register32 port map(input => z_data, enable=> decoder_out(1), store=>write_reg, fetch=>read_reg, output=>z_data);
	R2 : register32 port map(input => z_data, enable=> decoder_out(2), store=>write_reg, fetch=>read_reg, output=>z_data);
	R3 : register32 port map(input => z_data, enable=> decoder_out(3), store=>write_reg, fetch=>read_reg, output=>z_data);
	R4 : register32 port map(input => z_data, enable=> decoder_out(4), store=>write_reg, fetch=>read_reg, output=>z_data);
	R5 : register32 port map(input => z_data, enable=> decoder_out(5), store=>write_reg, fetch=>read_reg, output=>z_data);
	R6 : register32 port map(input => z_data, enable=> decoder_out(6), store=>write_reg, fetch=>read_reg, output=>z_data);
	R7 : register32 port map(input => z_data, enable=> decoder_out(7), store=>write_reg, fetch=>read_reg, output=>z_data);
	R8 : register32 port map(input => z_data, enable=> decoder_out(8), store=>write_reg, fetch=>read_reg, output=>z_data);
	R9 : register32 port map(input => z_data, enable=> decoder_out(9), store=>write_reg, fetch=>read_reg, output=>z_data);
	R10 : register32 port map(input => z_data, enable=> decoder_out(10), store=>write_reg, fetch=>read_reg, output=>z_data);
	R11 : register32 port map(input => z_data, enable=> decoder_out(11), store=>write_reg, fetch=>read_reg, output=>z_data);
	R12 : register32 port map(input => z_data, enable=> decoder_out(12), store=>write_reg, fetch=>read_reg, output=>z_data);
	R13 : register32 port map(input => z_data, enable=> decoder_out(13), store=>write_reg, fetch=>read_reg, output=>z_data);
	R14 : register32 port map(input => z_data, enable=> decoder_out(14), store=>write_reg, fetch=>read_reg, output=>z_data);
	R15 : register32 port map(input => z_data, enable=> decoder_out(15), store=>write_reg, fetch=>read_reg, output=>z_data);
	R16 : register32 port map(input => z_data, enable=> decoder_out(16), store=>write_reg, fetch=>read_reg, output=>z_data);
	R17 : register32 port map(input => z_data, enable=> decoder_out(17), store=>write_reg, fetch=>read_reg, output=>z_data);
	R18 : register32 port map(input => z_data, enable=> decoder_out(18), store=>write_reg, fetch=>read_reg, output=>z_data);
	R19 : register32 port map(input => z_data, enable=> decoder_out(19), store=>write_reg, fetch=>read_reg, output=>z_data);
	R20 : register32 port map(input => z_data, enable=> decoder_out(20), store=>write_reg, fetch=>read_reg, output=>z_data);
	R21 : register32 port map(input => z_data, enable=> decoder_out(21), store=>write_reg, fetch=>read_reg, output=>z_data);
	R22 : register32 port map(input => z_data, enable=> decoder_out(22), store=>write_reg, fetch=>read_reg, output=>z_data);
	R23 : register32 port map(input => z_data, enable=> decoder_out(23), store=>write_reg, fetch=>read_reg, output=>z_data);
	R24 : register32 port map(input => z_data, enable=> decoder_out(24), store=>write_reg, fetch=>read_reg, output=>z_data);
	R25 : register32 port map(input => z_data, enable=> decoder_out(25), store=>write_reg, fetch=>read_reg, output=>z_data);
	R26 : register32 port map(input => z_data, enable=> decoder_out(26), store=>write_reg, fetch=>read_reg, output=>z_data);
	R27 : register32 port map(input => z_data, enable=> decoder_out(27), store=>write_reg, fetch=>read_reg, output=>z_data);
	R28 : register32 port map(input => z_data, enable=> decoder_out(28), store=>write_reg, fetch=>read_reg, output=>z_data);
	R29 : register32 port map(input => z_data, enable=> decoder_out(29), store=>write_reg, fetch=>read_reg, output=>z_data);
	R30 : register32 port map(input => z_data, enable=> decoder_out(30), store=>write_reg, fetch=>read_reg, output=>z_data);
	R31 : register32 port map(input => z_data, enable=> decoder_out(31), store=>write_reg, fetch=>read_reg, output=>z_data);
	
	-- this section is for zero value register
	z_data <= R0_intermediate;
	R0_intermediate <= R0 when decoder_out(0) = '1' and read_reg ='1' else
								(others=> 'Z');
								
	-- this section is for deocder output
	decoder_out <= x"00000001" when register_address_mux = "00000" else
							x"00000002" when register_address_mux = "00001" else
							x"00000004" when register_address_mux = "00010" else
							x"00000008" when register_address_mux = "00011" else
							x"00000010" when register_address_mux = "00100" else
							x"00000020" when register_address_mux = "00101" else
							x"00000040" when register_address_mux = "00110" else
							x"00000080" when register_address_mux = "00111" else
							x"00000100" when register_address_mux = "01000" else
							x"00000200" when register_address_mux = "01001" else
							x"00000400" when register_address_mux = "01010" else
							x"00000800" when register_address_mux = "01011" else
							x"00001000" when register_address_mux = "01100" else
							x"00002000" when register_address_mux = "01101" else
							x"00004000" when register_address_mux = "01110" else
							x"00008000" when register_address_mux = "01111" else
							x"00010000" when register_address_mux = "10000" else
							x"00020000" when register_address_mux = "10001" else
							x"00040000" when register_address_mux = "10010" else
							x"00080000" when register_address_mux = "10011" else
							x"00100000" when register_address_mux = "10100" else
							x"00200000" when register_address_mux = "10101" else
							x"00400000" when register_address_mux = "10110" else
							x"00800000" when register_address_mux = "10111" else
							x"01000000" when register_address_mux = "11000" else
							x"02000000" when register_address_mux = "11001" else
							x"04000000" when register_address_mux = "11010" else
							x"08000000" when register_address_mux = "11011" else
							x"10000000" when register_address_mux = "11100" else
							x"20000000" when register_address_mux = "11101" else
							x"40000000" when register_address_mux = "11110" else
							x"80000000";
	-- this sector is for multiplexer implementation
	register_address_mux <= rd when reg_address_sel = "01" else 
									rs1 when reg_address_sel = "10" else
									rs2 when reg_address_sel = "11" else
									"00000";
end Behavioral;

