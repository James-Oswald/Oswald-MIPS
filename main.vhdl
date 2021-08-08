

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.utils.all;

entity OzMIPS is
end entity;

architecture OzMIPSArch of OzMIPS is
    signal clock: std_logic := '0';
    signal pc : unsigned(31 downto 0) := "00000000000000000000000000000000";
    signal instruction: std_logic_vector(31 downto 0) := (others=>'0');
    signal regDest, jump, branch, memRead, memtoReg, memWrite, ALUSrc, regWrite: std_logic := '0';
    signal ALUOp : std_logic_vector(1 downto 0) := (others=>'0');
    signal ALUControlSig : std_logic_vector(2 downto 0) := (others=>'0');
    signal writeRegister : std_logic_vector(4 downto 0) := (others=>'0');
    signal writeData : std_logic_vector(31 downto 0) := (others=>'0');
    signal registerData1 : std_logic_vector(31 downto 0) := (others=>'0');
    signal registerData2 : std_logic_vector(31 downto 0) := (others=>'0');
    signal signExtentedImm : std_logic_vector(31 downto 0) := (others=>'0');
    signal ALUInput2 : std_logic_vector(31 downto 0) := (others=>'0');
    signal ALUOutput : std_logic_vector(31 downto 0) := (others=>'0');
    signal ALUZero : std_logic := '0';
    signal dataOut : std_logic_vector(31 downto 0) := (others=>'0');
    signal nextPC : unsigned(31 downto 0) := (others=>'0');
begin
    clock <= not clock after 1 sec;
    instructionMemoryUnit : entity work.instructionMemory(instructionMemoryArch)
        port map(
            std_logic_vector(pc), instruction
        );
    controlUnit : entity work.control(logicGate)
        port map(
            instruction(31 downto 26),
            regDest, jump, branch, memRead, memtoReg, ALUOp, memWrite, ALUSrc, regWrite
        );
    ALUControlUnit : entity work.ALUControl(logicGate)
        port map(
            instruction(5 downto 0),
            ALUOp, ALUControlSig
        );
    --This functions as the multiplexer on the writeRegister input
    process(instruction, regDest) is 
    begin
        if regDest /= '1' then
            writeRegister <= instruction(20 downto 16);
        else
            writeRegister <= instruction(15 downto 11);
        end if;
    end process;
    registerFileUnit : entity work.registerFile(registerFileArch)
        port map(
            regWrite, 
            instruction(25 downto 21),
            instruction(20 downto 16),
            writeRegister, writeData, registerData1, registerData2
        );
    --Sign extender for ALU input 
    signExtentedImm <= std_logic_vector(resize(signed(instruction(15 downto 0)), 32));
    process(signExtentedImm, registerData2, ALUSrc) is 
    begin
        if ALUSrc /= '1' then
            ALUInput2 <= registerData2;
        else
            ALUInput2 <= signExtentedImm;
        end if;
    end process;
    ALUUnit : entity work.ALU(behavioral)
        port map(
            registerData1, ALUInput2, ALUControlSig,
            ALUZero, ALUOutput
        );
    --memread is kind of useless?
    dataMemoryUnit : entity work.dataMemory(dataMemoryArch)
        port map(
            memWrite, ALUOutput, registerData2, dataOut
        );
    
    process(dataOut, memtoReg, ALUOutput) is 
    begin
        if memtoReg='1' then
            writeData <= dataOut;
        else
            writeData <= ALUOutput;
        end if;
    end process;

    --Jump Logic
    process(pc, instruction, signExtentedImm, branch, ALUZero, jump) is 
        variable pcp : unsigned(31 downto 0) := pc + 1;
    begin
        if jump='1' then
            nextPC <= unsigned(pcp(31 downto 28)) & (unsigned(instruction(25 downto 0)) sll 2);
        else
            if not (branch='1' and ALUZero ='1') then
                nextPC <= pcp;
            else
                nextPC <= (unsigned(signExtentedImm) sll 2) + pcp;
            end if;
        end if;
    end process;

    process(clock) is
    begin
        if rising_edge(clock)then
            pc <= nextPC;
        end if;
    end process;
end architecture;