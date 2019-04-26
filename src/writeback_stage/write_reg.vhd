library ieee;
library processor;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use processor.config.all;

entity write_unit is
     generic(n : integer := 16);
    port (        
        dest1_addr_write : in regadr_t;
        -- instruction 1
        dest2_addr_write : in regadr_t ;
       -- instruction 2
       ld_array:out std_logic_vector(n_register-1 downto 0):=(others=>'0');
       output:out reg_vector ;
       input1:in std_logic_vector(n-1 downto 0):=(others=>'0');
       input2:in std_logic_vector(n-1 downto 0):=(others=>'0')
       
    );
end write_unit;

architecture behavioural of write_unit is
signal temp:reg_vector;
signal temp_ld:std_logic_vector(n_register-1 downto 0):=(others=>'0');
begin


process(temp_ld,temp,dest1_addr_write,dest2_addr_write)
begin 
temp_ld<="00000000";
 if dest1_addr_write="0000" then 
	temp_ld<="00000001";
	temp(0)<=input1;

elsif dest1_addr_write="0001" then

	temp_ld<="00000010";
	temp(1)<=input1;
elsif dest1_addr_write="0010" then
 	temp_ld<="00000100";
	temp(2)<=input1;

elsif dest1_addr_write="0011" then
	temp_ld<="00001000";
	temp(3)<=input1;

elsif dest1_addr_write="0100" then
	temp_ld<="00010000";
	temp(4)<=input1;
 
elsif dest1_addr_write="0101" then
	temp_ld<="00100000";
	temp(5)<=input1; 

elsif dest1_addr_write="0110" then
	temp_ld<="01000000";
	temp(6)<=input1;

elsif dest1_addr_write="0111" then
	temp_ld<="10000000"; 
	temp(7	)<=input1;

end if;


if dest2_addr_write="0000" then 
	temp_ld(0)<='1';
	temp(0)<=input2;

elsif dest2_addr_write="0001" then

	temp_ld(1)<='1'; 
	temp(1)<=input2;
elsif dest2_addr_write="0010" then
	temp_ld(2)<='1';
	temp(2)<=input2;

elsif dest2_addr_write="0011" then
	temp_ld(3)<='1' ;
	temp(3)<=input2;

elsif dest2_addr_write="0100" then
	temp_ld(4)<='1';
	temp(4)<=input2;
 
elsif dest2_addr_write="0101" then
	temp_ld(5)<='1';
	temp(5)<=input2; 

elsif dest2_addr_write="0110" then
	temp_ld(6)<='1';
	temp(6)<=input2;

elsif dest2_addr_write="0111" then
	temp_ld(7)<='1';
	temp(7	)<=input2;
end if ;

ld_array<=temp_ld;
output<=temp;
end process;




end behavioural;
