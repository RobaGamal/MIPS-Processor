library ieee;
library processor;
use ieee.std_logic_1164.all;
use processor.config.all;


entity fetch_stage is 

generic ( n : natural := n_word ;
 n_pc: natural:=32  );

port(

      
      inst1_out: out std_logic_vector(n_word-1 downto 0);
      inst2_out: out std_logic_vector(n_word-1 downto 0);
      pc_out:out std_logic_vector(n_pc -1 downto 0);
      pc_immediate : in std_logic_vector(n_pc-1 downto 0) := (others => '0');
      normal_mode : in std_logic := '0';
      non_comp_mode: in std_logic := '0';
      excep_mode : in std_logic := '0';
      branch_mode : in std_logic := '0';
      load_address : in std_logic_vector(n_pc-1 downto 0) := (others => '0');

      clk:in std_logic ;
      stall:in std_logic :='0';
      
      rst:in std_logic

);


end fetch_stage ;

architecture structural of fetch_stage is
signal pc_addr_out:std_logic_vector(n_pc -1 downto 0);
signal memout:std_logic_vector(n_pc-1 downto 0);
signal inst1: std_logic_vector(n_word-1 downto 0);
signal inst2: std_logic_vector(n_word-1 downto 0);
signal opcode1 : opcode_t;
signal src1_addr :  regadr_t;
signal dest1_addr :  regadr_t;
signal imm1 :  shiftamount_t;    
signal opcode2 :  opcode_t;
signal src2_addr :  regadr_t;
signal dest2_addr :  regadr_t;
signal imm2 :  shiftamount_t;
signal is_compatible:std_logic;
signal ld_pc:std_logic:='0' ;
signal ld_buff: std_logic:='0' ;

begin
inst1<= memout(2*n_word-1 downto n_word);
inst2<= memout(n_word-1 downto 0);
ld_pc<=clk;
pc:entity processor.PCModule
 generic map(n_pc )
    port map(
        pc_immediate ,
        clk, ld_pc, rst ,
	stall,
	normal_mode ,
        non_comp_mode,
	excep_mode ,
	branch_mode ,
	load_address ,
     pc_addr_out
    );



mem:entity processor.instr_ram   Generic map ( n_word )
	PORT map(
		clk,
		pc_addr_out,
		memout);

packet_decode:entity processor.PacketDecode 
    port map (        
        inst1 ,
        inst2 ,
        opcode1 ,
        src1_addr,
        dest1_addr ,
        imm1 ,
        opcode2 ,
        src2_addr ,
        dest2_addr ,
        imm2
    );

checkcomp: entity processor.CheckCompatible
    port map(        
        opcode1 ,
        src1_addr ,
        dest1_addr,
        opcode2 ,
        src2_addr ,
        dest2_addr ,
        is_compatible 
    );

ld_buff<= clk and is_compatible ;
fetch_buff:entity processor.fetch_buffer generic map( n_word )

port map( inst1,
       inst2,
      inst1_out,
       inst2_out,
       clk,
       rst,
       ld_buff

    );


pc_out<=pc_addr_out;









end structural;
