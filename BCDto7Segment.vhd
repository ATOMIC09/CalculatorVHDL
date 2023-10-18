LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY BCDto7Segment IS
	GENERIC (N : INTEGER := 5); -- N is the number of bits of the input
	PORT (
		BCD_i : IN STD_LOGIC_VECTOR (N - 2 DOWNTO 0);
		clk_i : IN STD_LOGIC;
		seven_seg : OUT STD_LOGIC_VECTOR (6 DOWNTO 0)); -- gfedcba
END BCDto7Segment;

ARCHITECTURE data_process OF BCDto7Segment IS -- data_process is the name of the architecture
BEGIN
	PROCESS (clk_i) -- sensitivity list
	BEGIN
		IF clk_i'event AND clk_i = '1' THEN
			CASE BCD_i IS --gfedcba (This 7-segment is active low, common anode)
				WHEN "0000" => seven_seg <= "1000000"; --7-segment display number 0
				WHEN "0001" => seven_seg <= "1111001"; --7-segment display number 1
				WHEN "0010" => seven_seg <= "0100100"; --7-segment display number 2
				WHEN "0011" => seven_seg <= "0110000"; --7-segment display number 3
				WHEN "0100" => seven_seg <= "0011001"; --7-segment display number 4 
				WHEN "0101" => seven_seg <= "0010010"; --7-segment display number 5
				WHEN "0110" => seven_seg <= "0000010"; --7-segment display number 6
				WHEN "0111" => seven_seg <= "1111000"; --7-segment display number 7
				WHEN "1000" => seven_seg <= "0000000"; --7-segment display number 8
				WHEN "1001" => seven_seg <= "0010000"; --7-segment display number 9

				WHEN "1011" => seven_seg <= "0111111"; --7-segment display minus

				WHEN "1100" => seven_seg <= "0001110"; --7-segment display E
				WHEN "1101" => seven_seg <= "0101111"; --7-segment display r

				WHEN OTHERS => seven_seg <= "1111111"; --7-segment display none
			END CASE;
		END IF;
	END PROCESS;
END data_process;