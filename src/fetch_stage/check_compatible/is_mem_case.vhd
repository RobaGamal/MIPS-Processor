library ieee;
library processor;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use processor.config.all;

entity IsMemCase is
    port (        
        -- instruction 1
        opcode1 : in opcode_t;
        opcode2 : in opcode_t;
        is_mem_case : out std_logic
    );
end IsMemCase;

architecture Behavioral of IsMemCase is
begin
    process
    begin
        if (opcode1 = op_ldd or opcode1 = op_std or
                opcode1 = op_in or opcode1 = op_out) and
                (opcode2 = op_ldd or opcode2 = op_std or 
                opcode2 = op_in or opcode2 = op_out) then
            is_mem_case <= '1';
        else
            is_mem_case <= '0';
        end if;
    end process;
end Behavioral;