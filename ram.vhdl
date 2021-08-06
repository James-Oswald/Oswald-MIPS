
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity RAM 
    generic(
        defaultValueFile: string;
        dataWidth : integer := 8;
        addressWidth : integer := 32
    );
    port(
        clock, writeEnable : in std_logic;
        addressBus: in std_logic_vector(addressWidth downto 0)
        inputBus : in std_logic_vector(dataWidth-1 downto 0)
        outputBus : out std_logic_vector(dataWidth-1 downto 0)
    );
end entity;

architecture RAM_Arch of RAM is
    type ramType is array(0 to 2**addressWidth) of std_logic_vector(dataWidth-1 downto 0);

    --Helper function, reads memory from a file
    impure function loadRamFromFile() return ramType is
        file ramfile : text open read_mode is defaultValueFile
        variable textLine : line;
        variable textBitVector : bit_vector(dataWidth-1 downto 0);
        variable textRam : ramType;
        begin for i in ramType'range loop
            readline(ramfile, textLine);
            read(textBitVector, textLine);
            textRam(i) := to_stdlogicvector(textBitVector);
        end loop;
        return textRam;
    end function;
    
    --Helper function, writes memory into a file
    procedure writeRamToFile(values : ramType) is
        file ramfile : text open read_mode is defaultValueFile
        variable textLine : line;
        variable textBitVector : bit_vector(dataWidth-1 downto 0);
        variable textRam : ramType;
        begin for i in ramType'range loop
            readline(ramfile, textLine);
            textBitVector := to_bitvector(textRam(i));
            write(textLine, textBitVector);
            writeline(ramfile, textLine);
        end loop;
    end procedure;
    
    signal ram : ramType <= loadRamFromFile()
    signal dataReg : std_logic_vector(dataWidth-1 downto 0) <= 0
begin
    process(clk) is
    begin
        if rising_edge(clk) and writeEnable = '1' then
            ram(to_integer(unsigned(addressBus))) <= inputBus
            dataReg <= ram(to_integer(unsigned(addressBus)))
        end if;
        outputBus <= dataReg
    end process;
end architecture
    