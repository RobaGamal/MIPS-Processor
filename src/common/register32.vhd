library ieee;
library processor;
use ieee.std_logic_1164.all;
use processor.config.all;

entity Reg32 is
    generic (
        n : natural := 32 -- number of bits
    ); 
    port (        
        d  : in std_logic_vector(n-1 downto 0) := (others => '0'); -- parallel input
        q  : out std_logic_vector(n-1 downto 0) := (others => '0'); -- parallel output
	    clk, load, reset : in std_logic := '0' -- clock, load, and reset
    );
end Reg32;

architecture Behavioral of Reg32 is
begin
    process(clk, reset)
    begin
        if reset = '1' then
            q <= (others => '0');
        elsif rising_edge(clk) then
            if load = '1' then
                q <= d;
            end if;
        end if;
    end process;
end Behavioral;
