library ieee;
library processor;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use processor.config.all;

entity WBControl is
	port (        
		opcode : in opcode_t;
		wb : out std_logic
	);
end  WBControl;

architecture Behavioral of  WBControl is
begin
	process(opcode)
	begin
	   wb <= '0';
		if opcode = op_setc then
			wb <= '0';
		elsif opcode = op_clrc then
			wb <= '0';
		elsif opcode = op_not then
			wb <= '1';
		elsif opcode = op_inc then
			wb <= '1';
		elsif opcode = op_dec then
			wb <= '1';
		elsif opcode = op_mov then
			wb <= '1';
		elsif opcode = op_add then
			wb <= '1';
		elsif opcode = op_sub then
			wb <= '1';
		elsif opcode = op_and then
			wb <= '1';
		elsif opcode = op_or then
			wb <= '1';
		elsif opcode = op_shl then
			wb <= '1';
		elsif opcode = op_shr then
			wb <= '1';
		elsif opcode = op_ldd then
			wb <= '1';
		elsif opcode = op_ldm then
			wb <= '1';
		elsif opcode = op_std then
			wb <= '0';
		elsif opcode = op_jz then
			wb <= '0';
		elsif opcode = op_jn then
			wb <= '0';
		elsif opcode = op_jc then
			wb <= '0';
		elsif opcode = op_jmp then
			wb <= '0';
		elsif opcode = op_in then
			wb <= '1';
		end if;
	end process;
end Behavioral;
	
	
	


