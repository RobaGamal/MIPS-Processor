library ieee;
library processor;
use ieee.std_logic_1164.all;
use processor.config.all;

entity mux is
    generic (
        n : natural := n_word -- number of bits    
    ); 

    port (        
         sel: in std_logic_vector(3 downto 0);
         input: in reg_vector;
         pc_val:in std_logic_vector (n-1 downto 0);
         immd:in std_logic_vector (n-1 downto 0);
         output: out std_logic_vector(n-1 downto 0)
    );
end mux;

architecture behavioural of mux is

begin 
process(sel,input)
begin 
if sel="0000" then 
output<=input(0);

elsif sel="0001" then 
output<=input(1);

elsif sel="0010" then 
output<=input(2);

elsif sel="0011" then 
output<=input(3);

elsif sel="0100" then 
output<=input(4);

elsif sel="0101" then 
output<=input(5);

elsif sel="0110" then 
output<=input(6);

elsif sel="0111" then 
output<=input(7);

elsif sel="1000" then
output<=pc_val ;

elsif sel="1010" then 
output<=immd  ;

end if ;
end process;
end behavioural ;
