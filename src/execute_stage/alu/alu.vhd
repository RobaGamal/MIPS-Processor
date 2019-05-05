library ieee;
library processor;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use processor.config.all;

entity ALU is
	port(
		a : in dword_t := (others => '0');
		b : in dword_t := (others => '0');
		shift:in shiftamount_t;
		fun : in alufun_t := alu_first_op;
		s : out dword_t := (others => '0');
		z_flag : out std_logic;
		n_flag : out std_logic;
		c_flag : out std_logic
	);
end ALU;

architecture Behavioral of ALU is
signal a_tmp : unsigned(2*n_word downto 0);
signal b_tmp : unsigned(2*n_word downto 0);
signal s_tmp : unsigned(2*n_word downto 0);
signal shift_tmp:unsigned(n_shiftamount-1 downto 0);
begin
    shift_tmp<=unsigned(shift);
	a_tmp <= unsigned('0' & a);
	b_tmp <= unsigned('0' & b);
	s_tmp <=	a_tmp + b_tmp	when 	fun = alu_add else
				a_tmp - b_tmp	when	fun = alu_sub else
				b_tmp + 1		when	fun = alu_inc else
				b_tmp - 1		when	fun = alu_dec else
				not(b_tmp)		when	fun = alu_not else
				a_tmp and b_tmp	when	fun = alu_and else
				a_tmp or b_tmp	when	fun = alu_or  else
				a_tmp 			when	fun = alu_first_op else
				b_tmp 			when	fun = alu_second_op else
				shift_left(a_tmp, to_integer(shift_tmp)) when fun = alu_shl else
				shift_right(a_tmp, to_integer(shift_tmp)) when fun = alu_shr;

	s <= std_logic_vector(s_tmp(2*n_word-1 downto 0));
	
	z_flag <= '1' when s_tmp(n_word-1 downto 0) = 0 else '0';
	n_flag <= s_tmp(n_word-1);
	c_flag <= not(s_tmp(n_word - 1)) when fun = alu_sub else
			  s_tmp(n_word);
end Behavioral;
