----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    07:40:16 02/05/2023 
-- Design Name: 
-- Module Name:    a_register - Behavioral 
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


entity a_register is
    Port ( a_in : in  STD_LOGIC_VECTOR (31 downto 0);
           a_out : out  STD_LOGIC_VECTOR (31 downto 0);
           load_a : in  STD_LOGIC);
end a_register;

architecture Behavioral of a_register is
	signal a : std_logic_vector(31 downto 0) := (others => '0');
begin
	a_out <= a;
	process(load_a) 
	begin 
		if rising_edge(load_a) then
			a <= a_in;
		end if;
	end process;
end Behavioral;

