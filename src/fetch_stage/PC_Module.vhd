library ieee;
library processor;
use ieee.std_logic_1164.all;
use processor.config.all;

entity PCModule is
    generic(
        n : integer := 32
    );
    port(
        pc_immediate : in std_logic_vector(n-1 downto 0) := (others => '0');
        ld,clk, rst : in std_logic := '0';
	stall:in std_logic := '0';
	normal_mode : in std_logic := '0';
        non_comp_mode: in std_logic := '0';
	excep_mode : in std_logic := '0';
	branch_mode : in std_logic := '0';
	load_address : in std_logic_vector(n-1 downto 0) := (others => '0');
        pc_addr_out:out std_logic_vector(n-1 downto 0)
    );

end PCModule;

architecture Structural of PCModule is


signal pc_in:std_logic_vector(n-1 downto 0);
signal pc_out:std_logic_vector(n-1 downto 0);
signal pc_ld:std_logic;

begin
    pc_calculate: entity processor.PCGen 
    generic map(n)
	port map(        
	normal_mode ,non_comp_mode,excep_mode,branch_mode ,pc_out ,load_address,
        pc_in
    );
   
    pc_ld<=stall or ld;
    pc_define: entity processor.PCReg generic map(n)
    port map(
        pc_in, pc_out, pc_ld, clk, rst
    );

pc_addr_out<=pc_out;
end Structural;
