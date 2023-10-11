LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_signed.ALL;

ENTITY SignDetectorPreview IS
    GENERIC (N : INTEGER := 5);
    PORT (
        s_detect : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        clk : IN STD_LOGIC;
        minus : OUT STD_LOGIC;
        o : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0));
END SignDetectorPreview;

ARCHITECTURE Structural OF SignDetectorPreview IS
    SIGNAL complemented : STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
    SIGNAL zero : STD_LOGIC_VECTOR(N - 1 DOWNTO 0) := (OTHERS => '0');

BEGIN
    adder : ENTITY work.BinaryAdderAndSubtractor(Structural) GENERIC MAP (N) -- Add 1 to the input
        PORT MAP(
            a => zero, b => s_detect, m => '1', clock => clk, enable => '1', s => complemented -- complemented is the output of the adders
        );

    minus <= s_detect(N - 1);

    WITH s_detect(N - 1) SELECT -- Detect MSB
    o <= s_detect WHEN '0', -- If MSB is 0, output is s_detect
        complemented WHEN OTHERS; -- If MSB is 1, output is complemented
END ARCHITECTURE;