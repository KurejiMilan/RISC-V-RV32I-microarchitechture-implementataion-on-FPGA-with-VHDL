--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   06:26:16 01/27/2023
-- Design Name:   
-- Module Name:   /home/ise/Documents/Projects/Typhlosion_RV32I/comparator_ALU_TB.vhd
-- Project Name:  Typhlosion_RV32I
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: comparator_ALU
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
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY comparator_ALU_TB IS
END comparator_ALU_TB;
 
ARCHITECTURE behavior OF comparator_ALU_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT comparator_ALU
    PORT(
         A_in : IN  std_logic_vector(31 downto 0);
         B_in : IN  std_logic_vector(31 downto 0);
			is_unsigned : in std_logic;
         Z_out : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal A_in : std_logic_vector(31 downto 0) := (others => '0');
   signal B_in : std_logic_vector(31 downto 0) := (others => '0');
	signal is_unsigned  : std_logic := '0';
 	--Outputs
   signal Z_out : std_logic_vector(31 downto 0);
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
   constant nega : integer := -10;
	constant negb : integer := -20;
	constant posa : integer := 200;
	constant posb : integer := 300;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: comparator_ALU PORT MAP (
          A_in => A_in,
          B_in => B_in,
			 is_unsigned => is_unsigned,
          Z_out => Z_out
        );
 

   -- Stimulus process
   stim_proc: process
   begin			
		a_in <= std_logic_vector(to_unsigned(posa, 32));
		b_in <= std_logic_vector(to_unsigned(posb, 32));
		wait for 10 ns;
		a_in <= std_logic_vector(to_unsigned(posb, 32));
		b_in <= std_logic_vector(to_unsigned(posa, 32));
		wait for 10 ns;
		a_in <= std_logic_vector(to_unsigned(posa, 32));
		b_in <= std_logic_vector(to_signed(negb, 32));
		wait for 10 ns;
		a_in <= std_logic_vector(to_signed(negb, 32));
		b_in <= std_logic_vector(to_unsigned(posa, 32));
		wait for 10 ns;
		a_in <= std_logic_vector(to_signed(nega, 32));
		b_in <= std_logic_vector(to_signed(negb, 32));
		wait for 10 ns;
		a_in <= std_logic_vector(to_signed(negb, 32));
		b_in <= std_logic_vector(to_signed(nega, 32));
		wait for 10 ns;
		
		is_unsigned <= '1';
		
		a_in <= std_logic_vector(to_unsigned(posa, 32));
		b_in <= std_logic_vector(to_unsigned(posb, 32));
		wait for 10 ns;
		a_in <= std_logic_vector(to_unsigned(posb, 32));
		b_in <= std_logic_vector(to_unsigned(posa, 32));
		wait for 10 ns;
      wait;
   end process;

END;
