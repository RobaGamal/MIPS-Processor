library ieee;
library processor;
use ieee.std_logic_1164.all;
use processor.config.all;

entity PCReg is
generic(n : integer := 32);
port(
        pc_d : in std_logic_vector(n-1 downto 0) := (others => '0');
        pc_q : out std_logic_vector(n-1 downto 0) := (others => '0');
        ld, clk, rst : in std_logic := '0'
    );

end PCReg;
architecture Structural of PCReg is

begin
    pc_define: entity processor.Reg 
    generic map(n)
    port map(
        pc_d, pc_q, ld, clk, rst
    );
end Structural;
