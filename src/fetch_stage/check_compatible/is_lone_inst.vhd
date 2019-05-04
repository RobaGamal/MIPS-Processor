library ieee;
library processor;
use ieee.std_logic_1164.all;
use processor.config.all;

entity IsLoneInst is
    port (        
        opcode1 : in opcode_t;
        opcode2 : in opcode_t;
        is_lone_inst : out std_logic
    );
end IsLoneInst;

architecture Behavioral of IsLoneInst is
begin
    process(opcode1, opcode2)
    begin
        if opcode1 = op_push or opcode1 = op_pop or opcode1 = op_call or
                opcode1 = op_ret or opcode1 = op_reti or opcode1 = op_jmp or
                opcode1 = op_jz or opcode1 = op_jn or opcode1 = op_jc or
                opcode1 = op_reti then
            is_lone_inst <= '1';
        elsif opcode1 = op_ldm then
            is_lone_inst <= '0';
        elsif opcode2 = op_push or opcode2 = op_pop or opcode2 = op_call or
                opcode2 = op_ret or opcode2 = op_reti or opcode2 = op_reti or
                opcode2 = op_ldm then
            is_lone_inst <= '1';
        else
            is_lone_inst <= '0';
        end if;
    end process;
end Behavioral;