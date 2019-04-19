library ieee;
library processor;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package config is
	constant period : time := 100 ns;
	constant n_word : natural := 16;
	-- ALU Constants --
	constant n_alufun : natural := 4;
	subtype alufun_t is std_logic_vector(n_alufun - 1 downto 0);
	-- arithmetic
	constant alu_add : alufun_t := "0000";
	constant alu_sub : alufun_t := "0001";
	constant alu_inc : alufun_t := "0010";
	constant alu_dec : alufun_t := "0011";
	-- logical
	constant alu_and : alufun_t := "0100";
	constant alu_or : alufun_t := "0101";
	constant alu_not : alufun_t := "0110";
	-- shifting
	constant alu_shl : alufun_t := "0111";
	constant alu_shr : alufun_t := "1000";
	-- nop
	constant alu_first_op : alufun_t := "1001";
	constant alu_second_op : alufun_t := "1010";
	constant alu_setc : alufun_t := "1011";
	constant alu_clearc : alufun_t := "1100";

	-- opcodes
	constant n_opcode : natural := 5;
	subtype opcode_t is std_logic_vector(n_opcode - 1 downto 0);
	constant op_nop : opcode_t := "00000";
	constant op_setc : opcode_t := "00001";
	constant op_clrc : opcode_t := "00010";
	constant op_not : opcode_t := "00011";
	constant op_inc : opcode_t := "00100";
	constant op_dec : opcode_t := "00101";
	constant op_out : opcode_t := "00110";
	constant op_in : opcode_t := "00111";
	constant op_mov : opcode_t := "01000";
	constant op_add : opcode_t := "01001";
	constant op_sub : opcode_t := "01010";
	constant op_and : opcode_t := "01011";
	constant op_or : opcode_t := "01000";
	constant op_shl : opcode_t := "01101";
	constant op_shr : opcode_t := "01110";
	constant op_push : opcode_t := "11000";
	constant op_pop : opcode_t := "11001";
	constant op_ldm : opcode_t := "11010";
	constant op_ldd : opcode_t := "11011";
	constant op_std : opcode_t := "11100";
	constant op_jz : opcode_t := "10000";
	constant op_jn : opcode_t := "10001";
	constant op_jc : opcode_t := "10010";
	constant op_jmp : opcode_t := "10011";
	constant op_call : opcode_t := "10100";
	constant op_ret : opcode_t := "10101";
	constant op_reti : opcode_t := "10110";

	-- registers
	constant n_regadr : natural := 4;
	subtype regadr_t is std_logic_vector(n_regadr-1 downto 0);
	constant gregadr_l : regadr_t := "0000";
	constant gregadr_h : regadr_t := "0111";
	constant pcregadr : regadr_t := "1000";
	constant spregadr : regadr_t := "1001";
	constant immregadr_l : regadr_t := "1010";

	constant n_shiftamout : natural := 4;
	subtype shiftamout_t is std_logic_vector(n_shiftamout-1 downto 0);
	
	subtype word_t is std_logic_vector(n_word-1 downto 0);
	type wordarr_t is array(integer range <>) of word_t;
end package;