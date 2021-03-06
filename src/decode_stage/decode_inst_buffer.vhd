library ieee;
library processor;
use ieee.std_logic_1164.all;
use processor.config.all;

entity DecodeInstBuffer is
	port (
		-- buffer input
		alu_op_in : in  alufun_t;
		update_flag_in : in std_logic;
		wb_in : in std_logic;
		is_branch_in : in std_logic_vector(2 downto 0);
		immd_in : in shiftamount_t;
		src_addr_in : in regaddr_t;
		dst_addr_in : in regaddr_t;
		src_val_in : in dword_t;
		dst_val_in : in dword_t;
		-- buffer output
		alu_op_out : out  alufun_t;
		update_flag_out : out std_logic;
		wb_out : out  std_logic;
		is_branch_out : out std_logic_vector(2 downto 0);
		src_addr_out : out regaddr_t ;
		dst_addr_out:out regaddr_t ;
		src_val_out:out dword_t;
		dst_val_out:out dword_t;
		immd_out : out shiftamount_t;
		-- control
		clk: in std_logic;
		ld:in std_logic:='1';
		rst:in std_logic
	);
end DecodeInstBuffer;

Architecture Structural of DecodeInstBuffer is
	signal signals_in : std_logic_vector(1 downto 0);
	signal signals_out : std_logic_vector(1 downto 0);
begin
	reg1: entity processor.Reg
	generic map (n_alufun)
	port map (
	   alu_op_in, alu_op_out, clk, ld, rst
	);

	reg3: entity processor.Reg
	generic map (n_shiftamount)
	port map (
	   immd_in, immd_out, clk, ld, rst
	);
	
	reg4: entity processor.Reg
	generic map (n_shiftamount)
	port map (
	   is_branch_in, is_branch_out, clk, ld, rst
	);

	signals_in <= update_flag_in  & wb_in;
	reg5: entity processor.Reg
	generic map (2)
	port map (
	   signals_in, signals_out, clk, ld, rst
	);
	update_flag_out <= signals_out(1);
	wb_out <= signals_out(0);

	reg10:  entity processor.Reg
	generic map (n_regaddr)
	port map (
		src_addr_in, src_addr_out, clk, ld, rst
	);

	reg11: entity processor.Reg
	generic map (n_regaddr)
	port map (
		dst_addr_in, dst_addr_out, clk, ld, rst
	);

	reg14: entity processor.Reg
	generic map (n_dword)
	port map (
	   src_val_in, src_val_out, clk, ld, rst
	);

	reg15: entity processor.Reg
	generic map (n_dword)
	port map (
	  dst_val_in, dst_val_out, clk, ld, rst
	);
end Structural ;
