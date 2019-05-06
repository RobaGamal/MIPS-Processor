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
		update_flag <= '0';
		alu_fun <= alu_second_op;
		if opcode = op_setc  then
			alu_fun <= alu_setc;
		elsif opcode = op_clrc  then
			alu_fun <= alu_clearc;
		elsif opcode = op_not  then
			alu_fun <= alu_not;
			update_flag <= '1';
		elsif opcode = op_inc  then
			alu_fun <= alu_inc;
			update_flag <= '1';
		elsif opcode = op_dec  then
			alu_fun <= alu_dec;
			update_flag <= '1';
		elsif opcode = op_inc2  then
			alu_fun <= alu_inc2;
		elsif opcode = op_dec2 then
			alu_fun <= alu_dec2;
		elsif opcode = op_mov  then
			alu_fun <= alu_first_op;
		elsif opcode = op_in  then
			alu_fun <= alu_first_op;
		elsif opcode = op_add  then
			alu_fun <= alu_add;
			update_flag <= '1';
		elsif opcode = op_sub  then
			alu_fun <= alu_sub;
			update_flag <= '1';
		elsif opcode = op_and  then
			alu_fun <= alu_and;
			update_flag <= '1';
		elsif opcode = op_or  then
			alu_fun <= alu_or;
			update_flag <= '1';
		elsif opcode = op_shl  then
			alu_fun <= alu_shl;
			update_flag <= '1';
		elsif opcode = op_shr  then
			alu_fun <= alu_shr;
			update_flag <= '1';
		end if;
		if dst_addr = pcregaddr or dst_addr = spregaddr or dst_addr = notregaddr then
			update_flag <= '0';
		end if;
	end process;
end Behavioral;
