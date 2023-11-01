LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

ENTITY OperatorSelector IS
    PORT (
        clk, enable, resetop : IN STD_LOGIC; -- `enable` will derived from the "DONE" signal
        operator_in : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        enaop_adder, enaop_subtractor, enaop_multiplier, enaop_divider : OUT STD_LOGIC -- will be used to enable the adder, subtractor, multiplier and dividerr
    );
END OperatorSelector;

ARCHITECTURE Behavioral OF OperatorSelector IS
BEGIN
    PROCESS (clk, enable, resetop, operator_in)
    BEGIN
        IF rising_edge(clk) THEN
            IF resetop = '1' THEN
                enaop_divider <= '0';
                enaop_subtractor <= '0';
                enaop_multiplier <= '0';
                enaop_adder <= '0';
            ELSIF enable = '1' THEN
                CASE operator_in IS
                    WHEN "00" => -- Division
                        enaop_divider <= '1';
                        enaop_subtractor <= '0';
                        enaop_multiplier <= '0';
                        enaop_adder <= '0';
                    WHEN "01" => -- Multiplication
                        enaop_divider <= '0';
                        enaop_subtractor <= '0';
                        enaop_multiplier <= '1';
                        enaop_adder <= '0';
                    WHEN "10" => -- Subtraction
                        enaop_divider <= '0';
                        enaop_subtractor <= '1';
                        enaop_multiplier <= '0';
                        enaop_adder <= '0';
                    WHEN "11" => -- Addition
                        enaop_divider <= '0';
                        enaop_subtractor <= '0';
                        enaop_multiplier <= '0';
                        enaop_adder <= '1';
                END CASE;
            END IF;
        END IF;
    END PROCESS;
END Behavioral;