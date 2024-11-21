--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   14:34:21 01/29/2023
-- Design Name:   
-- Module Name:   /home/ise/Documents/Projects/Typhlosion_RV32I/ALU_TB.vhd
-- Project Name:  Typhlosion_RV32I
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: ALU
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
USE ieee.numeric_std.ALL;
 
ENTITY ALU_TB IS
END ALU_TB;
 
ARCHITECTURE behavior OF ALU_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT ALU
    PORT(
         a_in : IN  std_logic_vector(31 downto 0);
         b_in : IN  std_logic_vector(31 downto 0);
         i_30 : IN  std_logic;
			address_add : IN std_logic;
         unsign_comp : IN  std_logic;
         sl : IN  std_logic;
         sr : IN  std_logic;
         arith : IN  std_logic;
         xor_sel : IN  std_logic;
         and_sel : IN  std_logic;
         or_sel : IN  std_logic;
         comp_sel : IN  std_logic;
         z_out : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal a_in : std_logic_vector(31 downto 0) := (others => '0');
   signal b_in : std_logic_vector(31 downto 0) := (others => '0');
   signal i_30 : std_logic := '0';
   signal unsign_comp : std_logic := '0';
   signal sl : std_logic := '0';
   signal sr : std_logic := '0';
   signal arith : std_logic := '0';
   signal xor_sel : std_logic := '0';
   signal and_sel : std_logic := '0';
   signal or_sel : std_logic := '0';
   signal comp_sel : std_logic := '0';
	signal address_add : std_logic := '0';
 	--Outputs
   signal z_out : std_logic_vector(31 downto 0);
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 

 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: ALU PORT MAP (
          a_in => a_in,
          b_in => b_in,
          i_30 => i_30,
			 address_add => address_add,
          unsign_comp => unsign_comp,
          sl => sl,
          sr => sr,
          arith => arith,
          xor_sel => xor_sel,
          and_sel => and_sel,
          or_sel => or_sel,
          comp_sel => comp_sel,
          z_out => z_out
        );

   -- Clock process definitions
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- addition simulation
		a_in <= std_logic_vector(to_unsigned(10,32));
		b_in <= std_logic_vector(to_unsigned(20,32));
		arith <= '1';
      wait for 10 ns;
		-- subtraction
		i_30 <= '1';
		wait for 10 ns;
		-- address addition
		
		address_add <= '1';
		wait for 10 ns;
		
		-- logical left shift
		arith <= '0';
		i_30 <= '0';
		a_in <= x"80000001";
		b_in <= x"00000001";
		sl <= '1';
		wait for 10 ns;
		--logical right shift
		sl <= '0';
		sr <= '1';
		wait for 10 ns;
		-- arithmetic right shift
		i_30 <='1';
		wait for 10 ns;
		-- xor operation
		sr <= '0';
		xor_sel <= '1';
		wait for 10 ns;
		xor_sel <= '0';
		and_sel <= '1';
		wait for 10 ns;
		and_sel <= '0';
		or_sel <= '1';
		wait for 10 ns;
		or_sel <= '0';
		
		-- unsigned comprision operation
		comp_sel <= '1';
		unsign_comp <= '1';
		wait for 10 ns;
		-- signed comparion
		unsign_comp <= '0';
		a_in <= std_logic_vector(to_unsigned(10, 32));
		b_in <= std_logic_vector(to_signed(-10, 32));
		wait for 10 ns;
		b_in <= std_logic_vector(to_unsigned(10, 32));
		a_in <= std_logic_vector(to_signed(-10, 32));
		wait for 10 ns;
		a_in <= std_logic_vector(to_signed(-20, 32));
		b_in <= std_logic_vector(to_signed(-10, 32));
      wait for 10 ns;
		wait;
   end process;

END;
