
library work;
use work.utils.all;
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
        writeEnable : in std_logic;
        addressBus: in std_logic_vector(addressWidth-1 downto 0);
        inputBus : in std_logic_vector(dataWidth-1 downto 0);
        outputBus : out std_logic_vector(dataWidth-1 downto 0)
    );
end entity;

architecture RAMArch of RAM is
    type ramType is array(0 to 2**addressWidth) of std_logic_vector(dataWidth-1 downto 0);

    pure function to_string(s: ramType) return string is
        variable part : string(0 to dataWidth) := (others => NUL);
        variable rv : string(0 to s'length*(dataWidth+1)) := (others => NUL);
    begin
        for i in 0 to s'length-1 loop
            part := to_string(s(i)) & lf;
            for j in 0 to part'length-1 loop
                rv(i*(dataWidth+1)+j) := part(j);
            end loop;
        end loop;
        return lf & rv;
    end function;

    --Helper function, reads memory from a file
    impure function loadRamFromFile return ramType is
        constant zero : std_logic_vector(dataWidth-1 downto 0) := (others => '0');
        file ramfile : text open read_mode is defaultValueFile;
        variable textLine : line;
        variable textBitVector : bit_vector(dataWidth-1 downto 0);
        variable textRam : ramType;
        variable j : integer := 0;
    begin
        for i in ramType'range loop
            textRam(i) := zero;
        end loop;
        while not endfile(ramfile) loop
            readline(ramfile, textLine);
            read(textLine, textBitVector);
            textRam(j) := to_stdlogicvector(textBitVector);
            j := j + 1;
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
    --signal dataReg : std_logic_vector(dataWidth-1 downto 0) := (others => '0');
begin
    process(addressBus, writeEnable, inputBus) is
    begin
        --report to_string(physicalRam);
        if writeEnable = '1' then
            physicalRam(to_integer(unsigned(addressBus))) <= inputBus;
        else
            outputBus <= physicalRam(to_integer(unsigned(addressBus)));
        end if;            
    end process;
end architecture;
    
