library ieee;
library processor;
use ieee.std_logic_1164.all;
use processor.config.all;

entity branch_execute is
port(
     branch_op: in std_logic_vector(2 downto 0);
     flags:in std_logic_vector(2 downto 0);
     branch:out std_logic

);

end branch_execute;

Architecture behavioural of branch_execute is
begin
process(branch_op,flags)
begin



end process ;
end behavioural;