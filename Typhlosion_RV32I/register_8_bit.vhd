----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    07:19:20 01/29/2023 
-- Design Name: 
-- Module Name:    register8 - Behavioral 
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

entity register8 is
    Port ( data_in : in  STD_LOGIC_VECTOR (7 downto 0) := x"00";
           store : in  STD_LOGIC;
           data_out : out  STD_LOGIC_VECTOR (7 downto 0));
end register8;

architecture Behavioral of register8 is
	signal data : std_logic_vector(7 downto 0);
begin
	data_out <= data;
	load_data : process(store)
	begin
		if rising_edge(store) then
			data <= data_in;
		end if;
	end process;
end Behavioral;

