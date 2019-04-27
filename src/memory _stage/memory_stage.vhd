library ieee;
library processor;
use ieee.std_logic_1164.all;
use processor.config.all;

entity Memory_stage is
    port ( 
        memrw:in std_logic_vector(2 downto 0);
        mem_inst_no:in std_logic; 
        src1_add_in:in regadr_t ;
        dst1_add_in:in regadr_t ;
        src2_add_in:in regadr_t ;
        dst2_add_in:in regadr_t ;
        val_dst1_in:in std_logic_vector(2*n_word-1 downto 0);
        val_src1_in:in std_logic_vector(n_word-1 downto 0);
        val_dst2_in:in std_logic_vector(2*n_word-1 downto 0);
        val_src2_in:in std_logic_vector(n_word-1 downto 0);
       
        wb_1_in:in std_logic_vector(0 downto 0);
        wb_2_in:in std_logic_vector(0 downto 0);
       
       
        wb_1_out:out std_logic_vector(0 downto 0);
        wb_2_out:out std_logic_vector(0 downto 0);
        src1_add_out:out regadr_t ;
        dst1_add_out:out regadr_t ;
        src2_add_out:out regadr_t ;
        dst2_add_out:out regadr_t ;
        val_dst1_out:out std_logic_vector(n_word-1 downto 0);
        val_src1_out:out std_logic_vector(n_word-1 downto 0);
        val_dst2_out:out std_logic_vector(n_word-1 downto 0);
        val_src2_out:out std_logic_vector(n_word-1 downto 0);
       
        pc_out:out std_logic_vector(2*n_word-1 downto 0);
        clk:in std_logic;
        rst: in std_logic;
        stall:in std_logic:='0';
        ld: in std_logic:='1'


    );
end Memory_stage;


Architecture Structural of Memory_stage is


signal ld_buff: std_logic;
signal val_dst1_temp:std_logic_vector(n_word-1 downto 0);
signal val_dst2_temp:std_logic_vector(n_word-1 downto 0);
signal address:std_logic_vector(n_word - 1 downto 0);
signal data_in : std_logic_vector(2*n_word - 1 downto 0);
signal data_out: std_logic_vector(n_word - 1 downto 0);
signal pc_out_temp:std_logic_vector(2*n_word - 1 downto 0);

begin
ld_buff<= ld or stall ;





data_ram:entity processor.Ram 
    generic map (n_word,n_word
       
    )
    port map(
        clk,
        memrw,
        address,
        data_in,
        data_out,
        pc_out_temp
   
    );


process(memrw,mem_inst_no,data_out,data_in,pc_out_temp)
begin
if(memrw="001") then
    if(mem_inst_no='0') then 
    address<=val_src1_in;
    val_dst1_temp<=data_out;
    val_dst2_temp<=val_dst2_in(n_word-1 downto 0);
    elsif(mem_inst_no='1') then
    address<=val_src2_in;
    val_dst2_temp<=data_out;
    val_dst1_temp<=val_dst1_in(n_word-1 downto 0);
    end if;

elsif (memrw="010") then 
    if(mem_inst_no='0') then 
    address<=val_src1_in;
    pc_out<=pc_out_temp;
    val_dst1_temp<=val_dst1_in(n_word-1 downto 0);
    val_dst2_temp<=val_dst1_in(n_word-1 downto 0);
    elsif(mem_inst_no='1') then
    address<=val_src2_in;
    pc_out<=pc_out_temp;
    val_dst1_temp<=val_dst1_in(n_word-1 downto 0);
    val_dst2_temp<=val_dst2_in(n_word-1 downto 0);
    end if;

elsif(memrw="011") then
    if(mem_inst_no='0') then 
    address<=val_src1_in;
    data_in<=val_dst1_in;
    elsif(mem_inst_no='1') then
    address<=val_src2_in;
    data_in<=val_dst2_in;
    end if;

elsif(memrw="100") then
    if(mem_inst_no='0') then 
    address<=val_src1_in;
    data_in<=val_dst1_in;
    elsif(mem_inst_no='1') then
    address<=val_src2_in;
    data_in<=val_dst2_in;
    end if;
else
val_dst1_temp<=val_dst1_in(n_word-1 downto 0);
val_dst1_temp<=val_dst1_in(n_word-1 downto 0);
    
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
        val_dst1_temp,
        val_src2_in,
        val_dst2_temp,
        
       
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
