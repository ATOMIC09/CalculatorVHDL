LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY CalculatorVHDL IS
    GENERIC (N : INTEGER := 5);
    PORT (
        CLK, RST_N, Start : IN STD_LOGIC;
        SWITCHES : IN STD_LOGIC_VECTOR(2 * N - 1 DOWNTO 0);
        SEVENSEG_DIGIT_1, SEVENSEG_DIGIT_2, SEVENSEG_DIGIT_3, SEVENSEG_DIGIT_4, SEVENSEG_DIGIT_5, SEVENSEG_DIGIT_6 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0) := (others => '0')
    );
END CalculatorVHDL;

ARCHITECTURE Structural OF CalculatorVHDL IS
signal z : std_logic_vector(N - 2 downto 0) := (others => '0');
    SIGNAL STORE_A, STORE_B : STD_LOGIC_VECTOR(N - 1 DOWNTO 0) := (others => '0');
    SIGNAL PREVIEW_A, PREVIEW_B : STD_LOGIC_VECTOR(N - 1 DOWNTO 0) := (others => '0');
    SIGNAL SIGNDETECTED_A_PREVIEW, SIGNDETECTED_B_PREVIEW : STD_LOGIC_VECTOR(N - 1 DOWNTO 0) := (others => '0');

    SIGNAL STORE_OPERATOR : STD_LOGIC_VECTOR(1 DOWNTO 0) := (others => '0');
    SIGNAL DONE : STD_LOGIC := '0';
    SIGNAL TRIG_ADD, TRIG_SUB, TRIG_MUL, TRIG_DIV : STD_LOGIC := '0';
    SIGNAL RESULT_ADD, RESULT_SUB : STD_LOGIC_VECTOR(N - 1 DOWNTO 0) := (others => '0');
    SIGNAL RESULT_MUL, RESULT_DIV : STD_LOGIC_VECTOR(2 * N - 1 DOWNTO 0) := (others => '0');
    -- SIGNAL REMAINDER_DIV : STD_LOGIC_VECTOR(N - 1 DOWNTO 0) := (others => '0');   
    SIGNAL MINUS_ADD, MINUS_SUB, MINUS_MUL, MINUS_DIV, MINUS_PREVIEW_A, MINUS_PREVIEW_B : STD_LOGIC := '0';
    SIGNAL SIGNDETECTED_ADD_RESULT, SIGNDETECTED_SUB_RESULT, SIGNDETECTED_MUL_RESULT, SIGNDETECTED_DIV_RESULT : STD_LOGIC_VECTOR(N - 1 DOWNTO 0) := (others => '0');
    SIGNAL V_ADD, V_SUB : STD_LOGIC := '0';

    -- SIGNAL Between Converter and MUX (Digit 4 bits)
    SIGNAL SEG1_ADD, SEG2_ADD, SEG3_ADD, SEG4_ADD, SEG5_ADD, SEG6_ADD : STD_LOGIC_VECTOR(N-2 DOWNTO 0) := (others => '0');
    SIGNAL SEG1_SUB, SEG2_SUB, SEG3_SUB, SEG4_SUB, SEG5_SUB, SEG6_SUB : STD_LOGIC_VECTOR(N-2 DOWNTO 0) := (others => '0');
    SIGNAL SEG1_MUL, SEG2_MUL, SEG3_MUL, SEG4_MUL, SEG5_MUL, SEG6_MUL : STD_LOGIC_VECTOR(N-2 DOWNTO 0) := (others => '0');
    SIGNAL SEG1_DIV, SEG2_DIV, SEG3_DIV, SEG4_DIV, SEG5_DIV, SEG6_DIV : STD_LOGIC_VECTOR(N-2 DOWNTO 0) := (others => '0');
    SIGNAL SEG1_A, SEG2_A, SEG3_A : STD_LOGIC_VECTOR(N-2 DOWNTO 0) := (others => '0');
    SIGNAL SEG1_B, SEG2_B, SEG3_B : STD_LOGIC_VECTOR(N-2 DOWNTO 0) := (others => '0');

    -- SIGNAL Between MUX and 7 Segment (Digit 4 bits)
    SIGNAL SEG1_A_BCDto7SEG, SEG2_A_BCDto7SEG, SEG3_A_BCDto7SEG : STD_LOGIC_VECTOR(N-2 DOWNTO 0) := (others => '0');
    SIGNAL SEG1_B_BCDto7SEG, SEG2_B_BCDto7SEG, SEG3_B_BCDto7SEG : STD_LOGIC_VECTOR(N-2 DOWNTO 0) := (others => '0');

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
            done => DONE,
            preview_A => PREVIEW_A,
            preview_B => PREVIEW_B
        );

    SignDetectorPreviewA : ENTITY work.SignDetectorPreview(Structural)
        PORT MAP(
            s_detect => PREVIEW_A,
            clk => CLK,
            minus => MINUS_PREVIEW_A,
            o => SIGNDETECTED_A_PREVIEW
        );

    SignDetectorPreviewB : ENTITY work.SignDetectorPreview(Structural)
        PORT MAP(
            s_detect => PREVIEW_B,
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

    MUX_Result : ENTITY work.MUX6to3_Result(Behavioral)
        PORT MAP(
            clk => CLK,
            control => DONE,
            BCD_digit_1_A => SEG1_A,
            BCD_digit_2_A => SEG2_A,
            BCD_digit_3_A => SEG3_A,
            BCD_digit_1_B => z,
            BCD_digit_2_B => z,
            BCD_digit_3_B => z,
            BCD_TO_SEGMENT_1 => SEG1_A_BCDto7SEG,
            BCD_TO_SEGMENT_2 => SEG2_A_BCDto7SEG,
            BCD_TO_SEGMENT_3 => SEG3_A_BCDto7SEG
        );

    MUX_Result_B : ENTITY work.MUX6to3_Result(Behavioral)
        PORT MAP(
            clk => CLK,
            control => DONE,
            BCD_digit_1_A => SEG1_B,
            BCD_digit_2_A => SEG2_B,
            BCD_digit_3_A => SEG3_B,
            BCD_digit_1_B => z,
            BCD_digit_2_B => z,
            BCD_digit_3_B => z,
            BCD_TO_SEGMENT_1 => SEG1_B_BCDto7SEG,
            BCD_TO_SEGMENT_2 => SEG2_B_BCDto7SEG,
            BCD_TO_SEGMENT_3 => SEG3_B_BCDto7SEG
        );

    -- Preview A
    BCD_DIGIT_1_A : ENTITY work.BCDto7Segment(data_process)
        PORT MAP(
            BCD_i => SEG1_A_BCDto7SEG,
            clk_i => CLK,
            seven_seg => SEVENSEG_DIGIT_1
        );
    BCD_DIGIT_2_A : ENTITY work.BCDto7Segment(data_process)
        PORT MAP(
            BCD_i => SEG2_A_BCDto7SEG,
            clk_i => CLK,
            seven_seg => SEVENSEG_DIGIT_2
        );
    BCD_DIGIT_3_A : ENTITY work.BCDto7Segment(data_process)
        PORT MAP(
            BCD_i => SEG3_A_BCDto7SEG,
            clk_i => CLK,
            seven_seg => SEVENSEG_DIGIT_3
        );

    -- Preview B
    BCD_DIGIT_1_B : ENTITY work.BCDto7Segment(data_process)
        PORT MAP(
            BCD_i => SEG1_B_BCDto7SEG,
            clk_i => CLK,
            seven_seg => SEVENSEG_DIGIT_4
        );
    BCD_DIGIT_2_B : ENTITY work.BCDto7Segment(data_process)
        PORT MAP(
            BCD_i => SEG2_B_BCDto7SEG,
            clk_i => CLK,
            seven_seg => SEVENSEG_DIGIT_5
        );
    BCD_DIGIT_3_B : ENTITY work.BCDto7Segment(data_process)
        PORT MAP(
            BCD_i => SEG3_B_BCDto7SEG,
            clk_i => CLK,
            seven_seg => SEVENSEG_DIGIT_6
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
            m => '0',
            clock => CLK,
            enable => TRIG_ADD,
            s => RESULT_ADD,
            v => V_ADD
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
        );

    SignDetect_Adder : ENTITY work.SignDetector(Structural)
        PORT MAP(
            s_detect =>  RESULT_ADD,
            clk => CLK,
            minus => MINUS_ADD,
            o => SIGNDETECTED_ADD_RESULT
        );

    SignDetect_Subtractor : ENTITY work.SignDetector(Structural)
        PORT MAP(
            s_detect =>  RESULT_SUB,
            clk => CLK,
            minus => MINUS_SUB,
            o => SIGNDETECTED_SUB_RESULT
        );

    BinaryToBCDConverter_Adder : ENTITY work.BinaryToBCDConverterADD(Structural)
        PORT MAP(
            clk => CLK,
            v => V_ADD,
            minus_con => MINUS_ADD,
            data => RESULT_ADD,
            BCD_digit_1 => SEG1_ADD,
            BCD_digit_2 => SEG2_ADD,
            BCD_digit_3 => SEG3_ADD
        );
    BinaryToBCDConverter_Subtractor : ENTITY work.BinaryToBCDConverterSUB(Structural)
        PORT MAP(
            clk => CLK,
            v => V_SUB,
            minus_con => MINUS_SUB,
            data => RESULT_SUB,
            BCD_digit_1 => SEG1_SUB,
            BCD_digit_2 => SEG2_SUB,
            BCD_digit_3 => SEG3_SUB
        );
        
    -- -- Adder
    -- BCD_DIGIT_1 : ENTITY work.BCDto7Segment(data_process)
    --     PORT MAP(
    --         BCD_i => SEG1_ADD,
    --         clk_i => CLK,
    --         seven_seg => SEVENSEG_DIGIT_1 -- logic vector 7 bit
    --     );
    -- BCD_DIGIT_2 : ENTITY work.BCDto7Segment(data_process)
    --     PORT MAP(
    --         BCD_i => SEG2_ADD,
    --         clk_i => CLK,
    --         seven_seg => SEVENSEG_DIGIT_2
    --     );
    -- BCD_DIGIT_3 : ENTITY work.BCDto7Segment(data_process)
    --     PORT MAP(
    --         BCD_i => SEG3_ADD,
    --         clk_i => CLK,
    --         seven_seg => SEVENSEG_DIGIT_3
    --     );
        
END Structural;