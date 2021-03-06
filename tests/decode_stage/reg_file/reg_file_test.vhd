library ieee;
library processor;
use processor.config.all;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RegFileTest is
end RegFileTest;

architecture Test of RegFileTest is
    constant period : time := 10 ps;
    signal clk : std_logic := '0';
    signal en : std_logic := '0';
    signal rst : std_logic := '0';
    signal pc_val : dword_t := (others => '1');

    signal src1_addr_read : regaddr_t;
    signal val_src1_out : dword_t;
    signal dst1_addr_read : regaddr_t;
    signal val_dst1_out : dword_t;
    signal src2_addr_read : regaddr_t;
    signal val_src2_out : dword_t;
    signal dst2_addr_read : regaddr_t;
    signal val_dst2_out : dword_t;
    -- write operation
    signal addr1_write : regaddr_t;
    signal ld1_write : std_logic;
    signal val1_write : dword_t;
    signal addr2_write : regaddr_t;
    signal ld2_write : std_logic;
    signal val2_write : dword_t;
    signal in_ld : std_logic;
    signal in_val : word_t ;
begin
    process is
    begin
        clk <= '1';
        wait for period / 2;
        clk <= '0';
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
        
        for i in 0 to 1 loop
            src1_addr_read <= std_logic_vector(to_unsigned(4*i, n_regaddr));
            dst1_addr_read <= std_logic_vector(to_unsigned(4*i + 1, n_regaddr));
            src2_addr_read <= std_logic_vector(to_unsigned(4*i + 2, n_regaddr));
            dst2_addr_read <= std_logic_vector(to_unsigned(4*i + 3, n_regaddr));
            wait for period;
            assert val_src1_out = std_logic_vector(to_unsigned(4*i, n_dword));
            assert val_dst1_out = std_logic_vector(to_unsigned(4*i + 1, n_dword));
            assert val_src2_out = std_logic_vector(to_unsigned(4*i + 2, n_dword));
            assert val_dst2_out = std_logic_vector(to_unsigned(4*i + 3, n_dword));
        end loop;
    end process;

    gen_regfile: entity processor.RegFile
    port map (
        pc_val => pc_val,
        -- read operation
        src1_addr_read => src1_addr_read,
        val_src1_out => val_src1_out,
        dst1_addr_read => dst1_addr_read,
        val_dst1_out => val_dst1_out,
        src2_addr_read => src2_addr_read,
        val_src2_out => val_src2_out,
        dst2_addr_read => dst2_addr_read,
        val_dst2_out => val_dst2_out,
        -- write operation
        addr1_write => addr1_write,
        ld1_write => ld1_write,
        val1_write => val1_write,
        addr2_write => addr2_write,
        ld2_write => ld2_write,
        val2_write => val2_write,
        clk => clk,
        rst => rst,
        in_ld => in_ld,
        in_val => in_val
    );
end Test;