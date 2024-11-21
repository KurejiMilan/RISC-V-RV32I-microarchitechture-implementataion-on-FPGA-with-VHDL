----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    06:02:49 01/27/2023 
-- Design Name: 
-- Module Name:    comparator_ALU - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity comparator_ALU is
    Port ( A_in : in  STD_LOGIC_VECTOR (31 downto 0);
           B_in : in  STD_LOGIC_VECTOR (31 downto 0);
			  is_unsigned : in std_logic;
           Z_out : out  STD_LOGIC_VECTOR (31 downto 0));
end comparator_ALU;

architecture Behavioral of comparator_ALU is
	signal msb_concat : std_logic_vector(1 downto 0);
begin
	
	msb_concat <= a_in(31) & b_in(31);
	
	z_out <= x"00000001" when (a_in < b_in) and (msb_concat = "11" or msb_concat = "00") and is_unsigned = '0' else
				x"00000000" when (a_in > b_in) and (msb_concat = "11" or msb_concat = "00") and is_unsigned = '0' else
				
				x"00000001" when (a_in > b_in) and (msb_concat = "10" or msb_concat = "01") and is_unsigned = '0' else
				x"00000000" when (a_in < b_in) and (msb_concat = "10" or msb_concat = "01") and is_unsigned = '0' else
				
				-- this is used for unsigned comparision only
				x"00000001" when (a_in < b_in) and is_unsigned = '1' else
				x"00000000";
				
end Behavioral;

