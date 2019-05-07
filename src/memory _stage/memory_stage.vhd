library ieee;
library processor;
use ieee.std_logic_1164.all;
use processor.config.all;

entity Memory_stage is
	port (
		memrw: in memfun_t;
		mem_inst_no:in std_logic;
		src1_add_in:in regaddr_t ;
		dst1_add_in:in regaddr_t ;
		src2_add_in:in regaddr_t ;
		dst2_add_in:in regaddr_t ;
		val_dst1_in:in dword_t;
		val_src1_in:in dword_t;
		val_dst2_in:in dword_t;
		val_src2_in:in dword_t;
		wb_1_in:in std_logic;
		wb_2_in:in std_logic;
		wb_1_out:out std_logic;
		wb_2_out:out std_logic;
		src1_add_out:out regaddr_t ;
		dst1_add_out:out regaddr_t ;
		src2_add_out:out regaddr_t ;
		dst2_add_out:out regaddr_t ;
		val_dst1_out:out dword_t;
		val_src1_out:out dword_t;
		val_dst2_out:out dword_t;
		val_src2_out:out dword_t;
		flush:in std_logic;
		clk:in std_logic;
		rst: in std_logic;
		stall:in std_logic:='0';
		-- Forwarding
		dst1_val_fwd : in dword_t;
		src1_val_fwd : in dword_t;
		dst2_val_fwd : in dword_t;
		src2_val_fwd : in dword_t;
		dst1_is_fwd : in std_logic;
		src1_is_fwd : in std_logic;
		dst2_is_fwd : in std_logic;
		src2_is_fwd : in std_logic
	);
end Memory_stage;

Architecture Structural of Memory_stage is
	signal ld_buff: std_logic;
	signal val_dst1_temp:dword_t;
	signal val_dst2_temp:dword_t;
	signal address:std_logic_vector(n_word - 1 downto 0);
	signal data_in : dword_t;
	signal data_out: dword_t;

	-- forwarding
	signal dst1_val_after_fwd : dword_t;
	signal src1_val_after_fwd : dword_t;
	signal dst2_val_after_fwd : dword_t;
	signal src2_val_after_fwd : dword_t;
	signal dst2_val_after_fwd2 : dword_t;
	signal src2_val_after_fwd2 : dword_t;

	signal inst1_mem : std_logic;
	signal inst2_mem : std_logic;
begin
	ld_buff<= not(stall) ;
	inst2_mem <= '1' when memrw /= mem_nop and mem_inst_no ='1' else '0';
	inst1_mem <= '1' when memrw /= mem_nop and mem_inst_no ='0' else '0';

	-- External Forwarding --
	dst1_val_after_fwd <= dst1_val_fwd when dst1_is_fwd = '1' and inst1_mem = '1' else
							val_dst1_in;
	dst2_val_after_fwd2 <= dst2_val_fwd when dst2_is_fwd = '1' and inst2_mem = '1' else
							val_dst2_in;
	src1_val_after_fwd <= src1_val_fwd when src1_is_fwd = '1' and inst1_mem = '1' else
							val_src1_in;
	src2_val_after_fwd2 <= src2_val_fwd when src2_is_fwd = '1' and inst2_mem = '1' else
							val_src2_in;
	----

	-- Internal Forwarding --
	src2_val_after_fwd <= dst1_val_after_fwd when
						inst2_mem = '1' and src2_add_in = dst1_add_in and
						src2_add_in /= notregaddr else
					src2_val_after_fwd2;
	dst2_val_after_fwd <= dst1_val_after_fwd when
						inst2_mem = '1' and dst2_add_in = dst1_add_in and
						dst2_add_in /= notregaddr else
					dst2_val_after_fwd2;
	--
	process(clk)
	begin
		if(falling_edge(clk)) then
			report "MemStage: " & to_hstring(address);
		end if;
	end process;

	data_ram:entity processor.Ram
	generic map (n_word)
	port map (
		clk,
		memrw,
		address,
		data_in,
		data_out,
		rst
	);

	process (
		memrw, mem_inst_no, dst1_val_after_fwd, dst2_val_after_fwd,
		src1_val_after_fwd, src2_val_after_fwd, data_out, data_in)
	begin
		val_dst1_temp<=dst1_val_after_fwd;
		val_dst2_temp<=dst2_val_after_fwd;
		if(memrw = mem_read or memrw = mem_readw) then
			if(mem_inst_no='0') then
				address <= src1_val_after_fwd(n_word-1 downto 0);
				val_dst1_temp <= data_out;
			elsif(mem_inst_no='1') then
				address <= src2_val_after_fwd(n_word-1 downto 0);
				val_dst2_temp <= data_out;
			end if;
		elsif(memrw= mem_write or memrw = mem_writew) then
			if(mem_inst_no='0') then
				address<=dst1_val_after_fwd(n_word-1 downto 0);
				data_in<=src1_val_after_fwd;
			elsif(mem_inst_no='1') then
				address<=dst2_val_after_fwd(n_word-1 downto 0);
				data_in<=src2_val_after_fwd;
			end if;
		end if;
	end process;

	memory_buffer: entity processor.Memory_Buffer
	generic map (n_word)
	port map (
		wb_1_in,
		wb_2_in,
		src1_add_in,
		dst1_add_in,
		src2_add_in,
		dst2_add_in,
		src1_val_after_fwd,
		val_dst1_temp,
		src2_val_after_fwd,
		val_dst2_temp,
		wb_1_out,
		wb_2_out,
		src1_add_out,
		dst1_add_out,
		src2_add_out,
		dst2_add_out,
		val_src1_out,
		val_dst1_out,
		val_src2_out,
		val_dst2_out,
		clk,
		ld_buff,
		rst
	);
end Structural ;
