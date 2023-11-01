LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY BinaryToBCDConverterPreviewOperator IS
    PORT (
        clk : IN STD_LOGIC;
        data : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        BCD_All_digit : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
    );
END BinaryToBCDConverterPreviewOperator;

ARCHITECTURE Structural OF BinaryToBCDConverterPreviewOperator IS
    SIGNAL signal_integer : INTEGER := 0;
BEGIN
    PROCESS (clk)
    BEGIN
        IF rising_edge(clk) THEN
            BCD_All_digit <= "00" & data;
        END IF;
    END PROCESS;
END Structural;