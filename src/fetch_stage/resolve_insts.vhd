library ieee;
library processor;
use ieee.std_logic_1164.all;
use processor.config.all;

entity ResolveInsts is
	generic (n : integer := 32);
	port (
        inst1_in : in word_t;
        inst2_in : in word_t;
        stall : in std_logic;
        is_compatible : in std_logic;
        inst1_out : out word_t;
        inst2_out : out word_t
	);
end ResolveInsts;

architecture Structural of ResolveInsts is
begin
    -- Assumes op_nop = 0
    inst1_out <= (others => '0') when stall = '1' else inst1_in;
    inst2_out <= (others => '0') when stall = '1' or is_compatible = '0'
                else inst2_in;
end Structural;

