library ieee;
library processor;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use processor.config.all;

entity MemoryControl is
	port (        
		opcode : in opcode_t;
		mem_fun : out memfun_t
	);
end  MemoryControl;

architecture Behavioral of  MemoryControl is
begin
	process(opcode)
	begin
		mem_fun <= mem_nop;
		if opcode = op_ldd   then
			mem_fun <= mem_read;
		elsif opcode = op_std then
			mem_fun <= mem_write;
		elsif opcode = op_out then
			mem_fun <= mem_out;
		elsif opcode = op_in then
			mem_fun <= mem_in;
		end if;
	end process;
end Behavioral;
