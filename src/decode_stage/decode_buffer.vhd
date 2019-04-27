library ieee;
library processor;
use ieee.std_logic_1164.all;
use processor.config.all;

entity Decode_Buffer is
generic (
        n : natural := n_word -- number of bits
       
    );  

port (  alu_op1_in: in  alufun_t;
        alu_op2_in: in  alufun_t;
        update_flag_in1: in std_logic_vector(0 downto 0);
        update_flag_in2: in  std_logic_vector(0 downto 0);
        mem_op_in:  in std_logic_vector(2 downto 0);
        mem_inst_no_in:in std_logic_vector(0 downto 0);
        wb_1_in:in std_logic_vector(0 downto 0);
        wb_2_in:in std_logic_vector(0 downto 0);
        is_branch_in:in std_logic_vector(0 downto 0);
	    immd_in1:in shiftamount_t;
	    immd_in2:in shiftamount_t;
        src1_add_in:in regadr_t ;
        dst1_add_in:in regadr_t ;
        src2_add_in:in regadr_t ;
        dst2_add_in:in regadr_t ;
        src1_val_in:in std_logic_vector(n_word-1 downto 0);
        dst1_val_in:in std_logic_vector(n_word-1 downto 0);
        src2_val_in:in std_logic_vector(n_word-1 downto 0);
        dst2_val_in:in std_logic_vector(n_word-1 downto 0);
	    pc_val_in:in std_logic_vector(2*n_word-1 downto 0);

        alu_op1_out: out  alufun_t;
        alu_op2_out: out  alufun_t;
        update_flag_out1: out std_logic_vector(0 downto 0);
        update_flag_out2: out std_logic_vector(0 downto 0);
        mem_op_out: out std_logic_vector(2 downto 0);
        mem_inst_no_out:out std_logic_vector(0 downto 0);
        wb_1_out:out  std_logic_vector(0 downto 0);
        wb_2_out:out std_logic_vector(0 downto 0);
        is_branch_out:out std_logic_vector(0 downto 0);
        src1_add_out:out regadr_t ;
        dst1_add_out:out regadr_t ;
        src2_add_out:out regadr_t ;
        dst2_add_out:out regadr_t ;
        src1_val_out:out std_logic_vector(n_word-1 downto 0);
        dst1_val_out:out std_logic_vector(n_word-1 downto 0);
        src2_val_out:out std_logic_vector(n_word-1 downto 0);
        dst2_val_out:out std_logic_vector(n_word-1 downto 0);
        immd_out1:out shiftamount_t;
        immd_out2:out shiftamount_t;

	    pc_val_out:out std_logic_vector(2*n_word-1 downto 0);

        clk: in std_logic;
        ld:in std_logic:='1';
        rst:in std_logic
        

    );

end Decode_Buffer ;

Architecture Structural of Decode_Buffer is
begin
reg1: entity processor.Reg 
    generic map(4)
    port map(
       alu_op1_in, alu_op1_out,clk,ld, rst
    );
    
reg2: entity processor.Reg 
    generic map(4)
    port map(
       alu_op2_in, alu_op2_out,clk,ld, rst
    );
 
 

reg3: entity processor.Reg 
    generic map(3)
    port map(
       immd_in1, immd_out1,clk,ld, rst
    );

reg4: entity processor.Reg 
    generic map(3)
    port map(
       immd_in2, immd_out2,clk,ld, rst
    );

reg5: entity processor.Reg 
    generic map(1)
    port map(
       update_flag_in1, update_flag_out1,clk,ld, rst
    );  

reg6: entity processor.Reg 
    generic map(1)
   port map(
       update_flag_in2, update_flag_out2,clk,ld, rst
    );
    

reg7: entity processor.Reg 
    generic map(3)
    port map(
       mem_op_in,  mem_op_out,clk,ld, rst
    );




reg8: entity processor.Reg 
    generic map(1)
    port map(
        wb_1_in,  wb_1_out,clk,ld, rst
    );
        
        
 reg9: entity processor.Reg 
    generic map(1)
    port map(
        wb_2_in,  wb_2_out,clk,ld, rst
    );

reg10:  entity processor.Reg 
    generic map(4)
    port map(
        src1_add_in,  src1_add_out,clk,ld, rst
    );  

reg11:  entity processor.Reg 
    generic map(4)
    port map(
        dst1_add_in,  dst1_add_out,clk,ld, rst
    );     

 reg12:  entity processor.Reg 
    generic map(4)
    port map(
        src2_add_in,  src2_add_out,clk,ld, rst
    ); 
       
 reg13:  entity processor.Reg 
    generic map(4)
    port map(
        dst2_add_in,  dst2_add_out,clk,ld, rst
    );   

reg14:  entity processor.Reg 
    generic map(n)
    port map(
       src1_val_in, src1_val_out,clk,ld, rst
    );  

reg15:  entity processor.Reg 
    generic map(n)
    port map(
      dst1_val_in, dst1_val_out,clk,ld, rst
    );     

reg16:  entity processor.Reg 
    generic map(n)
    port map(
       src2_val_in, src2_val_out,clk,ld, rst
    ); 

 reg17:  entity processor.Reg 
    generic map(n)
    port map(
      dst2_val_in, dst2_val_out,clk,ld, rst
    );     
      
reg_pc:entity processor.Reg32 
    generic map(2*n)
    port map(
      pc_val_in, pc_val_out,clk,ld, rst
    );   

is_branch:entity processor.Reg 
    generic map(1)
    port map(
      is_branch_in, is_branch_out,clk,ld, rst
    );   

mem_inst_no:entity processor.Reg 
    generic map(1)
    port map(
      mem_inst_no_in, mem_inst_no_out,clk,ld, rst
    );   

end Structural ;
