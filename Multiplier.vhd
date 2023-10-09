library ieee;
use ieee.std_logic_1164.all;

entity Multiplier2 is
    generic (
        N : integer := 5
    );
    port(
        clk, rst, enable : in std_logic;
        a, b : in std_logic_vector(3 downto 0);
        p : out std_logic_vector(7 downto 0)
    );
end entity;

architecture Behavioral of Multiplier2 is
    signal total : std_logic_vector(N-1 downto 0);
    signal C_INTERNAL : std_logic_vector(1 to N);

    component BinaryAdderAndSubtractor is
        port (
            A, B : in std_logic_vector(N-1 downto 0);
            M : in std_logic := '0';
            S : out std_logic_vector(N-1 downto 0);
            C : out std_logic_vector(N downto 0);
            V : out std_logic
        );
    end component;

begin
    process(clk, rst, enable)
    begin
        if rst = '1' then
            total <= (others => '0');
            C_INTERNAL <= (others => '0');
        elsif enable = '1' then
            if rising_edge(clk) then
                for i in 0 to n-1 loop
                    uut : BinaryAdderAndSubtractor;
                        port map (
                            A => total,
                            B => a,
                            M => '0',
                            S => total,
                            C => C_INTERNAL
                        );
                end loop;
            end if;
        end if;
    end process;

    p <= total;

end Behavioral;
