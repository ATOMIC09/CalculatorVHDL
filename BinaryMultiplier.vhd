LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE IEEE.std_logic_unsigned.ALL;

ENTITY BinaryMultiplier IS
    GENERIC (N : INTEGER := 5);
    PORT (
        clk : IN STD_LOGIC;
        enable : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        A, B : IN STD_LOGIC_VECTOR (N - 1 DOWNTO 0) := (OTHERS => '0');
        R : OUT STD_LOGIC_VECTOR (2 * N - 1 DOWNTO 0) := (OTHERS => '0');
        DONE : OUT STD_LOGIC := '0');
END BinaryMultiplier;

ARCHITECTURE Behavioral OF BinaryMultiplier IS
    TYPE state_type IS (s0, s1, s2);
    SIGNAL state : state_type := s0;
    SIGNAL s_start : STD_LOGIC := '1';
    SIGNAL normalised_data_A : STD_LOGIC_VECTOR (N - 1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL normalised_data_B : STD_LOGIC_VECTOR (N - 1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL data_A : STD_LOGIC_VECTOR (2 * N - 1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL data_B : STD_LOGIC_VECTOR (N - 1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL data_R : STD_LOGIC_VECTOR (2 * N - 1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL counter : INTEGER := 0;
BEGIN
    PROCESS (clk, reset, enable)
    BEGIN
        IF reset = '1' THEN
            -- toggle reset
            state <= s0;
            s_start <= '1';
            DONE <= '0';
            counter <= 0;
            R <= (OTHERS => '0');
            data_A <= (OTHERS => '0');
            data_B <= (OTHERS => '0');
            data_R <= (OTHERS => '0');
        
		  ELSIF rising_edge(clk) THEN

            -- detect a sign bit. if it's 1, do 2 compliment.
            IF A(N - 1) = '1' THEN
                normalised_data_A <= NOT A + 1;
            END IF;
            IF B(N - 1) = '1' THEN
                normalised_data_B <= NOT B + 1;
            END IF;
            IF A(N - 1) = '0' THEN
                normalised_data_A <= A;
            END IF;
            IF B(N - 1) = '0' THEN
                normalised_data_B <= B;
            END IF;

            -- FSM for BinaryMultiplier
            CASE state IS
                WHEN s0 =>
                    IF enable = '1' AND s_start = '1' THEN
                        data_A (N - 1 DOWNTO 0) <= normalised_data_A;--normalised_data_A;
                        data_B <= normalised_data_B;--normalised_data_B;
                        state <= s1;
                    ELSE
                        state <= s0;
                    END IF;

                WHEN s1 =>
                    IF (counter <= N) THEN
                        state <= s1;
                        IF data_B(counter) = '1' THEN
                            data_R <= data_R + data_A;
                            data_A <= STD_LOGIC_VECTOR(shift_left(unsigned(data_A), 1));
                            R <= data_R;
                            counter <= counter + 1;
                        ELSE
                            data_A <= STD_LOGIC_VECTOR(shift_left(unsigned(data_A), 1));
                            R <= data_R;
                            counter <= counter + 1;
                        END IF;
                    ELSE
                        state <= s2;
                    END IF;
                WHEN OTHERS =>
                    DONE <= '1';
                    --state <= s0;
            END CASE;
        END IF;
    END PROCESS;
END Behavioral;