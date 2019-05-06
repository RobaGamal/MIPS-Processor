library ieee;
library processor;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use processor.config.all;

entity ComplexBreaker is
	port (
		-- input - first instruction
		opcode1_in : in opcode_t;
		src_addr1_in : in regaddr_t;
		dst_addr1_in : in regaddr_t;
		imm1_in : in shiftamount_t;
		-- input - second instruction
		opcode2_in : in opcode_t;
		src_addr2_in : in regaddr_t;
		dst_addr2_in : in regaddr_t;
		imm2_in : in shiftamount_t;
		-- output - first instruction
		opcode1_out : out opcode_t;
		src_addr1_out : out regaddr_t;
		dst_addr1_out : out regaddr_t;
		imm1_out : out shiftamount_t;
		-- output - second instruction
		opcode2_out : out opcode_t;
		src_addr2_out : out regaddr_t;
		dst_addr2_out : out regaddr_t;
		imm2_out : out shiftamount_t;
		-- output - third instruction
		opcode3_out : out opcode_t;
		src_addr3_out : out regaddr_t;
		dst_addr3_out : out regaddr_t;
		-- output - ldm case
		is_ldm_out : out std_logic
	);
end ComplexBreaker;

architecture Behavioral of ComplexBreaker is
begin
	process(opcode1_in, src_addr1_in, dst_addr1_in, imm1_in,
			opcode2_in, src_addr2_in, dst_addr2_in, imm2_in)
	begin
		-- initialize
		opcode1_out <= opcode1_in;
		src_addr1_out <= src_addr1_in;
		dst_addr1_out <= dst_addr1_in;
		imm1_out <= imm1_in;
		opcode2_out <= opcode2_in;
		src_addr2_out <= src_addr2_in;
		dst_addr2_out <= dst_addr2_in;
		imm2_out <= imm2_in;
		opcode3_out <= op_nop;
		src_addr3_out <= notregaddr;
		dst_addr3_out <= notregaddr;
		is_ldm_out <= '0';
		if opcode1_in = op_ldm then
			opcode1_out <= op_mov;
			src_addr1_out <= notregaddr ;
			opcode2_out <= op_nop;
			src_addr2_out <= notregaddr;
			dst_addr2_out <= notregaddr;
			is_ldm_out <= '1';
		elsif opcode1_in = op_push then
			-- STD Rdst SP
			opcode1_out <= op_std;
			src_addr1_out <= dst_addr1_in;
			dst_addr1_out <= spregaddr;
			imm1_out <= (others => '0');
			-- DEC SP
			opcode2_out <= op_dec;
			src_addr2_out <= notregaddr;
			dst_addr2_out <= spregaddr;
			imm2_out <= (others => '0');
		elsif opcode1_in = op_pop then
			-- INC SP
			opcode1_out <= op_inc;
			src_addr1_out <= notregaddr;
			dst_addr1_out <= spregaddr;
			imm1_out <= (others => '0');
			-- LDD SP Rdst
			opcode2_out <= op_ldd;
			src_addr2_out <= spregaddr;
			dst_addr2_out <= dst_addr1_in;
			imm2_out <= (others => '0');
		elsif opcode1_in = op_call then
			-- NOTE: PC at this moment has been incremented
			-- which is convienent for our uses
			-- STD PC SP
			opcode1_out <= op_std;
			src_addr1_out <= spregaddr;
			dst_addr1_out <= spregaddr;
			imm1_out <= (others => '0');
			-- DEC2 SP
			opcode2_out <= op_dec2;
			src_addr2_out <= notregaddr;
			dst_addr2_out <= spregaddr;
			imm2_out <= (others => '0');
			-- JMP Rdst
			opcode3_out <= op_jmp;
			src_addr3_out <= notregaddr;
			dst_addr3_out <= dst_addr1_in;
		elsif opcode1_in = op_ret then
			-- NOTE: Remember to handle LDD SP PC in memory stage
			-- This will require flushing and loading PC from regfile
			-- INC2 SP
			opcode1_out <= op_inc2;
			src_addr1_out <= notregaddr;
			dst_addr1_out <= spregaddr;
			imm1_out <= (others => '0');
			-- LDD SP PC
			opcode2_out <= op_ldd;
			src_addr2_out <= spregaddr;
			dst_addr2_out <= pcregaddr;
			imm2_out <= (others => '0');
		end if;
		-- TODO: handle RETI
	end process;
end Behavioral;
