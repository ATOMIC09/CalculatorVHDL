library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity divider is
    generic (N : integer := 5);
    Port ( clk : in STD_LOGIC;
           enable : in STD_LOGIC;
           reset : in STD_LOGIC;
           A : in  STD_LOGIC_VECTOR (N-1 downto 0);
           B : in  STD_LOGIC_VECTOR (N-1 downto 0);
           Q : out STD_LOGIC_VECTOR (N-1 downto 0);
           R : out STD_LOGIC_VECTOR (N-1 downto 0));
end divider;

architecture Behavioral of divider is
begin
    process(clk, reset)
        variable dividend : STD_LOGIC_VECTOR(N-1 downto 0);
        variable divisor : STD_LOGIC_VECTOR(N-1 downto 0);
        variable quotient : STD_LOGIC_VECTOR(N-1 downto 0) := (others => '0'); -- initialize to 0
        variable remainder : STD_LOGIC_VECTOR(N-1 downto 0) := (others => '0'); -- initialize to 0
    begin
        if reset = '1' then
            quotient := (others => '0');
            Q <= std_logic_vector(quotient);
            R <= std_logic_vector(remainder);
            
        elsif rising_edge(clk) then
            if enable = '1' then
                if B = "00000" then
                    Q <= "11111";
                    R <= "11111";
                else
                    dividend := A;
                    divisor := B;
                    
                    -- Still cannot write
                    
                    Q <= std_logic_vector(quotient);
                    R <= std_logic_vector(remainder);
                end if;
            end if;
        end if;
    end process;
end Behavioral;
