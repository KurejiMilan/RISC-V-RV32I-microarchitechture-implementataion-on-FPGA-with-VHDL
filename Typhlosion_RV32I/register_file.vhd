----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:53:44 01/29/2023 
-- Design Name: 
-- Module Name:    register - Behavioral 
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


entity register32 is
    Port ( input : in  STD_LOGIC_VECTOR (31 downto 0);
           enable : in  STD_LOGIC;
           store : in  STD_LOGIC;
           fetch : in  STD_LOGIC;
			  output : out  STD_LOGIC_VECTOR (31 downto 0) := (others=>'Z'));
end register32;

architecture Behavioral of register32 is
	signal z : std_logic_vector(31 downto 0) := (others => '0');
begin

	process(input, enable, store, fetch)
	begin
		if enable = '1' then
			if rising_edge(store) then
				z <= input;	
			elsif fetch = '1' then
				output <= z;
			else
				output <= (others => 'Z');
			end if;
		else
			output <= (others => 'Z');
		end if;
	end process;
	
end Behavioral;

