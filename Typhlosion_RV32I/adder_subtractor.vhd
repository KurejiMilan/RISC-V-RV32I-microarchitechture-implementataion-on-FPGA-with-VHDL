----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:51:10 01/29/2023 
-- Design Name: 
-- Module Name:    add_sub - Behavioral 
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


entity add_sub is
    Port ( a_in : in  STD_LOGIC_VECTOR (31 downto 0);
           b_in : in  STD_LOGIC_VECTOR (31 downto 0);
           add : in  STD_LOGIC;											-- add input takes the Instruction(30)
           result : out  STD_LOGIC_VECTOR (31 downto 0));
end add_sub;

architecture Behavioral of add_sub is

	component Paraller_adder is
		 Port ( a_in : in  STD_LOGIC_VECTOR (31 downto 0);
				  b_in : in  STD_LOGIC_VECTOR (31 downto 0);
				  c_in : in  STD_LOGIC;
				  sum : out  STD_LOGIC_vector (31 downto 0);
				  carry_out : out  STD_LOGIC);
	end component Paraller_adder;
	
	signal dropcarry : std_logic;
	
	signal xored_b : std_logic_vector(31 downto 0);		-- this is used to invert the b input

begin
	xored_b(0) <= b_in(0) xor add;
	xored_b(1) <= b_in(1) xor add;
	xored_b(2) <= b_in(2) xor add;
	xored_b(3) <= b_in(3) xor add;
	xored_b(4) <= b_in(4) xor add;
	xored_b(5) <= b_in(5) xor add;
	xored_b(6) <= b_in(6) xor add;
	xored_b(7) <= b_in(7) xor add;
	xored_b(8) <= b_in(8) xor add;
	xored_b(9) <= b_in(9) xor add;
	xored_b(10) <= b_in(10) xor add;
	xored_b(11) <= b_in(11) xor add;
	xored_b(12) <= b_in(12) xor add;
	xored_b(13) <= b_in(13) xor add;
	xored_b(14) <= b_in(14) xor add;
	xored_b(15) <= b_in(15) xor add;
	xored_b(16) <= b_in(16) xor add;
	xored_b(17) <= b_in(17) xor add;
	xored_b(18) <= b_in(18) xor add;
	xored_b(19) <= b_in(19) xor add;
	xored_b(20) <= b_in(20) xor add;
	xored_b(21) <= b_in(21) xor add;
	xored_b(22) <= b_in(22) xor add;
	xored_b(23) <= b_in(23) xor add;
	xored_b(24) <= b_in(24) xor add;
	xored_b(25) <= b_in(25) xor add;
	xored_b(26) <= b_in(26) xor add;
	xored_b(27) <= b_in(27) xor add;
	xored_b(28) <= b_in(28) xor add;
	xored_b(29) <= b_in(29) xor add;
	xored_b(30) <= b_in(30) xor add;
	xored_b(31) <= b_in(31) xor add;
	
	adder : paraller_adder port map(a_in =>a_in, b_in => xored_b, c_in =>add, sum=> result, carry_out => dropcarry);
	
end Behavioral;

