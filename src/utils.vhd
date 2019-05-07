-- The answer from Jonathan Bromley to the toopic "std_logic_vector to string in hex format"
-- asked by Mad I.D. helped to write the functions below.
-- https://groups.google.com/forum/#!topic/comp.lang.vhdl/1RiLjbgoPy0

library ieee;
use ieee.std_logic_1164.all;

package util_str is

function bin (lvec: in std_logic_vector) return string;
function hex (lvec: in std_logic_vector) return string;

end package;


package body util_str is

    function bin (lvec: in std_logic_vector) return string is
        variable text: string(lvec'length-1 downto 0) := (others => '9');
    begin
        for k in lvec'range loop
            case lvec(k) is
                when '0' => text(k) := '0';
                when '1' => text(k) := '1';
                when 'U' => text(k) := 'U';
                when 'X' => text(k) := 'X';
                when 'Z' => text(k) := 'Z';
                when '-' => text(k) := '-';
                when others => text(k) := '?';
            end case;
        end loop;
        return text;
    end function;

    function hex (lvec: in std_logic_vector) return string is
        variable text: string(lvec'length / 4 - 1 downto 0) := (others => '9');
        subtype halfbyte is std_logic_vector(4-1 downto 0);
    begin
        assert lvec'length mod 4 = 0
            report "hex() works only with vectors whose length is a multiple of 4"
            severity FAILURE;
        for k in text'range loop
            case halfbyte'(lvec(4 * k + 3 downto 4 * k)) is
                when "0000" => text(k) := '0';
                when "0001" => text(k) := '1';
                when "0010" => text(k) := '2';
                when "0011" => text(k) := '3';
                when "0100" => text(k) := '4';
                when "0101" => text(k) := '5';
                when "0110" => text(k) := '6';
                when "0111" => text(k) := '7';
                when "1000" => text(k) := '8';
                when "1001" => text(k) := '9';
                when "1010" => text(k) := 'A';
                when "1011" => text(k) := 'B';
                when "1100" => text(k) := 'C';
                when "1101" => text(k) := 'D';
                when "1110" => text(k) := 'E';
                when "1111" => text(k) := 'F';
                when others => text(k) := '!';
            end case;
        end loop;
        return text;
    end function;

end package body;


library ieee;

use ieee.std_logic_1164.all;
use work.util_str.all;

entity util_str_tb is
end entity;

architecture util_str_tb_arch of util_str_tb is
begin
    process is
        variable byte: std_logic_vector(12-1 downto 0) := "000001001111";
    begin
        report "bin " & bin(byte);
        report "hex " & hex(byte);
        wait;
    end process;
end architecture;