library ieee;
library processor;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use processor.config.all;

entity ALU is
	port(
		a : in word_t := (others => '0');
		b : in word_t := (others => '0');
		fun : in alufun_t := alu_first_op;
		s : out word_t := (others => '0');
		z_flag : out std_logic;
		n_flag : out std_logic;
		c_flag : out std_logic
	);
end ALU;

architecture Behavioral of ALU is
signal a_tmp : unsigned(n_word downto 0);
signal b_tmp : unsigned(n_word downto 0);
signal s_tmp : unsigned(n_word downto 0);
begin
	a_tmp <= unsigned('0' & a);
	b_tmp <= unsigned('0' & b);
	s_tmp <=	a_tmp + b_tmp	when 	fun = alu_add else
				a_tmp - b_tmp	when	fun = alu_sub else
				a_tmp + 1		when	fun = alu_inc else
				a_tmp - 1		when	fun = alu_dec else
				a_tmp and b_tmp	when	fun = alu_and else
				a_tmp or b_tmp	when	fun = alu_or  else
				a_tmp 			when	fun = alu_first_op else
				not(a_tmp)		when	fun = alu_not else
				shift_left(a_tmp, to_integer(b_tmp)) when fun = alu_shl else
				shift_right(a_tmp, to_integer(b_tmp)) when fun = alu_shr;

	s <= std_logic_vector(s_tmp(n_word-1 downto 0));
	
	z_flag <= '1' when s_tmp(n_word-1 downto 0) = 0 else '0';
	n_flag <= s_tmp(n_word-1);
	c_flag <= not(s_tmp(n_word - 1)) when fun = alu_sub else
			  s_tmp(n_word);
end Behavioral;
