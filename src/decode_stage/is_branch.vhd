library ieee;
library processor;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use processor.config.all;

entity IsBranch is
	port (
		opcode : in opcode_t;
		is_branch : out std_logic
	);
end  IsBranch;

architecture Behavioral of  IsBranch is
begin
	process(opcode)
	begin
		is_branch <= '0';
		if opcode = op_jz then
			is_branch <= '1';
		elsif opcode = op_jn then
			is_branch <= '1';
		elsif opcode = op_jc then
			is_branch <= '1';
		elsif opcode = op_jmp then
			is_branch <= '1';
		end if;
	end process;
end Behavioral;
