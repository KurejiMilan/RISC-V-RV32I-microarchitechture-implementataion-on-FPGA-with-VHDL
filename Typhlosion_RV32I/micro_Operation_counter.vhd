----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:43:33 01/27/2023 
-- Design Name: 
-- Module Name:    micro_Operation_counter - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;


entity micro_Operation_counter is
    Port ( clock : in  STD_LOGIC;
           uOp_stage : out  STD_LOGIC_VECTOR (4 downto 0);
           reset_uOp : in  STD_LOGIC);
end micro_Operation_counter;

architecture Behavioral of micro_Operation_counter is
	signal counter : std_logic_vector(4 downto 0) := (others => '0');
begin
	uOp_stage <= counter;
	
	process(clock, reset_uOp)
	begin
		
		if reset_uOp = '1' then
			counter <= (others => '0');
		end if;
		
		if reset_uOp = '0' then
			if rising_edge(clock) then
				counter <= counter+1;
			end if;
		end if;
	end process;
end Behavioral;

