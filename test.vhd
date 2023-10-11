-- ENTITY SimpleFSM IS
--     PORT (
--         clock : IN STD_LOGIC;
--         P : IN STD_LOGIC;
--         reset : IN STD_LOGIC;
--         R : OUT STD_LOGIC);
-- END SimpleFSM;

-- -- Architecture definition for the SimpleFSM entity
-- ARCHITECTURE RTL OF SimpleFSM IS
--     TYPE State_type IS (A, B, C, D); -- Define the states
--     SIGNAL State : State_Type; -- Create a signal that uses 
--     -- the different states
-- BEGIN
--     PROCESS (clock, reset)
--     BEGIN
--         IF (reset = '1') THEN -- Upon reset, set the state to A
--             State <= A;

--         ELSIF rising_edge(clock) THEN -- if there is a rising edge of the
--             CASE State IS
--                 WHEN A =>
--                     IF P = '1' THEN
--                         State <= B;
--                     END IF;

--                     -- If the current state is B and P is set to 1, then the
--                     -- next state is C
--                 WHEN B =>
--                     IF P = '1' THEN
--                         State <= C;
--                     END IF;

--                     -- If the current state is C and P is set to 1, then the
--                     -- next state is D
--                 WHEN C =>
--                     IF P = '1' THEN
--                         State <= D;
--                     END IF;

--                     -- If the current state is D and P is set to 1, then the
--                     -- next state is B.
--                     -- If the current state is D and P is set to 0, then the
--                     -- next state is A.
--                 WHEN D =>
--                     IF P = '1' THEN
--                         State <= B;
--                     ELSE
--                         State <= A;
--                     END IF;
--                 WHEN OTHERS =>
--                     State <= A;
--             END CASE;
--         END IF;
--     END PROCESS;

--     -- Decode the current state to create the output
--     -- if the current state is D, R is 1 otherwise R is 0
--     R <= ÃÂÃÂ¢ÃÂÃÂÃÂÃÂ1ÃÂÃÂ¢ÃÂÃÂÃÂÃÂ WHEN State = D ELSE
--         ÃÂÃÂ¢ÃÂÃÂÃÂÃÂ0ÃÂÃÂ¢ÃÂÃÂÃÂÃÂ;
-- END rtl;
-- TYPE State_type IS (A, B, C, D); -- the 4 different states
-- SIGNAL State : State_Type; -- Create a signal that uses 
-- -- the 4 different states

-- PROCESS (clock, reset)
-- BEGIN
--     IF (reset = ÃÂÃÂ¢ÃÂÃÂÃÂÃÂ1ÃÂÃÂ¢ÃÂÃÂÃÂÃÂ) THEN -- Upon reset, set the state to A
--         State <= A;

--     ELSIF rising_edge(clock) THEN

--         WHEN A =>
--         IF P = '1' THEN
--             State <= B;
--         END IF;
--         WHEN OTHERS =>
--         State <= A;
--         R <= ÃÂÃÂ¢ÃÂÃÂÃÂÃÂ1ÃÂÃÂ¢ÃÂÃÂÃÂÃÂ WHEN State = D ELSE
--             ÃÂÃÂ¢ÃÂÃÂÃÂÃÂ0ÃÂÃÂ¢ÃÂÃÂÃÂÃÂ;
-- Old Multiply
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY Yeet IS
    GENERIC (
        n : INTEGER := 5
    );
    PORT (
        clk : IN STD_LOGIC;
        enable : IN STD_LOGIC; -- will be used to enable the Yeet
        A : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
        B : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
        result : OUT STD_LOGIC_VECTOR(2 * n - 1 DOWNTO 0); -- 2n bit result of multiplication
        calDONE : OUT STD_LOGIC -- will be used to indicate that the multiplication is done
    );
END Yeet;

ARCHITECTURE Behavioral OF Yeet IS
    TYPE listState IS (s0, s1);
    SIGNAL state : listState := s0;
    SIGNAL count : INTEGER := 0;
    SIGNAL Data_A : STD_LOGIC_VECTOR(2 * n - 1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL Data_B : STD_LOGIC_VECTOR(n - 1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL Data_Product : STD_LOGIC_VECTOR(2 * n - 1 DOWNTO 0) := (OTHERS => '0');

BEGIN
    PROCESS (enable, clk)
    BEGIN
        IF rising_edge(clk) THEN
            CASE state IS
                WHEN s0 =>
                    IF enable = '1' THEN
                        Data_A (n - 1 DOWNTO 0) <= A; -- keep data A
                        Data_B <= B; -- keep data B
                        state <= s1;
                    ELSE
                        state <= s0;
                        calDONE <= '0';
                    END IF;

                WHEN s1 =>
                    IF count < n + 1 THEN
                        state <= s1;
                        IF (Data_B(count) = '1') THEN
                            Data_Product <= Data_Product + Data_A; -- plus one then shift
                            Data_A <= STD_LOGIC_VECTOR(shift_left(unsigned(Data_A), 1)); -- shift data_a to the left by one bit
                            result <= Data_Product;
                            count <= count + 1;
                        ELSE -- no plus one then shift
                            Data_A <= STD_LOGIC_VECTOR(shift_left(unsigned(Data_A), 1));
                            result <= Data_Product;
                            count <= count + 1;
                        END IF;
                    ELSE
                        count <= 0;
                        Data_Product <= (OTHERS => '0');
                        Data_A <= (OTHERS => '0');
                        Data_B <= (OTHERS => '0');
                        state <= s0;
                        calDONE <= '1';
                    END IF;
                WHEN OTHERS =>
                    state <= s0;
            END CASE;
        END IF;
    END PROCESS;

END Behavioral;