library ieee;
library processor;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use processor.config.all;

entity ExecuteForward is
	port (        
		src1_addr_decode : in regaddr_t;
		dst1_addr_decode : in regaddr_t;
		src2_addr_decode : in regaddr_t;
		dst2_addr_decode : in regaddr_t;
		-- EX/MEM		
		src1_addr_ex : in regaddr_t;
		dst1_addr_ex : in regaddr_t;
		src2_addr_ex : in regaddr_t;
		dst2_addr_ex : in regaddr_t;
		src1_val_ex : in dword_t;
		dst1_val_ex : in dword_t;
		src2_val_ex : in dword_t;
		dst2_val_ex : in dword_t;
		-- MEM/WB
		src1_addr_mem : in regaddr_t;
		dst1_addr_mem : in regaddr_t;
		src2_addr_mem : in regaddr_t;
		dst2_addr_mem : in regaddr_t;
		src1_val_mem : in dword_t;
		dst1_val_mem : in dword_t;
		src2_val_mem : in dword_t;
		dst2_val_mem : in dword_t;
		-- Output
		src1_val_fwd_ex : out dword_t;
		dst1_val_fwd_ex : out dword_t;
		src2_val_fwd_ex : out dword_t;
		dst2_val_fwd_ex : out dword_t;
		src1_is_fwd_ex : out std_logic;
		dst1_is_fwd_ex : out std_logic;
		src2_is_fwd_ex : out std_logic;
		dst2_is_fwd_ex : out std_logic
	);
end ExecuteForward;

