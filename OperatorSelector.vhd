library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity OperatorSelector is
    Port (
        clk, enable : in STD_LOGIC; -- `enable` will derived from the "DONE" signal
        operator_in : in STD_LOGIC_VECTOR(1 downto 0);
        enaop_adder, enaop_subtractor, enaop_multiplier, enaop_divider : out STD_LOGIC -- will be used to enable the adder, subtractor, multiplier and dividerr
    );
end OperatorSelector;

architecture Behavioral of OperatorSelector is
begin
    process (clk, enable, operator_in)
    begin
        if rising_edge(clk) and enable = '1' then
            case operator_in is
                when "00" =>  -- Division
                    enaop_divider <= '1';
                    enaop_subtractor <= '0';
                    enaop_multiplier <= '0';
                    enaop_adder <= '0';
                when "01" =>  -- Multiplication
                    enaop_divider <= '0';
                    enaop_subtractor <= '0';
                    enaop_multiplier <= '1';
                    enaop_adder <= '0';
                when "10" =>  -- Subtraction
                    enaop_divider <= '0';
                    enaop_subtractor <= '1';
                    enaop_multiplier <= '0';
                    enaop_adder <= '0';
                when "11" =>  -- Addition
                    enaop_divider <= '0';
                    enaop_subtractor <= '0';
                    enaop_multiplier <= '0';
                    enaop_adder <= '1';
            end case;
        end if;
end process;
end Behavioral;