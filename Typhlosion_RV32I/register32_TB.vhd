--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   08:46:53 01/31/2023
-- Design Name:   
-- Module Name:   /home/ise/Documents/Projects/Typhlosion_RV32I/register32_TB.vhd
-- Project Name:  Typhlosion_RV32I
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: register32
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
 
ENTITY register32_TB IS
END register32_TB;
 
ARCHITECTURE behavior OF register32_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT register32
    PORT(
         input : IN  std_logic_vector(31 downto 0);
         enable : IN  std_logic;
         store : IN  std_logic;
         fetch : IN  std_logic;
         output : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal input : std_logic_vector(31 downto 0) := (others => '0');
   signal enable : std_logic := '0';
   signal store : std_logic := '0';
   signal fetch : std_logic := '0';

 	--Outputs
   signal output : std_logic_vector(31 downto 0);

 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: register32 PORT MAP (
          input => input,
          enable => enable,
          store => store,
          fetch => fetch,
          output => output
        );


   -- Stimulus process
   stim_proc: process
   begin		
      input <= x"a01f8021";
      wait for 10 ns;
		enable <= '1';
		wait for 10 ns;
		store <= '1';
		wait for 10 ns;
		store <= '0';
		wait for 10 ns;
		enable <= '0';
		wait for 10 ns;
		fetch <= '1';
		wait for 10 ns;
		enable <= '1';
		wait for 10 ns;
		enable <= '0';
		wait for 10 ns;
      wait;
   end process;

END;
