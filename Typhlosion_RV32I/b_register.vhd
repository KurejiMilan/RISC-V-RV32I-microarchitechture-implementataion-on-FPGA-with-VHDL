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


entity b_register is
    Port ( b_in : in  STD_LOGIC_VECTOR (31 downto 0);
           b_out : out  STD_LOGIC_VECTOR (31 downto 0);
           load_b : in  STD_LOGIC);
end b_register;

architecture Behavioral of b_register is
	signal b : std_logic_vector(31 downto 0) := (others => '0');
begin
	b_out <= b;
	process(load_b) 
	begin 
		if rising_edge(load_b) then
			b <= b_in;
		end if;
	end process;
end Behavioral;

