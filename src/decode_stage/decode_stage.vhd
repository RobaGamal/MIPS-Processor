library ieee;
library processor;
use ieee.std_logic_1164.all;
use processor.config.all;

entity DecodeStage is
	port (
		-- IF/ID buffer
		inst1 : in word_t;
		inst2 : in word_t;
		pc_val : in dword_t;
		-- Operands data
		src1_addr_out : out regaddr_t;
		val_src1_out: out dword_t;
		dst1_addr_out : out regaddr_t;
		val_dst1_out : out dword_t;
		src2_addr_out : out regaddr_t;
		val_src2_out : out dword_t;
		dst2_addr_out : out regaddr_t;
		val_dst2_out : out dword_t;
		-- Execute stage control
		alu_op1_out : out alufun_t;
		update_flag_out1 : out std_logic;
		alu_op2_out : out alufun_t;
		update_flag_out2 : out std_logic;
		is_branch1_out : out std_logic_vector(2 downto 0);
		is_branch2_out : out std_logic_vector(2 downto 0);
		immd1_out : out shiftamount_t;
		immd2_out : out shiftamount_t;
		-- Memory stage control
		mem_fun_out : out memfun_t;
		mem_inst_no_out : out std_logic;
		-- Writeback stage control
		wb_1_out : out std_logic;
		wb_2_out : out std_logic;
		--regfile interface
		addr1_write : in regaddr_t;
		ld1_write : in std_logic;
		val1_write : in dword_t;
		addr2_write : in regaddr_t;
		ld2_write : in std_logic;
		val2_write : in dword_t;
		--General 
		clk : in std_logic;
		rst : in std_logic;
		stall : in std_logic:='0';
		ld : in std_logic:='1'
	);
end DecodeStage;

--complex_circuit breaker goes here
Architecture Structural of DecodeStage is
	signal src1_addr: regaddr_t;
	signal dest1_addr: regaddr_t;
	signal src2_addr: regaddr_t;
	signal dest2_addr: regaddr_t;
	signal val_dst1_out_temp: dword_t;
	signal val_src1_out_temp:  dword_t;
	signal val_dst2_out_temp: dword_t;
	signal val_src2_out_temp:  dword_t;
	signal opcode1:opcode_t;
	signal imm1: shiftamount_t;
	signal opcode2 :opcode_t;
	signal imm2:shiftamount_t;
	signal alu_fun1:alufun_t;
	signal alu_fun2:alufun_t;
	signal update_flag1:std_logic;
	signal update_flag2:std_logic;
	signal mem_fun1:memfun_t;
	signal mem_fun2:memfun_t;
	signal mem_fun_in:memfun_t;
	signal mem_inst_no:std_logic;
	signal wb1:std_logic;
	signal wb2:std_logic;
	signal ld_buff: std_logic;
	signal  is_branch1: std_logic_vector(2 downto 0);
	signal  is_branch2: std_logic_vector(2 downto 0);
begin
	packet_decoder:entity processor.PacketDecode
	port map (
		inst1 ,
		inst2 ,
		opcode1 ,
		src1_addr,
		dest1_addr ,
		imm1 ,
		opcode2 ,
		src2_addr ,
		dest2_addr ,
		imm2
	);

	execute_decode_inst1: entity processor.ExecuteControl
	port map (
		opcode1,
		dest1_addr,
		alu_fun1 ,
		update_flag1
	);

	execute_decode_inst2: entity processor.ExecuteControl
	port map (
		opcode2,
		dest2_addr,
		alu_fun2 ,
		update_flag2
	);

	memory_decode_inst1:entity processor.MemoryControl
	port map (
		opcode1,
		src1_addr,
		dest1_addr,
		mem_fun1
	);

	memory_decode_inst2:entity processor.MemoryControl
	port map (
		opcode2,
		src2_addr,
		dest2_addr,
		mem_fun2
	);

	regfile:entity processor.regfile
	port map (
		pc_val => pc_val,
		src1_addr_read => src1_addr,
		val_src1_out => val_src1_out_temp,
		dst1_addr_read => dest1_addr,
		val_dst1_out => val_dst1_out_temp,
		src2_addr_read=>src2_addr,
		val_src2_out=>val_dst2_out_temp,
		dst2_addr_read=>dest2_addr,
		val_dst2_out=>val_src2_out_temp,
		addr1_write=>addr1_write ,
		ld1_write=>ld1_write,
		val1_write=>val1_write ,
		addr2_write=> addr2_write,
		ld2_write=>ld2_write ,
		val2_write=> val2_write,
		clk=>clk,
		rst=>rst	
	);

	process(mem_fun1,mem_fun2)
	begin
		if(mem_fun1=mem_nop)then
			mem_inst_no<='1';
		elsif(mem_fun2=mem_nop)then
			mem_inst_no<='0';
		end if;
	end process;

	mem_fun_in<=mem_fun1 or mem_fun2;
	ld_buff<= ld and not(stall);
	wb_signal_inst1:entity processor.WBControl
	port map (
		opcode1 ,
		wb1
	);

	wb_signal_inst2:entity processor.WBControl
	port map (
		opcode2 ,
		wb2
	);

	is_branch_inst1:entity processor.Isbranch
	port map (
		opcode1,
		is_branch1
	);

	is_branch_inst2:entity processor.Isbranch
	port map (
		opcode2,
		is_branch2
	);

	decode_buffer: entity processor.Decode_Buffer
	port map(
		-- buffer input - first instruction
		alu_op1_in =>alu_fun1,
		update_flag1_in =>update_flag1,
		wb1_in =>wb1,
		is_branch1_in=>is_branch1,
		immd1_in =>imm1,
		src_addr1_in =>src1_addr,
		dst_addr1_in=>dest1_addr,
		src_val1_in =>val_src1_out_temp,
		dst_val1_in =>val_dst1_out_temp,
		-- buffer input - second instruction
		alu_op2_in  =>alu_fun2,
		update_flag2_in =>update_flag2,
		wb2_in =>wb2,
		is_branch2_in =>is_branch2,
		immd2_in =>imm2,
		src_addr2_in =>src2_addr,
		dst_addr2_in =>dest2_addr,
		src_val2_in =>val_src2_out_temp,
		dst_val2_in=>val_dst2_out_temp,
		-- buffer input - memory
		mem_op_in => mem_fun_in,
		mem_inst_no_in => mem_inst_no,
		-- buffer output -- first instruction
		alu_op1_out =>alu_op1_out,
		update_flag1_out => update_flag_out1,
		wb1_out =>wb_1_out,
		is_branch1_out => is_branch1_out ,
		src_addr1_out =>src1_addr_out ,
		dst_addr1_out=>dst1_addr_out,
		src_val1_out=>val_src1_out,
		dst_val1_out=>val_dst1_out,
		immd1_out => immd1_out,
		-- buffer output -- second instruction
		alu_op2_out =>alu_op2_out,
		update_flag2_out => update_flag_out2,
		wb2_out =>wb_2_out,
		is_branch2_out => is_branch2_out ,
		src_addr2_out =>src2_addr_out ,
		dst_addr2_out=>dst2_addr_out,
		src_val2_out=>val_src2_out,
		dst_val2_out=>val_dst2_out,
		immd2_out => immd2_out,
		mem_op_out=>mem_fun_out,
		mem_inst_no_out=> mem_inst_no_out,
		clk=>clk,
		ld=>ld_buff,
		rst=>rst
	);
end Structural;

