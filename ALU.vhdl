
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.utils.all;

entity ALU is
    port(
        input1: in std_logic_vector(31 downto 0);
        input2: in std_logic_vector(31 downto 0);
        ALUControlSig: in std_logic_vector(2 downto 0);
        zero: out std_logic;
        ALUResult: buffer std_logic_vector(31 downto 0)
    );
end entity;

architecture behavioral of ALU is
    signal zeros : std_logic_vector(31 downto 0) := x"00000000";
    signal one : std_logic_vector(31 downto 0) := x"00000001";
begin
    process(input1, input2, ALUControlSig) is
    begin
        case ALUControlSig is
            when "000" => ALUResult <= input1 and input2;
            when "001" => ALUResult <= input1 or input2;
            when "010" => ALUResult <= std_logic_vector(signed(input1) + signed(input2));
            when "011" => ALUResult <= not (input1 or input2);
            when "100" => ALUResult <= input1 xor input2;
            when "101" => ALUResult <= zeros; --Supposed to be sign extension?
            when "110" => ALUResult <= std_logic_vector(signed(input1) - signed(input2));
            when "111" => 
                if input1 < input2 then
                    ALUResult <= zeros;
                else
                    ALUResult <= one;
                end if;
            when others => ALUResult <= zeros;
        end case;
    end process;
    zero <= to_stdlogic(unsigned(ALUResult)=0);
end architecture;