
library ieee;
use ieee.std_logic_1164.all;

entity control is
    port(
        opcode : in std_logic_vector(5 downto 0);
        regDest : out std_logic;
        jump : out std_logic;
        branch : out std_logic;
        memRead : out std_logic;
        memtoReg : out std_logic;
        ALUOp : out std_logic_vector(1 downto 0);
        memWrite : out std_logic;
        ALUSrc : out std_logic;
        regWrite : out std_logic
    );
end entity;

--Its way easier to code the logic gate implementation over the behavioral implementation
architecture logicGate of control is
    signal rformat : std_logic := '0';
    signal lw : std_logic := '0';
    signal sw : std_logic := '0';
    signal beq : std_logic := '0';
begin
    rformat <= not opcode(5) and not opcode(4) and not opcode(3) and not opcode(2) and not opcode(1) and not opcode(0);
    lw <= opcode(5) and not opcode(4) and not opcode(3) and not opcode(2) and opcode(1) and opcode(0);
    sw <= opcode(5) and not opcode(4) and opcode(3) and not opcode(2) and opcode(1) and opcode(0);
    beq <= not opcode(5) and not opcode(4) and not opcode(3) and opcode(2) and not opcode(1) and not opcode(0);
    regDest <= rformat;
    --This could be wrong, I found it on slide 54 of https://www.cis.upenn.edu/~milom/cis371-Spring09/lectures/02_singlecycle.pdf
    jump <= opcode(0); 
    branch <= beq;
    memRead <= lw;
    memtoReg <= lw;
    ALUOp(0) <= beq;
    ALUOp(1) <= rformat;
    memWrite <= sw;
    ALUSrc <= lw or sw;
    regWrite <= rformat or lw;
end architecture;