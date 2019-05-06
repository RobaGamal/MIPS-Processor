library ieee;
library processor;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use processor.config.all;

entity MemoryControl is
	port (        
		opcode : in opcode_t;
		src_addr : in regaddr_t;
		dst_addr : in regaddr_t;
		mem_fun : out memfun_t
	);
end  MemoryControl;

architecture Behavioral of  MemoryControl is
begin
	process(opcode, src_addr, dst_addr)
	begin
		mem_fun <= mem_nop;
		if opcode = op_ldd then
			if dst_addr = pcregaddr or dst_addr = spregaddr then
				mem_fun <= mem_readw;
			else
				mem_fun <= mem_read;
			end if;
		elsif opcode = op_std then
			if src_addr = pcregaddr or src_addr = spregaddr then
				mem_fun <= mem_writew;
			else
				mem_fun <= mem_write;
			end if;
		end if;
	end process;
end Behavioral;
