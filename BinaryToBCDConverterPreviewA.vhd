library ieee;
use ieee.std_logic_1164.all;
use ieee.STD_LOGIC_ARITH.all;

entity BinaryToBCDConverterPreviewA is
    generic(
        N : integer := 5
    );
    port(
        clk: in std_logic;
        minus_con: in std_logic;
        data: in std_logic_vector(N-1 downto 0);
        BCD_digit_1 : out std_logic_vector(N-2 downto 0);
        BCD_digit_2 : out std_logic_vector(N-2 downto 0);
        BCD_digit_3 : out std_logic_vector(N-2 downto 0)
    );
end BinaryToBCDConverterPreviewA;

architecture Structural of BinaryToBCDConverterPreviewA is
signal signal_integer1 : integer := 0;
signal signal_integer2 : integer := 0;
begin
    process(clk)
        begin 
            if rising_edge(clk) then
                signal_integer1 <=  conv_integer(unsigned(data)) MOD 10;
                signal_integer2 <=  (conv_integer(unsigned(data)) / 10) MOD 10;

                BCD_digit_1 <= conv_std_logic_vector(signal_integer1, N-1);
                BCD_digit_2 <= conv_std_logic_vector(signal_integer2, N-1);
                    
                if (minus_con = '1') then -- if MSB is 1
                    BCD_digit_3 <= "1011"; -- minus
                else
                    BCD_digit_3 <= "1010"; -- none
                end if;
            end if;
    end process;
end Structural;