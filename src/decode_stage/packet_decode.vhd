library ieee;
library processor;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use processor.config.all;

entity PacketDecode is
    port (        
        inst1 : in word_t;
        inst2 : in word_t;
        -- instruction 1
        opcode1 : out opcode_t;
        src1_addr : out regadr_t;
        dest1_addr : out regadr_t;
        imm1 : out shiftamount_t;
        -- instruction 2
        opcode2 : out opcode_t;
        src2_addr : out regadr_t;
        dest2_addr : out regadr_t;
        imm2 : out shiftamount_t
    );
end PacketDecode;

architecture Structural of PacketDecode is
begin
    opdecode_gen_1 : entity processor.OpDecode
        port map(
            inst1, opcode1, src1_addr, dest1_addr, imm1
        );

    opdecode_gen_2 : entity processor.OpDecode
        port map(
            inst2, opcode2, src2_addr, dest2_addr, imm2
        );
end Structural;