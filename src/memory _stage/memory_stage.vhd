library ieee;
library processor;
use ieee.std_logic_1164.all;
use processor.config.all;

entity Memory_stage is
    port ( 
        memrw:in std_logic_vector(2 downto 0);
        mem_inst_no:in std_logic; 
        src1_add_in:in regaddr_t ;
        dst1_add_in:in regaddr_t ;
        src2_add_in:in regaddr_t ;
        dst2_add_in:in regaddr_t ;
        val_dst1_in:in dword_t;
        val_src1_in:in dword_t;
        val_dst2_in:in dword_t;
        val_src2_in:in dword_t;
       
        wb_1_in:in std_logic;
        wb_2_in:in std_logic;
       
       
        wb_1_out:out std_logic;
        wb_2_out:out std_logic;
        src1_add_out:out regaddr_t ;
        dst1_add_out:out regaddr_t ;
        src2_add_out:out regaddr_t ;
        dst2_add_out:out regaddr_t ;
        val_dst1_out:out dword_t;
        val_src1_out:out dword_t;
        val_dst2_out:out dword_t;
        val_src2_out:out dword_t;
        flush:in std_logic;
        clk:in std_logic;
        rst: in std_logic;
        stall:in std_logic:='0'

    );
end Memory_stage;


Architecture Structural of Memory_stage is


signal ld_buff: std_logic;
signal val_dst1_temp:dword_t;
signal val_dst2_temp:dword_t;
signal address:std_logic_vector(n_word - 1 downto 0);
signal data_in : dword_t;
signal data_out: dword_t;
begin
ld_buff<= not(stall) ;

data_ram:entity processor.Ram 
    generic map (n_word)
    port map(
        clk,
        memrw,
        address,
        data_in,
        data_out
    
   
    );


process(memrw,mem_inst_no,data_out,data_in,val_dst1_in,val_dst2_in)
begin
if(memrw="001" or memrw="011") then
    if(mem_inst_no='0') then 
    address<=val_src1_in(n_word-1 downto 0);
    val_dst1_temp<=data_out;
    val_dst2_temp<=val_dst2_in;
    elsif(mem_inst_no='1') then
    address<=val_src2_in(n_word-1 downto 0);
    val_dst2_temp<=data_out;
    val_dst1_temp<=val_dst1_in;
    end if;

elsif(memrw="010" or memrw="100") then
    if(mem_inst_no='0') then 
    address<=val_src1_in(n_word-1 downto 0);
    data_in<=val_dst1_in;
    elsif(mem_inst_no='1') then
    address<=val_src2_in(n_word-1 downto 0);
    data_in<=val_dst2_in;
    end if;


elsif(memrw="000") then 
val_dst1_temp<=val_dst1_in;
val_dst2_temp<=val_dst2_in;
    
end if;

end process;

memory_buffer: entity processor.Memory_Buffer 
generic map(n_word) 
port map(  
        wb_1_in,
        wb_2_in,
        src1_add_in,
        dst1_add_in,
        src2_add_in,
        dst2_add_in,
        val_src1_in,
        val_dst1_in,
        val_src2_in,
        val_dst2_in,
        
       
        wb_1_out,
        wb_2_out,
        src1_add_out,
        dst1_add_out,
        src2_add_out,
        dst2_add_out,

        val_src1_out,
        val_dst1_out,
        val_src2_out,
        val_dst2_out,
        
        clk,
	    ld_buff,
        rst        

    );

end Structural ;
