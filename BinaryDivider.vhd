LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE IEEE.std_logic_unsigned.ALL;

ENTITY BinaryDivider IS
    GENERIC (N : INTEGER := 5);
    PORT (
        clk : IN STD_LOGIC;
        enable : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        Divident, Divisor : IN STD_LOGIC_VECTOR (N - 1 DOWNTO 0) := (OTHERS => '0');
        Quotient : OUT STD_LOGIC_VECTOR (N - 1 DOWNTO 0) := (OTHERS => '0');
        Remainder : OUT STD_LOGIC_VECTOR (2 * N - 1 DOWNTO 0) := (OTHERS => '0');
        MINUS_QUOTIENT : OUT STD_LOGIC;
        MINUS_REMAINDER : OUT STD_LOGIC;
        ERR : OUT STD_LOGIC;
        DONE : OUT STD_LOGIC := '0');
END BinaryDivider;

ARCHITECTURE Behavioral OF BinaryDivider IS
    TYPE state_type IS (s0, s1, s2);
    SIGNAL state : state_type := s0;
    SIGNAL s_start : STD_LOGIC := '1';
    SIGNAL normalised_data_Dividend : STD_LOGIC_VECTOR (N - 1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL normalised_data_Divisor : STD_LOGIC_VECTOR (N - 1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL data_Divisor : STD_LOGIC_VECTOR (2 * N - 1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL data_Quotient : STD_LOGIC_VECTOR (N - 1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL data_Remainder : STD_LOGIC_VECTOR (2 * N - 1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL counter : INTEGER := 0;
BEGIN

    PROCESS (clk, reset, enable)
    BEGIN
        IF Divisor = "00000" THEN
            ERR <= '1';
        ELSE
            ERR <= '0';
            IF reset = '1' THEN
                -- toggle reset
                state <= s0;
                s_start <= '1';
                counter <= 0;
                DONE <= '0';
                Quotient <= (OTHERS => '0');
                Remainder <= (OTHERS => '0');
                data_Divisor <= (OTHERS => '0');
                data_Quotient <= (OTHERS => '0');
                data_Remainder <= (OTHERS => '0');
            ELSIF rising_edge(clk) THEN

                -- detect a sign bit. if it's 1, do 2 compliment.
                IF Divident(N - 1) = '1' THEN
                    normalised_data_Dividend <= NOT Divident + 1;
                END IF;
                IF Divisor(N - 1) = '1' THEN
                    normalised_data_Divisor <= NOT Divisor + 1;
                END IF;
                IF Divident(N - 1) = '0' THEN
                    normalised_data_Dividend <= Divident;
                END IF;
                IF Divisor(N - 1) = '0' THEN
                    normalised_data_Divisor <= Divisor;
                END IF;

                -- FSM for BinaryDivider
                CASE state IS
                    WHEN s0 =>
                        IF enable = '1' and s_start = '1' THEN
                            data_Divisor <= STD_LOGIC_VECTOR(normalised_data_Divisor) & STD_LOGIC_VECTOR(to_unsigned(0, N));
                            data_Remainder <= STD_LOGIC_VECTOR(to_unsigned(0, N)) & STD_LOGIC_VECTOR(normalised_data_Dividend);
                            state <= s1;
                        ELSE
                            state <= s0;
                            DONE <= '0';
                        END IF;

                    WHEN s1 =>
                        IF (counter <= N) THEN
                            state <= s1;
                            IF data_Remainder < data_Divisor THEN
                                data_Divisor <= STD_LOGIC_VECTOR(shift_right(unsigned(data_Divisor), 1));
                                data_Quotient <= STD_LOGIC_VECTOR(shift_left(unsigned(data_Quotient), 1));
                                counter <= counter + 1;
                            ELSIF data_Remainder >= data_Divisor THEN
                                data_Remainder <= STD_LOGIC_VECTOR(unsigned(data_Remainder) - unsigned(data_Divisor));
                                data_Divisor <= STD_LOGIC_VECTOR(shift_right(unsigned(data_Divisor), 1));
                                data_Quotient <= STD_LOGIC_VECTOR(data_Quotient(N-2 DOWNTO 0)) & "1";
                                counter <= counter + 1;
                            END IF;
                        ELSE
                            if Divident(N - 1) = '0' AND Divisor(N - 1) = '0' THEN
                                Quotient <= data_Quotient;
                                Remainder <= data_Remainder;
                                MINUS_QUOTIENT <= '0';
                                MINUS_REMAINDER <= '0';
                            elsif Divident(N - 1) = '1' AND Divisor(N - 1) = '0' THEN
                                Quotient <= data_Quotient + 1;
                                Remainder <= data_Remainder + 1;
                                MINUS_QUOTIENT <= '1';
                                MINUS_REMAINDER <= '0';
                            elsif Divident(N - 1) = '0' AND Divisor(N - 1) = '1' THEN
                                Quotient <= data_Quotient + 1;
                                Remainder <= data_Remainder + 1;
                                MINUS_QUOTIENT <= '1';
                                MINUS_REMAINDER <= '1';
                            elsif Divident(N - 1) = '1' AND Divisor(N - 1) = '1' THEN
                                Quotient <= data_Quotient;
                                Remainder <= data_Remainder;
                                MINUS_QUOTIENT <= '0';
                                MINUS_REMAINDER <= '1';
                            end if;
                            state <= s2;
                        END IF;
                    WHEN others =>
                        DONE <= '1';
                END CASE;
            END IF;
        END IF;
    END PROCESS;
END Behavioral;