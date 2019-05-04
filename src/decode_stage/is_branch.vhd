library ieee;
library processor;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use processor.config.all;

entity IsBranch is
	port (
		opcode : in opcode_t;
		is_branch : out std_logic_vector(2 downto 0)
	);
end  IsBranch;

architecture Behavioral of  IsBranch is
begin
	process(opcode)
	begin
		is_branch <= "000";
		if opcode = op_jz then
			is_branch <= "001";
		elsif opcode = op_jn then
			is_branch <= "010";
		elsif opcode = op_jc then
			is_branch <= "011";
		end if;
	end process;
end Behavioral;
