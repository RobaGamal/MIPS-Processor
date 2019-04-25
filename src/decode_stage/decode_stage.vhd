library ieee;
library processor;
use ieee.std_logic_1164.all;
use processor.config.all;

entity Decode_stage is
    port (        
        inst1 : in word_t;
        inst2 : in word_t,
        src1_addr:out regadr_t,
        dest1_addr:out regadr_t,
        src2_addr:out regadr_t,
        dest2_addr:out regadr_t
    

    );
end Decode_stage;

--complex_circuit breaker goes here


signal opcode1:opcode_t ;
signal imm1: shiftamount_t;
signal opcode2 :opcode_t;
signal imm2:shiftamount_t ;
signal alu_fun1:alufun_t;
signal alu_fun2:alufun_t;
signal update_flag1:std_logic;
signal update_flag2:std_logic;


packet_decoder:entity processor. PacketDecode port (        
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
    port (        
        opcode1
        dest1_addr,
        alu_fun1 ,
        update_flag1
    );

execute_decode_inst2: entity processor.ExecuteControl 
    port (        
        opcode2
        dest2_addr,
        alu_fun2 ,
        update_flag2
    );


