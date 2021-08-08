entity control is
    port(
        instruction : in std_logic_vector(5 to 0);
        regDest : out std_logic;
        jump : out std_logic;
        branch : out std_logic;
        memRead : out std_logic;
        memtoReg : out std_logic;
        ALUOp : out std_logic_vector(1 to 0);
        memWrite : out std_logic;
        ALUSrc : out std_logic;
        regWrite : out std_logic;
    )
end entity;

--Its way easier to code the logic gate implementation over the behavioral implementation
architecture logicGate of control is
    signal rformat : std_logic := '0'
    signal lw : std_logic := '0'
    signal sw : std_logic := '0'
    signal beq : std_logic := '0'
begin:
    rformat <= not instruction(5) and not instruction(4) and not instruction(3) and not instruction(2) and not instruction(1) and not instruction(0);
    lw <= instruction(5) and not instruction(4) and not instruction(3) and not instruction(2) and instruction(1) and instruction(0);
    sw <= instruction(5) and not instruction(4) and instruction(3) and not instruction(2) and instruction(1) and instruction(0);
    beq <= not instruction(5) and not instruction(4) and not instruction(3) and instruction(2) and not instruction(1) and not instruction(0);
    regDest <= rformat;
    --This could be wrong, I found it on slide 54 of https://www.cis.upenn.edu/~milom/cis371-Spring09/lectures/02_singlecycle.pdf
    jump <= instruction(0); 
    branch <= beq;
    memRead <= lw;
    memtoReg <= lw;
    ALUOp(0) := beq;
    ALUOp(1) := rformat;
    memWrite <= sw;
    ALUSrc <= lw or sw;
    regWrite <= rformat or lw;
end architecture