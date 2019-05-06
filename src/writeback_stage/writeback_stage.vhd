library ieee;
library processor;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use processor.config.all;

entity WriteBackStage is
	port (
		wb_1_in : in std_logic;
        wb_2_in : in std_logic;
        src1_addr_in : in regaddr_t ;
        dst1_addr_in : in regaddr_t ;
        src2_addr_in : in regaddr_t ;
        dst2_addr_in : in regaddr_t ;
        src1_val_in : in dword_t;
        dst1_val_in : in dword_t;
        src2_val_in : in dword_t;
        dst2_val_in : in dword_t;
		addr1_write : out regaddr_t;
		ld1_write : out std_logic;
		val1_write : out dword_t;
		addr2_write : out regaddr_t;
		ld2_write : out std_logic;
		val2_write : out dword_t;
		clk : in std_logic
	);
end WriteBackStage;

architecture Behavioural of WriteBackStage is
begin
	addr2_write <= dst2_addr_in;
	ld2_write <= wb_2_in;
	val2_write <= dst2_val_in;
	addr1_write <= dst1_addr_in;
	ld1_write <= '0' when 
			addr1_write = addr2_write and ld2_write = '1' else
			wb_1_in;
	val1_write <= dst1_val_in;
	
	process(clk)
	begin
		if falling_edge(clk) then
			if ld1_write = '1' then
				report "WriteBack REG" & 
				to_string(addr1_write) & " = " &
				to_string(val1_write);
			end if;
			if ld2_write = '1' then
				report "WriteBack REG" & 
				to_string(addr2_write) & " = " &
				to_string(val2_write);
			end if;	
		end if;
	end process;
end Behavioural;
