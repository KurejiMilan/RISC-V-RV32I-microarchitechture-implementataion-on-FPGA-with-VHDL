--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   05:35:29 01/28/2023
-- Design Name:   
-- Module Name:   /home/ise/Documents/Projects/Typhlosion_RV32I/parallel_adder_TB.vhd
-- Project Name:  Typhlosion_RV32I
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Paraller_adder
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
use ieee.numeric_std.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY parallel_adder_TB IS
END parallel_adder_TB;
 
ARCHITECTURE behavior OF parallel_adder_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Paraller_adder
    PORT(
         a_in : IN  std_logic_vector(31 downto 0);
         b_in : IN  std_logic_vector(31 downto 0);
         c_in : IN  std_logic;
         sum : OUT  std_logic_vector(31 downto 0);
         carry_out : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal a_in : std_logic_vector(31 downto 0) := (others => '0');
   signal b_in : std_logic_vector(31 downto 0) := (others => '0');
   signal c_in : std_logic := '0';

 	--Outputs
   signal sum : std_logic_vector(31 downto 0);
   signal carry_out : std_logic;
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
	
	constant num1 : integer := 243;
	constant num2 : integer := 333;
  
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Paraller_adder PORT MAP (
          a_in => a_in,
          b_in => b_in,
          c_in => c_in,
          sum => sum,
          carry_out => carry_out
        );

   -- Stimulus process
   stim_proc: process
   begin		
		a_in <= std_logic_vector(to_unsigned(num1, 32));
		b_in <= std_logic_vector(to_unsigned(num2, 32));
		wait for 100 ns;
      wait;
   end process;

END;
