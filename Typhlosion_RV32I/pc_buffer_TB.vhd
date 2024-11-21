LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY pc_buffer_TB IS
END pc_buffer_TB;
 
ARCHITECTURE behavior OF pc_buffer_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT program_counter_buffer
    PORT(
         enable_PCBr : IN  std_logic;
         load_PCBr : IN  std_logic;
         PCBr_AddressOut : OUT  std_logic_vector(31 downto 0);
         PCBr_AddressIn : IN  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal enable_PCBr : std_logic := '0';
   signal load_PCBr : std_logic := '0';
   signal PCBr_AddressIn : std_logic_vector(31 downto 0) := (others => '0');

 	--Outputs
   signal PCBr_AddressOut : std_logic_vector(31 downto 0);

 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: program_counter_buffer PORT MAP (
          enable_PCBr => enable_PCBr,
          load_PCBr => load_PCBr,
          PCBr_AddressOut => PCBr_AddressOut,
          PCBr_AddressIn => PCBr_AddressIn
        );

   stim_proc: process
   begin
		PCBR_Addressin <= x"00008000";
      wait for 10 ns;	
		load_pcbr <= '1';
		wait for 10 ns;
		load_pcbr <= '0';
		wait for 10 ns;
		enable_pcbr <= '1';
		wait for 10 ns;
		enable_pcbr <= '0';
      wait;
   end process;

END;
