--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   06:16:20 02/05/2023
-- Design Name:   
-- Module Name:   /home/ise/Documents/Projects/Typhlosion_RV32I/register_bank_TB.vhd
-- Project Name:  Typhlosion_RV32I
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: register_bank
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
 
ENTITY register_bank_TB IS
END register_bank_TB;
 
ARCHITECTURE behavior OF register_bank_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT register_bank
    PORT(
         rs1 : IN  std_logic_vector(4 downto 0);
         rs2 : IN  std_logic_vector(4 downto 0);
         rd : IN  std_logic_vector(4 downto 0);
         reg_address_sel : IN  std_logic_vector(1 downto 0);
         write_reg : IN  std_logic;
         read_reg : IN  std_logic;
         z_data : INOUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal rs1 : std_logic_vector(4 downto 0) := (others => '0');
   signal rs2 : std_logic_vector(4 downto 0) := (others => '0');
   signal rd : std_logic_vector(4 downto 0) := (others => '0');
   signal reg_address_sel : std_logic_vector(1 downto 0) := (others => '0');
   signal write_reg : std_logic := '0';
   signal read_reg : std_logic := '0';

	--BiDirs
   signal z_data : std_logic_vector(31 downto 0);
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: register_bank PORT MAP (
          rs1 => rs1,
          rs2 => rs2,
          rd => rd,
          reg_address_sel => reg_address_sel,
          write_reg => write_reg,
          read_reg => read_reg,
          z_data => z_data
        );

   -- Clock process definitions
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 10 ns;	
		rs1 <= "00001";                           -- source register 1
		rs2 <= "00010";									-- source register 2
		rd <= "10000";										-- source register 16
		
		-- write on rs1
		wait for 10 ns;
		z_data <= x"0feeba88";
		reg_address_sel <= "10";
		wait for 10 ns;
		write_reg <= '1';
		wait for 10 ns;
		write_reg <= '0';
		
		-- write on rs2
		wait for 10 ns;
		z_data <= x"0feeba89";
		reg_address_sel <= "11";
		wait for 10 ns;
		write_reg <= '1';
		wait for 10 ns;
		write_reg <= '0';
		
		
		-- write on rd
		wait for 10 ns;
		z_data <= x"0feeba8a";
		reg_address_sel <= "01";
		wait for 10 ns;
		write_reg <= '1';
		wait for 10 ns;
		write_reg <= '0';
		wait for 10 ns;
		
		z_data <= (others => 'Z');
		-- read on rs1
		wait for 10 ns;
		reg_address_sel <= "10";
		wait for 10 ns;
		read_reg <= '1';
		wait for 10 ns;
		read_reg <= '0';
		
		-- read on rs2
		wait for 10 ns;
		reg_address_sel <= "11";
		wait for 10 ns;
		read_reg <= '1';
		wait for 10 ns;
		read_reg <= '0';
		
		-- read on rd
		wait for 10 ns;
		reg_address_sel <= "01";
		wait for 10 ns;
		read_reg <= '1';
		wait for 10 ns;
		read_reg <= '0';
		-- read on R0
		wait for 10 ns;
		reg_address_sel <= "00";
		wait for 10 ns;
		read_reg <= '1';
		wait for 10 ns;
		read_reg <= '0';
		
		wait for 10 ns;
      wait;
   end process;

END;
