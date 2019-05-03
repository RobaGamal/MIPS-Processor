library ieee;
library processor;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use processor.config.all;

entity ALUWithFlags is
	port(
		a : in dword_t := (others => '0');
        b : in dword_t := (others => '0');
        shift1: in shiftamount_t;
        shift2: in shiftamount_t;
        fun1 : in alufun_t := alu_first_op;
        update_flag1 : in std_logic := '0';
        c : in dword_t := (others => '0');
		d : in dword_t := (others => '0');
		fun2 : in alufun_t := alu_first_op;
        update_flag2 : in std_logic := '0';
        clk : in std_logic := '0';
        reset : in std_logic := '0';
        s1 : out dword_t := (others => '0');
        s2 : out dword_t := (others => '0');
        z_flag : out std_logic;
		n_flag : out std_logic;
		c_flag : out std_logic
	);
end ALUWithFlags;

architecture Structural of ALUWithFlags is
signal z_flag1_tmp : std_logic;
signal n_flag1_tmp : std_logic;
signal c_flag1_tmp : std_logic;

signal z_flag2_tmp : std_logic;
signal n_flag2_tmp : std_logic;
signal c_flag2_tmp : std_logic;

signal z_flag1 : std_logic;
signal n_flag1 : std_logic;
signal c_flag1 : std_logic;

signal z_flag2 : std_logic;
signal n_flag2 : std_logic;
signal c_flag2 : std_logic;

signal z_flag_tmp : std_logic;
signal n_flag_tmp : std_logic;
signal c_flag_tmp : std_logic;
signal flag_d : std_logic_vector(2 downto 0);
signal flag_q : std_logic_vector(2 downto 0);
signal flag_ld : std_logic;

constant z_flag_idx : integer := 0;
constant c_flag_idx : integer := 1;
constant n_flag_idx : integer := 2;
begin
    alu1 : entity processor.ALU 
        port map(
            a, b,shift1, fun1, s1,
            z_flag1_tmp, n_flag1_tmp, c_flag1_tmp 
        );
    alu2 : entity processor.ALU 
        port map(
            c, d,shift2, fun2, s2,
            z_flag2_tmp, n_flag2_tmp, c_flag2_tmp 
        );
      
    flag_reg : entity processor.Reg
        generic map(3)
        port map(
            flag_d,
            flag_q,
            clk,
            flag_ld,
            reset
        );

    z_flag1 <= flag_q(z_flag_idx) when fun1 = alu_clearc or fun1 = alu_setc else
                z_flag1_tmp;
    n_flag1 <= flag_q(n_flag_idx) when fun1 = alu_clearc or fun1 = alu_setc else
                n_flag1_tmp;
    c_flag1 <= '1' when fun1 = alu_setc else
                '0' when fun1 = alu_clearc else
                c_flag1_tmp;

    z_flag2 <= flag_q(z_flag_idx) when fun2 = alu_clearc or fun2 = alu_setc else
                z_flag2_tmp;
    n_flag2 <= flag_q(n_flag_idx) when fun2 = alu_clearc or fun2 = alu_setc else
                n_flag2_tmp;
    c_flag2 <= '1' when fun2 = alu_setc else
                '0' when fun2 = alu_clearc else
                c_flag2_tmp;

    flag_ld <= update_flag1 or update_flag2;

    flag_d(z_flag_idx) <= z_flag2 when update_flag2 = '1' else z_flag1;
    flag_d(n_flag_idx) <= n_flag2 when update_flag2 = '1' else n_flag1;
    flag_d(c_flag_idx) <= c_flag2 when update_flag2 = '1' else c_flag1; 
    z_flag <= flag_q(z_flag_idx);
    n_flag <= flag_q(n_flag_idx);
    c_flag <= flag_q(c_flag_idx);
end Structural;
