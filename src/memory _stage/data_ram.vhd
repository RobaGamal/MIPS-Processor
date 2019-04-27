library ieee;
library processor;
use ieee.std_logic_1164.all;
USE IEEE.numeric_std.all;
use processor.config.all;

entity Ram is
    generic (
        n_reg_bits : integer := 16;
        n_address : integer := 16
    );
    port (
        clk: in std_logic;
        rw: in std_logic;
        memw_2word:in std_logic;
        memr_2word:in std_logic;
        address: in std_logic_vector(n_address - 1 downto 0);
        data_in: in std_logic_vector(n_reg_bits - 1 downto 0);
        pc_in:in std_logic_vector(2*n_reg_bits-1 downto 0):=(others=>'0');
        data_out: out std_logic_vector(n_reg_bits - 1 downto 0);
        pc_out: out std_logic_vector(2*n_reg_bits-1 downto 0):=(others=>'0')
    );
end entity Ram;

architecture Ram_arch of Ram is
type ram_type is array(0 to 2 ** n_address - 1) of std_logic_vector(n_reg_bits - 1 downto 0);
signal ram: ram_type ;
begin
    process(clk) is
	begin
		if rising_edge(clk) then
			if rw = '1' then
				ram(to_integer(unsigned(address))) <= data_in;
			end if;
            if memw_2word='1' then 
            ram(to_integer(unsigned(address)))<= pc_in(2*n_word-1 downto n_word)
            ram(to_integer(unsigned(address)+1)) <= pc_in(n_word-1 downto 0);
			end if;
		end if;
	end process;
    
     process(clk) is


     if rising_edge(clk) then
			
            if memw_2word='1'
             pc_out <=ram(to_integer(unsigned(address)))&ram(to_integer(unsigned(address)+1)));
			end if;
		end if;
	end process;

   data_out<=ram(to_integer(unsigned(address)));



end Ram_arch;