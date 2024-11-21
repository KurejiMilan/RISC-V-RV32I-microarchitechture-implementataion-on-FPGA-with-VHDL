--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   10:21:36 01/29/2023
-- Design Name:   
-- Module Name:   /home/ise/Documents/Projects/Typhlosion_RV32I/add_sub_TB.vhd
-- Project Name:  Typhlosion_RV32I
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: add_sub
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
USE ieee.numeric_std.ALL;
use ieee.std_logic_unsigned.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY add_sub_TB IS
END add_sub_TB;
 
ARCHITECTURE behavior OF add_sub_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT add_sub
    PORT(
         a_in : IN  std_logic_vector(31 downto 0);
         b_in : IN  std_logic_vector(31 downto 0);
         add : IN  std_logic;
         result : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal a_in : std_logic_vector(31 downto 0) := (others => '0');
   signal b_in : std_logic_vector(31 downto 0) := (others => '0');
   signal add : std_logic := '0';

 	--Outputs
   signal result : std_logic_vector(31 downto 0);
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: add_sub PORT MAP (
          a_in => a_in,
          b_in => b_in,
          add => add,
          result => result
        );


   -- Stimulus process
   stim_proc: process
   begin	
		a_in <= std_logic_vector(to_unsigned(10, 32));
		b_in <= std_logic_vector(to_unsigned(20, 32));
      wait for 10 ns;	
		add <= '1';
		wait for 10 ns;
      wait;
   end process;

END;
