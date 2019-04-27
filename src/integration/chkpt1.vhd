library ieee;
library processor;
use ieee.std_logic_1164.all;
use processor.config.all;
entity pipelinedProcessor is
generic(n_pc: natural:=32 );
port(

    clk:in std_logic ;
    stall:in std_logic :='0';
    rst:in std_logic
);


end pipelinedProcessor;






Architecture Structural of pipelinedProcessor is
signal inst1:std_logic_vector(n_word-1 downto 0);
signal inst2:std_logic_vector(n_word-1 downto 0);
signal pc_val:std_logic_vector(n_pc-1 downto 0);

signal pc_immediate :std_logic_vector(n_pc-1 downto 0) := (others => '0');
signal normal_mode :std_logic := '1';
signal non_comp_mode:std_logic := '0';
signal excep_mode :std_logic := '0';
signal  branch_mode : std_logic := '0';
signal  load_address :std_logic_vector(n_pc-1 downto 0) := (others => '0');
signal src1_add_out: regadr_t ;
signal dst1_add_out: regadr_t ;
signal src2_add_out: regadr_t ;
signal dst2_add_out: regadr_t ;
signal val_dst1_out: std_logic_vector(n_word-1 downto 0);
signal val_src1_out: std_logic_vector(n_word-1 downto 0);
signal val_dst2_out: std_logic_vector(n_word-1 downto 0);
signal val_src2_out: std_logic_vector(n_word-1 downto 0);
signal alu_op1_out: alufun_t;
signal alu_op2_out: alufun_t;
signal update_flag_out1: std_logic_vector(0 downto 0);
signal update_flag_out2: std_logic_vector(0 downto 0);
signal mem_op_out: std_logic_vector(2 downto 0);
signal mem_inst_no_out: std_logic_vector(0 downto 0);
signal wb_1_out: std_logic_vector(0 downto 0);
signal wb_2_out: std_logic_vector(0 downto 0);
signal is_branch_out: std_logic_vector(0 downto 0);
signal immd1_out: shiftamount_t;
signal immd2_out: shiftamount_t;
signal pc_out: std_logic_vector(2*n_word-1 downto 0):=(others=>'0');

begin 
fetch_stage:entity processor.fetch_stage 

generic map( n_word ,
 n_pc)
port map(
      inst1,
      inst2,
      pc_val,
      pc_immediate ,
      normal_mode,
      non_comp_mode,
      excep_mode,
      branch_mode ,
      load_address ,

      clk,
      stall,      
      rst
);


decode_stage:entity processor.Decode_stage 
    port map (   
        pc_val,     
        inst1 ,
        inst2 ,

        src1_add_out,
        dst1_add_out,
        src2_add_out,
        dst2_add_out,
        val_dst1_out,
        val_src1_out,
        val_dst2_out,
        val_src2_out,
        alu_op1_out,
        alu_op2_out,
        update_flag_out1,
        update_flag_out2,
        mem_op_out,
        mem_inst_no_out,
        wb_1_out,
        wb_2_out,
        is_branch_out,
        immd1_out,
	    immd2_out,
	    pc_out,
        
        clk,
        rst,
        stall,
        '1'

    );






end Structural ;