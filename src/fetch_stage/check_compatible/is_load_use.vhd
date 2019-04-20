library ieee;
library processor;
use ieee.std_logic_1164.all;
use processor.config.all;

entity IsLoadUse is
    port (        
        -- instruction 1
        opcode1 : in opcode_t;
        dst1_adr : in regadr_t;
        -- instruction 2
        src2_adr : in regadr_t;
        dst2_adr : in regadr_t;
        -- output
        is_load_use : out std_logic
    );
end IsLoadUse;

architecture Behavioral of IsLoadUse is
begin
    process(opcode1,dst1_adr,src2_adr,dst2_adr)
    begin
        if opcode1 = op_ldd and 
                (dst1_adr = src2_adr or dst1_adr = dst2_adr) then
            is_load_use <= '1';
        else
            is_load_use <= '0';
        end if;
    end process;
end Behavioral;