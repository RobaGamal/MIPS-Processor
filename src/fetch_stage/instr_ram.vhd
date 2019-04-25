library ieee;
library processor;
use ieee.std_logic_1164.all;
USE IEEE.numeric_std.all;
use processor.config.all;

ENTITY instr_ram IS
        Generic ( n:integer:=16 );
	PORT(
		clk : IN std_logic;
		--we  : IN std_logic;
		address : IN  std_logic_vector(2*n-1 DOWNTO 0);
		--datain  : IN  std_logic_vector(n-1 DOWNTO 0);
		dataout : OUT std_logic_vector(2*n-1 DOWNTO 0));
END ENTITY instr_ram;

ARCHITECTURE syncrama OF instr_ram IS

	TYPE ram_type IS ARRAY(0 TO (2**10-1)) OF std_logic_vector(n-1 DOWNTO 0);
	SIGNAL ram : ram_type ;
	
	BEGIN
		
		dataout <= ram(to_integer(unsigned(address)))&ram(to_integer(unsigned(address)+1));
END syncrama;
