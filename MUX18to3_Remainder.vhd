LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY MUX18to3_Remainder IS
    GENERIC (N : INTEGER := 5);
    PORT (
        BCD_digit_4_S0 : IN STD_LOGIC_VECTOR(N - 2 DOWNTO 0); -- Preview B
        BCD_digit_5_S0 : IN STD_LOGIC_VECTOR(N - 2 DOWNTO 0);
        BCD_digit_6_S0 : IN STD_LOGIC_VECTOR(N - 2 DOWNTO 0);
        BCD_digit_4_S1 : IN STD_LOGIC_VECTOR(N - 2 DOWNTO 0); -- Preview Operator
        BCD_digit_5_S1 : IN STD_LOGIC_VECTOR(N - 2 DOWNTO 0);
        BCD_digit_6_S1 : IN STD_LOGIC_VECTOR(N - 2 DOWNTO 0);

        BCD_digit_4_ADD : IN STD_LOGIC_VECTOR(N - 2 DOWNTO 0);
        BCD_digit_5_ADD : IN STD_LOGIC_VECTOR(N - 2 DOWNTO 0);
        BCD_digit_6_ADD : IN STD_LOGIC_VECTOR(N - 2 DOWNTO 0);

        BCD_digit_4_SUB : IN STD_LOGIC_VECTOR(N - 2 DOWNTO 0);
        BCD_digit_5_SUB : IN STD_LOGIC_VECTOR(N - 2 DOWNTO 0);
        BCD_digit_6_SUB : IN STD_LOGIC_VECTOR(N - 2 DOWNTO 0);

        BCD_digit_4_MUL : IN STD_LOGIC_VECTOR(N - 2 DOWNTO 0);
        BCD_digit_5_MUL : IN STD_LOGIC_VECTOR(N - 2 DOWNTO 0);
        BCD_digit_6_MUL : IN STD_LOGIC_VECTOR(N - 2 DOWNTO 0);

        BCD_digit_4_DIV : IN STD_LOGIC_VECTOR(N - 2 DOWNTO 0);
        BCD_digit_5_DIV : IN STD_LOGIC_VECTOR(N - 2 DOWNTO 0);
        BCD_digit_6_DIV : IN STD_LOGIC_VECTOR(N - 2 DOWNTO 0);

        BCD_TO_SEGMENT_4 : OUT STD_LOGIC_VECTOR(N - 2 DOWNTO 0);
        BCD_TO_SEGMENT_5 : OUT STD_LOGIC_VECTOR(N - 2 DOWNTO 0);
        BCD_TO_SEGMENT_6 : OUT STD_LOGIC_VECTOR(N - 2 DOWNTO 0);

        control : IN STD_LOGIC_VECTOR;
        operate : IN STD_LOGIC_VECTOR;
        clk : IN STD_LOGIC
    );
END MUX18to3_Remainder;

ARCHITECTURE Behavioral OF MUX18to3_Remainder IS
    SIGNAL BCD_TO_SEGMENT_4_temp : STD_LOGIC_VECTOR(N - 2 DOWNTO 0);
    SIGNAL BCD_TO_SEGMENT_5_temp : STD_LOGIC_VECTOR(N - 2 DOWNTO 0);
    SIGNAL BCD_TO_SEGMENT_6_temp : STD_LOGIC_VECTOR(N - 2 DOWNTO 0);
BEGIN
    PROCESS (clk)
    BEGIN
        IF rising_edge(clk) THEN
            IF control = "00" THEN -- Choose Preview B
                BCD_TO_SEGMENT_4_temp <= BCD_digit_4_S0;
                BCD_TO_SEGMENT_5_temp <= BCD_digit_5_S0;
                BCD_TO_SEGMENT_6_temp <= BCD_digit_6_S0;
            ELSIF control = "01" THEN -- Choose Preview Operator
                BCD_TO_SEGMENT_4_temp <= BCD_digit_4_S1;
                BCD_TO_SEGMENT_5_temp <= BCD_digit_5_S1;
                BCD_TO_SEGMENT_6_temp <= BCD_digit_6_S1;
            ELSIF control = "10" THEN -- Choose Remainder
                IF operate = "00" THEN
                    BCD_TO_SEGMENT_4_temp <= BCD_digit_4_DIV;
                    BCD_TO_SEGMENT_5_temp <= BCD_digit_5_DIV;
                    BCD_TO_SEGMENT_6_temp <= BCD_digit_6_DIV;
                ELSIF operate = "01" THEN
                    BCD_TO_SEGMENT_4_temp <= BCD_digit_4_MUL;
                    BCD_TO_SEGMENT_5_temp <= BCD_digit_5_MUL;
                    BCD_TO_SEGMENT_6_temp <= BCD_digit_6_MUL;
                ELSIF operate = "10" THEN
                    BCD_TO_SEGMENT_4_temp <= BCD_digit_4_SUB;
                    BCD_TO_SEGMENT_5_temp <= BCD_digit_5_SUB;
                    BCD_TO_SEGMENT_6_temp <= BCD_digit_6_SUB;
                ELSIF operate = "11" THEN
                    BCD_TO_SEGMENT_4_temp <= BCD_digit_4_ADD;
                    BCD_TO_SEGMENT_5_temp <= BCD_digit_5_ADD;
                    BCD_TO_SEGMENT_6_temp <= BCD_digit_6_ADD;
                END IF;
            END IF;
        END IF;
    END PROCESS;

    BCD_TO_SEGMENT_4 <= BCD_TO_SEGMENT_4_temp;
    BCD_TO_SEGMENT_5 <= BCD_TO_SEGMENT_5_temp;
    BCD_TO_SEGMENT_6 <= BCD_TO_SEGMENT_6_temp;
END Behavioral;