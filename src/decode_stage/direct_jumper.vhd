library ieee;
library processor;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use processor.config.all;

entity DirectJumper is
	port (
		opcode1_in : in opcode_t;
		dst_val1_in : in dword_t;
		opcode2_in : in opcode_t;
		dst_val2_in : in dword_t;
		opcode3_in : in opcode_t;
		dst_val3_in : in dword_t;
		is_branch : out std_logic;
		load_address : out dword_t
	);
end  DirectJumper;

architecture Behavioral of DirectJumper is
begin
	process(opcode1_in, dst_val1_in, opcode2_in, dst_val2_in,
			opcode3_in, dst_val3_in)
	begin
		if opcode1_in = op_jmp then
			is_branch <= '1';
			load_address <= dst_val1_in;
		elsif opcode2_in = op_jmp then
			is_branch <= '1';
			load_address <= dst_val2_in;
		elsif opcode3_in = op_jmp then
			is_branch <= '1';
			load_address <= dst_val3_in;
		else
			is_branch <= '0';
		end if;
	end process;
end Behavioral;
