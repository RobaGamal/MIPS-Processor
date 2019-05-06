library ieee;
library processor;
use ieee.std_logic_1164.all;
use processor.config.all;

entity Decode_Buffer is
    port (
        -- buffer input - first instruction
		alu_op1_in : in  alufun_t;
		update_flag1_in : in std_logic;
		wb1_in : in std_logic;
		is_branch1_in : in std_logic_vector(2 downto 0);
		immd1_in : in shiftamount_t;
		src_addr1_in : in regaddr_t;
		dst_addr1_in : in regaddr_t;
		src_val1_in : in dword_t;
        dst_val1_in : in dword_t;
        -- buffer input - second instruction
        alu_op2_in : in  alufun_t;
		update_flag2_in : in std_logic;
		wb2_in : in std_logic;
		is_branch2_in : in std_logic_vector(2 downto 0);
		immd2_in : in shiftamount_t;
		src_addr2_in : in regaddr_t;
		dst_addr2_in : in regaddr_t;
		src_val2_in : in dword_t;
        dst_val2_in : in dword_t;
        -- buffer input - memory
        mem_op_in : in memfun_t;
        mem_inst_no_in : in std_logic;
		-- buffer output -- first instruction
		alu_op1_out : out  alufun_t;
		update_flag1_out : out std_logic;
		wb1_out : out  std_logic;
		is_branch1_out : out std_logic_vector(2 downto 0);
		src_addr1_out : out regaddr_t ;
		dst_addr1_out:out regaddr_t ;
		src_val1_out:out dword_t;
		dst_val1_out:out dword_t;
        immd1_out : out shiftamount_t;
        -- buffer output -- second instruction
        alu_op2_out : out  alufun_t;
		update_flag2_out : out std_logic;
		wb2_out : out  std_logic;
		is_branch2_out : out std_logic_vector(2 downto 0);
		src_addr2_out : out regaddr_t ;
		dst_addr2_out:out regaddr_t ;
		src_val2_out:out dword_t;
		dst_val2_out:out dword_t;
		immd2_out : out shiftamount_t;
		
     
        
        mem_op_out: out std_logic_vector(2 downto 0);
        mem_inst_no_out:out std_logic;
        

        clk: in std_logic;
        ld:in std_logic:='1';
        rst:in std_logic
        

    );

end Decode_Buffer ;

Architecture Structural of Decode_Buffer is
    signal mem_inst_no_in_s : std_logic_vector(0 downto 0);
    signal mem_inst_no_out_s : std_logic_vector(0 downto 0);
    begin


reg1: entity processor.Reg 
    generic map (3)
    port map (
       mem_op_in,  mem_op_out,clk,ld, rst
    );

mem_inst_no:entity processor.Reg 
    generic map (1)
    port map (
      mem_inst_no_in_s, mem_inst_no_out_s,clk,ld, rst
    );   


    mem_inst_no_in_s(0)<=mem_inst_no_in;
    mem_inst_no_out<=mem_inst_no_out_s(0);



    buffer1: entity processor.DecodeInstBuffer
    port map (
        -- buffer input
        alu_op_in => alu_op1_in ,
        update_flag_in => update_flag1_in, 
        wb_in => wb1_in, 
        is_branch_in => is_branch1_in,
        immd_in => immd1_in ,
        src_addr_in => src_addr1_in ,
        dst_addr_in => dst_addr1_in,
        src_val_in => src_val1_in,
        dst_val_in => dst_val1_in,
        -- buffer output
        alu_op_out => alu_op1_out ,
        update_flag_out => update_flag1_out, 
        wb_out => wb1_out, 
        is_branch_out => is_branch1_out,
        immd_out => immd1_out ,
        src_addr_out => src_addr1_out ,
        dst_addr_out => dst_addr1_out,
        src_val_out => src_val1_out,
        dst_val_out => dst_val1_out,
        -- control
        clk=> clk,
        ld=>ld,
        rst=>rst
    );



    buffer2: entity processor.DecodeInstBuffer
    port map (
        -- buffer input
        alu_op_in => alu_op2_in ,
        update_flag_in => update_flag2_in, 
        wb_in => wb2_in, 
        is_branch_in => is_branch2_in,
        immd_in => immd2_in ,
        src_addr_in => src_addr2_in ,
        dst_addr_in => dst_addr2_in,
        src_val_in => src_val2_in,
        dst_val_in => dst_val2_in,
        -- buffer output
        alu_op_out => alu_op2_out ,
        update_flag_out => update_flag2_out, 
        wb_out => wb2_out, 
        is_branch_out => is_branch2_out,
        immd_out => immd2_out ,
        src_addr_out => src_addr2_out ,
        dst_addr_out => dst_addr2_out,
        src_val_out => src_val2_out,
        dst_val_out => dst_val2_out,
        -- control
        clk=> clk,
        ld=>ld,
        rst=>rst
    );




    
end Structural ;
