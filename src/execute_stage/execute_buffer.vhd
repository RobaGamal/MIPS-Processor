library ieee;
library processor;
use ieee.std_logic_1164.all;
use processor.config.all;

entity Execute_Buffer is
generic (
        n : natural := n_word -- number of bits
       
    );  

port (  
        mem_op_in:  in std_logic_vector(2 downto 0);
        mem_inst_no_in:in std_logic;
        wb_1_in:in std_logic;
        wb_2_in:in std_logic;
        src1_add_in:in regaddr_t ;
        dst1_add_in:in regaddr_t ;
        src2_add_in:in regaddr_t ;
        dst2_add_in:in regaddr_t ;
        src1_val_in:in dword_t;
        dst1_val_in:in dword_t;
        src2_val_in:in dword_t;
        dst2_val_in:in dword_t;
	   
        mem_op_out: out std_logic_vector(2 downto 0);
        mem_inst_no_out:out std_logic;
        wb_1_out:out std_logic;
        wb_2_out:out std_logic;
        src1_add_out:out regaddr_t ;
        dst1_add_out:out regaddr_t ;
        src2_add_out:out regaddr_t ;
        dst2_add_out:out regaddr_t ;
        src1_val_out:out dword_t;
        dst1_val_out:out dword_t;
        src2_val_out:out dword_t;
        dst2_val_out:out dword_t;
       
        clk: in std_logic;
        ld:in std_logic:='1';
        rst:in std_logic
        

    );

end Execute_Buffer ;

Architecture Structural of Execute_Buffer is
signal wb :std_logic_vector(1 downto 0);
signal mem_no :std_logic_vector(0 downto 0);
signal wb_out :std_logic_vector(1 downto 0);
signal mem_no_out :std_logic_vector(0 downto 0);
begin


reg1: entity processor.Reg 
    generic map(n_memfun)
    port map(
       mem_op_in,  mem_op_out,clk,ld, rst
    );


wb(0)<=wb_1_in;
wb(1)<=wb_2_in;


mem_no(0)<=mem_inst_no_in;


wb_1_out<=wb_out(0);
wb_2_out<=wb_out(1);



mem_inst_no_out<= mem_no_out(0);

reg2: entity processor.Reg 
    generic map(2)
    port map(
        wb,  wb_out,clk,ld, rst
    );

reg3:  entity processor.Reg 
    generic map(4)
    port map(
        src1_add_in,  src1_add_out,clk,ld, rst
    );  

reg4:  entity processor.Reg 
    generic map(4)
    port map(
        dst1_add_in,  dst1_add_out,clk,ld, rst
    );     

 reg5:  entity processor.Reg 
    generic map(4)
    port map(
        src2_add_in,  src2_add_out,clk,ld, rst
    ); 
       
 reg6:  entity processor.Reg 
    generic map(4)
    port map(
        dst2_add_in,  dst2_add_out,clk,ld, rst
    );   

reg8:  entity processor.Reg 
    generic map(2*n_word)
    port map(
       src1_val_in, src1_val_out,clk,ld, rst
    );  

reg9:  entity processor.Reg 
    generic map(2*n_word)
    port map(
      dst1_val_in, dst1_val_out,clk,ld, rst
    );     

reg10:  entity processor.Reg 
    generic map(2*n_word)
    port map(
       src2_val_in, src2_val_out,clk,ld, rst
    ); 

 reg11:  entity processor.Reg 
    generic map(2*n_word)
    port map(
      dst2_val_in, dst2_val_out,clk,ld, rst
    );     
      
reg12:entity processor.Reg 
generic map(1)
port map(
    mem_no,  mem_no_out,clk,ld, rst
);


end Structural ;
