LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY CalculatorVHDL IS
    GENERIC (N : INTEGER := 5);
    PORT (
        CLK, RST_N, Start : IN STD_LOGIC;
        SWITCHES : IN STD_LOGIC_VECTOR(2 * N - 1 DOWNTO 0)
        -- SEG1, SEG2, SEG3, SEG4, SEG5, SEG6 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0) := (others => '0')
    );
END CalculatorVHDL;

ARCHITECTURE Structural OF CalculatorVHDL IS
    SIGNAL STORE_A, STORE_B : STD_LOGIC_VECTOR(N - 1 DOWNTO 0) := (others => '0'); -- Add default values
    SIGNAL STORE_OPERATOR : STD_LOGIC_VECTOR(1 DOWNTO 0) := (others => '0'); -- Add default values
    SIGNAL DONE : STD_LOGIC := '0';
    SIGNAL TRIG_ADD, TRIG_SUB, TRIG_MUL, TRIG_DIV : STD_LOGIC := '0'; -- Add default values
    SIGNAL RESULT_ADDandSUB : STD_LOGIC_VECTOR(N - 1 DOWNTO 0) := (others => '0'); -- Add default values
    SIGNAL RESULT_MUL, RESULT_DIV : STD_LOGIC_VECTOR(2 * N - 1 DOWNTO 0) := (others => '0'); -- Add default values

BEGIN
    FSM : ENTITY work.FSM(Behavioral)
        PORT MAP(
            clk => CLK,
            rst_n => RST_N,
            start => Start,
            switches => SWITCHES,
            A_out => STORE_A,
            B_out => STORE_B,
            operator_out => STORE_OPERATOR,
            done => DONE
        );

    OperatorSelector : ENTITY work.OperatorSelector(Behavioral)
        PORT MAP(
            clk => CLK,
            enable => DONE,
            operator_in => STORE_OPERATOR,
            enaop_adder => TRIG_ADD,
            enaop_subtractor => TRIG_SUB,
            enaop_multiplier => TRIG_MUL,
            enaop_divider => TRIG_DIV
        );

    Adder : ENTITY work.BinaryAdderAndSubtractor(Structural)
        PORT MAP(
            a => STORE_A,
            b => STORE_B,
            m => TRIG_ADD,
            clock => CLK,
            s => RESULT_ADDandSUB
        );

    Subtractor : ENTITY work.BinaryAdderAndSubtractor(Structural)
        PORT MAP(
            a => STORE_A,
            b => STORE_B,
            m => TRIG_SUB,
            clock => CLK,
            s => RESULT_ADDandSUB
        );
    -- Multiplier : ENTITY work.Multiplier(Behavioral)
    --     PORT MAP(
            
            
    --     );
END Structural;