----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:54:58 01/27/2023 
-- Design Name: 
-- Module Name:    PC - Behavioral 
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
use ieee.std_logic_unsigned.all;

-- needs to add input ports for loading the address

entity PC is
    Port ( enable_pc : in  STD_LOGIC;
           pc_clk : in  STD_LOGIC;
			  load_pc : in STD_LOGIC;
			  pc_to_pcbr : out std_logic_vector(31 downto 0);				  	-- this is feed to the pc buffer register
           address_in : in std_logic_vector(31 downto 0);					--	this is used to load the address for jump and load data instruciton
			  address_out : out  STD_LOGIC_VECTOR (31 downto 0) := (others => 'Z'));				-- while this is feed to the address bus
end PC;

architecture Behavioral of PC is
	signal address_counter : std_logic_vector(31 downto 0) := (others=>'0');
begin
	
	process(pc_clk, enable_pc, load_pc) 
	begin
		if rising_edge(pc_clk) then
			address_counter <= address_counter+1;
		end if;
		
		if rising_edge(load_pc) then
			address_counter <= address_in;
		end if;
	end process;
	
	-- enable or disable the pc output to connect or disconnect fromt the address bus
	pc_to_pcbr <= address_counter;
	
	address_out <= address_counter when enable_pc = '1' else
						(others => 'Z');
						
end Behavioral;

