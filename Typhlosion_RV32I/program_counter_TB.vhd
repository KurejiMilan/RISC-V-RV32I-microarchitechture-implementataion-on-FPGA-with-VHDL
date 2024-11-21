LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;
 
ENTITY program_counter_TB IS
END program_counter_TB;
 
ARCHITECTURE behavior OF program_counter_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
    
	component PC
   Port ( enable_pc : in  STD_LOGIC;
           pc_clk : in  STD_LOGIC;
			  load_pc : in STD_LOGIC;
			  pc_to_pcbr : out std_logic_vector(31 downto 0);				  	-- this is feed to the pc buffer register
           address_in : in std_logic_vector(31 downto 0);					--	this is used to load the address for jump and load data instruciton
			  address_out : out  STD_LOGIC_VECTOR (31 downto 0) := (others => 'Z')
			  );				-- while this is feed to the address bus
	end component PC;

   --Inputs
   signal enable_pc : std_logic := '0';
   signal pc_clk : std_logic := '0';
	signal load_pc : std_logic := '0';
	signal address_in : std_logic_vector(31 downto 0);
 	--Outputs
	signal pc_to_pcbr : std_logic_vector(31 downto 0);
   signal address_out : std_logic_vector(31 downto 0);
 
BEGIN
	
	 pc_clk <= not pc_clk after 10 ns;
	 address_in <= X"0000FFFE";
	-- Instantiate the Unit Under Test (UUT)
   uut: PC PORT MAP (
          enable_pc => enable_pc,
          pc_clk => pc_clk,
			 load_pc => load_pc,
			 address_in => address_in,
			 pc_to_pcbr => pc_to_pcbr,
          address_out => address_out
        );
 
   stim_proc: process
   
	begin
		wait for 100 ns;
		enable_pc <= '1'; 
		wait for 50 ns;
      enable_pc <= '1';
		wait for 50 ns;
		load_pc <= '1';
		wait for 10 ns;
		load_pc <= '0';
		wait for 100 ns;
		wait;
   
	end process;

END;
