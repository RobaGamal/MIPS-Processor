library ieee;
library processor;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use processor.config.all;

entity ExecuteControl is
	port (        
		opcode : in opcode_t;
		dst_addr : in regaddr_t;
		alu_fun : out alufun_t;
		update_flag : out std_logic
	);
end ExecuteControl;

architecture Behavioral of ExecuteControl is
begin
	process(dst_addr,opcode)
	begin
		update_flag <= '1';
		alu_fun <= alu_first_op;
		if dst_addr = pcregaddr or dst_addr = spregaddr then
			update_flag <= '0';
		end if;
		if opcode = op_setc  then
			alu_fun <= alu_setc;
		elsif opcode = op_clrc  then
			alu_fun <= alu_clearc;
		elsif opcode = op_not  then
			alu_fun <= alu_not;
		elsif opcode = op_inc  then
			if update_flag = '0' then
				alu_fun <= alu_inc2;
			else
				alu_fun <= alu_inc;
			end if;
		elsif opcode = op_dec  then
			if update_flag = '0' then
				alu_fun <= alu_dec2;
			else
				alu_fun <= alu_dec;
			end if;
		elsif opcode = op_mov  then
			alu_fun <= alu_second_op;
		elsif opcode = op_add  then
			alu_fun <= alu_add;
		elsif opcode = op_sub  then
			alu_fun <= alu_sub;
		elsif opcode = op_and  then
			alu_fun <= alu_and;
		elsif opcode = op_or  then
			alu_fun <= alu_or;
		elsif opcode = op_shl  then
			alu_fun <= alu_shl;
		elsif opcode = op_shr  then
			alu_fun <= alu_shr;
		elsif opcode = op_ldd  then
			alu_fun <= alu_second_op;
		end if;
	end process;
end Behavioral;
