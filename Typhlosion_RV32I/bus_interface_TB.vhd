--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   17:07:37 02/04/2023
-- Design Name:   
-- Module Name:   /home/ise/Documents/Projects/Typhlosion_RV32I/bus_interface_TB.vhd
-- Project Name:  Typhlosion_RV32I
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: external_bus_interface_module
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
 
ENTITY bus_interface_TB IS
END bus_interface_TB;
 
ARCHITECTURE behavior OF bus_interface_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT external_bus_interface_module
    PORT(
         core_bus : INOUT  std_logic_vector(31 downto 0);
         core_bus_enable : IN  std_logic;
         core_reg_data_in : IN  std_logic;
         mem_bus : INOUT  std_logic_vector(7 downto 0);
         mem_reg_data_in : IN  std_logic_vector(3 downto 0);
         mem_bus_enable : IN  std_logic_vector(3 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal core_bus_enable : std_logic := '0';
   signal core_reg_data_in : std_logic := '0';
   signal mem_reg_data_in : std_logic_vector(3 downto 0) := (others => '0');
   signal mem_bus_enable : std_logic_vector(3 downto 0) := (others => '0');

	--BiDirs
   signal core_bus : std_logic_vector(31 downto 0);
   signal mem_bus : std_logic_vector(7 downto 0) := (others => 'Z');
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: external_bus_interface_module PORT MAP (
          core_bus => core_bus,
          core_bus_enable => core_bus_enable,
          core_reg_data_in => core_reg_data_in,
          mem_bus => mem_bus,
          mem_reg_data_in => mem_reg_data_in,
          mem_bus_enable => mem_bus_enable
        );
   -- Stimulus process
   stim_proc: process
   begin		
	
		-- transmiting from 32 bit to 8 bit
      wait for 10 ns;	
		core_bus <= x"a01808ff";
		wait for 10 ns;
		core_reg_data_in <= '1';
		wait for 10 ns;
		core_reg_data_in <= '0';
		wait for 10 ns;
		
		mem_bus_enable <= x"1";
		wait for 10 ns;
		mem_bus_enable <= x"2";
		wait for 10 ns;
		mem_bus_enable <= x"4";
		wait for 10 ns;
		mem_bus_enable <= x"8";
		wait for 10 ns;
		mem_bus_enable <= x"0";
		wait for 10 ns;
		
		-- transmiting from 8 bit to 32 bit
		core_bus <= (others => 'Z');
		mem_bus <= x"00";
		mem_reg_data_in <= x"1";
		wait for 10 ns;
		mem_reg_data_in <= x"0";
		wait for 10 ns;
		mem_bus <= x"9f";
		mem_reg_data_in <= x"2";
		wait for 10 ns;
		mem_reg_data_in <= x"0";
		wait for 10 ns;
		mem_bus <= x"a2";
		mem_reg_data_in <= x"4";
		wait for 10 ns;
		mem_reg_data_in <= x"0";
		wait for 10 ns;
		mem_bus <= x"0e";
		mem_reg_data_in <= x"8";
		wait for 10 ns;
		core_bus_enable <= '1';
		wait for 10 ns;
		wait;
   end process;

END;
