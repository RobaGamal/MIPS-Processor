library ieee;
library processor;
use ieee.std_logic_1164.all;
use processor.config.all;

entity Execute_stage is
    port (   
        src1_add_in:in regaddr_t ;
        dst1_add_in:in regaddr_t ;
        src2_add_in:in regaddr_t ;
        dst2_add_in:in regaddr_t ;
        val_dst1_in:in dword_t;
        val_src1_in:in dword_t;
        val_dst2_in:in dword_t;
        val_src2_in:in dword_t;
        alu_op1_in:in alufun_t;
        alu_op2_in:in alufun_t;
        branch_op1:in std_logic_vector(2 downto 0);
        branch_op2:in std_logic_vector(2 downto 0);
        update_flag_in1:in std_logic;
        update_flag_in2:in std_logic ;
        mem_op_in:in std_logic_vector(2 downto 0);
        mem_inst_no_in:in std_logic;
        wb_1_in:in std_logic ;
        wb_2_in:in std_logic ;
        immd1_in:in shiftamount_t;
	    immd2_in:in shiftamount_t;
	   
        
        
        mem_op_out:out std_logic_vector(2 downto 0);
        mem_inst_no_out:out std_logic;
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
        load_address:out dword_t:=(others=>'0');
        clk:in std_logic;
        rst: in std_logic;
        stall:in std_logic:='0';
        ld: in std_logic:='1'


    );
end Execute_stage;


Architecture Structural of Execute_stage is


signal ld_buff: std_logic;
signal  val_dest1_out_temp:dword_t;
signal  val_dest2_out_temp:dword_t;
signal  z_flag:std_logic;
signal 	n_flag:std_logic;
signal	c_flag:std_logic;
signal update_flag1: std_logic;
signal update_flag2: std_logic; 
signal flags:std_logic_vector(2 downto 0);
signal branch1:std_logic;
signal branch2:std_logic;
begin
ld_buff<= ld and  not(stall) ;
update_flag1<=update_flag_in1;
update_flag2<=update_flag_in2;
alu:entity processor.ALUWithFlags 
	port map(
		val_dst1_in ,
        val_src1_in ,
        immd1_in,
        immd2_in,
        alu_op1_in,
        update_flag1 ,
        val_dst2_in ,
		val_src2_in,
		alu_op2_in,
        update_flag2 ,

        clk ,
        rst,
        val_dest1_out_temp,
        val_dest2_out_temp,
        z_flag ,
		n_flag ,
		c_flag 
	);




--branch circuit goes here to be completed
flags<=z_flag&n_flag&c_flag;

branch_ex1:entity processor.branch_execute 
    port map (
         branch_op1,
         flags,
         branch1
    
    );

branch_ex2:entity processor.branch_execute 
    port map (
         branch_op2,
         flags,
         branch2
    
    );
    

execute_buffer: entity processor.Execute_Buffer 

port map(  
        mem_op_in,
	    mem_inst_no_in,
        wb_1_in,
        wb_2_in,
        src1_add_in,
        dst1_add_in,
        src2_add_in,
        dst2_add_in,
        val_src1_in,
        val_dest1_out_temp,
        val_src2_in,
        val_dest2_out_temp,
        
        mem_op_out,
	mem_inst_no_out,
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

