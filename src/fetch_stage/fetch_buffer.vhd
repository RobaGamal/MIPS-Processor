library ieee;
library processor;
use ieee.std_logic_1164.all;
use processor.config.all;

entity FetchBuffer is
	generic (
		n : natural := n_word -- number of bits 
	);  
	port (
		inst1 : in std_logic_vector(n-1 downto 0);
		inst2 : in std_logic_vector(n-1 downto 0);
		out1 : out std_logic_vector(n-1 downto 0);
		out2 : out std_logic_vector(n-1 downto 0);
		clk : in std_logic;
		ld : in std_logic;
		rst : in std_logic
	);
end FetchBuffer;

Architecture Structural of FetchBuffer is
begin
	reg1: entity processor.Reg 
	generic map (n)
	port map (
		inst1, out1, clk, ld, rst
	);
	
	reg2: entity processor.Reg 
	generic map (n)
	port map (
		inst2, out2, clk, ld, rst
	);
end Structural;