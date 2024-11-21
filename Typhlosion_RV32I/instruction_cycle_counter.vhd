----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:27:10 01/27/2023 
-- Design Name: 
-- Module Name:    instruction_cycle_counter - Behavioral 
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

-- any instuction is executed in a number of cycles
-- fetch cycle, decode and execute cycle
-- fetch cycle is represented by Instruction_cycle = 0
-- decode and execute cycle is represented by instruction_cycle = 1

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity instruction_cycle_counter is
    Port ( inc_IC : in  STD_LOGIC;
           Instruction_cycle : out  STD_LOGIC);
end instruction_cycle_counter;

architecture Behavioral of instruction_cycle_counter is
	signal Ins_cycle : std_logic := '0';				
begin
	Instruction_cycle <= Ins_cycle;
	process(inc_IC)
	begin
		if rising_edge(inc_IC) then
			Ins_cycle <= not Ins_cycle;
		end if;
	end process;

end Behavioral;

