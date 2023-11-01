LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.STD_LOGIC_ARITH.ALL;

ENTITY BinaryToBCDConverterMUL IS
    GENERIC (
        N : INTEGER := 5
    );
    PORT (
        clk : IN STD_LOGIC;
        minus_con : IN STD_LOGIC;
        data : IN STD_LOGIC_VECTOR(2 * N - 1 DOWNTO 0);
        BCD_digit_1 : OUT STD_LOGIC_VECTOR(N - 2 DOWNTO 0);
        BCD_digit_2 : OUT STD_LOGIC_VECTOR(N - 2 DOWNTO 0);
        BCD_digit_3 : OUT STD_LOGIC_VECTOR(N - 2 DOWNTO 0)
    );
END BinaryToBCDConverterMUL;

ARCHITECTURE Structural OF BinaryToBCDConverterMUL IS
    SIGNAL signal_integer1 : INTEGER := 0;
    SIGNAL signal_integer2 : INTEGER := 0;
BEGIN
    PROCESS (clk)
    BEGIN
        IF rising_edge(clk) THEN
            IF (unsigned(data) > 0001100011) THEN -- if more than 99
                BCD_digit_1 <= "1101"; -- r
                BCD_digit_2 <= "1101"; -- r
                BCD_digit_3 <= "1100"; -- E
            ELSE
                signal_integer1 <= conv_integer(unsigned(data)) MOD 10;
                signal_integer2 <= (conv_integer(unsigned(data)) / 10) MOD 10;

                BCD_digit_1 <= conv_std_logic_vector(signal_integer1, N - 1);
                BCD_digit_2 <= conv_std_logic_vector(signal_integer2, N - 1);

                IF (minus_con = '1') THEN -- if MSB is 1
                    BCD_digit_3 <= "1011"; -- minus
                ELSE
                    BCD_digit_3 <= "1010"; -- none
                END IF;
            END IF;
        END IF;
    END PROCESS;
END Structural;