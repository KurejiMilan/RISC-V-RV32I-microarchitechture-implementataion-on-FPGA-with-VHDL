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


entity imm_register is
    Port ( imm_in : in  STD_LOGIC_VECTOR (31 downto 0);
           imm_out : out  STD_LOGIC_VECTOR (31 downto 0);
           load_imm : in  STD_LOGIC;
			  enable_imm: in STD_LOGIC);
end imm_register;

architecture Behavioral of imm_register is
	signal imm : std_logic_vector(31 downto 0) := (others => '0');
begin
	imm_out <= imm when enable_imm = '1' else
					(others => 'Z');
	
	process(load_imm) 
	begin 
		if rising_edge(load_imm) then
			imm <= imm_in;
		end if;
	end process;
end Behavioral;

