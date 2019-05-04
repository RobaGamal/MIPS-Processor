library ieee;
library processor;
use ieee.std_logic_1164.all;
use processor.config.all;
entity pipelinedProcessor4 is
generic(n_pc: natural:=32 );
port(

    clk:in std_logic ;
    interrupt:in std_logic;
    
    rst:in std_logic
);


end pipelinedProcessor4;






Architecture Structural of pipelinedProcessor4 is
signal stall:std_logic:='0';
signal flush:std_logic:='0';
signal inst1:word_t;
signal inst2:word_t;
signal pc_val:dword_t;

signal jump_address:dword_t;
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

signal mem_func_out_ex:std_logic_vector(2 downto 0);
signal mem_inst_no_out_ex:std_logic;
signal wb_1_out_ex:std_logic;
signal wb_2_out_ex:std_logic;
signal src1_add_out_ex:regaddr_t ;
signal dst1_add_out_ex:regaddr_t ;
signal src2_add_out_ex:regaddr_t ;
signal dst2_add_out_ex:regaddr_t ;

signal val_dst1_out_ex: dword_t;
signal val_src1_out_ex: dword_t;
signal val_dst2_out_ex: dword_t;
signal val_src2_out_ex: dword_t;

signal wb_1_out_mem:std_logic;
signal wb_2_out_mem:std_logic;
signal src1_add_out_mem:regaddr_t ;
signal dst1_add_out_mem:regaddr_t ;
signal src2_add_out_mem:regaddr_t ;
signal dst2_add_out_mem:regaddr_t ;

signal val_dst1_out_mem: dword_t;
signal val_src1_out_mem: dword_t;
signal val_dst2_out_mem: dword_t;
signal val_src2_out_mem: dword_t;
signal branch_exc:std_logic;
signal jmp_cond_address:dword_t;
signal pc_load:dword_t;
signal is_jmp:std_logic;

begin 
branch_mode<=branch_exc or is_jmp;

process(is_jmp,branch_exc)
begin
if(is_jmp='1') then 
pc_load <= jump_address;
elsif  branch_exc='1' then
pc_load<= jmp_cond_address ; 
end if; 
end process;


fetch_stage:entity processor .FetchStage
port map (
    inst1,
    inst2, 
    pc_val ,
    stall ,
    branch_mode ,
	pc_load ,
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





    execute_stage:entity processor.Execute_stage 
    port map(   
        src1_add_in=>src1_add_out,
        dst1_add_in=>dst1_add_out ,
        src2_add_in=>src2_add_out,
        dst2_add_in=>dst2_add_out ,
        val_dst1_in=>val_dst1_out,
        val_src1_in=>val_src1_out,
        val_dst2_in=>val_dst2_out,
        val_src2_in=>val_src2_out,
        alu_op1_in=>alu_op1_out,
        alu_op2_in=>alu_op1_out,
        branch_op1=>is_branch1_out ,
        branch_op2=>is_branch2_out ,
        update_flag_in1=>update_flag_out1,
        update_flag_in2=>update_flag_out1 ,
        mem_op_in=>mem_fun_out,
        mem_inst_no_in=>mem_inst_no_out,
        wb_1_in=>wb_1_out ,
        wb_2_in=>wb_2_out ,
        immd1_in=>immd1_out,
	    immd2_in=>immd2_out,
	   
        
        branch_mode=>branch_exc,
        mem_op_out=>mem_func_out_ex,
        mem_inst_no_out=>mem_inst_no_out_ex,
        wb_1_out=>wb_1_out_ex,
        wb_2_out=>wb_2_out_ex,
        src1_add_out=>src1_add_out_ex,
        dst1_add_out=>dst1_add_out_ex,
        src2_add_out=>src2_add_out_ex ,
        dst2_add_out=>dst2_add_out_ex,
        val_dst1_out=>val_dst1_out_ex,
        val_src1_out=>val_src1_out_ex,
        val_dst2_out=>val_dst2_out_ex,
        val_src2_out=>val_src2_out_ex,
        load_address=>jmp_cond_address,
        flush=>flush,
        clk=>clk,
        rst=>rst,
        stall=>stall,
        ld=>'1'


    );


    memory_stage:entity processor. Memory_stage 
        port map ( 
            memrw =>mem_func_out_ex,
            mem_inst_no=>mem_inst_no_out_ex, 
            src1_add_in=>src1_add_out_ex,
            dst1_add_in=>dst1_add_out_ex,
            src2_add_in=>src2_add_out_ex ,
            dst2_add_in=>dst2_add_out_ex,
            val_dst1_in=>val_dst1_out_ex,
            val_src1_in=>val_src1_out_ex,
            val_dst2_in=>val_dst2_out_ex,
            val_src2_in=>val_src2_out_ex,
           
            wb_1_in=>wb_1_out_ex,
            wb_2_in=>wb_2_out_ex,
           
           
            wb_1_out=>wb_1_out_mem,
            wb_2_out=>wb_2_out_mem,
            src1_add_out=> src1_add_out_mem ,
            dst1_add_out=> dst1_add_out_mem,
            src2_add_out=>src2_add_out_mem ,
            dst2_add_out=>dst2_add_out_mem ,
            val_dst1_out=>val_dst1_out_mem,
            val_src1_out=>val_src1_out_mem,
            val_dst2_out=>val_dst2_out_mem,
            val_src2_out=>val_src2_out_mem,
            flush=>flush,
            clk=>clk,
            rst=>rst,
            stall=>stall,
            ld=>'1'
    
    
        );
  -- write back stage
    addr1_write <=dst1_add_out_mem;
    ld1_write <=wb_1_out_mem;
    val1_write <= val_dst1_out_mem;
    addr2_write <= dst2_add_out_mem;
    ld2_write <= wb_2_out_mem;
    val2_write <= val_dst2_out_mem;

end Structural ;