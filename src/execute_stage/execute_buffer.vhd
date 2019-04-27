library ieee;
library processor;
use ieee.std_logic_1164.all;
use processor.config.all;

entity Execute_Buffer is
generic (
        n : natural := n_word -- number of bits
       
    );  

port (  
        mem_op_in:  in std_logic_vector(0 downto 0);
        wb_1_in:in std_logic_vector(0 downto 0);
        wb_2_in:in std_logic_vector(0 downto 0);
        src1_add_in:in regadr_t ;
        dst1_add_in:in regadr_t ;
        src2_add_in:in regadr_t ;
        dst2_add_in:in regadr_t ;
        src1_val_in:in std_logic_vector(n_word-1 downto 0);
        dst1_val_in:in std_logic_vector(2*n_word-1 downto 0);
        src2_val_in:in std_logic_vector(n_word-1 downto 0);
        dst2_val_in:in std_logic_vector(2*n_word-1 downto 0);
	   
        mem_op_out: out std_logic_vector(0 downto 0);
        wb_1_out:out std_logic_vector(0 downto 0);
        wb_2_out:out std_logic_vector(0 downto 0);
        src1_add_out:out regadr_t ;
        dst1_add_out:out regadr_t ;
        src2_add_out:out regadr_t ;
        dst2_add_out:out regadr_t ;
        src1_val_out:out std_logic_vector(n_word-1 downto 0);
        dst1_val_out:out std_logic_vector(2*n_word-1 downto 0);
        src2_val_out:out std_logic_vector(n_word-1 downto 0);
        dst2_val_out:out std_logic_vector(2*n_word-1 downto 0);
       
        clk: in std_logic;
        ld:in std_logic:='1';
        rst:in std_logic
        

    );

end Execute_Buffer ;

Architecture Structural of Execute_Buffer is
begin


reg1: entity processor.Reg 
    generic map(1)
    port map(
       mem_op_in,  mem_op_out,clk,ld, rst
    );




reg2: entity processor.Reg 
    generic map(1)
    port map(
        wb_1_in,  wb_1_out,clk,ld, rst
    );
        
        
 reg3: entity processor.Reg 
    generic map(1)
    port map(
        wb_2_in,  wb_2_out,clk,ld, rst
    );

reg4:  entity processor.Reg 
    generic map(4)
    port map(
        src1_add_in,  src1_add_out,clk,ld, rst
    );  

reg5:  entity processor.Reg 
    generic map(4)
    port map(
        dst1_add_in,  dst1_add_out,clk,ld, rst
    );     

 reg6:  entity processor.Reg 
    generic map(4)
    port map(
        src2_add_in,  src2_add_out,clk,ld, rst
    ); 
       
 reg7:  entity processor.Reg 
    generic map(4)
    port map(
        dst2_add_in,  dst2_add_out,clk,ld, rst
    );   

reg8:  entity processor.Reg 
    generic map(n)
    port map(
       src1_val_in, src1_val_out,clk,ld, rst
    );  

reg9:  entity processor.Reg 
    generic map(2*n)
    port map(
      dst1_val_in, dst1_val_out,clk,ld, rst
    );     

reg10:  entity processor.Reg 
    generic map(n)
    port map(
       src2_val_in, src2_val_out,clk,ld, rst
    ); 

 reg11:  entity processor.Reg 
    generic map(2*n)
    port map(
      dst2_val_in, dst2_val_out,clk,ld, rst
    );     
      


end Structural ;
