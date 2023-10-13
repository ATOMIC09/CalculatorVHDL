LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_signed.ALL;

ENTITY SignDetector IS
    generic (N : INTEGER := 5);
    PORT (
        s_detect : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
        clk : IN STD_LOGIC;
        minus : OUT STD_LOGIC;
        o : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0));
END SignDetector;

ARCHITECTURE Structural OF SignDetector IS
    SIGNAL complemented : STD_LOGIC_VECTOR(N-1 DOWNTO 0);
    SIGNAL plusone : STD_LOGIC_VECTOR(N-1 DOWNTO 0) := (0 => '1', OTHERS => '0');

BEGIN
    -- Add 1 to the input
    adder : ENTITY work.BinaryAdderAndSubtractor(Structural) -- Add 1 to the input
        PORT MAP(
            a => NOT s_detect,
            b => plusone,
            m => '0',
            clock => clk,
            enable => '1',
            s => complemented -- complemented is the output of the adders
        );

        minus <= s_detect(N-1);
        
        WITH s_detect(N-1) SELECT -- Detect MSB
        o <= s_detect when '0', -- If MSB is 0, output is s_detect
        complemented when others;  -- If MSB is 1, output is complemented

END Structural;