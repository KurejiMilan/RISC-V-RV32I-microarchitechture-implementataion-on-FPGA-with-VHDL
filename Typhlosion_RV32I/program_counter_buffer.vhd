library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity program_counter_buffer is
    Port ( enable_PCBr : in  STD_LOGIC;
           load_PCBr : in  STD_LOGIC;
           PCBr_AddressOut : out  STD_LOGIC_VECTOR (31 downto 0);
           PCBr_AddressIn : in  STD_LOGIC_VECTOR (31 downto 0));
end program_counter_buffer;

architecture Behavioral of program_counter_buffer is
	signal PCbuffer : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
begin
	
	process (enable_PCBr, load_PCBr)
	begin
		if rising_edge(load_PCBr) then
			PCBuffer <= PCBr_AddressIn;
		end if;
		
		if enable_PCBr = '1' then
			PCBr_AddressOut <= PCBuffer;
		else
			PCBr_AddressOut <= (others => 'Z');
		end if;
	end process;
	
end Behavioral;

