library ieee;
library processor;
use ieee.std_logic_1164.all;
use processor.config.all;
entity pipelinedProcessor is
generic(n_pc: natural:=32 );
port(

    clk:in std_logic ;
    interrupt:in std_logic;
    rst:in std_logic
);


end pipelinedProcessor;






Architecture Structural of pipelinedProcessor is
signal stall:std_logic;
signal inst1:word_t;
signal inst2:word_t;
signal pc_val:dword_t;
signal flush:std_logic:='0';

signal jump_address:dword_t;
signal is_jmp:std_logic;
signal branch_mode : std_logic := '0';
signal src1_add_out: regaddr_t ;
signal dst1_add_out: regaddr_t ;
signal src2_add_out: regaddr_t ;
signal dst2_add_out: regaddr_t ;
signal val_dst1_out: dword_t;
signal val_src1_out:  dword_t;
signal val_dst2_out:  dword_t;
signal val_src2_out:  dword_t;
signal alu_op1_out: alufun_t;
signal alu_op2_out: alufun_t;
signal update_flag_out1: std_logic;
signal update_flag_out2: std_logic;
signal mem_fun_out: std_logic_vector(2 downto 0);
signal mem_inst_no_out: std_logic;
signal wb_1_out: std_logic;
signal wb_2_out: std_logic;
signal is_branch1_out: std_logic_vector(2 downto 0);
signal is_branch2_out: std_logic_vector(2 downto 0);
signal immd1_out: shiftamount_t;
signal immd2_out: shiftamount_t;
signal addr1_write :regaddr_t ;
signal ld1_write :std_logic;
signal val1_write :dword_t;
signal addr2_write :regaddr_t ;
signal ld2_write :std_logic;
signal val2_write :dword_t;

begin 
fetch_stage:entity processor .FetchStage
port map (
    inst1,
    inst2, 
    pc_val ,
    stall ,
    branch_mode ,
	jump_address ,
	flush,
    clk ,
    rst 
);



decode_stage:entity processor. DecodeStage
	port map (
		-- IF/ID buffer
		inst1 ,
		inst2 ,
		pc_val,
		-- Operands data
		src1_add_out ,
		val_src1_out,
		dst1_add_out ,
		val_dst1_out ,
		src2_add_out ,
		val_src2_out ,
		dst2_add_out ,
		val_dst2_out ,
		-- Execute stage control
		alu_op1_out ,
		update_flag_out1 ,
		alu_op2_out  ,
		update_flag_out2 ,
		is_branch1_out ,
		is_branch2_out ,
		immd1_out ,
		immd2_out ,
		-- Memory stage control
		mem_fun_out ,
		mem_inst_no_out ,
		-- Writeback stage control
		wb_1_out ,
		wb_2_out ,
		--regfile interface
		addr1_write ,
		ld1_write ,
		val1_write ,
		addr2_write ,
		ld2_write ,
		val2_write ,
		---- Branch output (useful for CALL, 3rd inst is JMP)
		-- decoder executes JMP branches only
		is_jmp ,
		jump_address ,
		--General
		flush , 
		clk ,
		rst ,
		stall ,
		'1'
	);







end Structural ;