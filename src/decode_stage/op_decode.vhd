library ieee;
library processor;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use processor.config.all;

entity OpDecode is
    port (        
        inst : in word_t;
        opcode : out opcode_t;
        src_addr : out regaddr_t;
        dst_addr : out regaddr_t;
        imm : out shiftamount_t
    );
end OpDecode;

architecture Dataflow of OpDecode is
    constant imm_l : natural := 0;
    constant imm_h  : natural := n_shiftamout-1;
    constant srcaddr_l : natural := imm_h + 1;
    constant srcaddr_h : natural := srcaddr_l + n_regaddr - 1;
    constant dstaddr_l : natural := srcaddr_h + 1;
    constant dstaddr_h : natural := dstaddr_l + n_regaddr - 1;
    constant opcode_l : natural := dstaddr_h+1;
    constant opcode_h : natural := opcode_l+n_opcode-1;
begin
    opcode <= inst(opcode_h downto opcode_l);
    dst_addr <= inst(dstaddr_h downto dstaddr_l);
    src_addr <= inst(srcaddr_h downto srcaddr_l);
    imm <= inst(imm_h downto imm_l);
end Dataflow;