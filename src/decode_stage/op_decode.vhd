library ieee;
library processor;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use processor.config.all;

entity OpDecode is
    port (        
        -- instruction 1
        inst : in word_t;
        opcode : out opcode_t;
        src_addr : out regadr_t;
        dest_addr : out regadr_t;
        imm : out shiftamount_t
    );
end OpDecode;

architecture Dataflow of OpDecode is
constant opcode_l : natural := 0;
constant opcode_h : natural := n_opcode-1;

constant destadr_l : natural := opcode_h + 1;
constant destadr_h : natural := destadr_l + n_regadr - 1;

constant srcadr_l : natural := destadr_h + 1;
constant srcadr_h : natural := srcadr_l + n_regadr - 1;

constant imm_l : natural := srcadr_h + 1;
constant imm_h : natural := imm_l + n_shiftamout - 1;

begin
    opcode <= inst(opcode_h downto opcode_l);
    dest_addr <= inst(destadr_h downto destadr_l);
    src_addr <= inst(srcadr_h downto srcadr_l);
    --imm <= inst(imm_h downto imm_l);
end Dataflow;