LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY FSM IS
    GENERIC (N : INTEGER := 5); -- 0123
    PORT (
        clk, rst_n, start : IN STD_LOGIC;
        switches : IN STD_LOGIC_VECTOR(2 * N - 1 DOWNTO 0);
        A_out, B_out : OUT STD_LOGIC_VECTOR (N - 1 DOWNTO 0);
        operator_out : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        state_out : OUT STD_LOGIC_VECTOR;
        done : OUT STD_LOGIC
    );
END FSM;

ARCHITECTURE Behavioral OF FSM IS
    TYPE state_type IS (GET_AandB, GET_OPERATOR, FINISHED);
    SIGNAL current_state : state_type := GET_AandB;

BEGIN
    PROCESS (clk, rst_n, start)
    BEGIN
        IF rising_edge(start) THEN
            CASE current_state IS
                WHEN GET_AandB => current_state <= GET_OPERATOR;
                WHEN GET_OPERATOR => current_state <= FINISHED;
                WHEN FINISHED => current_state <= FINISHED;
            END CASE;
        END IF;

        IF rst_n = '1' THEN
            done <= '0';
            current_state <= GET_AandB;
        ELSIF rising_edge(clk) THEN
            CASE current_state IS
                WHEN GET_AandB =>
                    A_out <= switches(2 * N - 1 DOWNTO (2 * N - 1) - (N - 1));
                    B_out <= switches(N - 1 DOWNTO 0);
                    state_out <= "00";
                WHEN GET_OPERATOR =>
                    operator_out <= switches(1 DOWNTO 0);
                    state_out <= "01";
                WHEN FINISHED =>
                    done <= '1';
                    state_out <= "10";
            END CASE;
        END IF;
    END PROCESS;

END Behavioral;