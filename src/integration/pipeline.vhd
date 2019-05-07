library ieee;
library processor;
use ieee.std_logic_1164.all;
use processor.config.all;

entity Pipeline is
	port (
		in_val : in word_t;
		in_ld : in std_logic;
		out_val : out word_t;
		clk : in std_logic := '0';
		rst : in std_logic := '0'
	);
end Pipeline;

architecture Structural of Pipeline is
	-- fetch stage
	signal inst1 : word_t;
	signal inst2 : word_t;
	signal pc_out : dword_t;
	signal branch_mode : std_logic := '0';
	signal load_address : dword_t;
	signal flush : std_logic := '0';
	signal stall : std_logic := '0';

	-- decode stage
	signal src1_addr_decode : regaddr_t;
	signal val_src1_decode : dword_t;
	signal dst1_addr_decode : regaddr_t;
	signal val_dst1_decode : dword_t;
	signal src2_addr_decode : regaddr_t;
	signal val_src2_decode : dword_t;
	signal dst2_addr_decode : regaddr_t;
	signal val_dst2_decode : dword_t;
	signal alu_op1_decode : alufun_t;
	signal update_flag1_decode : std_logic;
	signal alu_op2_decode : alufun_t;
	signal update_flag2_decode : std_logic;
	signal is_branch1_decode : brfun_t;
	signal is_branch2_decode : brfun_t;
	signal immd1_decode : shiftamount_t;
	signal immd2_decode : shiftamount_t;
	signal mem_fun_decode : memfun_t;
	signal mem_no_decode : std_logic;
	signal wb_1_decode : std_logic;
	signal wb_2_decode : std_logic;
	signal addr1_write : regaddr_t := notregaddr;
	signal ld1_write : std_logic := '0';
	signal val1_write : dword_t := (others => '0');
	signal addr2_write : regaddr_t := notregaddr;
	signal ld2_write : std_logic := '0';
	signal val2_write : dword_t := (others => '0');
	signal is_jmp : std_logic;
	signal load_address_decode : dword_t;
	signal flush_decode : std_logic := '0';
	signal stall_decode : std_logic := '0';

	-- execute stage
	signal branch_mode_ex : std_logic;
	signal mem_fun_ex : memfun_t;
	signal mem_no_ex : std_logic;
	signal wb_1_ex : std_logic;
	signal wb_2_ex : std_logic;
	signal src1_addr_ex : regaddr_t;
	signal dst1_addr_ex : regaddr_t;
	signal src2_addr_ex : regaddr_t;
	signal dst2_addr_ex : regaddr_t;
	signal dst1_val_ex : dword_t;
	signal src1_val_ex : dword_t;
	signal dst2_val_ex : dword_t;
	signal src2_val_ex : dword_t;
	signal load_address_ex : dword_t;
	signal flush_ex : std_logic := '0';
	signal stall_ex : std_logic := '0';
	-- Forwarding
	signal src1_val_fwd_ex : dword_t;
	signal dst1_val_fwd_ex : dword_t;
	signal src2_val_fwd_ex : dword_t;
	signal dst2_val_fwd_ex : dword_t;
	signal src1_is_fwd_ex : std_logic;
	signal dst1_is_fwd_ex : std_logic;
	signal src2_is_fwd_ex : std_logic;
	signal dst2_is_fwd_ex : std_logic;
	
	-- memory stage
	signal wb_1_mem : std_logic;
	signal wb_2_mem : std_logic;
	signal src1_addr_mem : regaddr_t;
	signal dst1_addr_mem : regaddr_t;
	signal src2_addr_mem : regaddr_t;
	signal dst2_addr_mem : regaddr_t;
	signal dst1_val_mem : dword_t;
	signal src1_val_mem : dword_t;
	signal dst2_val_mem : dword_t;
	signal src2_val_mem : dword_t;
	signal flush_mem : std_logic := '0';
	signal stall_mem : std_logic := '0';
	-- Forwarding
	signal src1_val_fwd_mem : dword_t;
	signal dst1_val_fwd_mem : dword_t;
	signal src2_val_fwd_mem : dword_t;
	signal dst2_val_fwd_mem : dword_t;
	signal src1_is_fwd_mem : std_logic;
	signal dst1_is_fwd_mem : std_logic;
	signal src2_is_fwd_mem : std_logic;
	signal dst2_is_fwd_mem : std_logic;
