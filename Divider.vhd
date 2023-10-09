library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity Divider is
    -- bit digits
    generic (
        n : integer := 5
    );
    Port ( 
        clk : in STD_LOGIC;
        enable : in STD_LOGIC; -- will be used to enable the divider
        A : in  STD_LOGIC_VECTOR (n-1 downto 0);
        B : in  STD_LOGIC_VECTOR (n-1 downto 0);
        Quotient : out  STD_LOGIC_VECTOR (n-1 downto 0);
        Remainder : out  STD_LOGIC_VECTOR (n-1 downto 0));
end Divider;

-- architecture Behavioral of Divider is
--     begin
--         process (A, B) is
--             signal count : std_logic_vector(n downto 0);
--             signal Atemp : std_logic_vector(n downto 0);
--         begin
            
    
--     end Behavioral;