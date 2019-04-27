library ieee;
library processor;
use ieee.std_logic_1164.all;
use processor.config.all;

entity sign_extend is
generic (n : natural := n_word );
port(
     input: in std_logic_vector(n-1 downto 0);
     output:out std_logic_vector(2*n-1 downto 0)

);

end sign_extend;

Architecture behavioural of sign_extend is

signal extend: std_logic_vector(n-1 downto 0);

begin
extend<=(others=>'0');
output<= extend&input;





end behavioural;