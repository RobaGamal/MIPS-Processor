library ieee;
library processor;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use processor.config.all;

entity regfile is
     generic(n : integer := 16);
    port (        
        src1_addr_read : in regadr_t;
        dest1_addr_read : in regadr_t;
        dest1_addr_write : in regadr_t;
        load_dst1: in std_logic;
        val_dst1_in:in std_logic_vector(n-1 downto 0);
        val_dst1_out:out std_logic_vector(n-1 downto 0);
        val_src1_out:out std_logic_vector(n-1 downto 0);
        -- instruction 1
        src2_addr_read : in regadr_t;
        dest2_addr_read : in regadr_t;
        dest2_addr_write : in regadr_t;
        load_dst2: in std_logic;
        val_dst2_in:in std_logic_vector(n-1 downto 0);
        val_dst2_out:out std_logic_vector(n-1 downto 0);
        val_src2_out:out std_logic_vector(n-1 downto 0);
       -- instruction 2
       clk:in std_logic;
       rst: in std_logic;
       --immediate value and pc
       immd:in std_logic_vector(n-1 downto 0);
       pc_val: in std_logic_vector(n-1 downto 0)
    );
end regfile;

architecture structural  of regfile is
signal q_arr : reg_vector;
signal d_arr : reg_vector;
signal l_arr : std_logic_vector(n_register-1 downto 0):=(others=>'0');

begin

reg_loop : for i in 0 to n_register-1 generate
reg: entity processor.Reg 
    generic map(n)
    port map(
        d_arr(i), q_arr(i), l_arr(i), clk, rst
    );
    end generate;


mux1:entity processor.mux generic map(n)
   port map(        
         src1_addr_read ,
         q_arr,
         pc_val,
         immd,
         val_src1_out
    );



mux2:entity processor.mux generic map(n)
   port map (        
        dest1_addr_read ,
         q_arr,
         pc_val,
         immd,
        val_dst1_out
    );
 


mux3:entity processor.mux generic map(n)
   port map(        
         src2_addr_read ,
         q_arr,
         pc_val,
         immd,
         val_src2_out
    );
  

mux4:entity processor.mux generic map(n)
   port map(        
        dest2_addr_read ,
         q_arr,
         pc_val,
         immd,
        val_dst2_out
    );
   

write_unit:entity processor.write_unit generic map(n )
    port map(        
        dest1_addr_write ,
        dest2_addr_write ,
       l_arr,
       d_arr ,
        val_dst1_in,
       val_dst2_in
       
    );


end structural;