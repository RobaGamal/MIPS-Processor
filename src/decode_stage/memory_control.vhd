library ieee;
library processor;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use processor.config.all;

entity MemoryControl is
    port (        
        opcode : in opcode_t;
        mem_fun : out std_logic_vector(2 downto 0)
        
       
    );
end  MemoryControl;

architecture Behavioral of  MemoryControl is
begin
    process(opcode)
    begin
         mem_fun <= "000";
        if opcode = op_ldm   then
            mem_fun <= "001";
        elsif opcode = op_std then
            mem_fun <= "011";
        elsif opcode = op_out then
            mem_fun <= "001";
        elsif opcode = op_in then
            mem_fun <= "011";
        
        end if;
    end process;
end Behavioral;
