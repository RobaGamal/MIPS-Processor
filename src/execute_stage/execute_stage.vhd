library ieee;
library processor;
use ieee.std_logic_1164.all;
use processor.config.all;

entity ExecuteStage is
    port (   
        src1_addr_in:in regaddr_t ;
        dst1_addr_in:in regaddr_t ;
        src2_addr_in:in regaddr_t ;
        dst2_addr_in:in regaddr_t ;
        dst1_val_in:in dword_t;
        src1_val_in:in dword_t;
        dst2_val_in:in dword_t;
        src2_val_in:in dword_t;
        alu_op1_in:in alufun_t;
        alu_op2_in:in alufun_t;
        branch_op1:in brfun_t;
        branch_op2:in brfun_t;
        update_flag_in1:in std_logic;
        update_flag_in2:in std_logic ;
        mem_op_in:in memfun_t;
        mem_inst_no_in:in std_logic;
        wb_1_in:in std_logic ;
        wb_2_in:in std_logic ;
        immd1_in:in shiftamount_t;
        immd2_in:in shiftamount_t;
       
        branch_mode:out std_logic;
        mem_op_out:out memfun_t;
        mem_inst_no_out:out std_logic;
        wb_1_out:out std_logic;
        wb_2_out:out std_logic;
        src1_addr_out:out regaddr_t ;
        dst1_addr_out:out regaddr_t ;
        src2_addr_out:out regaddr_t ;
        dst2_addr_out:out regaddr_t ;
        val_dst1_out:out dword_t;
        val_src1_out:out dword_t;
        val_dst2_out:out dword_t;
        val_src2_out:out dword_t;
        load_address:out dword_t;
        flush:std_logic:='0';
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
end ExecuteStage;

Architecture Structural of ExecuteStage is
    signal ld_buff: std_logic;
    signal val_dst1_out_tmp:dword_t;
    signal val_dst2_out_tmp:dword_t;
    signal z_flag:std_logic;
    signal n_flag:std_logic;
    signal c_flag:std_logic;
    signal update_flag1: std_logic;
    signal update_flag2: std_logic; 
    signal flags:std_logic_vector(2 downto 0);
    signal branch1:std_logic;
    signal branch2:std_logic;
    signal src2_val_in_tmp : dword_t;
    signal dst2_val_in_tmp : dword_t;
    -- forwarding
    signal dst1_val_after_fwd : dword_t;
    signal src1_val_after_fwd : dword_t;
    signal dst2_val_after_fwd : dword_t;
    signal src2_val_after_fwd : dword_t;
begin
    ld_buff <= not(stall) ;
    update_flag1 <= update_flag_in1;
    update_flag2 <= update_flag_in2;

    -- External Forwarding --
    dst1_val_after_fwd <= dst1_val_fwd when dst1_is_fwd = '1' else
                          dst1_val_in;
    dst2_val_after_fwd <= dst2_val_fwd when dst2_is_fwd = '1' else
                          dst2_val_in;
    src1_val_after_fwd <= src1_val_fwd when src1_is_fwd = '1' else
                          src1_val_in;
    src2_val_after_fwd <= src2_val_fwd when src2_is_fwd = '1' else
                          src2_val_in;
    ----

    -- Internal Forwarding --
    src2_val_in_tmp <= val_dst1_out_tmp when
                        src2_addr_in = dst1_addr_in and
                        src2_addr_in /= notregaddr else
                    src2_val_after_fwd;  
    dst2_val_in_tmp <= val_dst1_out_tmp when
                        dst2_addr_in = dst1_addr_in and
                        dst2_addr_in /= notregaddr else
                    dst2_val_after_fwd;
    ----

    alu:entity processor.ALUWithFlags 
    port map(
        src1_val_after_fwd,
        dst1_val_after_fwd,
        immd1_in,
        immd2_in,
        alu_op1_in,
        update_flag1,
        src2_val_in_tmp,
        dst2_val_in_tmp,
        alu_op2_in,
        update_flag2,
        clk,
        rst,
        val_dst1_out_tmp,
        val_dst2_out_tmp,
        z_flag,
        n_flag,
        c_flag 
    );

    --branch circuit goes here to be completed
    branch_ex1:entity processor.branch_execute 
    port map (
        branch_op1,
        z_flag,
        n_flag,
        c_flag,
        branch1
    );

    branch_ex2:entity processor.branch_execute 
    port map (
        branch_op2,
        z_flag,
        n_flag,
        c_flag,
        branch2
    );
    
    branch_mode <= branch1 or branch2;
    load_address <= src1_val_after_fwd when branch1 = '1' else src2_val_after_fwd;

    execute_buffer: entity processor.Execute_Buffer 
    port map(  
        mem_op_in,
        mem_inst_no_in,
        wb_1_in,
        wb_2_in,
        src1_addr_in,
        dst1_addr_in,
        src2_addr_in,
        dst2_addr_in,
        src1_val_after_fwd,
        val_dst1_out_tmp,
        src2_val_in_tmp,
        val_dst2_out_tmp,
        mem_op_out,
        mem_inst_no_out,
        wb_1_out,
        wb_2_out,
        src1_addr_out,
        dst1_addr_out,
        src2_addr_out,
        dst2_addr_out,
        val_src1_out,
        val_dst1_out,
        val_src2_out,
        val_dst2_out,
        clk,
        ld_buff,
        rst    
    );
end Structural ;

