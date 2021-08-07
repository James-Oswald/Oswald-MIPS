
entity OzMIPS is
end entity

architecture OzMIPS_Arch is
    signal 
    process(clk) is
        begin
            if rising_edge(clk) and writeEnable = '1' then
                ram(to_integer(unsigned(addressBus))) <= inputBus
                dataReg <= ram(to_integer(unsigned(addressBus)))
            end if;
            outputBus <= dataReg
        end process;