library ieee;
library processor;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use processor.config.all;

entity ExecuteControl is
    port (        
        opcode : in opcode_t;
        dest_adr : in regadr_t;
        alu_fun : out alufun_t;
        update_flag : out std_logic
    );
end ExecuteControl;

architecture Behavioral of ExecuteControl is
begin
    process
    begin
        update_flag <= '1';
        alu_fun <= alu_first_op;
        if opcode = op_setc  then
            alu_fun <= alu_setc;
        elsif opcode = op_clrc  then
            alu_fun <= alu_clearc;
        elsif opcode = op_not  then
            alu_fun <= alu_not;
        elsif opcode = op_inc  then
            alu_fun <= alu_inc;
        elsif opcode = op_dec  then
            alu_fun <= alu_dec;
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
        elsif opcode = op_ldm  then
            alu_fun <= alu_second_op;
        end if;
        if dest_adr = pcregadr or dest_adr = spregadr then
            update_flag <= '0';
        end if;
    end process;
end Behavioral;