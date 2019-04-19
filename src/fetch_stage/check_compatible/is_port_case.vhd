library ieee;
library processor;
use ieee.std_logic_1164.all;
use processor.config.all;

entity IsPortCase is
    port (        
        -- instruction 1
        opcode1 : in opcode_t;
        -- instruction 2
        opcode2 : in opcode_t;
        -- output
        is_port_case : out std_logic
    );
end IsPortCase;

architecture Behavioral of IsPortCase is
begin
    process
    begin
        if (opcode1 = op_out or opcode1 = op_in) and
                (opcode2 = op_out or opcode2 = op_in) then
            is_port_case <= '1';
        else
            is_port_case <= '0';
        end if;
    end process;
end Behavioral;