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
        update_flag_in: in std_logic_vector(0 downto 0);
        mem_op1_in: in opcode_t;
        mem_op2_in: in opcode_t;
        wb_1_in:in std_logic_vector(0 downto 0);
        wb_2_in:in std_logic_vector(0 downto 0);

        src1_add_in:in regadr_t ;
        dst1_add_in:in regadr_t ;
        src2_add_in:in regadr_t ;
        dst2_add_in:in regadr_t ;
        src1_val_in:in std_logic_vector(n_word-1 downto 0);
        dst1_val_in:in std_logic_vector(n_word-1 downto 0);
        src2_val_in:in std_logic_vector(n_word-1 downto 0);
        dst2_val_in:in std_logic_vector(n_word-1 downto 0);

        alu_op1_out: out  alufun_t;
        alu_op2_out: out  alufun_t;
        update_flag_out: out  std_logic_vector(0 downto 0);
        mem_op1_out: out opcode_t;
        mem_op2_out: out opcode_t;
        wb_1_out:out  std_logic_vector(0 downto 0);
        wb_2_out:out std_logic_vector(0 downto 0);

        src1_add_out:out regadr_t ;
        dst1_add_out:out regadr_t ;
        src2_add_out:out regadr_t ;
        dst2_add_out:out regadr_t ;
        src1_val_out:out std_logic_vector(n_word-1 downto 0);
        dst1_val_out:out std_logic_vector(n_word-1 downto 0);
        src2_val_out:out std_logic_vector(n_word-1 downto 0);
        dst2_val_out:out std_logic_vector(n_word-1 downto 0);

        clk: in std_logic;
        rst:in std_logic;
        ld:in std_logic

    );

end Decode_Buffer ;

Architecture Structural of Decode_Buffer is
begin
reg1: entity processor.Reg 
    generic map(n)
    port map(
       alu_op1_in, alu_op1_out,ld, clk, rst
    );
    
reg2: entity processor.Reg 
    generic map(n)
    port map(
       alu_op2_in, alu_op2_out,ld, clk, rst
    );
    

reg3: entity processor.Reg 
    generic map(n)
    port map(
       update_flag_in, update_flag_out,ld, clk, rst
    );
    

reg4: entity processor.Reg 
    generic map(n)
    port map(
       mem_op1_in,  mem_op1_out,ld, clk, rst
    );


reg5: entity processor.Reg 
    generic map(n)
    port map(
       mem_op2_in,  mem_op2_out,ld, clk, rst
    );

reg6: entity processor.Reg 
    generic map(n)
    port map(
        wb_1_in,  wb_1_out,ld, clk, rst
    );
        
        
 reg7: entity processor.Reg 
    generic map(n)
    port map(
        wb_2_in,  wb_2_out,ld, clk, rst
    );

reg8:  entity processor.Reg 
    generic map(n)
    port map(
        src1_add_in,  src1_add_out,ld, clk, rst
    );  

reg9:  entity processor.Reg 
    generic map(n)
    port map(
        dst1_add_in,  dst1_add_out,ld, clk, rst
    );     

 reg10:  entity processor.Reg 
    generic map(n)
    port map(
        src2_add_in,  src2_add_out,ld, clk, rst
    ); 
       
 reg11:  entity processor.Reg 
    generic map(n)
    port map(
        dst2_add_in,  dst2_add_out,ld, clk, rst
    );   

reg12:  entity processor.Reg 
    generic map(n)
    port map(
       src1_val_in, src1_val_out,ld, clk, rst
    );  

reg13:  entity processor.Reg 
    generic map(n)
    port map(
      dst1_val_in, dst1_val_out,ld, clk, rst
    );     

reg14:  entity processor.Reg 
    generic map(n)
    port map(
       src2_val_in, src2_val_out,ld, clk, rst
    ); 

 reg15:  entity processor.Reg 
    generic map(n)
    port map(
      dst2_val_in, dst2_val_out,ld, clk, rst
    );     
      


end Structural ;