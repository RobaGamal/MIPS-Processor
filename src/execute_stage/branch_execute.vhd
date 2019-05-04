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
     branch<='0';
     if branch_op="000" then
          branch<='0';
     elsif branch_op="001" then
		if flags(2)= '1' then
              branch <= '1';
          end if;
     
     elsif branch_op="010" then
          if flags(1)= '1' then
               branch <= '1';
          end if;
     
     elsif branch_op="011" then
          if flags(0)= '1' then
          branch <= '1';
          end if ;
     
     end if;	


end process ;
end behavioural;