architecture Behavioral of ExecuteForward is
begin
	process(
		src1_addr_decode, dst1_addr_decode, src2_addr_decode, dst2_addr_decode,
		src1_addr_ex, dst1_addr_ex, src2_addr_ex, dst2_addr_ex,
		src1_addr_mem, dst1_addr_mem, src2_addr_mem, dst2_addr_mem)
	begin
		-- initialize
		dst1_val_fwd_ex <= (others => '0');
		src1_val_fwd_ex <= (others => '0');
		src2_val_fwd_ex <= (others => '0');
		dst2_val_fwd_ex <= (others => '0');
		dst1_is_fwd_ex <= '0';
		src1_is_fwd_ex <= '0';
		dst2_is_fwd_ex <= '0';
		src2_is_fwd_ex <= '0';
		-- forward from MEM/WB buffer
		if src1_addr_decode /= notregaddr and src1_addr_decode /= inregaddr then
			if dst2_addr_mem = src1_addr_decode then
				src1_is_fwd_ex <= '1';
				src1_val_fwd_ex <= dst2_val_mem;
			elsif src2_addr_mem = src1_addr_decode then
				src1_is_fwd_ex <= '1';
				src1_val_fwd_ex <= src2_val_mem;
			elsif dst1_addr_mem = src1_addr_decode then
				src1_is_fwd_ex <= '1';
				src1_val_fwd_ex <= dst1_val_mem;
			elsif src1_addr_mem = src1_addr_decode then
				src1_is_fwd_ex <= '1';
				src1_val_fwd_ex <= src1_val_mem;
			end if;
		end if;
		if dst1_addr_decode /= notregaddr and dst1_addr_decode /= inregaddr then
			if dst2_addr_mem = dst1_addr_decode then
				dst1_is_fwd_ex <= '1';
				dst1_val_fwd_ex <= dst2_val_mem;
			elsif src2_addr_mem = dst1_addr_decode then
				dst1_is_fwd_ex <= '1';
				dst1_val_fwd_ex <= src2_val_mem;
			elsif dst1_addr_mem = dst1_addr_decode then
				dst1_is_fwd_ex <= '1';
				dst1_val_fwd_ex <= dst1_val_mem;
			elsif src1_addr_mem = dst1_addr_decode then
				dst1_is_fwd_ex <= '1';
				dst1_val_fwd_ex <= src1_val_mem;
			end if;
		end if;
		if src2_addr_decode /= notregaddr and src2_addr_decode /= inregaddr then
			if dst2_addr_mem = src2_addr_decode then
				src2_is_fwd_ex <= '1';
				src2_val_fwd_ex <= dst2_val_mem;
			elsif src2_addr_mem = src2_addr_decode then
				src2_is_fwd_ex <= '1';
				src2_val_fwd_ex <= src2_val_mem;
			elsif dst1_addr_mem = src2_addr_decode then
				src2_is_fwd_ex <= '1';
				src2_val_fwd_ex <= dst1_val_mem;
			elsif src1_addr_mem = src2_addr_decode then
				src2_is_fwd_ex <= '1';
				src2_val_fwd_ex <= src1_val_mem;
			end if;
		end if;
		if dst2_addr_decode /= notregaddr and dst2_addr_decode /= inregaddr then
			if dst2_addr_mem = dst2_addr_decode then
				dst2_is_fwd_ex <= '1';
				dst2_val_fwd_ex <= dst2_val_mem;
			elsif src2_addr_mem = dst2_addr_decode then
				dst2_is_fwd_ex <= '1';
				dst2_val_fwd_ex <= src2_val_mem;
			elsif dst1_addr_mem = dst2_addr_decode then
				dst2_is_fwd_ex <= '1';
				dst2_val_fwd_ex <= dst1_val_mem;
			elsif src1_addr_mem = dst2_addr_decode then
				dst2_is_fwd_ex <= '1';
				dst2_val_fwd_ex <= src1_val_mem;
			end if;
		end if;
		-- forward from EX/MEM buffer
		if src1_addr_decode /= notregaddr and src1_addr_decode /= inregaddr then
			if dst2_addr_ex = src1_addr_decode then
				src1_is_fwd_ex <= '1';
				src1_val_fwd_ex <= dst2_val_ex;
			elsif src2_addr_ex = src1_addr_decode then
				src1_is_fwd_ex <= '1';
				src1_val_fwd_ex <= src2_val_ex;
			elsif dst1_addr_ex = src1_addr_decode then
				src1_is_fwd_ex <= '1';
				src1_val_fwd_ex <= dst1_val_ex;
			elsif src1_addr_ex = src1_addr_decode then
				src1_is_fwd_ex <= '1';
				src1_val_fwd_ex <= src1_val_ex;
			end if;
		end if;
		if dst1_addr_decode /= notregaddr and dst1_addr_decode /= inregaddr then
			if dst2_addr_ex = dst1_addr_decode then
				dst1_is_fwd_ex <= '1';
				dst1_val_fwd_ex <= dst2_val_ex;
			elsif src2_addr_ex = dst1_addr_decode then
				dst1_is_fwd_ex <= '1';
				dst1_val_fwd_ex <= src2_val_ex;
			elsif dst1_addr_ex = dst1_addr_decode then
				dst1_is_fwd_ex <= '1';
				dst1_val_fwd_ex <= dst1_val_ex;
			elsif src1_addr_ex = dst1_addr_decode then
				dst1_is_fwd_ex <= '1';
				dst1_val_fwd_ex <= src1_val_ex;
			end if;
		end if;
		if src2_addr_decode /= notregaddr and src2_addr_decode /= inregaddr then
			if dst2_addr_ex = src2_addr_decode then
				src2_is_fwd_ex <= '1';
				src2_val_fwd_ex <= dst2_val_ex;
			elsif src2_addr_ex = src2_addr_decode then
				src2_is_fwd_ex <= '1';
				src2_val_fwd_ex <= src2_val_ex;
			elsif dst1_addr_ex = src2_addr_decode then
				src2_is_fwd_ex <= '1';
				src2_val_fwd_ex <= dst1_val_ex;
			elsif src1_addr_ex = src2_addr_decode then
				src2_is_fwd_ex <= '1';
				src2_val_fwd_ex <= src1_val_ex;
			end if;
		end if;
		if dst2_addr_decode /= notregaddr and dst2_addr_decode /= inregaddr then
			if dst2_addr_ex = dst2_addr_decode then
				dst2_is_fwd_ex <= '1';
				dst2_val_fwd_ex <= dst2_val_ex;
			elsif src2_addr_ex = dst2_addr_decode then
				dst2_is_fwd_ex <= '1';
				dst2_val_fwd_ex <= src2_val_ex;
			elsif dst1_addr_ex = dst2_addr_decode then
				dst2_is_fwd_ex <= '1';
				dst2_val_fwd_ex <= dst1_val_ex;
			elsif src1_addr_ex = dst2_addr_decode then
				dst2_is_fwd_ex <= '1';
				dst2_val_fwd_ex <= src1_val_ex;
			end if;
		end if;
	end process;
end Behavioral;