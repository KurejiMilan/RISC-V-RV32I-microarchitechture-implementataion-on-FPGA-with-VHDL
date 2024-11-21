--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   09:34:20 03/27/2023
-- Design Name:   
-- Module Name:   /home/ise/Documents/Projects/Typhlosion_RV32I/Decode_TB.vhd
-- Project Name:  Typhlosion_RV32I
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: ControlUnit_Decoder
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
 
ENTITY Decode_TB IS
END Decode_TB;
 
ARCHITECTURE behavior OF Decode_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT ControlUnit_Decoder
    PORT(
         uOp_in : IN  std_logic_vector(4 downto 0);
         current_instruction : IN  std_logic_vector(31 downto 0);
         instruction_cycle : IN  std_logic;
         data_in : IN  std_logic_vector(31 downto 0);
         imm : OUT  std_logic_vector(31 downto 0);
         load_imm : OUT  std_logic;
         enable_imm : OUT  std_logic;
         load_ins : OUT  std_logic_vector(3 downto 0);
         en_pc : OUT  std_logic;
         pc_clock : OUT  std_logic;
         unsign_comp : OUT  std_logic;
         sl : OUT  std_logic;
         sr : OUT  std_logic;
         arith : OUT  std_logic;
         xor_sel : OUT  std_logic;
         and_sel : OUT  std_logic;
         or_sel : OUT  std_logic;
         comp_sel : OUT  std_logic;
         load_a : OUT  std_logic;
         load_b : OUT  std_logic;
         load_acc : OUT  std_logic;
         enable_acc : OUT  std_logic;
         reset_uOp : OUT  std_logic;
         inc_ic : OUT  std_logic;
         reg_address_sel : OUT  std_logic_vector(1 downto 0);
         write_reg : OUT  std_logic;
         read_reg : OUT  std_logic;
         core_bus_enable : OUT  std_logic;
         core_reg_data_in : OUT  std_logic;
         mem_reg_data_in : OUT  std_logic_vector(3 downto 0);
         mem_bus_enable : OUT  std_logic_vector(3 downto 0);
         mem_read : OUT  std_logic;
         mem_write : OUT  std_logic;
         enable_pcbr : OUT  std_logic;
         load_pcbr : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal uOp_in : std_logic_vector(4 downto 0) := (others => '0');
   signal current_instruction : std_logic_vector(31 downto 0) := (others => '0');
   signal instruction_cycle : std_logic := '0';
   signal data_in : std_logic_vector(31 downto 0) := (others => '0');

 	--Outputs
   signal imm : std_logic_vector(31 downto 0);
   signal load_imm : std_logic;
   signal enable_imm : std_logic;
   signal load_ins : std_logic_vector(3 downto 0);
   signal en_pc : std_logic;
   signal pc_clock : std_logic;
   signal unsign_comp : std_logic;
   signal sl : std_logic;
   signal sr : std_logic;
   signal arith : std_logic;
   signal xor_sel : std_logic;
   signal and_sel : std_logic;
   signal or_sel : std_logic;
   signal comp_sel : std_logic;
   signal load_a : std_logic;
   signal load_b : std_logic;
   signal load_acc : std_logic;
   signal enable_acc : std_logic;
   signal reset_uOp : std_logic;
   signal inc_ic : std_logic;
   signal reg_address_sel : std_logic_vector(1 downto 0);
   signal write_reg : std_logic;
   signal read_reg : std_logic;
   signal core_bus_enable : std_logic;
   signal core_reg_data_in : std_logic;
   signal mem_reg_data_in : std_logic_vector(3 downto 0);
   signal mem_bus_enable : std_logic_vector(3 downto 0);
   signal mem_read : std_logic;
   signal mem_write : std_logic;
   signal enable_pcbr : std_logic;
   signal load_pcbr : std_logic;

   -- Clock period definitions
   constant pc_clock_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: ControlUnit_Decoder PORT MAP (
          uOp_in => uOp_in,
          current_instruction => current_instruction,
          instruction_cycle => instruction_cycle,
          data_in => data_in,
          imm => imm,
          load_imm => load_imm,
          enable_imm => enable_imm,
          load_ins => load_ins,
          en_pc => en_pc,
          pc_clock => pc_clock,
          unsign_comp => unsign_comp,
          sl => sl,
          sr => sr,
          arith => arith,
          xor_sel => xor_sel,
          and_sel => and_sel,
          or_sel => or_sel,
          comp_sel => comp_sel,
          load_a => load_a,
          load_b => load_b,
          load_acc => load_acc,
          enable_acc => enable_acc,
          reset_uOp => reset_uOp,
          inc_ic => inc_ic,
          reg_address_sel => reg_address_sel,
          write_reg => write_reg,
          read_reg => read_reg,
          core_bus_enable => core_bus_enable,
          core_reg_data_in => core_reg_data_in,
          mem_reg_data_in => mem_reg_data_in,
          mem_bus_enable => mem_bus_enable,
          mem_read => mem_read,
          mem_write => mem_write,
          enable_pcbr => enable_pcbr,
          load_pcbr => load_pcbr
        );

   -- Clock process definitions
   pc_clock_process :process
   begin
		pc_clock <= '0';
		wait for pc_clock_period/2;
		pc_clock <= '1';
		wait for pc_clock_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	


      wait;
   end process;

END;
