library ieee;
library processor;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use processor.config.all;

entity MemoryForward is
	port (        
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
		src1_val_fwd_mem : out dword_t;
		dst1_val_fwd_mem : out dword_t;
		src2_val_fwd_mem : out dword_t;
		dst2_val_fwd_mem : out dword_t;
		src1_is_fwd_mem : out std_logic;
		dst1_is_fwd_mem : out std_logic;
		src2_is_fwd_mem : out std_logic;
		dst2_is_fwd_mem : out std_logic
	);
end MemoryForward;

architecture Behavioral of MemoryForward is
begin
	process(
		src1_addr_ex, dst1_addr_ex, src2_addr_ex, dst2_addr_ex,
		src1_addr_mem, dst1_addr_mem, src2_addr_mem, dst2_addr_mem)
	begin
		-- initialize
		dst1_val_fwd_mem <= (others => '0');
		src1_val_fwd_mem <= (others => '0');
		src2_val_fwd_mem <= (others => '0');
		dst2_val_fwd_mem <= (others => '0');
		dst1_is_fwd_mem <= '0';
		src1_is_fwd_mem <= '0';
		dst2_is_fwd_mem <= '0';
		src2_is_fwd_mem <= '0';
		if src1_addr_ex /= notregaddr and src1_addr_ex /= inregaddr then
			if dst2_addr_mem = src1_addr_ex then
				src1_is_fwd_mem <= '1';
				src1_val_fwd_mem <= dst2_val_mem;
			elsif src2_addr_mem = src1_addr_ex then
				src1_is_fwd_mem <= '1';
				src1_val_fwd_mem <= src2_val_mem;
			elsif dst1_addr_mem = src1_addr_ex then
				src1_is_fwd_mem <= '1';
				src1_val_fwd_mem <= dst1_val_mem;
			elsif src1_addr_mem = src1_addr_ex then
				src1_is_fwd_mem <= '1';
				src1_val_fwd_mem <= src1_val_mem;
			end if;
		end if;
		if dst1_addr_ex /= notregaddr and dst1_addr_ex /= inregaddr then
			if dst2_addr_mem = dst1_addr_ex then
				dst1_is_fwd_mem <= '1';
				dst1_val_fwd_mem <= dst2_val_mem;
			elsif src2_addr_mem = dst1_addr_ex then
				dst1_is_fwd_mem <= '1';
				dst1_val_fwd_mem <= src2_val_mem;
			elsif dst1_addr_mem = dst1_addr_ex then
				dst1_is_fwd_mem <= '1';
				dst1_val_fwd_mem <= dst1_val_mem;
			elsif src1_addr_mem = dst1_addr_ex then
				dst1_is_fwd_mem <= '1';
				dst1_val_fwd_mem <= src1_val_mem;
			end if;
		end if;
		if src2_addr_ex /= notregaddr and src2_addr_ex /= inregaddr then
			if dst2_addr_mem = src2_addr_ex then
				src2_is_fwd_mem <= '1';
				src2_val_fwd_mem <= dst2_val_mem;
			elsif src2_addr_mem = src2_addr_ex then
				src2_is_fwd_mem <= '1';
				src2_val_fwd_mem <= src2_val_mem;
			elsif dst1_addr_mem = src2_addr_ex then
				src2_is_fwd_mem <= '1';
				src2_val_fwd_mem <= dst1_val_mem;
			elsif src1_addr_mem = src2_addr_ex then
				src2_is_fwd_mem <= '1';
				src2_val_fwd_mem <= src1_val_mem;
			end if;
		end if;
		if dst2_addr_ex /= notregaddr and dst2_addr_ex /= inregaddr then
			if dst2_addr_mem = dst2_addr_ex then
				dst2_is_fwd_mem <= '1';
				dst2_val_fwd_mem <= dst2_val_mem;
			elsif src2_addr_mem = dst2_addr_ex then
				dst2_is_fwd_mem <= '1';
				dst2_val_fwd_mem <= src2_val_mem;
			elsif dst1_addr_mem = dst2_addr_ex then
				dst2_is_fwd_mem <= '1';
				dst2_val_fwd_mem <= dst1_val_mem;
			elsif src1_addr_mem = dst2_addr_ex then
				dst2_is_fwd_mem <= '1';
				dst2_val_fwd_mem <= src1_val_mem;
			end if;
		end if;
	end process;
end Behavioral;