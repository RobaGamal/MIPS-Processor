
library ieee;
use ieee.std_logic_1164.all;

entity PCModule is
    generic(
        n : integer := 32
    );
    port(
        pc_immediate : in std_logic_vector(n-1 downto 0) := (others => '0');
        ld, clk, rst : in std_logic := '0';
	    normal_mode : in std_logic := '0';
        non_comp_mode: in std_logic := '0';
	    excep_mode : in std_logic := '0';
	    branch_mode : in std_logic := '0';
	    load_address : in std_logic_vector(n-1 downto 0) := (others => '0');
        pc_addr_out:out std_logic_vector(n-1 downto 0)
    );

end PCModule;

architecture Structural of PCModule is

component PCReg is
generic(n : integer := 32);
port(
        pc_d : in std_logic_vector(n-1 downto 0) := (others => '0');
        pc_q : out std_logic_vector(n-1 downto 0) := (others => '0');
        ld, clk, rst : in std_logic := '0'
    );
end component ;

component PCGen is
    generic(n : integer := 32);
	port(        
        normal_mode : in std_logic := '0';
        non_comp_mode: in std_logic := '0';
        excep_mode : in std_logic := '0';
        branch_mode : in std_logic := '0';
        pc_old : in std_logic_vector(n-1 downto 0) := (others => '0');
        load_address : in std_logic_vector(n-1 downto 0) := (others => '0');
        pc_new : out std_logic_vector(n-1 downto 0) := (others => '0')
    
        
    );
end component;
signal pc_in:std_logic_vector(n-1 downto 0);
signal pc_out:std_logic_vector(n-1 downto 0);

begin
    pc_calculate: PCGen 
    generic map(n)
	port map(        
	normal_mode ,non_comp_mode,excep_mode,branch_mode ,pc_out ,load_address,
        pc_in
    );

    pc_define: PCReg generic map(n)
    port map(
        pc_in, pc_out, '1', clk, rst
    );

pc_addr_out<=pc_out;
end Structural;
