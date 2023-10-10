library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity multiplier is
    generic (N : integer := 5);
    Port ( clk : in STD_LOGIC;
           enable : in STD_LOGIC;
           reset : in STD_LOGIC;
           A : in  STD_LOGIC_VECTOR (N-1 downto 0);
           B : in  STD_LOGIC_VECTOR (N-1 downto 0);
           R : out STD_LOGIC_VECTOR (2*N-1 downto 0));
end multiplier;

architecture Behavioral of multiplier is
begin
    process(clk, reset)
        variable result : STD_LOGIC_VECTOR(2*N-1 downto 0) := (others => '0'); -- init all bits to zero
        variable multiplicand : STD_LOGIC_VECTOR(N-1 downto 0);
        variable multiplier : STD_LOGIC_VECTOR(N-1 downto 0);
    begin
        if reset = '1' then
            result := (others => '0');
            R <= result;
        elsif rising_edge(clk) then
            if enable = '1' then
                multiplicand := unsigned("00000" & A); -- add 5 zeros to the left of multiplicand
                multiplier := B;
                
                for i in 0 to N-1 loop
                    if multiplier(i) = '1' then -- if bit of multiplier is 1, add multiplicand to result. if 0, do nothing
                        result := STD_LOGIC_VECTOR(result + signed(multiplicand));
                    end if;
                    multiplicand := shift_left(multiplicand, 1); -- shifts bit of mutiplicand to the left by one
                end loop;
                
                R <= result;
            end if;
        end if;
    end process;
end Behavioral;
