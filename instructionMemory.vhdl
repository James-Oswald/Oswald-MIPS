
library ieee;
use ieee.std_logic_1164.all;

entity instructionMemory is
    port(
        readAddress: in std_logic_vector(31 downto 0);
        instruction: out std_logic_vector(31 downto 0)
    );
end entity;

architecture instructionMemoryArch of instructionMemory is
    signal groundedBus : std_logic_vector(31 downto 0) := (others => '0');
    signal groundedWriteEnable : std_logic := '0';
begin
    physicalRam : entity work.RAM(RAMArch) 
        generic map(
            defaultValueFile => "memoryFiles/instructionMemory",
            dataWidth => 32,
            addressWidth => 32
        )
        port map(
            addressBus => readAddress,
            outputBus => instruction, 
            writeEnable => groundedWriteEnable,
            inputBus => groundedBus
        );
end architecture;