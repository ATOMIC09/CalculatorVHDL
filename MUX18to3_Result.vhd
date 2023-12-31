LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY MUX18to3_Result IS
    GENERIC (N : INTEGER := 5);
    PORT (
        BCD_digit_1_A : IN STD_LOGIC_VECTOR(N - 2 DOWNTO 0);
        BCD_digit_2_A : IN STD_LOGIC_VECTOR(N - 2 DOWNTO 0);
        BCD_digit_3_A : IN STD_LOGIC_VECTOR(N - 2 DOWNTO 0);
        BCD_digit_1_B : IN STD_LOGIC_VECTOR(N - 2 DOWNTO 0);
        BCD_digit_2_B : IN STD_LOGIC_VECTOR(N - 2 DOWNTO 0);
        BCD_digit_3_B : IN STD_LOGIC_VECTOR(N - 2 DOWNTO 0);

        BCD_digit_1_ADD : IN STD_LOGIC_VECTOR(N - 2 DOWNTO 0);
        BCD_digit_2_ADD : IN STD_LOGIC_VECTOR(N - 2 DOWNTO 0);
        BCD_digit_3_ADD : IN STD_LOGIC_VECTOR(N - 2 DOWNTO 0);

        BCD_digit_1_SUB : IN STD_LOGIC_VECTOR(N - 2 DOWNTO 0);
        BCD_digit_2_SUB : IN STD_LOGIC_VECTOR(N - 2 DOWNTO 0);
        BCD_digit_3_SUB : IN STD_LOGIC_VECTOR(N - 2 DOWNTO 0);

        BCD_digit_1_MUL : IN STD_LOGIC_VECTOR(N - 2 DOWNTO 0);
        BCD_digit_2_MUL : IN STD_LOGIC_VECTOR(N - 2 DOWNTO 0);
        BCD_digit_3_MUL : IN STD_LOGIC_VECTOR(N - 2 DOWNTO 0);

        BCD_digit_1_DIV : IN STD_LOGIC_VECTOR(N - 2 DOWNTO 0);
        BCD_digit_2_DIV : IN STD_LOGIC_VECTOR(N - 2 DOWNTO 0);
        BCD_digit_3_DIV : IN STD_LOGIC_VECTOR(N - 2 DOWNTO 0);

        BCD_TO_SEGMENT_1 : OUT STD_LOGIC_VECTOR(N - 2 DOWNTO 0);
        BCD_TO_SEGMENT_2 : OUT STD_LOGIC_VECTOR(N - 2 DOWNTO 0);
        BCD_TO_SEGMENT_3 : OUT STD_LOGIC_VECTOR(N - 2 DOWNTO 0);

        DONE_LED_ADD : OUT STD_LOGIC;
        DONE_LED_SUB : OUT STD_LOGIC;

        control : IN STD_LOGIC_VECTOR;
        operate : IN STD_LOGIC_VECTOR;
        clk : IN STD_LOGIC
    );
END MUX18to3_Result;

ARCHITECTURE Behavioral OF MUX18to3_Result IS
    SIGNAL BCD_TO_SEGMENT_1_temp : STD_LOGIC_VECTOR(N - 2 DOWNTO 0);
    SIGNAL BCD_TO_SEGMENT_2_temp : STD_LOGIC_VECTOR(N - 2 DOWNTO 0);
    SIGNAL BCD_TO_SEGMENT_3_temp : STD_LOGIC_VECTOR(N - 2 DOWNTO 0);
    SIGNAL DONE_LED_ADD_temp : STD_LOGIC := '0';
    SIGNAL DONE_LED_SUB_temp : STD_LOGIC := '0';
BEGIN
    PROCESS (clk)
    BEGIN

        IF rising_edge(clk) THEN
            IF control = "00" THEN
                BCD_TO_SEGMENT_1_temp <= BCD_digit_1_A;
                BCD_TO_SEGMENT_2_temp <= BCD_digit_2_A;
                BCD_TO_SEGMENT_3_temp <= BCD_digit_3_A;
                DONE_LED_ADD_temp <= '0';
                DONE_LED_SUB_temp <= '0';
            ELSIF control = "01" THEN
                BCD_TO_SEGMENT_1_temp <= BCD_digit_1_B;
                BCD_TO_SEGMENT_2_temp <= BCD_digit_2_B;
                BCD_TO_SEGMENT_3_temp <= BCD_digit_3_B;
                DONE_LED_ADD_temp <= '0';
                DONE_LED_SUB_temp <= '0';
            ELSIF control = "10" THEN

                IF operate = "11" THEN
                    DONE_LED_ADD_temp <= '1';
                ELSIF operate = "10" THEN
                    DONE_LED_SUB_temp <= '1';
                END IF;

                IF operate = "00" THEN
                    BCD_TO_SEGMENT_1_temp <= BCD_digit_1_DIV;
                    BCD_TO_SEGMENT_2_temp <= BCD_digit_2_DIV;
                    BCD_TO_SEGMENT_3_temp <= BCD_digit_3_DIV;
                ELSIF operate = "01" THEN
                    BCD_TO_SEGMENT_1_temp <= BCD_digit_1_MUL;
                    BCD_TO_SEGMENT_2_temp <= BCD_digit_2_MUL;
                    BCD_TO_SEGMENT_3_temp <= BCD_digit_3_MUL;
                ELSIF operate = "10" THEN
                    BCD_TO_SEGMENT_1_temp <= BCD_digit_1_SUB;
                    BCD_TO_SEGMENT_2_temp <= BCD_digit_2_SUB;
                    BCD_TO_SEGMENT_3_temp <= BCD_digit_3_SUB;
                ELSIF operate = "11" THEN
                    BCD_TO_SEGMENT_1_temp <= BCD_digit_1_ADD;
                    BCD_TO_SEGMENT_2_temp <= BCD_digit_2_ADD;
                    BCD_TO_SEGMENT_3_temp <= BCD_digit_3_ADD;
                END IF;
            END IF;
        END IF;
    END PROCESS;

    BCD_TO_SEGMENT_1 <= BCD_TO_SEGMENT_1_temp;
    BCD_TO_SEGMENT_2 <= BCD_TO_SEGMENT_2_temp;
    BCD_TO_SEGMENT_3 <= BCD_TO_SEGMENT_3_temp;
    DONE_LED_ADD <= DONE_LED_ADD_temp;
    DONE_LED_SUB <= DONE_LED_SUB_temp;
END Behavioral;