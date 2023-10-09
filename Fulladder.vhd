LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY Fulladder IS
	PORT (
		x, y, z, clk : IN STD_LOGIC;
		s, c : OUT STD_LOGIC);
END Fulladder;

ARCHITECTURE Structural OF Fulladder IS
BEGIN
	PROCESS (clk) IS
	BEGIN
		IF rising_edge(clk) THEN -- clk event and clk = '1'
			s <= (x XOR y) XOR z;
			c <= ((x XOR y) AND z) OR (x AND y);
		END IF;
	END PROCESS;
END Structural;