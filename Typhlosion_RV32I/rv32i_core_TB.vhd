--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   11:00:03 04/06/2023
-- Design Name:   
-- Module Name:   /home/ise/Documents/Projects/Typhlosion_RV32I/rv32i_core_TB.vhd
-- Project Name:  Typhlosion_RV32I
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: rv32i_core
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

ENTITY rv32i_core_TB IS
END rv32i_core_TB;
 
ARCHITECTURE behavior OF rv32i_core_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT rv32i_core
    PORT(
         input_clock : IN  std_logic;
         memory_read : OUT  std_logic;
         memory_write : OUT  std_logic;
			memory_clock : OUT std_logic;
         DATA_BUS : INOUT  std_logic_vector(7 downto 0);
         ADDRESS_BUS : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal input_clock : std_logic := '0';

	--BiDirs
   signal DATA_BUS : std_logic_vector(7 downto 0);

 	--Outputs
   signal memory_read : std_logic;
   signal memory_write : std_logic;
	signal memory_clock : std_logic;
	
   signal ADDRESS_BUS : std_logic_vector(31 downto 0);

	signal write_loc : std_logic_vector(7 downto 0);
	
	signal output_reg : std_logic_vector(7 downto 0);
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: rv32i_core PORT MAP (
          input_clock => input_clock,
          memory_read => memory_read,
          memory_write => memory_write,
          DATA_BUS => DATA_BUS,
          ADDRESS_BUS => ADDRESS_BUS
        );

	input_clock <= not input_clock after 10 ns;


   stim_proc: process(memory_read)
   begin		
		if memory_read = '1' then
		
			if address_bus = std_logic_vector(to_unsigned(0, 32)) then
				data_bus <= X"83";
			end if;
			if address_bus = std_logic_vector(to_unsigned(1, 32)) then
				data_bus <= X"20";
			end if;
			if address_bus = std_logic_vector(to_unsigned(2, 32)) then
				data_bus <= X"00";
			end if;
			if address_bus = std_logic_vector(to_unsigned(3, 32)) then
				data_bus <= X"7d";
			end if;
			if address_bus = std_logic_vector(to_unsigned(4, 32)) then
				data_bus <= X"23";
			end if;
			if address_bus = std_logic_vector(to_unsigned(5, 32)) then
				data_bus <= X"1e";
			end if;
			if address_bus = std_logic_vector(to_unsigned(6, 32)) then
				data_bus <= X"10";
			end if;
			if address_bus = std_logic_vector(to_unsigned(7, 32)) then
				data_bus <= X"5c";
			end if;
			if address_bus = std_logic_vector(to_unsigned(8, 32)) then
				data_bus <= X"23";
			end if;
			if address_bus = std_logic_vector(to_unsigned(9, 32)) then
				data_bus <= X"20";
			end if;
			if address_bus = std_logic_vector(to_unsigned(10, 32)) then
				data_bus <= X"10";
			end if;
			if address_bus = std_logic_vector(to_unsigned(11, 32)) then
				data_bus <= X"5e";
			end if;
			if address_bus = std_logic_vector(to_unsigned(2000, 32)) then
				data_bus <= X"11";
			end if;
			if address_bus = std_logic_vector(to_unsigned(2001, 32)) then
				data_bus <= X"AA";
			end if;
			if address_bus = std_logic_vector(to_unsigned(2002, 32)) then
				data_bus <= X"00";
			end if;
			if address_bus = std_logic_vector(to_unsigned(2003, 32)) then
				data_bus <= X"FF";
			end if;
		
		elsif memory_read = '0' then
			data_bus <= (others => 'Z');
		
		end if;
		
		
   end process;
	
	write_proc: process(memory_write)
	begin
		if memory_write = '1' then
			if rising_edge(memory_clock) then
				output_reg <= data_bus;
			end if;
		end if;
		
	end process;
END;
