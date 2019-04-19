library ieee;
library processor;
use processor.config.all;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALUWithFlagsTest is
end ALUWithFlagsTest;

architecture Test of ALUWithFlagsTest is
    signal a : word_t := (others => '0');
    signal b : word_t := (others => '0');
    signal fun1 : alufun_t := alu_first_op;
    signal update_flag1 : std_logic;
    signal c : word_t := (others => '0');
    signal d : word_t := (others => '0');
    signal fun2 : alufun_t := alu_first_op;
    signal update_flag2 : std_logic;
    signal clk : std_logic;
    signal reset : std_logic := '0';
    signal s1 : word_t := (others => '0');
    signal s2 : word_t := (others => '0');
    signal z_flag : std_logic;
    signal n_flag : std_logic;
    signal c_flag : std_logic;
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
        a <= std_logic_vector(to_unsigned(4, n_word));
        b <= std_logic_vector(to_unsigned(6, n_word));
        fun1 <= alu_add;
        
        c <= std_logic_vector(to_unsigned(5, n_word));
        d <= std_logic_vector(to_unsigned(8, n_word));
        fun2 <= alu_sub;
    
        update_flag1 <= '1';
        update_flag2 <= '1';
        wait for period;

        assert s1 = std_logic_vector(to_unsigned(10, n_word));
        assert s2 = std_logic_vector(to_signed(-3, n_word));
        assert z_flag = '0';
        assert n_flag = '1';
        assert c_flag = '0';

        a <= "1010111001111000";
        b <= "0100101001101010";
        fun1 <= alu_and;
        
        c <= "1011111001111001";
        d <= "0100101001101010";
        fun2 <= alu_or;
    
        update_flag1 <= '0';
        update_flag2 <= '1';
        wait for period;

        assert s1 = (a and b);
        assert s2 = (c or d);
        assert z_flag = '0';
        assert n_flag = '1';
        assert c_flag = '0';

        a <= std_logic_vector(to_unsigned(10, n_word));
        fun1 <= alu_inc;
        
        c <= std_logic_vector(to_unsigned(1, n_word));
        fun2 <= alu_dec;
    
        update_flag1 <= '1';
        update_flag2 <= '1';
        wait for period;

        assert s1 = std_logic_vector(to_unsigned(11, n_word));
        assert s2 = std_logic_vector(to_unsigned(0, n_word));
        assert z_flag = '1';
        assert n_flag = '0';
        assert c_flag = '0';
        
        a <= "1111111111111111";
        fun1 <= alu_inc;
        
        c <= "0000000000000000";
        fun2 <= alu_dec;
    
        update_flag1 <= '1';
        update_flag2 <= '0';
        wait for period;

        assert s1 = "0000000000000000";
        assert s2 = "1111111111111111";
        assert z_flag = '1';
        assert n_flag = '0';
        assert c_flag = '1';

        a <= "0000101110000000";
        b <= std_logic_vector(to_unsigned(5, n_word));
        fun1 <= alu_shl;
        
        c <= "0000000100111111";
        d <= std_logic_vector(to_unsigned(6, n_word));
        fun2 <= alu_shr;
    
        update_flag1 <= '1';
        update_flag2 <= '0';
        wait for period;

        assert s1 = "0111000000000000";
        assert s2 = "0000000000000100";
        assert z_flag = '0';
        assert n_flag = '0';
        assert c_flag = '1';
    end process;

    alu_gen: entity processor.ALUWithFlags
        port map(
            a,
            b,
            fun1,
            update_flag1,
            c,
            d,
            fun2,
            update_flag2,
            clk,
            reset,
            s1,
            s2,
            z_flag,
            n_flag,
            c_flag
        );
    
end Test;