begin
	fetch_stage: entity processor.FetchStage
	port map (
		inst1_out => inst1,
		inst2_out => inst2,
		pc_out => pc_out,
		stall => stall,
		branch_mode => branch_mode,
		flush => flush,
		clk => clk,
		rst => rst
	);

	decode_stage: entity processor.DecodeStage
	port map (
		inst1 => inst1,
		inst2 => inst2,
		pc_val => pc_out,
		in_val => in_val,
		out_val => out_val,
		in_ld => in_ld,
		src1_addr_out => src1_addr_decode,
		val_src1_out => val_src1_decode,
		dst1_addr_out => dst1_addr_decode,
		val_dst1_out => val_dst1_decode,
		src2_addr_out => src2_addr_decode,
		val_src2_out => val_src2_decode,
		dst2_addr_out => dst2_addr_decode,
		val_dst2_out => val_dst2_decode,
		alu_op1_out => alu_op1_decode,
		update_flag_out1 => update_flag1_decode,
		alu_op2_out => alu_op2_decode,
		update_flag_out2 => update_flag2_decode,
		is_branch1_out => is_branch1_decode,
		is_branch2_out => is_branch2_decode,
		immd1_out => immd1_decode,
		immd2_out => immd2_decode,
		mem_fun_out => mem_fun_decode,
		mem_inst_no_out => mem_no_decode,
		wb_1_out => wb_1_decode,
		wb_2_out => wb_2_decode,
		addr1_write => addr1_write,
		ld1_write => ld1_write,
		val1_write => val1_write,
		addr2_write => addr2_write,
		ld2_write => ld2_write,
		val2_write => val2_write,
		is_jmp => is_jmp,
		load_address => load_address_decode,
		flush => flush_decode,
		clk => clk,
		rst => rst,
		stall => stall_decode
	);

	execute_stage: entity processor.ExecuteStage
	port map (
		src1_addr_in => src1_addr_decode,
		dst1_addr_in => dst1_addr_decode,
		src2_addr_in => src2_addr_decode,
		dst2_addr_in => dst2_addr_decode,
		dst1_val_in => val_dst1_decode,
		src1_val_in => val_src1_decode,
		dst2_val_in => val_dst2_decode,
		src2_val_in => val_src2_decode,
		alu_op1_in => alu_op1_decode,
		alu_op2_in => alu_op2_decode,
		branch_op1 => is_branch1_decode,
		branch_op2 => is_branch2_decode,
		update_flag_in1 => update_flag1_decode,
		update_flag_in2 => update_flag2_decode,
		mem_op_in => mem_fun_decode,
		mem_inst_no_in => mem_no_decode,
		wb_1_in => wb_1_decode,
		wb_2_in => wb_2_decode,
		immd1_in => immd1_decode,
		immd2_in => immd2_decode,
		branch_mode => branch_mode_ex,
		mem_op_out => mem_fun_ex,
		mem_inst_no_out => mem_no_ex,
		wb_1_out => wb_1_ex,
		wb_2_out => wb_2_ex,
		src1_addr_out => src1_addr_ex,
		dst1_addr_out => dst1_addr_ex,
		src2_addr_out => src2_addr_ex,
		dst2_addr_out => dst2_addr_ex,
		val_dst1_out => dst1_val_ex,
		val_src1_out => src1_val_ex,
		val_dst2_out => dst2_val_ex,
		val_src2_out => src2_val_ex,
		load_address => load_address_ex,
		flush => flush_ex,
		clk => clk,
		rst => rst,
		stall => stall_ex,
		dst1_val_fwd => dst1_val_fwd_ex,
		src1_val_fwd => src1_val_fwd_ex,
		dst2_val_fwd => dst2_val_fwd_ex,
		src2_val_fwd => src2_val_fwd_ex,
		dst1_is_fwd => dst1_is_fwd_ex,
		src1_is_fwd => src1_is_fwd_ex,
		dst2_is_fwd => dst2_is_fwd_ex,
		src2_is_fwd => src2_is_fwd_ex
	);

	memory_stage: entity processor.Memory_Stage
	port map (
		memrw => mem_fun_ex,
		mem_inst_no => mem_no_ex,
		src1_add_in => src1_addr_ex,
		dst1_add_in => dst1_addr_ex,
		src2_add_in => src2_addr_ex,
		dst2_add_in => dst2_addr_ex,
		val_dst1_in => dst1_val_ex,
		val_src1_in => src1_val_ex,
		val_dst2_in => dst2_val_ex,
		val_src2_in => src2_val_ex,
		wb_1_in => wb_1_ex,
		wb_2_in => wb_2_ex,
		wb_1_out => wb_1_mem,
		wb_2_out => wb_2_mem,
		src1_add_out => src1_addr_mem,
		dst1_add_out => dst1_addr_mem,
		src2_add_out => src2_addr_mem,
		dst2_add_out => dst2_addr_mem,
		val_dst1_out => dst1_val_mem,
		val_src1_out => src1_val_mem,
		val_dst2_out => dst2_val_mem,
		val_src2_out => src2_val_mem,
		flush => flush_mem,
		clk => clk,
		rst => rst,
		stall => stall_mem,
		dst1_val_fwd => dst1_val_fwd_mem,
		src1_val_fwd => src1_val_fwd_mem,
		dst2_val_fwd => dst2_val_fwd_mem,
		src2_val_fwd => src2_val_fwd_mem,
		dst1_is_fwd => dst1_is_fwd_mem,
		src1_is_fwd => src1_is_fwd_mem,
		dst2_is_fwd => dst2_is_fwd_mem,
		src2_is_fwd => src2_is_fwd_mem
	);

	writeback_stage: entity processor.WriteBackStage
	port map (
		wb_1_in => wb_1_mem,
		wb_2_in => wb_2_mem,
		src1_addr_in => src1_addr_mem,
		dst1_addr_in => dst1_addr_mem,
		src2_addr_in => src2_addr_mem,
		dst2_addr_in => dst2_addr_mem,
		dst1_val_in => dst1_val_mem,
		src1_val_in => src1_val_mem,
		dst2_val_in => dst2_val_mem,
		src2_val_in => src2_val_mem,
		addr1_write => addr1_write,
		ld1_write => ld1_write,
		val1_write => val1_write,
		addr2_write => addr2_write,
		ld2_write => ld2_write,
		val2_write => val2_write,
		clk => clk
	);

	ex_fwd: entity processor.ExecuteForward
	port map (
		src1_addr_decode => src1_addr_decode, dst1_addr_decode => dst1_addr_decode,
		src2_addr_decode => src2_addr_decode, dst2_addr_decode => dst2_addr_decode,
		src1_addr_ex => src1_addr_ex, dst1_addr_ex => dst1_addr_ex,
		src2_addr_ex => src2_addr_ex, dst2_addr_ex => dst2_addr_ex,
		src1_val_ex => src1_val_ex, dst1_val_ex => dst1_val_ex,
		src2_val_ex => src2_val_ex, dst2_val_ex => dst2_val_ex,
		src1_addr_mem => src1_addr_mem, dst1_addr_mem => dst1_addr_mem,
		src2_addr_mem => src2_addr_mem, dst2_addr_mem => dst2_addr_mem,
		src1_val_mem => src1_val_mem, dst1_val_mem => dst1_val_mem,
		src2_val_mem => src2_val_mem, dst2_val_mem => dst2_val_mem,
		src1_val_fwd_ex => src1_val_fwd_ex, dst1_val_fwd_ex => dst1_val_fwd_ex,
		src2_val_fwd_ex => src2_val_fwd_ex, dst2_val_fwd_ex => dst2_val_fwd_ex,
		src1_is_fwd_ex => src1_is_fwd_ex, dst1_is_fwd_ex => dst1_is_fwd_ex,
		src2_is_fwd_ex => src2_is_fwd_ex, dst2_is_fwd_ex => dst2_is_fwd_ex
	);

	mem_fwd: entity processor.MemoryForward
	port map (
		src1_addr_ex => src1_addr_ex, dst1_addr_ex => dst1_addr_ex,
		src2_addr_ex => src2_addr_ex, dst2_addr_ex => dst2_addr_ex,
		src1_val_ex => src1_val_ex, dst1_val_ex => dst1_val_ex,
		src2_val_ex => src2_val_ex, dst2_val_ex => dst2_val_ex,
		src1_addr_mem => src1_addr_mem, dst1_addr_mem => dst1_addr_mem,
		src2_addr_mem => src2_addr_mem, dst2_addr_mem => dst2_addr_mem,
		src1_val_mem => src1_val_mem, dst1_val_mem => dst1_val_mem,
		src2_val_mem => src2_val_mem, dst2_val_mem => dst2_val_mem,
		src1_val_fwd_mem => src1_val_fwd_mem, dst1_val_fwd_mem => dst1_val_fwd_mem,
		src2_val_fwd_mem => src2_val_fwd_mem, dst2_val_fwd_mem => dst2_val_fwd_mem,
		src1_is_fwd_mem => src1_is_fwd_mem, dst1_is_fwd_mem => dst1_is_fwd_mem,
		src2_is_fwd_mem => src2_is_fwd_mem, dst2_is_fwd_mem => dst2_is_fwd_mem
	);
end Structural;