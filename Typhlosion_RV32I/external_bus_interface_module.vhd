----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:46:16 02/04/2023 
-- Design Name: 
-- Module Name:    external_bus_interface_module - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity external_bus_interface_module is
    Port ( core_bus : inout  STD_LOGIC_VECTOR (31 downto 0);
			  core_bus_enable : in std_logic;																	-- this is used to enable the bus towards the core side
			  core_reg_data_in : in std_logic;																	-- this is used to latch in the 32 bit word from the core bus
			  mem_bus : inout  STD_LOGIC_VECTOR (7 downto 0);												-- used to interface along the mem bus
			  mem_reg_data_in : in std_logic_vector(3 downto 0);											-- this is used to latch in 8 bit word one at a time from the 8 bit mem bus
			  mem_bus_enable : in std_logic_vector(3 downto 0)												-- this is used to enable the tristate towards the 8 bit bus
			  );											
			  
end external_bus_interface_module;

architecture Behavioral of external_bus_interface_module is
	component register8 is
		 Port ( data_in : in  STD_LOGIC_VECTOR (7 downto 0) := x"00";
				  store : in  STD_LOGIC;
				  data_out : out  STD_LOGIC_VECTOR (7 downto 0));
	end component register8;

	signal to_core_tri_state : std_logic_vector(31 downto 0);
	signal to_core_intermediate : std_logic_vector(31 downto 0);                               -- this is used to connect the register to 
	signal to_membus_tri_state : std_logic_vector(7 downto 0);
	signal to_membus_intermediate : std_logic_Vector(31 downto 0);
	signal membus : std_logic_vector(7 downto 0);
	
begin
	-- connecting the output and tristate part
	core_bus <= to_core_tri_state;
		
	to_core_tri_state <=  to_core_intermediate when core_bus_enable = '1' else
								(others => 'Z');
								
	to_membus_tri_state(7 downto 0) <= to_membus_intermediate(7 downto 0) when mem_bus_enable(0) = '1' else
													 to_membus_intermediate(15 downto 8) when mem_bus_enable(1) = '1' else 
													 to_membus_intermediate(23 downto 16) when mem_bus_enable(2) = '1' else
													 to_membus_intermediate(31 downto 24) when mem_bus_enable(3) = '1' else
													 (others => 'Z'); 
	
	to_core_0 : register8 port map(data_in => mem_bus, store => mem_reg_data_in(0), data_out=> to_core_intermediate(7 downto 0));
	to_core_1 : register8 port map(data_in => mem_bus, store => mem_reg_data_in(1), data_out=> to_core_intermediate(15 downto 8));
	to_core_2 : register8 port map(data_in => mem_bus, store => mem_reg_data_in(2), data_out=> to_core_intermediate(23 downto 16));
	to_core_3 : register8 port map(data_in => mem_bus, store => mem_reg_data_in(3), data_out=> to_core_intermediate(31 downto 24));
	
	to_mem_0 : register8 port map(data_in => core_bus(7 downto 0), store => core_reg_data_in, data_out=> to_membus_intermediate(7 downto 0));
	to_mem_1 : register8 port map(data_in => core_bus(15 downto 8), store => core_reg_data_in, data_out=> to_membus_intermediate(15 downto 8));
	to_mem_2 : register8 port map(data_in => core_bus(23 downto 16), store => core_reg_data_in, data_out=> to_membus_intermediate(23 downto 16));
	to_mem_3 : register8 port map(data_in => core_bus(31 downto 24), store => core_reg_data_in, data_out=> to_membus_intermediate(31 downto 24));
	
	mem_bus <= to_membus_tri_state;
	
end Behavioral;

