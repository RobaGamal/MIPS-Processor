library ieee;
library processor;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use processor.config.all;

entity RegFile is
	port (
		pc_val : in dword_t;
		-- IN register
		in_val : in word_t;
		in_ld : in std_logic;
		-- read operation
		src1_addr_read : in regaddr_t;
		val_src1_out : out dword_t;
		dst1_addr_read : in regaddr_t;
		val_dst1_out : out dword_t;
		src2_addr_read : in regaddr_t;
		val_src2_out : out dword_t;
		dst2_addr_read : in regaddr_t;
		val_dst2_out : out dword_t;
		-- write operation
		addr1_write : in regaddr_t;
		ld1_write : in std_logic;
		val1_write : in dword_t;
		addr2_write : in regaddr_t;
		ld2_write : in std_logic;
		val2_write : in dword_t;
		clk : in std_logic;
		rst : in std_logic
	);
end RegFile;

architecture Structural  of RegFile is
	signal q_arr : reg_vector := (others => (others => '0'));
	signal d_arr : reg_vector := (others => (others => '0'));
	signal l_arr : word_t := (others => '0');
	signal not_clk : std_logic;
begin
	not_clk <= not(clk);
	reg_loop : for i in 0 to n_register-1 generate
		reg: entity processor.Reg
		generic map (n_word)
		port map (
			d_arr(i)(n_word-1 downto 0),
			q_arr(i)(n_word-1 downto 0),
			not_clk, l_arr(i), rst -- falling edge
		);
		-- sign extend
		q_arr(i)(n_dword-1 downto n_word) <= (others => q_arr(i)(n_word-1));

		d_arr(i) <= val1_write when to_integer(unsigned(addr1_write)) = i else
					val2_write when to_integer(unsigned(addr2_write)) = i;
		l_arr(i) <= '1' when to_integer(unsigned(addr1_write)) = i or 
							to_integer(unsigned(addr2_write)) = i
						else '0';
	end generate;

	in_reg: entity processor.Reg
	generic map (n_word)
	port map(
		d_arr(to_integer(unsigned(inregaddr)))(n_word-1 downto 0),
		q_arr(to_integer(unsigned(inregaddr)))(n_word-1 downto 0),
		not_clk, in_ld, rst
	);

	sp_gen: entity processor.Reg
	generic map (n_dword)
	port map(
		d_arr(to_integer(unsigned(spregaddr))),
		q_arr(to_integer(unsigned(spregaddr))),
		not_clk,
		l_arr(to_integer(unsigned(spregaddr))),
		rst
	);
	q_arr(to_integer(unsigned(pcregaddr))) <= pc_val;

	val_src1_out <= q_arr(to_integer(unsigned(src1_addr_read)));
	val_src2_out <= q_arr(to_integer(unsigned(src2_addr_read)));
	val_dst1_out <= q_arr(to_integer(unsigned(dst1_addr_read)));
	val_dst2_out <= q_arr(to_integer(unsigned(dst2_addr_read)));
end Structural;
