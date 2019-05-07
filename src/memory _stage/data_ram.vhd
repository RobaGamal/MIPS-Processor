library ieee;
library processor;
use ieee.std_logic_1164.all;
USE IEEE.numeric_std.all;
use processor.config.all;

entity Ram is
    generic (
        n_address : integer := 16
    );
    port (
        clk: in std_logic;
        rw: in std_logic_vector(2 downto 0);
        address: in std_logic_vector(n_address - 1 downto 0);
        data_in: in dword_t;
        data_out: out dword_t;
        rst: in std_logic
    );
end entity Ram;

architecture Ram_arch of Ram is
type ram_type is array(0 to 2 ** n_address - 1) of std_logic_vector(n_word - 1 downto 0);
signal ram: ram_type ;
begin
    process(clk, rw, address, rst, data_out) is
    begin
        if rst = '1' then
            ram <= (others => (others => '0'));
		elsif falling_edge(clk) then
			if rw = mem_write then
			    ram(to_integer(unsigned(address))) <= data_in(n_word-1 downto 0);
            elsif rw = mem_writew then 
                ram(to_integer(unsigned(address))) <= data_in(2*n_word-1 downto n_word);
                ram(to_integer(unsigned(address)+1)) <= data_in(n_word-1 downto 0);
			end if;
		end if;
        if rw = mem_read then
            data_out(n_word-1 downto 0) <= ram(to_integer(unsigned(address)));
            data_out(2*n_word-1 downto n_word) <= (others => data_out(n_word-1));
        elsif rw =mem_readw then 
            data_out <=ram(to_integer(unsigned(address)))&ram(to_integer(unsigned(address)+1));
        end if;
	end process;
    
    

end Ram_arch;