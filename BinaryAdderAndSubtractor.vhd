LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.STD_LOGIC_ARITH.ALL;
USE ieee.STD_LOGIC_UNSIGNED.ALL;

ENTITY BinaryAdderAndSubtractor IS
    GENERIC (N : INTEGER := 5);
    PORT (
        a, b : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        m, clock, enable : IN STD_LOGIC;
        s : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        c : OUT STD_LOGIC_VECTOR(N DOWNTO 1);
        v : OUT STD_LOGIC
    );
END BinaryAdderAndSubtractor;

ARCHITECTURE Structural OF BinaryAdderAndSubtractor IS
    COMPONENT FullAdder IS
        PORT (
            x, y, z, clk, enable_fulladder : IN STD_LOGIC;
            s, c : OUT STD_LOGIC
        );
    END COMPONENT;
	SIGNAL c_internal : STD_LOGIC_VECTOR(1 to N);
BEGIN
    FA0 : FullAdder
    PORT MAP (
        x => a(0),
        y => m XOR b(0),
        z => m,
        clk => clock,
        enable_fulladder => enable,
        s => s(0),
        c => c_internal(1)
    );

    FA_gen : FOR i IN 1 TO N - 1 GENERATE
        FAi : FullAdder
        PORT MAP (
            x => a(i),
            y => m XOR b(i),
            z => c_internal(i),
            clk => clock,
            enable_fulladder => enable,
            s => s(i),
            c => c_internal(i + 1)
        );
    END GENERATE;

    v <= c_internal(N) XOR c_internal(N - 1); -- Calculate overflow
END Structural;