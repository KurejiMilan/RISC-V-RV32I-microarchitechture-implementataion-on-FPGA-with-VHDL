----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:00:57 01/29/2023 
-- Design Name: 
-- Module Name:    ALU - Behavioral 
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

-- i_30 '0' is used for addition and the logical shift, '1' for subtraction and arithmetic shift
-- unsign_comp '1' is used for unsign comparision while '0' is used for sign comparision

entity ALU is
    Port ( a_in : in  STD_LOGIC_VECTOR (31 downto 0);
           b_in : in  STD_LOGIC_VECTOR (31 downto 0);
			  i_30 : in std_logic;																-- this is the 31th bit from the instuction register
           address_add : in std_logic;														-- this is used for the addition of address only
			  unsign_comp : in std_logic;														-- this is used for sign comparision operation, Control signal
			  sl : in  STD_LOGIC;																-- this is used as control signal
           sr : in  STD_LOGIC;																-- control signal to select the left shift
           arith : in  STD_LOGIC;															-- control signal to select the right shift
           xor_sel : in  STD_LOGIC;															-- control signal to select the xor_output
           and_sel : in  STD_LOGIC;															-- control signal to select the and  output
           or_sel : in  STD_LOGIC;															-- control signal to select the or output
			  comp_sel : in STD_LOGIC;															-- control signal to select the comparator output
           eql : in std_logic; 																-- to test equality
			  z_out : out  STD_LOGIC_VECTOR (31 downto 0));								-- this is connected to the accumulator 
end ALU;

architecture Behavioral of ALU is

	component shifter is
		 Port ( A_in : in  STD_LOGIC_VECTOR (31 downto 0);
				  B_in : in  STD_LOGIC_VECTOR (4 downto 0);
				  arith_shift : in  STD_LOGIC;
				  shift_left : out  STD_LOGIC_VECTOR (31 downto 0);
				  shift_right : out  STD_LOGIC_VECTOR (31 downto 0));
	end component shifter;
	
	component add_sub is
    Port ( a_in : in  STD_LOGIC_VECTOR (31 downto 0);
           b_in : in  STD_LOGIC_VECTOR (31 downto 0);
           add : in  STD_LOGIC;											-- add input takes the Instruction(30)
           result : out  STD_LOGIC_VECTOR (31 downto 0));
	end component;
	
	component comparator_ALU is
    Port ( A_in : in  STD_LOGIC_VECTOR (31 downto 0);
           B_in : in  STD_LOGIC_VECTOR (31 downto 0);
			  is_unsigned : in std_logic;
           Z_out : out  STD_LOGIC_VECTOR (31 downto 0));
	end component comparator_ALU;
	
	signal add_controller : std_logic;
	
	signal shift_l : std_logic_vector(31 downto 0);
	signal shift_r : std_logic_vector(31 downto 0);
	signal comparator_out : std_logic_vector(31 downto 0);
	signal arith_out : std_logic_vector(31 downto 0);
	
	signal a_and_b : std_logic_vector(31 downto 0);
	signal a_or_b : std_logic_vector(31 downto 0);
	signal a_xor_b : std_logic_vector(31 downto 0);
	signal a_eq_b : std_logic_vector(31 downto 0);
	
begin
	
	add_controller <= i_30 and (not address_add);
	shift_module : shifter port map (a_in => a_in, b_in=> b_in(4 downto 0), arith_shift => i_30, shift_left => shift_l, shift_right=> shift_r);
	math_module : add_sub port map (a_in => a_in, b_in => b_in, add => add_controller, result=> arith_out);
	comparator_module : comparator_ALU port map (a_in => a_in, b_in => b_in, is_unsigned => unsign_comp ,z_out => comparator_out);
	
	a_and_b <= a_in and b_in;
	a_or_b <= a_in or b_in;
	a_xor_b <= a_in xor b_in;
	a_eq_b <= X"00000001" when (a_in = b_in) else
					X"00000000";
	
	z_out <= shift_l when sl = '1' else 
				shift_r when sr = '1' else 
				arith_out when arith = '1' else 
				a_xor_b when xor_sel = '1' else
				a_and_b when and_sel = '1' else 
				a_or_b when or_sel = '1' else
				comparator_out when comp_sel = '1' else
				a_eq_b when eql = '1' else
				x"00000000";
	
end Behavioral;

