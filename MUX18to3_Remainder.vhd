LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

entity MUX18to3_Remainder is
    generic(N : integer := 5);
    port(
        BCD_digit_4_A : in std_logic_vector(N-2 downto 0);
        BCD_digit_5_A : in std_logic_vector(N-2 downto 0);
        BCD_digit_6_A : in std_logic_vector(N-2 downto 0);
        BCD_digit_4_B : in std_logic_vector(N-2 downto 0);
        BCD_digit_5_B : in std_logic_vector(N-2 downto 0);
        BCD_digit_6_B : in std_logic_vector(N-2 downto 0);

        BCD_digit_4_ADD : in std_logic_vector(N-2 downto 0);
        BCD_digit_5_ADD : in std_logic_vector(N-2 downto 0);
        BCD_digit_6_ADD : in std_logic_vector(N-2 downto 0);

        BCD_digit_4_SUB : in std_logic_vector(N-2 downto 0);
        BCD_digit_5_SUB : in std_logic_vector(N-2 downto 0);
        BCD_digit_6_SUB : in std_logic_vector(N-2 downto 0);

        BCD_digit_4_MUL : in std_logic_vector(N-2 downto 0);
        BCD_digit_5_MUL : in std_logic_vector(N-2 downto 0);
        BCD_digit_6_MUL : in std_logic_vector(N-2 downto 0);

        BCD_digit_4_DIV : in std_logic_vector(N-2 downto 0);
        BCD_digit_5_DIV : in std_logic_vector(N-2 downto 0);
        BCD_digit_6_DIV : in std_logic_vector(N-2 downto 0);

        BCD_TO_SEGMENT_4 : out std_logic_vector(N-2 downto 0);
        BCD_TO_SEGMENT_5 : out std_logic_vector(N-2 downto 0);
        BCD_TO_SEGMENT_6 : out std_logic_vector(N-2 downto 0);

        control : in std_logic_vector;
        operate : in std_logic_vector;
        clk : in std_logic
    );
end MUX18to3_Remainder;

architecture Behavioral of MUX18to3_Remainder is
    signal BCD_TO_SEGMENT_4_temp : std_logic_vector(N-2 downto 0);
    signal BCD_TO_SEGMENT_5_temp : std_logic_vector(N-2 downto 0);
    signal BCD_TO_SEGMENT_6_temp : std_logic_vector(N-2 downto 0);
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if control = "00"  then
                BCD_TO_SEGMENT_4_temp <= BCD_digit_4_A;
                BCD_TO_SEGMENT_5_temp <= BCD_digit_5_A;
                BCD_TO_SEGMENT_6_temp <= BCD_digit_6_A;
            elsif control = "01" then
                BCD_TO_SEGMENT_4_temp <= BCD_digit_4_B;
                BCD_TO_SEGMENT_5_temp <= BCD_digit_5_B;
                BCD_TO_SEGMENT_6_temp <= BCD_digit_6_B;
            elsif control = "10" then
                if operate = "00" then
                    BCD_TO_SEGMENT_4_temp <= BCD_digit_4_DIV;
                    BCD_TO_SEGMENT_5_temp <= BCD_digit_5_DIV;
                    BCD_TO_SEGMENT_6_temp <= BCD_digit_6_DIV;
                elsif operate = "01" then
                    BCD_TO_SEGMENT_4_temp <= BCD_digit_4_MUL;
                    BCD_TO_SEGMENT_5_temp <= BCD_digit_5_MUL;
                    BCD_TO_SEGMENT_6_temp <= BCD_digit_6_MUL;
                elsif operate = "10" then
                    BCD_TO_SEGMENT_4_temp <= BCD_digit_4_SUB;
                    BCD_TO_SEGMENT_5_temp <= BCD_digit_5_SUB;
                    BCD_TO_SEGMENT_6_temp <= BCD_digit_6_SUB;
                elsif operate = "11" then
                    BCD_TO_SEGMENT_4_temp <= BCD_digit_4_ADD;
                    BCD_TO_SEGMENT_5_temp <= BCD_digit_5_ADD;
                    BCD_TO_SEGMENT_6_temp <= BCD_digit_6_ADD;
                end if;
            end if;
        end if;
    end process;

    BCD_TO_SEGMENT_4 <= BCD_TO_SEGMENT_4_temp;
    BCD_TO_SEGMENT_5 <= BCD_TO_SEGMENT_5_temp;
    BCD_TO_SEGMENT_6 <= BCD_TO_SEGMENT_6_temp;
end Behavioral;