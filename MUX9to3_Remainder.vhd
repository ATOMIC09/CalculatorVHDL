LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

entity MUX9to3_Remainder is
    generic(N : integer := 5);
    port(
        BCD_digit_1_A : in std_logic_vector(N-2 downto 0);
        BCD_digit_2_A : in std_logic_vector(N-2 downto 0);
        BCD_digit_3_A : in std_logic_vector(N-2 downto 0);
        BCD_digit_1_B : in std_logic_vector(N-2 downto 0);
        BCD_digit_2_B : in std_logic_vector(N-2 downto 0);
        BCD_digit_3_B : in std_logic_vector(N-2 downto 0);
        BCD_digit_1_C : in std_logic_vector(N-2 downto 0);
        BCD_digit_2_C : in std_logic_vector(N-2 downto 0);
        BCD_digit_3_C : in std_logic_vector(N-2 downto 0);
        BCD_TO_SEGMENT_1 : out std_logic_vector(N-2 downto 0);
        BCD_TO_SEGMENT_2 : out std_logic_vector(N-2 downto 0);
        BCD_TO_SEGMENT_3 : out std_logic_vector(N-2 downto 0);
        control : in std_logic_vector;
        clk : in std_logic
    );
end MUX9to3_Remainder;

architecture Behavioral of MUX9to3_Remainder is
    COMPONENT FSM IS
        PORT (
            state_out : OUT STD_LOGIC_VECTOR
        );
    END COMPONENT;
    signal BCD_TO_SEGMENT_1_temp : std_logic_vector(N-2 downto 0);
    signal BCD_TO_SEGMENT_2_temp : std_logic_vector(N-2 downto 0);
    signal BCD_TO_SEGMENT_3_temp : std_logic_vector(N-2 downto 0);
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if control = "00"  then
                BCD_TO_SEGMENT_1_temp <= BCD_digit_1_A;
                BCD_TO_SEGMENT_2_temp <= BCD_digit_2_A;
                BCD_TO_SEGMENT_3_temp <= BCD_digit_3_A;
            elsif control = "01" then
                BCD_TO_SEGMENT_1_temp <= BCD_digit_1_B;
                BCD_TO_SEGMENT_2_temp <= BCD_digit_2_B;
                BCD_TO_SEGMENT_3_temp <= BCD_digit_3_B;
            elsif control = "10" then
                BCD_TO_SEGMENT_1_temp <= BCD_digit_1_C;
                BCD_TO_SEGMENT_2_temp <= BCD_digit_2_C;
                BCD_TO_SEGMENT_3_temp <= BCD_digit_3_C;
            end if;
        end if;
    end process;

    BCD_TO_SEGMENT_1 <= BCD_TO_SEGMENT_1_temp;
    BCD_TO_SEGMENT_2 <= BCD_TO_SEGMENT_2_temp;
    BCD_TO_SEGMENT_3 <= BCD_TO_SEGMENT_3_temp;
end Behavioral;