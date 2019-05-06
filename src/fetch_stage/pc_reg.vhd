library ieee;
library processor;
use ieee.std_logic_1164.all;
use processor.config.all;
use ieee.numeric_std.all;

entity PCReg is
	generic (n : integer := 32);
	port (
		pc_d : in std_logic_vector(n-1 downto 0) := (others => '0');
		pc_q : out std_logic_vector(n-1 downto 0) := (others => '0');
		ld, clk, rst : in std_logic := '0'
	);
end PCReg;

architecture Structural of PCReg is
begin
	process(clk, rst)
    begin
        if rst = '1' then
            pc_q <= std_logic_vector(to_unsigned(16, 32));
        elsif rising_edge(clk) then
            if ld = '1' then
                pc_q <= pc_d;
            end if;
        end if;
    end process;
end Structural;

