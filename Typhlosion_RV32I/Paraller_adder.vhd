----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    04:13:03 01/28/2023 
-- Design Name: 
-- Module Name:    Paraller_adder - Behavioral 
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


entity Paraller_adder is
    Port ( a_in : in  STD_LOGIC_VECTOR (31 downto 0);
           b_in : in  STD_LOGIC_VECTOR (31 downto 0);
           c_in : in  STD_LOGIC;
           sum : out  STD_LOGIC_vector (31 downto 0);
           carry_out : out  STD_LOGIC);
end Paraller_adder;

architecture Behavioral of Paraller_adder is

	component full_adder is
    Port ( a : in  STD_LOGIC;
           b : in  STD_LOGIC;
           c_in : in  STD_LOGIC;
           s : out  STD_LOGIC;
           c_out : out  STD_LOGIC);
	end component full_adder;

	signal internal_carry : std_logic_vector(31 downto 0);
begin
	fa0 : full_adder port map(a=>a_in(0), b=>b_in(0), c_in=>c_in, s=>sum(0), c_out=>internal_carry(0));
	fa1 : full_adder port map(a=>a_in(1), b=>b_in(1), c_in=>internal_carry(0), s=>sum(1), c_out=>internal_carry(1));
	fa2 : full_adder port map(a=>a_in(2), b=>b_in(2), c_in=>internal_carry(1), s=>sum(2), c_out=>internal_carry(2));
	fa3 : full_adder port map(a=>a_in(3), b=>b_in(3), c_in=>internal_carry(2), s=>sum(3), c_out=>internal_carry(3));
	fa4 : full_adder port map(a=>a_in(4), b=>b_in(4), c_in=>internal_carry(3), s=>sum(4), c_out=>internal_carry(4));
	fa5 : full_adder port map(a=>a_in(5), b=>b_in(5), c_in=>internal_carry(4), s=>sum(5), c_out=>internal_carry(5));
	fa6 : full_adder port map(a=>a_in(6), b=>b_in(6), c_in=>internal_carry(5), s=>sum(6), c_out=>internal_carry(6));
	fa7 : full_adder port map(a=>a_in(7), b=>b_in(7), c_in=>internal_carry(6), s=>sum(7), c_out=>internal_carry(7));
	fa8 : full_adder port map(a=>a_in(8), b=>b_in(8), c_in=>internal_carry(7), s=>sum(8), c_out=>internal_carry(8));
	fa9 : full_adder port map(a=>a_in(9), b=>b_in(9), c_in=>internal_carry(8), s=>sum(9), c_out=>internal_carry(9));
	fa10: full_adder port map(a=>a_in(10), b=>b_in(10), c_in=>internal_carry(9), s=>sum(10), c_out=>internal_carry(10));
	fa11: full_adder port map(a=>a_in(11), b=>b_in(11), c_in=>internal_carry(10), s=>sum(11), c_out=>internal_carry(11));
	fa12: full_adder port map(a=>a_in(12), b=>b_in(12), c_in=>internal_carry(11), s=>sum(12), c_out=>internal_carry(12));
	fa13: full_adder port map(a=>a_in(13), b=>b_in(13), c_in=>internal_carry(12), s=>sum(13), c_out=>internal_carry(13));
	fa14: full_adder port map(a=>a_in(14), b=>b_in(14), c_in=>internal_carry(13), s=>sum(14), c_out=>internal_carry(14));
	fa15: full_adder port map(a=>a_in(15), b=>b_in(15), c_in=>internal_carry(14), s=>sum(15), c_out=>internal_carry(15));
	fa16: full_adder port map(a=>a_in(16), b=>b_in(16), c_in=>internal_carry(15), s=>sum(16), c_out=>internal_carry(16));
	fa17: full_adder port map(a=>a_in(17), b=>b_in(17), c_in=>internal_carry(16), s=>sum(17), c_out=>internal_carry(17));
	fa18: full_adder port map(a=>a_in(18), b=>b_in(18), c_in=>internal_carry(17), s=>sum(18), c_out=>internal_carry(18));
	fa19: full_adder port map(a=>a_in(19), b=>b_in(19), c_in=>internal_carry(18), s=>sum(19), c_out=>internal_carry(19));
	fa20: full_adder port map(a=>a_in(20), b=>b_in(20), c_in=>internal_carry(19), s=>sum(20), c_out=>internal_carry(20));
	fa21: full_adder port map(a=>a_in(21), b=>b_in(21), c_in=>internal_carry(20), s=>sum(21), c_out=>internal_carry(21));
	fa22: full_adder port map(a=>a_in(22), b=>b_in(22), c_in=>internal_carry(21), s=>sum(22), c_out=>internal_carry(22));
	fa23: full_adder port map(a=>a_in(23), b=>b_in(23), c_in=>internal_carry(22), s=>sum(23), c_out=>internal_carry(23));
	fa24: full_adder port map(a=>a_in(24), b=>b_in(24), c_in=>internal_carry(23), s=>sum(24), c_out=>internal_carry(24));
	fa25: full_adder port map(a=>a_in(25), b=>b_in(25), c_in=>internal_carry(24), s=>sum(25), c_out=>internal_carry(25));
	fa26: full_adder port map(a=>a_in(26), b=>b_in(26), c_in=>internal_carry(25), s=>sum(26), c_out=>internal_carry(26));
	fa27: full_adder port map(a=>a_in(27), b=>b_in(27), c_in=>internal_carry(26), s=>sum(27), c_out=>internal_carry(27));
	fa28: full_adder port map(a=>a_in(28), b=>b_in(28), c_in=>internal_carry(27), s=>sum(28), c_out=>internal_carry(28));
	fa29: full_adder port map(a=>a_in(29), b=>b_in(29), c_in=>internal_carry(28), s=>sum(29), c_out=>internal_carry(29));
	fa30: full_adder port map(a=>a_in(30), b=>b_in(30), c_in=>internal_carry(29), s=>sum(30), c_out=>internal_carry(30));
	fa31: full_adder port map(a=>a_in(31), b=>b_in(31), c_in=>internal_carry(30), s=>sum(31), c_out=>internal_carry(31));
	
	carry_out <= internal_carry(31);
	--fa0 : full_adder port map(a=>, b=>, c_in=>, s=>, c_out=>);

end Behavioral;

