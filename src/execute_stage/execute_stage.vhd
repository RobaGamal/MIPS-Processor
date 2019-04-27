library ieee;
library processor;
use ieee.std_logic_1164.all;
use processor.config.all;

entity Execute_stage is
    port (   
        src1_add_in:in regadr_t ;
        dst1_add_in:in regadr_t ;
        src2_add_in:in regadr_t ;
        dst2_add_in:in regadr_t ;
        val_dst1_in:in std_logic_vector(n_word-1 downto 0);
        val_src1_in:in std_logic_vector(n_word-1 downto 0);
        val_dst2_in:in std_logic_vector(n_word-1 downto 0);
        val_src2_in:in std_logic_vector(n_word-1 downto 0);
        alu_op1_in:in alufun_t;
        alu_op2_in:in alufun_t;
        update_flag_in1:in std_logic_vector(0 downto 0);
        update_flag_in2:in std_logic_vector(0 downto 0);
        mem_op_in:in std_logic_vector(0 downto 0);
        wb_1_in:in std_logic_vector(0 downto 0);
        wb_2_in:in std_logic_vector(0 downto 0);
        is_branch_in:in std_logic_vector(0 downto 0);
        immd1_in:in shiftamount_t;
	    immd2_in:in shiftamount_t;
	    pc_in:in std_logic_vector(2*n_word-1 downto 0):=(others=>'0');
        
        
        mem_op_out:out std_logic_vector(0 downto 0);
        wb_1_out:out std_logic_vector(0 downto 0);
        wb_2_out:out std_logic_vector(0 downto 0);
        src1_add_out:out regadr_t ;
        dst1_add_out:out regadr_t ;
        src2_add_out:out regadr_t ;
        dst2_add_out:out regadr_t ;
        val_dst1_out:out std_logic_vector(n_word-1 downto 0);
        val_src1_out:out std_logic_vector(n_word-1 downto 0);
        val_dst2_out:out std_logic_vector(n_word-1 downto 0);
        val_src2_out:out std_logic_vector(n_word-1 downto 0);
        pc_out:out std_logic_vector(2*n_word-1 downto 0):=(others=>'0');

        clk:in std_logic;
        rst: in std_logic;
        stall:in std_logic:='0';
        ld: in std_logic:='1'


    );
end Execute_stage;

--complex_circuit breaker goes here
Architecture Structural of Execute_stage is


signal ld_buff: std_logic;

signal mem_op_out: std_logic_vector(0 downto 0);
signal wb_1_out:std_logic_vector(0 downto 0);
signal wb_2_out:std_logic_vector(0 downto 0);
signal  src1_add_out:regadr_t ;
signal  dst1_add_out:regadr_t ;
signal  src2_add_out:regadr_t ;
signal  dst2_add_out:regadr_t ;
signal  src1_val_out:std_logic_vector(n_word-1 downto 0);
signal  dst1_val_out:std_logic_vector(n_word-1 downto 0);
signal  src2_val_out:std_logic_vector(n_word-1 downto 0);
signal  dst2_val_out:std_logic_vector(n_word-1 downto 0);

       
begin

execute_buffer: entity processor.Execute_Buffer 
generic map(n_word) 

port map(  
        mem_op_in,
        wb1,
        wb2,
        src1_addr,
        dest1_addr,
        src2_addr,
        dest2_addr,
        val_src1_out,
        val_dst1_out,
        val_src2_out,
        val_dst2_out,
        
        mem_op_out,
        wb_1_out,
        wb_2_out,
        src1_add_out,
        dst1_add_out,
        src2_add_out,
        dst2_add_out,
        val_dst1_out,
        val_src1_out,
        val_dst2_out,
        val_src2_out,
        clk,
	    ld_buff,
        rst
        

    );

end Structural ;

