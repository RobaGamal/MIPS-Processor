library ieee;
library processor;
use ieee.std_logic_1164.all;
use processor.config.all;

entity branch_execute is
	port (
		  branch_op : in brfun_t;
		  z_flag : in std_logic;
		  n_flag : in std_logic;
		  c_flag : in std_logic;
		  branch : out std_logic
	);
end branch_execute;

Architecture behavioural of branch_execute is
begin
	branch <= '1' when (branch_op = br_jz and z_flag = '1') or
						(branch_op = br_jn and n_flag = '1') or
						(branch_op = br_jc and c_flag = '1') else '0';
end behavioural;