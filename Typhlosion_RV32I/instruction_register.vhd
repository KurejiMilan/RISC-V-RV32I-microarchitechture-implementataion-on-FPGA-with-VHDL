----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    07:27:52 01/29/2023 
-- Design Name: 
-- Module Name:    instruction_register - Behavioral 
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


-- load_instruction is used as control signal, load_instruction(0) corresponds to storing 8 bit value to IR_0
-- similarly for others

entity instruction_register is
    Port ( instruction_in : in  STD_LOGIC_VECTOR (7 downto 0);																		-- setting the external data bus to be 8 bit width
           load_instruction : in  STD_LOGIC_VECTOR (3 downto 0);
           instruction : out  STD_LOGIC_VECTOR (31 downto 0) := (others=>'0'));
end instruction_register;

architecture Behavioral of instruction_register is

	component register8 is
		 Port ( data_in : in  STD_LOGIC_VECTOR (7 downto 0);
				  store : in  STD_LOGIC;
				  data_out : out  STD_LOGIC_VECTOR (7 downto 0));
	end component register8;
	
	signal instruct : std_logic_vector(31 downto 0);
	
begin
	IR_0 : register8 port map( data_in => instruction_in(7 downto 0), store => load_instruction(0), data_out=> instruct(7 downto 0));
	IR_1 : register8 port map( data_in => instruction_in(7 downto 0), store => load_instruction(1), data_out=> instruct(15 downto 8));
	IR_2 : register8 port map( data_in => instruction_in(7 downto 0), store => load_instruction(2), data_out=> instruct(23 downto 16));
	IR_3 : register8 port map( data_in => instruction_in(7 downto 0), store => load_instruction(3), data_out=> instruct(31 downto 24));
	
	instruction <= instruct;
	
end Behavioral;
