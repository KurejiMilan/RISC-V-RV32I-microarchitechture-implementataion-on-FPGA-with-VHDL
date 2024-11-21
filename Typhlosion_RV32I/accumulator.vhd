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


entity acc_register is
    Port ( acc_in : in  STD_LOGIC_VECTOR (31 downto 0);
           acc_out : out  STD_LOGIC_VECTOR (31 downto 0);
           load_acc : in  STD_LOGIC;
			  enable_acc: in STD_LOGIC);
end acc_register;

architecture Behavioral of acc_register is
	signal acc : std_logic_vector(31 downto 0) := (others => '0');
begin
	acc_out <= acc when enable_acc = '1' else
					(others => 'Z');
	
	process(load_acc) 
	begin 
		if rising_edge(load_acc) then
			acc <= acc_in;
		end if;
	end process;
end Behavioral;

