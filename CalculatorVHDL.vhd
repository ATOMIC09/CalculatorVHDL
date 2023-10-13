LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY CalculatorVHDL IS
    GENERIC (N : INTEGER := 5);
    PORT (
        CLK, RST_N, Start : IN STD_LOGIC;
        SWITCHES : IN STD_LOGIC_VECTOR(2 * N - 1 DOWNTO 0);
        SEVENSEG_DIGIT_1, SEVENSEG_DIGIT_2, SEVENSEG_DIGIT_3, SEVENSEG_DIGIT_4, SEVENSEG_DIGIT_5, SEVENSEG_DIGIT_6 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0) := (OTHERS => '0')
    );
END CalculatorVHDL;

ARCHITECTURE Structural OF CalculatorVHDL IS
    SIGNAL z : STD_LOGIC_VECTOR(N - 2 DOWNTO 0) := (OTHERS => '0');
    SIGNAL STORE_A, STORE_B : STD_LOGIC_VECTOR(N - 1 DOWNTO 0) := (OTHERS => '0');
    -- SIGNAL PREVIEW_A, PREVIEW_B : STD_LOGIC_VECTOR(N - 1 DOWNTO 0) := (others => '0');
    SIGNAL SIGNDETECTED_A_PREVIEW, SIGNDETECTED_B_PREVIEW : STD_LOGIC_VECTOR(N - 1 DOWNTO 0) := (OTHERS => '0');

    SIGNAL STORE_OPERATOR : STD_LOGIC_VECTOR(1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL STORE_STATE : STD_LOGIC_VECTOR(1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL DONE : STD_LOGIC := '0';
    SIGNAL TRIG_ADD, TRIG_SUB, TRIG_MUL, TRIG_DIV : STD_LOGIC := '0';
    SIGNAL RESULT_ADD, RESULT_SUB, RESULT_DIV_QUO : STD_LOGIC_VECTOR(N - 1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL RESULT_MUL, RESULT_DIV_REM : STD_LOGIC_VECTOR(2 * N - 1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL RESULT_DIV_MINUS_QUO, RESULT_DIV_MINUS_REM, RESULT_DIV_ERR : STD_LOGIC := '0'; 
    SIGNAL MINUS_ADD, MINUS_SUB, MINUS_MUL, MINUS_DIV, MINUS_PREVIEW_A, MINUS_PREVIEW_B : STD_LOGIC := '0';
    SIGNAL SIGNDETECTED_ADD_RESULT, SIGNDETECTED_SUB_RESULT : STD_LOGIC_VECTOR(N - 1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL V_ADD, V_SUB : STD_LOGIC := '0';

    -- SIGNAL Between Converter and MUX (Digit 4 bits)
    SIGNAL SEG1_ADD, SEG2_ADD, SEG3_ADD, SEG4_ADD, SEG5_ADD, SEG6_ADD : STD_LOGIC_VECTOR(N - 2 DOWNTO 0) := (OTHERS => '0');
    SIGNAL SEG1_SUB, SEG2_SUB, SEG3_SUB, SEG4_SUB, SEG5_SUB, SEG6_SUB : STD_LOGIC_VECTOR(N - 2 DOWNTO 0) := (OTHERS => '0');
    SIGNAL SEG1_MUL, SEG2_MUL, SEG3_MUL, SEG4_MUL, SEG5_MUL, SEG6_MUL : STD_LOGIC_VECTOR(N - 2 DOWNTO 0) := (OTHERS => '0');
    SIGNAL SEG1_DIV, SEG2_DIV, SEG3_DIV, SEG4_DIV, SEG5_DIV, SEG6_DIV : STD_LOGIC_VECTOR(N - 2 DOWNTO 0) := (OTHERS => '0');
    SIGNAL SEG1_A, SEG2_A, SEG3_A : STD_LOGIC_VECTOR(N - 2 DOWNTO 0) := (OTHERS => '0');
    SIGNAL SEG1_B, SEG2_B, SEG3_B : STD_LOGIC_VECTOR(N - 2 DOWNTO 0) := (OTHERS => '0');
    SIGNAL SEG1_O : STD_LOGIC_VECTOR(N - 2 DOWNTO 0) := (OTHERS => '0');

    -- SIGNAL Between MUX and 7 Segment (Digit 4 bits)
    SIGNAL SEG1_A_BCDto7SEG, SEG2_A_BCDto7SEG, SEG3_A_BCDto7SEG : STD_LOGIC_VECTOR(N - 2 DOWNTO 0) := (OTHERS => '0');
    SIGNAL SEG1_B_BCDto7SEG, SEG2_B_BCDto7SEG, SEG3_B_BCDto7SEG : STD_LOGIC_VECTOR(N - 2 DOWNTO 0) := (OTHERS => '0');

BEGIN
    FSM : ENTITY work.FSM(Behavioral)
        PORT MAP(
            clk => CLK,
            rst_n => NOT RST_N,
            start => NOT Start,
            switches => SWITCHES,
            A_out => STORE_A,
            B_out => STORE_B,
            state_out => STORE_STATE,
            operator_out => STORE_OPERATOR,
            done => DONE
        );

    SignDetectorPreviewA : ENTITY work.SignDetectorPreview(Structural)
        PORT MAP(
            s_detect => STORE_A,
            clk => CLK,
            minus => MINUS_PREVIEW_A,
            o => SIGNDETECTED_A_PREVIEW
        );

    SignDetectorPreviewB : ENTITY work.SignDetectorPreview(Structural)
        PORT MAP(
            s_detect => STORE_B,
            clk => CLK,
            minus => MINUS_PREVIEW_B,
            o => SIGNDETECTED_B_PREVIEW
        );

    BinaryToBCDConverterPreviewA : ENTITY work.BinaryToBCDConverterPreviewA(Structural)
        PORT MAP(
            clk => CLK,
            minus_con => MINUS_PREVIEW_A,
            data => SIGNDETECTED_A_PREVIEW,
            BCD_digit_1 => SEG1_A,
            BCD_digit_2 => SEG2_A,
            BCD_digit_3 => SEG3_A
        );

    BinaryToBCDConverterPreviewB : ENTITY work.BinaryToBCDConverterPreviewB(Structural)
        PORT MAP(
            clk => CLK,
            minus_con => MINUS_PREVIEW_B,
            data => SIGNDETECTED_B_PREVIEW,
            BCD_digit_1 => SEG1_B,
            BCD_digit_2 => SEG2_B,
            BCD_digit_3 => SEG3_B
        );
    BinaryToBCDConverterPreviewOperator : ENTITY work.BinaryToBCDConverterPreviewOperator(Structural)
        PORT MAP(
            clk => CLK,
            data => STORE_OPERATOR,
            BCD_digit_1 => SEG1_O
        );

    MUX_Result : ENTITY work.MUX18to3_Result(Behavioral) -- choose what value to show for the first 3 digit
        PORT MAP(
            clk => CLK,
            control => STORE_STATE,
            operate => STORE_OPERATOR,
            BCD_digit_1_A => SEG1_A,
            BCD_digit_2_A => SEG2_A,
            BCD_digit_3_A => SEG3_A,
            BCD_digit_1_B => SEG1_O,
            BCD_digit_2_B => SEG1_O,
            BCD_digit_3_B => SEG1_O,
            BCD_digit_1_ADD => SEG1_ADD,
            BCD_digit_2_ADD => SEG2_ADD,
            BCD_digit_3_ADD => SEG3_ADD,
            BCD_digit_1_SUB => SEG1_SUB,
            BCD_digit_2_SUB => SEG2_SUB,
            BCD_digit_3_SUB => SEG3_SUB,
            BCD_digit_1_MUL => SEG1_MUL,
            BCD_digit_2_MUL => SEG2_MUL,
            BCD_digit_3_MUL => SEG3_MUL,
            BCD_digit_1_DIV => SEG1_DIV,
            BCD_digit_2_DIV => SEG2_DIV,
            BCD_digit_3_DIV => SEG3_DIV,

            BCD_TO_SEGMENT_1 => SEG1_A_BCDto7SEG,
            BCD_TO_SEGMENT_2 => SEG2_A_BCDto7SEG,
            BCD_TO_SEGMENT_3 => SEG3_A_BCDto7SEG
        );

    MUX_Remainder : ENTITY work.MUX18to3_Remainder(Behavioral) -- choose what value to show for the last 3 digit
        PORT MAP(
            clk => CLK,
            control => STORE_STATE,
            operate => STORE_OPERATOR,
            BCD_digit_4_A => SEG1_B,
            BCD_digit_5_A => SEG2_B,
            BCD_digit_6_A => SEG3_B,
            BCD_digit_4_B => SEG1_O,
            BCD_digit_5_B => SEG1_O,
            BCD_digit_6_B => SEG1_O,
            BCD_digit_4_ADD => "1011",
            BCD_digit_5_ADD => "1011",
            BCD_digit_6_ADD => "1011",
            BCD_digit_4_SUB => "1011",
            BCD_digit_5_SUB => "1011",
            BCD_digit_6_SUB => "1011",
            BCD_digit_4_MUL => "1011",
            BCD_digit_5_MUL => "1011",
            BCD_digit_6_MUL => "1011",
            BCD_digit_4_DIV => SEG4_DIV,
            BCD_digit_5_DIV => SEG5_DIV,
            BCD_digit_6_DIV => SEG6_DIV,
            BCD_TO_SEGMENT_4 => SEG1_B_BCDto7SEG,
            BCD_TO_SEGMENT_5 => SEG2_B_BCDto7SEG,
            BCD_TO_SEGMENT_6 => SEG3_B_BCDto7SEG
        );

    -- -- Preview A
    -- BCD_DIGIT_1_A : ENTITY work.BCDto7Segment(data_process)
    --     PORT MAP(
    --         BCD_i => SEG1_A_BCDto7SEG,
    --         clk_i => CLK,
    --         seven_seg => SEVENSEG_DIGIT_1
    --     );
    -- BCD_DIGIT_2_A : ENTITY work.BCDto7Segment(data_process)
    --     PORT MAP(
    --         BCD_i => SEG2_A_BCDto7SEG,
    --         clk_i => CLK,
    --         seven_seg => SEVENSEG_DIGIT_2
    --     );
    -- BCD_DIGIT_3_A : ENTITY work.BCDto7Segment(data_process)
    --     PORT MAP(
    --         BCD_i => SEG3_A_BCDto7SEG,
    --         clk_i => CLK,
    --         seven_seg => SEVENSEG_DIGIT_3
    --     );

    -- -- Preview B
    -- BCD_DIGIT_1_B : ENTITY work.BCDto7Segment(data_process)
    --     PORT MAP(
    --         BCD_i => SEG1_B_BCDto7SEG,
    --         clk_i => CLK,
    --         seven_seg => SEVENSEG_DIGIT_4
    --     );
    -- BCD_DIGIT_2_B : ENTITY work.BCDto7Segment(data_process)
    --     PORT MAP(
    --         BCD_i => SEG2_B_BCDto7SEG,
    --         clk_i => CLK,
    --         seven_seg => SEVENSEG_DIGIT_5
    --     );
    -- BCD_DIGIT_3_B : ENTITY work.BCDto7Segment(data_process)
    --     PORT MAP(
    --         BCD_i => SEG3_B_BCDto7SEG,
    --         clk_i => CLK,
    --         seven_seg => SEVENSEG_DIGIT_6
    --     );

    -- operator selection and operations calculate unit
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
            m => '0',
            clock => CLK,
            enable => TRIG_ADD,
            s => RESULT_ADD,
            v => V_ADD
            -- Reserved for done signal
        );

    Subtractor : ENTITY work.BinaryAdderAndSubtractor(Structural)
        PORT MAP(
            a => STORE_A,
            b => STORE_B,
            m => '1',
            clock => CLK,
            enable => TRIG_SUB,
            s => RESULT_SUB,
            v => V_SUB
            -- Reserved for done signal
        );
    
    Multiplier : ENTITY work.BinaryMultiplier(Behavioral)
        PORT MAP(
            clk => CLK,
            enable => TRIG_MUL,
            reset => NOT RST_N,
            A => STORE_A,
            B => STORE_B,
            R => RESULT_MUL
            -- Reserved for done signal
        );

    Divider : ENTITY work.BinaryDivider(Behavioral)
        PORT MAP(
            clk => CLK,
            enable => TRIG_DIV,
            reset => NOT RST_N,
            Divident => STORE_A,
            Divisor => STORE_B,
            Quotient => RESULT_DIV_QUO,
            Remainder => RESULT_DIV_REM,
            MINUS_QUOTIENT => RESULT_DIV_MINUS_QUO,
            MINUS_REMAINDER => RESULT_DIV_MINUS_REM,
            ERR => RESULT_DIV_ERR
            -- Reserved for done signal
        );

    -- sign detector (for add and subtract)
    SignDetect_Adder : ENTITY work.SignDetector(Structural)
        PORT MAP(
            s_detect => RESULT_ADD,
            clk => CLK,
            minus => MINUS_ADD,
            o => SIGNDETECTED_ADD_RESULT
        );

    SignDetect_Subtractor : ENTITY work.SignDetector(Structural)
        PORT MAP(
            s_detect => RESULT_SUB,
            clk => CLK,
            minus => MINUS_SUB,
            o => SIGNDETECTED_SUB_RESULT
        );

    -- Result (binary) to BCD conversions
    BinaryToBCDConverter_Adder : ENTITY work.BinaryToBCDConverterADD(Structural)
        PORT MAP(
            clk => CLK,
            v => V_ADD,
            minus_con => MINUS_ADD,
            data => SIGNDETECTED_ADD_RESULT,
            BCD_digit_1 => SEG1_ADD,
            BCD_digit_2 => SEG2_ADD,
            BCD_digit_3 => SEG3_ADD
        );
    BinaryToBCDConverter_Subtractor : ENTITY work.BinaryToBCDConverterSUB(Structural)
        PORT MAP(
            clk => CLK,
            v => V_SUB,
            minus_con => MINUS_SUB,
            data => SIGNDETECTED_SUB_RESULT,
            BCD_digit_1 => SEG1_SUB,
            BCD_digit_2 => SEG2_SUB,
            BCD_digit_3 => SEG3_SUB
        );
    BinaryToBCDConverter_Multiplier : ENTITY work.BinaryToBCDConverterMUL(Structural)
        PORT MAP(
            clk => CLK,
            minus_con => STORE_A(N-1) XOR STORE_B(N-1),
            data => RESULT_MUL,
            BCD_digit_1 => SEG1_MUL,
            BCD_digit_2 => SEG2_MUL,
            BCD_digit_3 => SEG3_MUL
        );
    BinaryToBCDConverter_Divider : ENTITY work.BinaryToBCDConverterDIV(Structural)
        PORT MAP(
            clk => CLK,
            minus_q => RESULT_DIV_MINUS_QUO,
            minus_r => RESULT_DIV_MINUS_REM,
            data_err => RESULT_DIV_ERR,
            data_q => RESULT_DIV_QUO,
            data_r => RESULT_DIV_REM,
            BCD_digit_1 => SEG1_DIV,
            BCD_digit_2 => SEG2_DIV,
            BCD_digit_3 => SEG3_DIV,
            BCD_digit_4 => SEG4_DIV,
            BCD_digit_5 => SEG5_DIV,
            BCD_digit_6 => SEG6_DIV
        );

    -- BCD Result showing
    BCD_DIGIT_1 : ENTITY work.BCDto7Segment(data_process)
        PORT MAP(
            BCD_i => SEG1_A_BCDto7SEG,
            clk_i => CLK,
            seven_seg => SEVENSEG_DIGIT_1
        );
    BCD_DIGIT_2 : ENTITY work.BCDto7Segment(data_process)
        PORT MAP(
            BCD_i => SEG2_A_BCDto7SEG,
            clk_i => CLK,
            seven_seg => SEVENSEG_DIGIT_2
        );
    BCD_DIGIT_3 : ENTITY work.BCDto7Segment(data_process)
        PORT MAP(
            BCD_i => SEG3_A_BCDto7SEG,
            clk_i => CLK,
            seven_seg => SEVENSEG_DIGIT_3
        );
    BCD_DIGIT_4 : ENTITY work.BCDto7Segment(data_process)
        PORT MAP(
            BCD_i => SEG1_B_BCDto7SEG,
            clk_i => CLK,
            seven_seg => SEVENSEG_DIGIT_4
        );
    BCD_DIGIT_5 : ENTITY work.BCDto7Segment(data_process)
        PORT MAP(
            BCD_i => SEG2_B_BCDto7SEG,
            clk_i => CLK,
            seven_seg => SEVENSEG_DIGIT_5
        );
    BCD_DIGIT_6 : ENTITY work.BCDto7Segment(data_process)
        PORT MAP(
            BCD_i => SEG3_B_BCDto7SEG,
            clk_i => CLK,
            seven_seg => SEVENSEG_DIGIT_6
        );

END Structural;