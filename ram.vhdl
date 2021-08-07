
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library std;
use std.textio.all;

entity RAM is
    generic(
        defaultValueFile: string;
        dataWidth : integer := 8;
        addressWidth : integer := 32
    );
    port(
        clock, writeEnable : in std_logic;
        addressBus: in std_logic_vector(addressWidth-1 downto 0);
        inputBus : in std_logic_vector(dataWidth-1 downto 0);
        outputBus : out std_logic_vector(dataWidth-1 downto 0)
    );
end entity;

architecture RAMArch of RAM is
    type ramType is array(0 to 2**addressWidth) of std_logic_vector(dataWidth-1 downto 0);

    --Helper function, reads memory from a file
    impure function loadRamFromFile return ramType is
        file ramfile : text open read_mode is defaultValueFile;
        variable textLine : line;
        variable textBitVector : bit_vector(dataWidth-1 downto 0);
        variable textRam : ramType;
    begin
        for i in ramType'range loop
            readline(ramfile, textLine);
            read(textLine, textBitVector);
            textRam(i) := to_stdlogicvector(textBitVector);
        end loop;
        return textRam;
    end function;
    
    --Helper function, writes memory into a file
    procedure writeRamToFile(values : ramType) is
        file ramfile : text open read_mode is defaultValueFile;
        variable textLine : line;
        variable textBitVector : bit_vector(dataWidth-1 downto 0);
        variable textRam : ramType;
    begin 
        for i in ramType'range loop
            readline(ramfile, textLine);
            textBitVector := to_bitvector(textRam(i));
            write(textLine, textBitVector);
            writeline(ramfile, textLine);
        end loop;
    end procedure;
    
    signal physicalRam : ramType := loadRamFromFile;
    signal dataReg : std_logic_vector(dataWidth-1 downto 0) := (others => '0');
begin
    process(clock) is
    begin
        if rising_edge(clock) and writeEnable = '1' then
            physicalRam(to_integer(unsigned(addressBus))) <= inputBus;
            dataReg <= physicalRam(to_integer(unsigned(addressBus)));
        end if;
        outputBus <= dataReg;
    end process;
end architecture;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library std;
use std.textio.all;

entity RAMTestBench is
end entity;

architecture RAMTestBenchArch of RAMTestBench is
    constant dataWidth : integer := 8;
    constant addressWidth :integer := 4;
    signal finished : std_logic := '0';
    signal clock : std_logic := '0';
    signal writeEnable : std_logic := '1';
    signal addressBus: std_logic_vector(addressWidth-1 downto 0) := (others => '0');
    signal inputBus : std_logic_vector(dataWidth-1 downto 0);
    signal outputBus : std_logic_vector(dataWidth-1 downto 0);
begin
    ram : entity work.RAM(RAMArch) 
        generic map(
            defaultValueFile => "TestBenchMemoryDump",
            dataWidth => dataWidth,
            addressWidth => addressWidth
        )
        port map(
            clock => clock, addressBus => addressBus, writeEnable => writeEnable,
            inputBus => inputBus, outputBus => outputBus
        );
    clock <= not clock after 10 ns when (finished='1');
    process(clock) is 
    begin
        if unsigned(outputBus) /= 0 then 
            report integer'image(to_integer(unsigned(addressBus))) & "\n";
            addressBus <= std_logic_vector(unsigned(addressBus) + 1);
        else
            finished <= '1';
        end if; 
    end process;
end architecture;
    
