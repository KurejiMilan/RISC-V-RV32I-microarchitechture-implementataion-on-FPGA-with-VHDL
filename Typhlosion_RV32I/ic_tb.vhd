--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   11:41:54 01/27/2023
-- Design Name:   
-- Module Name:   /home/ise/Documents/Projects/Typhlosion_RV32I/ic_tb.vhd
-- Project Name:  Typhlosion_RV32I
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: instruction_cycle_counter
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY ic_tb IS
END ic_tb;
 
ARCHITECTURE behavior OF ic_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT instruction_cycle_counter
    PORT(
         inc_IC : IN  std_logic;
         Instruction_cycle : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal inc_IC : std_logic := '0';

 	--Outputs
   signal Instruction_cycle : std_logic;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: instruction_cycle_counter PORT MAP (
          inc_IC => inc_IC,
          Instruction_cycle => Instruction_cycle
        );

   -- Clock process definitions

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	
		inc_IC <= '1';
		wait for 100 ns;
		inc_ic <= '0';
		wait for 100 ns;
		inc_IC <= '1';
		wait for 100 ns;
      wait;
   end process;

END;
