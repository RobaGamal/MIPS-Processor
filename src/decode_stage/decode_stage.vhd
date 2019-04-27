library ieee;
library processor;
use ieee.std_logic_1164.all;
use processor.config.all;

entity Decode_stage is
    port (   
        pc_val:in std_logic_vector(2*n_word-1 downto 0);     
        inst1 : in word_t;
        inst2 : in word_t;

        src1_add_out:out regadr_t ;
        dst1_add_out:out regadr_t ;
        src2_add_out:out regadr_t ;
        dst2_add_out:out regadr_t ;
        val_dst1_out:out std_logic_vector(n_word-1 downto 0);
        val_src1_out:out std_logic_vector(n_word-1 downto 0);
        val_dst2_out:out std_logic_vector(n_word-1 downto 0);
        val_src2_out:out std_logic_vector(n_word-1 downto 0);
        alu_op1_out:out alufun_t;
        alu_op2_out:out alufun_t;
        update_flag_out1:out std_logic_vector(0 downto 0);
        update_flag_out2:out std_logic_vector(0 downto 0);
        mem_op_out:out std_logic_vector(2 downto 0);
        mem_inst_no_out:out std_logic_vector(0 downto 0);
        wb_1_out:out std_logic_vector(0 downto 0);
        wb_2_out:out std_logic_vector(0 downto 0);
        is_branch_out:out std_logic_vector(0 downto 0);
        immd1_out:out shiftamount_t;
	    immd2_out:out shiftamount_t;
	    pc_out:out std_logic_vector(2*n_word-1 downto 0):=(others=>'0');
        clk:in std_logic;
        rst: in std_logic;
        stall:in std_logic:='0';
        ld: in std_logic:='1'

    );
end Decode_stage;

--complex_circuit breaker goes here
Architecture Structural of Decode_stage is

signal src1_addr: regadr_t;
signal dest1_addr: regadr_t;
signal src2_addr: regadr_t;
signal dest2_addr: regadr_t;
signal val_dst1_out_temp:std_logic_vector(n_word-1 downto 0);
signal val_src1_out_temp: std_logic_vector(n_word-1 downto 0);   
signal val_dst2_out_temp:std_logic_vector(n_word-1 downto 0);
signal val_src2_out_temp: std_logic_vector(n_word-1 downto 0);   

signal opcode1:opcode_t ;
signal imm1: shiftamount_t;
signal opcode2 :opcode_t;
signal imm2:shiftamount_t ;
signal alu_fun1:alufun_t;
signal alu_fun2:alufun_t;
signal update_flag1_temp:std_logic;
signal update_flag2_temp:std_logic;
signal update_flag1:std_logic_vector(0 downto 0);
signal update_flag2:std_logic_vector(0 downto 0);
signal mem_fun1:std_logic_vector(2 downto 0);
signal mem_fun2:std_logic_vector(2 downto 0);
signal mem_op_in:std_logic_vector(2 downto 0);
signal mem_inst_no:std_logic_vector(0 downto 0);
signal wb1:std_logic_vector(0 downto 0);
signal wb2:std_logic_vector(0 downto 0);
signal wb1temp:std_logic;
signal wb2temp:std_logic;
signal ld_buff: std_logic;
signal  is_branch_in: std_logic_vector(0 downto 0);
signal  is_branch1: std_logic;
signal  is_branch2: std_logic;
signal pc_temp:std_logic_vector(2*n_word-1 downto 0):=(others=>'0');
signal immd_loadval:std_logic_vector(n_word-1 downto 0);

       
begin
packet_decoder:entity processor.PacketDecode port map (        
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
    port map(        
        opcode1,
        dest1_addr,
        alu_fun1 ,
        update_flag1_temp
    );

execute_decode_inst2: entity processor.ExecuteControl 
    port map(        
        opcode2,
        dest2_addr,
        alu_fun2 ,
        update_flag2_temp
    );


memory_decode_inst1:entity processor.MemoryControl 
    port map(        
        opcode1 ,
        mem_fun1 
        
       
    );

memory_decode_inst2:entity processor.MemoryControl 
    port map(        
        opcode2 ,
        mem_fun2 
        
       
    );

regfile:entity processor.regfile 
     generic map(n_word)
    port map(        
        src1_addr,
        dest1_addr,
        val_dst1_out_temp,
        val_src1_out_temp,
        src2_addr ,
        dest2_addr, 
        val_dst2_out_temp,
        val_src2_out_temp,
        clk,
        rst,
        pc_val,
	pc_temp,
        immd_loadval
       
    );

process(mem_fun1,mem_fun2)
begin
if(mem_fun1="000")then
    mem_inst_no(0)<='1';
elsif(mem_fun2="000")then
    mem_inst_no(0)<='0';
end if;
end process;


mem_op_in<=mem_fun1 or mem_fun2;
ld_buff<= stall or ld;
update_flag1(0)<=update_flag1_temp;
update_flag2(0)<=update_flag2_temp;
wb1(0)<=wb1temp;
wb2(0)<=wb2temp;

wb_signal_inst1:entity processor.WBSignal_gen 
    port map(        
        opcode1 ,
         wb1temp 
    );
wb_signal_inst2:entity processor.WBSignal_gen 
    port map(        
        opcode2 ,
         wb2temp
    );

is_branch_inst1:entity processor.Isbranch 
    port map(        
        opcode1,
        is_branch1
        
    );

is_branch_inst2:entity processor.Isbranch 
    port map(        
        opcode2,
        is_branch2
        
    );
is_branch_in(0)<=is_branch1 or is_branch2;
decode_buffer: entity processor.Decode_Buffer 
generic map(n_word) 

port map(  
	    alu_fun1,
        alu_fun2,
        update_flag1,
        update_flag2,
        mem_op_in,
        mem_inst_no,
        wb1,
        wb2,
        is_branch_in,
	    imm1,
	    imm2,
        src1_addr,
        dest1_addr,
        src2_addr,
        dest2_addr,
        val_src1_out_temp,
        val_dst1_out_temp,
        val_src2_out_temp,
        val_dst2_out_temp,
        pc_temp,

        alu_op1_out,
        alu_op2_out,
        update_flag_out1,
        update_flag_out2,
        mem_op_out,
        mem_inst_no_out,
        wb_1_out,
        wb_2_out,
        is_branch_out,
        src1_add_out,
        dst1_add_out,
        src2_add_out,
        dst2_add_out,
        val_dst1_out,
        val_src1_out,
        val_dst2_out,
        val_src2_out,
	    immd1_out,
	    immd2_out,
	    pc_out,
        clk,
	    ld_buff,
        rst
        

    );

end Structural ;

