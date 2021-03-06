library ieee;
library processor;
use ieee.std_logic_1164.all;
use processor.config.all;

entity FetchStage is 
	port (
		inst1_out : out word_t;
		inst2_out : out word_t;
		pc_out : out dword_t;
		stall : in std_logic :='0';
		branch_mode : in std_logic := '0';
		load_address : in dword_t := (others => '0');
		flush : in std_logic;
		clk : in std_logic;
		rst : in std_logic
	);
end FetchStage;

architecture structural of FetchStage is
	signal pc_addr_out : dword_t;
	signal memout : dword_t;
	signal inst1_tmp : word_t;
	signal inst2_tmp : word_t;
	signal inst1 : word_t;
	signal inst2 : word_t;
	signal inst1_resolved : word_t;
	signal inst2_resolved : word_t;
	signal opcode1 : opcode_t;
	signal src1_addr : regaddr_t;
	signal dst1_addr : regaddr_t;
	signal imm1 : shiftamount_t;    
	signal opcode2 : opcode_t;
	signal src2_addr : regaddr_t;
	signal dst2_addr : regaddr_t;
	signal imm2 : shiftamount_t;
	signal is_compatible : std_logic:='1';
	signal non_comp:std_logic;
	signal normal:std_logic;
	-- signal ld_pc : std_logic:='0';
	-- signal ld_buff : std_logic:='0';
begin
	inst1_tmp <= memout(2*n_word-1 downto n_word);
	inst2_tmp <= memout(n_word-1 downto 0);
	inst1 <= (others => '0') when flush = '1' else inst1_tmp;
	inst2 <= (others => '0') when flush = '1' else inst2_tmp;
	non_comp<=not(is_compatible);
	normal<=not(branch_mode) and is_compatible;
	-- ld_pc <= clk;
	pc_gen: entity processor.PCModule
	port map (
		stall => stall,
		normal_mode => normal,
		non_comp_mode => non_comp ,
		branch_mode => branch_mode,
		load_address => load_address,
		ld => clk,
		clk => clk,
		rst => rst,
		pc_addr_out => pc_addr_out
	);

	mem: entity processor.InstrRam
	port map (
		clk => clk,
		address => pc_addr_out,
		dataout => memout
	);

	packet_decode: entity processor.PacketDecode 
	port map (
		inst1 => inst1,
		inst2 => inst2,
		opcode1 => opcode1,
		src1_addr => src1_addr,
		dst1_addr => dst1_addr,
		imm1 => imm1,
		opcode2 => opcode2,
		src2_addr => src2_addr,
		dst2_addr => dst2_addr,
		imm2 => imm2
	);

	checkcomp: entity processor.CheckCompatible
	port map (        
		opcode1 => opcode1,
		src1_addr => src1_addr,
		dst1_addr => dst1_addr,
		opcode2 => opcode2,
		src2_addr => src2_addr,
		dst2_addr => dst2_addr,
		is_compatible => is_compatible 
	);

	resolveinsts: entity processor.ResolveInsts
	port map (
		inst1_in => inst1,
		inst2_in => inst2,
		stall => stall,
		is_compatible => is_compatible,
		inst1_out => inst1_resolved,
		inst2_out => inst2_resolved
	);

	fetch_buff: entity processor.FetchBuffer
	generic map (n_word)
	port map (
		inst1 => inst1_resolved,
		inst2 => inst2_resolved,
		out1 => inst1_out,
		out2 => inst2_out,
		clk => clk,
		ld => clk,
		rst => rst
	);
	pc_out <= pc_addr_out;
end structural;
