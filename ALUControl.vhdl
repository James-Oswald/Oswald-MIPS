
library ieee;
use ieee.std_logic_1164.all;

entity ALUControl is
    port(
        func : in std_logic_vector(5 downto 0);
        ALUOp : in std_logic_vector(1 downto 0);
        ALUControlSig : out std_logic_vector(2 downto 0)
    );
end entity;

--This is based off the MARS ALU control diagram
architecture logicGate of ALUControl is
begin
    ALUControlSig(0) <= ALUOp(1) and (func(0) or func(3));
    ALUControlSig(1) <= not ALUOp(1) or not func(2);
    ALUControlSig(2) <= (ALUOp(1) and func(1)) or ALUOp(0);
end architecture;