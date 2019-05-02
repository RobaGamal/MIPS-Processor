library ieee;
library processor;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use processor.config.all;

entity PacketDecode is
	port (        
		inst1 : in word_t;
		inst2 : in word_t;
		-- instruction 1
		opcode1 : out opcode_t;
		src1_addr : out regaddr_t;
		dst1_addr : out regaddr_t;
		imm1 : out shiftamount_t;
		-- instruction 2
		opcode2 : out opcode_t;
		src2_addr : out regaddr_t;
		dst2_addr : out regaddr_t;
		imm2 : out shiftamount_t
	);
end PacketDecode;

architecture Structural of PacketDecode is
begin
	opdecode_gen_1 : entity processor.OpDecode
	port map (
		inst => inst1,
		opcode => opcode1,
		src_addr => src1_addr,
		dst_addr => dst1_addr,
		imm => imm1
	);

	opdecode_gen_2 : entity processor.OpDecode
	port map (
		inst => inst2,
		opcode => opcode2,
		src_addr => src2_addr,
		dst_addr => dst2_addr,
		imm => imm2
	);
end Structural;