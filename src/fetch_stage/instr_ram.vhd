library ieee;
library processor;
use ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
use processor.config.all;

entity InstrRam is
	port (
		clk : in std_logic;
		address : in  dword_t;
		dataout : out dword_t
	);
end entity InstrRam;

architecture syncrama of InstrRam is
	type ram_type is array(0 to (2**10-1)) of word_t;
	signal ram : ram_type;
begin
	dataout <= ram(to_integer(unsigned(address))) & ram(to_integer(unsigned(address)+1));
end syncrama;
