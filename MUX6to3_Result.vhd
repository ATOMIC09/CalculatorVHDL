LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

entity MUX6to3_Result is
    generic(N : integer := 5);
    port(
        BCD_digit_1_A : in std_logic_vector(N-2 downto 0);
        BCD_digit_2_A : in std_logic_vector(N-2 downto 0);
        BCD_digit_3_A : in std_logic_vector(N-2 downto 0);
        BCD_digit_1_B : in std_logic_vector(N-2 downto 0);
        BCD_digit_2_B : in std_logic_vector(N-2 downto 0);
        BCD_digit_3_B : in std_logic_vector(N-2 downto 0);
        BCD_TO_SEGMENT_1 : out std_logic_vector(N-2 downto 0);
        BCD_TO_SEGMENT_2 : out std_logic_vector(N-2 downto 0);
        BCD_TO_SEGMENT_3 : out std_logic_vector(N-2 downto 0);
        control : in std_logic := '0';
        clk : in std_logic := '0'
    );
end MUX6to3_Result;

architecture Behavioral of MUX6to3_Result is
    signal BCD_TO_SEGMENT_1_temp : std_logic_vector(N-2 downto 0);
    signal BCD_TO_SEGMENT_2_temp : std_logic_vector(N-2 downto 0);
    signal BCD_TO_SEGMENT_3_temp : std_logic_vector(N-2 downto 0);
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if control = '0' then
                BCD_TO_SEGMENT_1_temp <= BCD_digit_1_A;
                BCD_TO_SEGMENT_2_temp <= BCD_digit_2_A;
                BCD_TO_SEGMENT_3_temp <= BCD_digit_3_A;
            else
                BCD_TO_SEGMENT_1_temp <= BCD_digit_1_B;
                BCD_TO_SEGMENT_2_temp <= BCD_digit_2_B;
                BCD_TO_SEGMENT_3_temp <= BCD_digit_3_B;
            end if;
        end if;
    end process;

    BCD_TO_SEGMENT_1 <= BCD_TO_SEGMENT_1_temp;
    BCD_TO_SEGMENT_2 <= BCD_TO_SEGMENT_2_temp;
    BCD_TO_SEGMENT_3 <= BCD_TO_SEGMENT_3_temp;
end Behavioral;