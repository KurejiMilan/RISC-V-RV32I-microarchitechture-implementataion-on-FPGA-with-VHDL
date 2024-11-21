--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   04:05:41 01/28/2023
-- Design Name:   
-- Module Name:   /home/ise/Documents/Projects/Typhlosion_RV32I/full_adder_tb.vhd
-- Project Name:  Typhlosion_RV32I
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: full_adder
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
 
ENTITY full_adder_tb IS
END full_adder_tb;
 
ARCHITECTURE behavior OF full_adder_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT full_adder
    PORT(
         a : IN  std_logic;
         b : IN  std_logic;
         c_in : IN  std_logic;
         s : OUT  std_logic;
         c_out : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal a : std_logic := '0';
   signal b : std_logic := '0';
   signal c_in : std_logic := '0';

 	--Outputs
   signal s : std_logic;
   signal c_out : std_logic;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: full_adder PORT MAP (
          a => a,
          b => b,
          c_in => c_in,
          s => s,
          c_out => c_out
        );

   stim_proc: process
   begin		
      wait for 100 ns;	
		a <= '1';
		wait for 100 ns;
		a <= '0';
		b <= '1';
		wait for 100 ns;
		a <= '1';
		b <= '1';
		wait for 100 ns;
		a <= '0';
		b <= '0';
		c_in <= '1';
		wait for 100 ns;
		a <= '1';
		b <= '0';
		wait for 100 ns;
		a <= '0';
		b <= '1';
		wait for 100 ns;
		a <= '1';
		b <= '1';
		wait for 100 ns;
      wait;
   end process;

END;
