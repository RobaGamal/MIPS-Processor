library ieee;
library processor;
use ieee.std_logic_1164.all;
use processor.config.all;

entity PCModule is
	port (
		stall : in std_logic := '0';
		normal_mode : in std_logic := '0';
		non_comp_mode: in std_logic := '0';
		excep_mode : in std_logic := '0';
		branch_mode : in std_logic := '0';
		load_address : in dword_t := (others => '0');
		ld, clk, rst : in std_logic := '0';
		pc_addr_out : out dword_t
	);
end PCModule;

architecture Structural of PCModule is
	signal pc_in : dword_t;
	signal pc_out : dword_t;
	signal pc_ld : std_logic;
begin
	pc_calculate: entity processor.PCGen 
	generic map (n_dword)
	port map (        
		normal_mode => normal_mode,
		non_comp_mode => non_comp_mode,
		excep_mode => excep_mode,
		branch_mode => branch_mode,
		pc_old => pc_out,
		load_address => load_address,
		pc_new => pc_in
	);
   
	pc_ld <= ld and not(stall);
	pc_define: entity processor.PCReg generic map (n_dword)
	port map (
		pc_in, pc_out, pc_ld, clk, rst
	);
	pc_addr_out <= pc_out;
end Structural;
