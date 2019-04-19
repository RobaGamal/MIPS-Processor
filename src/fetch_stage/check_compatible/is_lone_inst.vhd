library ieee;
library processor;
use ieee.std_logic_1164.all;
use processor.config.all;

entity IsLoneInst is
    port (        
        opcode : in opcode_t;
        is_lone_inst : out std_logic
    );
end IsLoneInst;

architecture Behavioral of IsLoneInst is
begin
    process
    begin
        if opcode = op_push or opcode = op_pop or
            opcode = op_ldm or opcode = op_call then
                is_lone_inst <= '1';
        else
                is_lone_inst <= '0';
        end if;
    end process;
end Behavioral;