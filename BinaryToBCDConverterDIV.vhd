LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.STD_LOGIC_ARITH.ALL;

ENTITY BinaryToBCDConverterDIV IS
    GENERIC (
        N : INTEGER := 5
    );
    PORT (
        clk : IN STD_LOGIC;
        minus_q : IN STD_LOGIC;
        minus_r : IN STD_LOGIC;
        data_err : IN STD_LOGIC;
        data_q : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        data_r : IN STD_LOGIC_VECTOR(2 * N - 1 DOWNTO 0);
        BCD_digit_1 : OUT STD_LOGIC_VECTOR(N - 2 DOWNTO 0);
        BCD_digit_2 : OUT STD_LOGIC_VECTOR(N - 2 DOWNTO 0);
        BCD_digit_3 : OUT STD_LOGIC_VECTOR(N - 2 DOWNTO 0);
        BCD_digit_4 : OUT STD_LOGIC_VECTOR(N - 2 DOWNTO 0);
        BCD_digit_5 : OUT STD_LOGIC_VECTOR(N - 2 DOWNTO 0);
        BCD_digit_6 : OUT STD_LOGIC_VECTOR(N - 2 DOWNTO 0)
    );
END BinaryToBCDConverterDIV;

ARCHITECTURE Structural OF BinaryToBCDConverterDIV IS
    -- signal integer quotient
    SIGNAL signal_integer1 : INTEGER := 0;
    SIGNAL signal_integer2 : INTEGER := 0;
    -- signal integer remainder
    SIGNAL signal_integer3 : INTEGER := 0;
    SIGNAL signal_integer4 : INTEGER := 0;
BEGIN
    PROCESS (clk)
    BEGIN
        IF rising_edge(clk) THEN
            --IF (unsigned(data_q) > 11111) THEN -- ERR overflow
              --  BCD_digit_1 <= "1101"; -- R
               -- BCD_digit_2 <= "1101"; -- R
               -- BCD_digit_3 <= "1100"; -- E
               -- BCD_digit_4 <= "1101"; -- R
              --  BCD_digit_5 <= "1101"; -- R
              --  BCD_digit_6 <= "1100"; -- E
            -- ELSIF (unsigned(data_r) > 0001100011) THEN -- ERR overflow
              --  BCD_digit_1 <= "1101"; -- R
              --  BCD_digit_2 <= "1101"; -- R
              --  BCD_digit_3 <= "1100"; -- E
              --  BCD_digit_4 <= "1101"; -- R
              --  BCD_digit_5 <= "1101"; -- R
              --  BCD_digit_6 <= "1100"; -- E
            IF (data_err = '1') THEN -- ERR div by zero
                BCD_digit_1 <= "1101"; -- R
                BCD_digit_2 <= "1101"; -- R
                BCD_digit_3 <= "1100"; -- E
                BCD_digit_4 <= "0000"; -- 0
                BCD_digit_5 <= "0000"; -- 0
                BCD_digit_6 <= "0000"; -- 0
            ELSE -- normal mod and div operations
                signal_integer1 <= conv_integer(unsigned(data_q)) MOD 10;
                signal_integer2 <= (conv_integer(unsigned(data_q)) / 10) MOD 10;
                signal_integer3 <= conv_integer(unsigned(data_r)) MOD 10;
                signal_integer4 <= (conv_integer(unsigned(data_r)) / 10) MOD 10;

                BCD_digit_1 <= conv_std_logic_vector(signal_integer1, N - 1);
                BCD_digit_2 <= conv_std_logic_vector(signal_integer2, N - 1);
                BCD_digit_4 <= conv_std_logic_vector(signal_integer3, N - 1);
                BCD_digit_5 <= conv_std_logic_vector(signal_integer4, N - 1);

                IF (minus_q = '1') THEN
                    BCD_digit_3 <= "1011"; -- quotient minus
                ELSIF (minus_r = '1') THEN
                    BCD_digit_6 <= "1011"; -- remainder minus
                ELSE
                    BCD_digit_3 <= "1111";
                    BCD_digit_6 <= "1111";
                END IF;
            END IF;
        END IF;
    END PROCESS;
END Structural;
