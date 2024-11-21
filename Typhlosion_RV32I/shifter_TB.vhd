--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   07:44:41 01/28/2023
-- Design Name:   
-- Module Name:   /home/ise/Documents/Projects/Typhlosion_RV32I/shifter_TB.vhd
-- Project Name:  Typhlosion_RV32I
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: shifter
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
 
ENTITY shifter_TB IS
END shifter_TB;
 
ARCHITECTURE behavior OF shifter_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT shifter
    PORT(
         A_in : IN  std_logic_vector(31 downto 0);
         B_in : IN  std_logic_vector(4 downto 0);
         arith_shift : IN  std_logic;
         shift_left : OUT  std_logic_vector(31 downto 0);
         shift_right : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal A_in : std_logic_vector(31 downto 0) := (others => '0');
   signal B_in : std_logic_vector(4 downto 0) := (others => '0');
   signal arith_shift : std_logic := '0';

 	--Outputs
   signal shift_left : std_logic_vector(31 downto 0);
   signal shift_right : std_logic_vector(31 downto 0);
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: shifter PORT MAP (
          A_in => A_in,
          B_in => B_in,
          arith_shift => arith_shift,
          shift_left => shift_left,
          shift_right => shift_right
        );
 

   -- Stimulus process
   stim_proc: process
   begin		
		A_in <= x"8000100A";
		B_in <= "00010";
		wait for 100 ns;
		arith_shift <= '1';
		wait for 100 ns;
      wait;
   end process;

END;
