library ieee;
library processor;
use processor.config.all;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity DecodestageTest is
end DecodestageTest;

architecture Test of DecodestageTest is
    constant period : time := 10 ps;
    signal clk : std_logic := '0';
    signal stall : std_logic := '0';
    signal rst : std_logic := '0';
    signal ld : std_logic:='1';


    signal instr1:dword_t;
    signal instr2:dword_t;

    signal src1_addr_out : regaddr_t;
    signal val_src1_out : dword_t;
    signal dst1_addr_out : regaddr_t;
    signal val_dst1_out : dword_t;
    signal src2_addr_out: regaddr_t;
    signal val_src2_out : dword_t;
    signal dst2_addr_out : regaddr_t;
    signal val_dst2_out : dword_t;
    signal pc_val:dword_t;
    -- write operation
    signal addr1_write : regaddr_t;
    signal ld1_write : std_logic;
    signal val1_write : dword_t;
    signal addr2_write : regaddr_t;
    signal ld2_write : std_logic;
    signal val2_write : dword_t;
    --decode stage
    signal alu_op1_out :  alufun_t;
    signal update_flag_out1 : std_logic;
    signal alu_op2_out :  alufun_t;
    signal update_flag_out2 :  std_logic;
    signal is_branch1_out :  std_logic;
    signal is_branch2_out :  std_logic;
    signal immd1_out :  shiftamount_t;
    signal immd2_out :  shiftamount_t;
    signal mem_fun_out :  memfun_t;
    signal mem_inst_no_out : std_logic;
    signal wb_1_out :  std_logic;
    signal wb_2_out :  std_logic;

begin
    process is
    begin
        clk <= '0';
        wait for period / 2;
        clk <= '1';
        wait for period / 2;
    end process;

    process is
    begin
        rst <= '1';
        wait for period;
        rst <= '0';

        -- write registers
        ld1_write <= '1';
        ld2_write <= '1';
        for i in 0 to 3 loop
            addr1_write <= std_logic_vector(to_unsigned(2*i, n_regaddr));
            addr2_write <= std_logic_vector(to_unsigned(2*i + 1, n_regaddr));
            val1_write <= std_logic_vector(to_unsigned(2*i, n_dword));
            val2_write <= std_logic_vector(to_unsigned(2*i + 1, n_dword));
            wait for period;
        end loop;
        ld2_write <= '0';
        addr1_write <= spregaddr;
        val1_write <= (31 => '1', others => '0');
        wait for period;
        ld1_write <= '0';

        --decode stage
        assert alu_op1_out =  "1011";
        assert update_flag_out1 = '0';
        assert alu_op2_out = "1011";
        assert update_flag_out2 =  '0';
        assert is_branch1_out =  '0';
        assert is_branch2_out =  '0';
        assert immd1_out =  "000";
        assert immd2_out =  "000";
        assert mem_fun_out =  "000";
        assert mem_inst_no_out = '0'';
        assert wb_1_out =  '1';
        assert wb_2_out =  '1'';
        
        
        assert val_src1_out = std_logic_vector(to_unsigned(2, n_dword));
        assert val_dst1_out = std_logic_vector(to_unsigned(1 , n_dword));
        assert val_src2_out = std_logic_vector(to_unsigned(4, n_dword));
        assert val_dst2_out = std_logic_vector(to_unsigned(3, n_dword));
        
    end process;

    gen_regfile: entity DecodeStage is
        port (
            -- IF/ID buffer
            inst1,
            inst2 ,
            pc_val ,
            -- Operands data
            src1_addr_out ,
            dst1_addr_out ,
            val_dst1_out ,
            src2_addr_out ,
            val_src2_out ,
            dst2_addr_out ,
            val_dst2_out ,
            -- Execute stage control
            alu_op1_out,
            update_flag_out1,
            alu_op2_out ,
            update_flag_out2,
            is_branch1_out ,
            is_branch2_out ,
            immd1_out ,
            immd2_out ,
            -- Memory stage control
            mem_fun_out ,
            mem_inst_no_out,
            -- Writeback stage control
            wb_1_out ,
            wb_2_out ,
            --regfile interface
            addr1_write ,
            ld1_write ,
            val1_write ,
            addr2_write ,
            ld2_write ,
            val2_write ,
            --General 
            clk ,
            rst ,
            stall ,
            ld ,
        );
end Test;