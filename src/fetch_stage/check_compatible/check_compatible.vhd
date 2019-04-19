library ieee;
library processor;
use ieee.std_logic_1164.all;
use processor.config.all;

entity CheckCompatible is
    port (        
        -- instruction 1
        opcode1 : in opcode_t;
        src1_adr : in regadr_t;
        dst1_adr : in regadr_t;
        -- instruction 2
        opcode2 : in opcode_t;
        src2_adr : in regadr_t;
        dst2_adr : in regadr_t;
        -- output
        is_compatible : out std_logic
    );
end CheckCompatible;

architecture Structural of CheckCompatible is
signal is_mem_case : std_logic;
signal is_load_use : std_logic;
signal is_port_case : std_logic;
signal is_lone_inst1 : std_logic;
signal is_lone_inst2 : std_logic;
begin
    is_mem_case_gen : entity processor.IsMemCase 
        port map(
            opcode1, opcode2, is_mem_case 
        );

    is_load_use_gen : entity processor.IsLoadUse
        port map(
            opcode1, dst1_adr, src2_adr, dst2_adr, is_load_use
        );
    
    is_port_case_gen : entity processor.IsPortCase
        port map(
            opcode1, opcode2, is_port_case
        );
    
    is_lone_inst_gen1 : entity processor.IsLoneInst
        port map(
            opcode1, is_lone_inst1
        );
    
    is_lone_inst_gen2 : entity processor.IsLoneInst
        port map(
            opcode2, is_lone_inst2
        );
    
    is_compatible <= is_mem_case or is_load_use or is_port_case or
                    is_lone_inst1 or is_lone_inst2;
end Structural;