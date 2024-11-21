--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   07:45:14 01/29/2023
-- Design Name:   
-- Module Name:   /home/ise/Documents/Projects/Typhlosion_RV32I/IR_TB.vhd
-- Project Name:  Typhlosion_RV32I
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: instruction_register
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
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY IR_TB IS
END IR_TB;
 
ARCHITECTURE behavior OF IR_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT instruction_register
    PORT(
         instruction_in : IN  std_logic_vector(7 downto 0);
         load_instruction : IN  std_logic_vector(3 downto 0);
         instruction : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal instruction_in : std_logic_vector(7 downto 0) := (others => '0');
   signal load_instruction : std_logic_vector(3 downto 0) := (others => '0');

 	--Outputs
   signal instruction : std_logic_vector(31 downto 0);

 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: instruction_register PORT MAP (
          instruction_in => instruction_in,
          load_instruction => load_instruction,
          instruction => instruction
        );

   -- Clock process definitions

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
		instruction_in <= x"b1";
      wait for 10 ns;	
		load_instruction(0) <= '1';
		wait for 10 ns;
		load_instruction(0) <= '0';
		instruction_in <= x"a9";
		wait for 10 ns;
		load_instruction(1) <= '1';
		wait for 10 ns;
		load_instruction(1) <= '0';
		instruction_in <= x"1f";
		wait for 10 ns;
		load_instruction(2) <= '1';
		wait for 10 ns;
		load_instruction(2) <= '0';
		instruction_in <= x"de";
		wait for 10 ns;
		load_instruction(3) <= '1';
		wait for 10 ns;
		load_instruction(3) <= '0';
		wait for 10 ns;
      wait;
   end process;

END;
