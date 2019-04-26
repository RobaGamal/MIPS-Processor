library ieee;
library processor;
use ieee.std_logic_1164.all;
use processor.config.all;

entity Decode_stage is
    port (   
        pc_val:in std_logic_vector(2*n_word-1 downto 0);     
        inst1 : in word_t;
        inst2 : in word_t;
       
        val_dst1_out:out std_logic_vector(n_word-1 downto 0);
        val_src1_out:out std_logic_vector(n_word-1 downto 0);
        val_dst2_out:out std_logic_vector(n_word-1 downto 0);
        val_src2_out:out std_logic_vector(n_word-1 downto 0);
        clk:in std_logic;
        rst: in std_logic;
        stall:in std_logic:='0';
        ld: in std_logic

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
signal mem_fun1:std_logic;
signal mem_fun2:std_logic;
signal mem_op_in:std_logic_vector(0 downto 0);
signal wb1:std_logic_vector(0 downto 0);
signal wb2:std_logic_vector(0 downto 0);
signal wb1temp:std_logic;
signal wb2temp:std_logic;
signal ld_buff: std_logic;
signal alu_op1_out:alufun_t;
signal alu_op2_out:alufun_t;
signal update_flag_out1:std_logic_vector(0 downto 0);
signal update_flag_out2:std_logic_vector(0 downto 0);
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



signal immd: std_logic_vector(n_word-1 downto 0);
       
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
        immd
       
    );

mem_op_in(0)<=mem_fun1 or mem_fun2;
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


decode_buffer: entity processor.Decode_Buffer 
generic map(n_word) 

port map(  alu_fun1,
        alu_fun2,
        update_flag1,
        update_flag2,
        mem_op_in,
        wb1,
        wb2,

        src1_addr,
        dest1_addr,
        src2_addr,
        dest2_addr,
        val_src1_out_temp,
        val_dst1_out_temp,
        val_src2_out_temp,
        val_dst2_out_temp,
        

        alu_op1_out,
        alu_op2_out,
        update_flag_out1,
        update_flag_out2,
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
        rst,
        ld_buff

    );

end Structural ;

