
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity registerFile is
    port(
        clock 
        readRegister1 : in std_logic_vector(3 downto 0);
        readRegister2 : in std_logic_vector(3 downto 0);
        writeRegister : in std_logic_vector(3 downto 0);
        writeData : in std_logic_vector(31 downto 0);
        readData1 : out std_logic_vector(31 downto 0);
        readData2 : out std_logic_vector(31 downto 0)
    );
end entity;

architecture registerFile_Arch of registerFile is
    signal addressBus : in std_logic_vector(3 downto 0);
    ram : enity work.RAM(RAM_Arch) 
        generic map(
            defaultValueFile => "registerFileDump",
            dataWidth => 32,
            addressWidth => 4
        )
        port map(
            a
        )
begin
    process(clk) is
    begin
        if rising_edge(clk) and then
            ram(to_integer(unsigned(addressBus))) <= inputBus
            dataReg <= ram(to_integer(unsigned(addressBus)))
        end if;
        outputBus <= dataReg
    end process;

end architecture;