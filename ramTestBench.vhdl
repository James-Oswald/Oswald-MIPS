library work;
use work.utils.all;
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
    signal writeEnable : std_logic := '0';
    signal addressBus: std_logic_vector(addressWidth-1 downto 0) := (others => '0');
    signal inputBus : std_logic_vector(dataWidth-1 downto 0) := (others => '0');
    signal outputBus : std_logic_vector(dataWidth-1 downto 0) := (others => '0');
begin
    ram : entity work.RAM(RAMArch) 
        generic map(
            defaultValueFile => "TestBenchMemoryDump",
            dataWidth => dataWidth,
            addressWidth => addressWidth)
        port map(
            clock => clock, addressBus => addressBus, writeEnable => writeEnable,
            inputBus => inputBus, outputBus => outputBus);
    clock <= not clock after 10 ns when not (finished='1');
    process(clock) is 
    begin
        if rising_edge(clock) then
            if unsigned(outputBus) = 0 and unsigned(addressBus) /= 0 then
                finished <= '1';
            else
                report integer'image(to_integer(unsigned(addressBus) - 1)) & ":" & to_string(outputBus);
                addressBus <= std_logic_vector(unsigned(addressBus) + 1);
            end if;
        end if;
    end process;
end architecture;