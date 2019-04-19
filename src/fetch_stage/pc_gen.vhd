library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned;

entity PCGen is
    generic(n : integer := 32);
	port(        
	normal_mode : in std_logic := '0';
        non_comp_mode: in std_logic := '0';
	excep_mode : in std_logic := '0';
	branch_mode : in std_logic := '0';
        pc_old : in std_logic_vector(n-1 downto 0) := (others => '0');
	load_address : in std_logic_vector(n-1 downto 0) := (others => '0');
        pc_new : out std_logic_vector(n-1 downto 0) := (others => '0')
    );
end PCGen;

architecture Behavioural of PCGen is
begin

process(pc_old,normal_mode,non_comp_mode,branch_mode,excep_mode,load_address)
begin
	if excep_mode ='1' then
		pc_new <= (others => '0');	
	elsif  branch_mode ='1' then
		pc_new <=load_address;
	elsif non_comp_mode ='1' then
		pc_new<=std_logic_vector(unsigned(pc_old)-1) ; 
	elsif normal_mode ='1' then
		pc_new<= std_logic_vector(unsigned(pc_old)+2);
	end if;
end process;


end Behavioural;
