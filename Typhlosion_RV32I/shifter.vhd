----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    06:51:00 01/28/2023 
-- Design Name: 
-- Module Name:    shifter - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity shifter is
    Port ( A_in : in  STD_LOGIC_VECTOR (31 downto 0);
           B_in : in  STD_LOGIC_VECTOR (4 downto 0);
           arith_shift : in  STD_LOGIC;
           shift_left : out  STD_LOGIC_VECTOR (31 downto 0);
           shift_right : out  STD_LOGIC_VECTOR (31 downto 0));
end shifter;

architecture Behavioral of shifter is
	signal aith_mux_output : std_logic_vector(30 downto 0) := (others => '0');												-- this is used to differentiate between the aith or logical right shift
begin
	
	aith_mux_output <= (others => A_in(31)) when arith_shift = '1' else
								(others => '0');
								
	shift_left <= A_in(31 downto 0) when B_in = "00000" else
						(A_in(30 downto 0) & aith_mux_output(0)) when B_in = "00001" else
						(A_in(29 downto 0) & aith_mux_output(1 downto 0)) when B_in = "00010" else
						(A_in(28 downto 0) & aith_mux_output(2 downto 0)) when B_in = "00011" else
						(A_in(27 downto 0) & aith_mux_output(3 downto 0)) when B_in = "00100" else
						(A_in(26 downto 0) & aith_mux_output(4 downto 0)) when B_in = "00101" else
						(A_in(25 downto 0) & aith_mux_output(5 downto 0)) when B_in = "00110" else
						(A_in(24 downto 0) & aith_mux_output(6 downto 0)) when B_in = "00111" else
						(A_in(23 downto 0) & aith_mux_output(7 downto 0)) when B_in = "01000" else
						(A_in(22 downto 0) & aith_mux_output(8 downto 0)) when B_in = "01001" else
						(A_in(21 downto 0) & aith_mux_output(9 downto 0)) when B_in = "01010" else
						(A_in(20 downto 0) & aith_mux_output(10 downto 0)) when B_in = "01011" else
						(A_in(19 downto 0) & aith_mux_output(11 downto 0)) when B_in = "01100" else
						(A_in(18 downto 0) & aith_mux_output(12 downto 0)) when B_in = "01101" else
						(A_in(17 downto 0) & aith_mux_output(13 downto 0)) when B_in = "01110" else
						(A_in(16 downto 0) & aith_mux_output(14 downto 0)) when B_in = "01111" else
						(A_in(15 downto 0) & aith_mux_output(15 downto 0)) when B_in = "10000" else
						(A_in(14 downto 0) & aith_mux_output(16 downto 0)) when B_in = "10001" else
						(A_in(13 downto 0) & aith_mux_output(17 downto 0)) when B_in = "10010" else
						(A_in(12 downto 0) & aith_mux_output(18 downto 0)) when B_in = "10011" else
						(A_in(11 downto 0) & aith_mux_output(19 downto 0)) when B_in = "10100" else
						(A_in(10 downto 0) & aith_mux_output(20 downto 0)) when B_in = "10101" else
						(A_in(9 downto 0) & aith_mux_output(21 downto 0)) when B_in = "10110" else
						(A_in(8 downto 0) & aith_mux_output(22 downto 0)) when B_in = "10111" else
						(A_in(7 downto 0) & aith_mux_output(23 downto 0)) when B_in = "11000" else
						(A_in(6 downto 0) & aith_mux_output(24 downto 0)) when B_in = "11001" else
						(A_in(5 downto 0) & aith_mux_output(25 downto 0)) when B_in = "11010" else
						(A_in(4 downto 0) & aith_mux_output(26 downto 0)) when B_in = "11011" else
						(A_in(3 downto 0) & aith_mux_output(27 downto 0)) when B_in = "11100" else
						(A_in(2 downto 0) & aith_mux_output(28 downto 0)) when B_in = "11101" else
						(A_in(1 downto 0) & aith_mux_output(29 downto 0)) when B_in = "11110" else
						(A_in(0) & aith_mux_output(30 downto 0));
			
	shift_right <= A_in(31 downto 0) when B_in = "00000" else
						(aith_mux_output(30)& A_in(31 downto 1)) when B_in = "00001" else
						(aith_mux_output(30 downto 29)& A_in(31 downto 2)) when B_in = "00010" else
						(aith_mux_output(30 downto 28)& A_in(31 downto 3)) when B_in = "00011" else
						(aith_mux_output(30 downto 27)& A_in(31 downto 4)) when B_in = "00100" else
						(aith_mux_output(30 downto 26)& A_in(31 downto 5)) when B_in = "00101" else
						(aith_mux_output(30 downto 25)& A_in(31 downto 6)) when B_in = "00110" else
						(aith_mux_output(30 downto 24)& A_in(31 downto 7)) when B_in = "00111" else
						(aith_mux_output(30 downto 23)& A_in(31 downto 8)) when B_in = "01000" else
						(aith_mux_output(30 downto 22)& A_in(31 downto 9)) when B_in = "01001" else
						(aith_mux_output(30 downto 21)& A_in(31 downto 10)) when B_in = "01010" else
						(aith_mux_output(30 downto 20)& A_in(31 downto 11)) when B_in = "01011" else
						(aith_mux_output(30 downto 19)& A_in(31 downto 12)) when B_in = "01100" else
						(aith_mux_output(30 downto 18)& A_in(31 downto 13)) when B_in = "01101" else
						(aith_mux_output(30 downto 17)& A_in(31 downto 14)) when B_in = "01110" else
						(aith_mux_output(30 downto 16)& A_in(31 downto 15)) when B_in = "01111" else
						(aith_mux_output(30 downto 15)& A_in(31 downto 16)) when B_in = "10000" else
						(aith_mux_output(30 downto 14)& A_in(31 downto 17)) when B_in = "10001" else
						(aith_mux_output(30 downto 13)& A_in(31 downto 18)) when B_in = "10010" else
						(aith_mux_output(30 downto 12)& A_in(31 downto 19)) when B_in = "10011" else
						(aith_mux_output(30 downto 11)& A_in(31 downto 20)) when B_in = "10100" else
						(aith_mux_output(30 downto 10)& A_in(31 downto 21)) when B_in = "10101" else
						(aith_mux_output(30 downto 9) & A_in(31 downto 22)) when B_in = "10110" else
						(aith_mux_output(30 downto 8) & A_in(31 downto 23)) when B_in = "10111" else
						(aith_mux_output(30 downto 7) & A_in(31 downto 24)) when B_in = "11000" else
						(aith_mux_output(30 downto 6) & A_in(31 downto 25)) when B_in = "11001" else
						(aith_mux_output(30 downto 5) & A_in(31 downto 26)) when B_in = "11010" else
						(aith_mux_output(30 downto 4) & A_in(31 downto 27)) when B_in = "11011" else
						(aith_mux_output(30 downto 3) & A_in(31 downto 28)) when B_in = "11100" else
						(aith_mux_output(30 downto 2) & A_in(31 downto 29)) when B_in = "11101" else
						(aith_mux_output(30 downto 1) & A_in(31 downto 30)) when B_in = "11110" else
						(aith_mux_output(30 downto 0) & A_in(31));
	
end Behavioral;

