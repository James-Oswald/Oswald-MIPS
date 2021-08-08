
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity registerFile is
    port(
        clock : in std_logic;
        regWrite : in std_logic;
        readRegister1 : in std_logic_vector(3 downto 0);
        readRegister2 : in std_logic_vector(3 downto 0);
        writeRegister : in std_logic_vector(3 downto 0);
        writeData : in std_logic_vector(31 downto 0);
        readData1 : out std_logic_vector(31 downto 0);
        readData2 : out std_logic_vector(31 downto 0)
    );
end entity;

architecture registerFileArch of registerFile is
    signal addressBus : std_logic_vector(3 downto 0) := (others => '0');
    signal inputBus : std_logic_vector(31 downto 0)  := (others => '0');
    signal outputBus : std_logic_vector(31 downto 0)  := (others => '0');
    signal writeEnable : std_logic := '0';
begin
    physicalRam : entity work.RAM(RAM_Arch) 
        generic map(
            defaultValueFile => "registerFileDump",
            dataWidth => 32,
            addressWidth => 4
        )
        port map(
            clock => clock,
            writeEnable => writeEnable,
            addressBus => addressBus,
            inputBus => inputBus,
            outputBus => outputBus
        );
    process(clock) is
    begin
        if rising_edge(clock) then
            addressBus <= readRegister1;
            readData1 <= outputBus;
            addressBus <= readRegister2;
            readData2 <= outputBus;
            if regWrite = '1' then
                writeEnable <= '1';
                addressBus <= writeRegister;
                inputBus <= writeData;
                writeEnable <= '0';
            end if;
        end if;
    end process;
end architecture;