LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY FullAdder IS
	PORT (
		x, y, z, clk, enable_fulladder : IN STD_LOGIC;
		s, c : OUT STD_LOGIC);
END FullAdder;

ARCHITECTURE Structural OF FullAdder IS
BEGIN
	PROCESS (clk) IS
	BEGIN
		IF (rising_edge(clk) AND enable_fulladder = '1') THEN -- clk event and clk = '1'
			s <= (x XOR y) XOR z;
			c <= ((x XOR y) AND z) OR (x AND y);
		END IF;
	END PROCESS;
END Structural;