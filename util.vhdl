
library ieee;
use ieee.std_logic_1164.all;

package utils is
    function to_string(a: std_logic_vector) return string;
    function to_string(a: std_logic) return string;
end package;

package body utils is
    pure function to_string(a: std_logic_vector) return string is
        variable b : string (0 to a'length-1) := (others => NUL);
    begin
        for i in 0 to a'length-1 loop
            b(i) := std_logic'image(a(a'length-i-1))(2);
        end loop;
        return b;
    end function;

    pure function to_string(a: std_logic) return string is
    begin
        return std_logic'image(a);
    end function;

end package body;

