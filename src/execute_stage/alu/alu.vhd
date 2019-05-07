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
signal a_tmp : unsigned(n_dword downto 0);
signal b_tmp : unsigned(n_dword downto 0);
signal b_tmp2 : unsigned(n_dword downto 0);
signal s_tmp : unsigned(n_dword downto 0);
signal shift_tmp : unsigned(n_shiftamount-1 downto 0);
signal shift_tmp2 : unsigned(n_shiftamount-1 downto 0);
signal shr_carry : std_logic;
signal is_sub : std_logic;
begin
	shift_tmp<=unsigned(shift);
	shift_tmp2 <= shift_tmp + 1 when shift = "000" else shift_tmp;
	a_tmp <= unsigned('0' & a);
	b_tmp <= unsigned('0' & b);
	s_tmp <=	a_tmp + b_tmp	when 	fun = alu_add else
				a_tmp - b_tmp	when	fun = alu_sub else
				b_tmp + 1		when	fun = alu_inc else
				b_tmp - 1		when	fun = alu_dec else
				b_tmp + 2		when	fun = alu_inc2 else
				b_tmp - 2		when	fun = alu_dec2 else
				not(b_tmp)		when	fun = alu_not else
				a_tmp and b_tmp	when	fun = alu_and else
				a_tmp or b_tmp	when	fun = alu_or  else
				a_tmp 			when	fun = alu_first_op else
				b_tmp 			when	fun = alu_second_op else
				shift_left(b_tmp, to_integer(shift_tmp)) when fun = alu_shl else
				shift_right(b_tmp, to_integer(shift_tmp)) when fun = alu_shr;

	is_sub <= '1' when fun = alu_sub or fun = alu_dec else '0';
	s <= std_logic_vector(s_tmp(n_dword-1 downto 0));
	shr_carry <= b_tmp(to_integer(shift_tmp2 - 1));
	z_flag <= '1' when s_tmp(n_word-1 downto 0) = 0 else '0';
	n_flag <= s_tmp(n_word-1);
	c_flag <= '1' when is_sub = '1' and a < b else
				'0' when is_sub = '1' else 
				shr_carry when fun = alu_shr else s_tmp(n_dword);
end Behavioral;
