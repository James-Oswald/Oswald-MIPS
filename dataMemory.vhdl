
library ieee;
use ieee.std_logic_1164.all;

entity dataMemory is
    port(
        memWrite: in std_logic; 
        address: in std_logic_vector(31 downto 0);
        writeData: in std_logic_vector(31 downto 0);
        readData: out std_logic_vector(31 downto 0)
    );
end entity;

architecture dataMemoryArch of dataMemory is
begin
    physicalRam : entity work.RAM(RAMArch) 
        generic map(
            defaultValueFile => "memoryFiles/dataMemory",
            dataWidth => 32,
            addressWidth => 32
        )
        port map(
            inputBus => writeData,
            addressBus => address,
            outputBus => readData, 
            writeEnable => memWrite
        );
end architecture;