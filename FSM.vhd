library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FSM is
    generic (N : integer := 5); -- 0123
    Port (
        clk, rst_n, start : in STD_LOGIC;
        switches : in STD_LOGIC_VECTOR(2*N-1 downto 0); 
        A_out, B_out : out STD_LOGIC_VECTOR (N-1 downto 0);
        operator_out : out STD_LOGIC_VECTOR(1 downto 0);
        done : out STD_LOGIC
    );
end FSM;

architecture Behavioral of FSM is
    type state_type is (GET_AandB, GET_OPERATOR, FINISHED);
    signal current_state : state_type := GET_AandB;
    signal stored_A, stored_B : STD_LOGIC_VECTOR (N-1 downto 0) := (others => '0');
    signal stored_operator : STD_LOGIC_VECTOR(1 downto 0) := (others => '0');
    signal stored_done : std_logic := '0';

begin
    process(clk, rst_n)
    begin
        if rst_n = '1' then
            stored_A <= (others => '0');
            stored_B <= (others => '0');
            stored_operator <= (others => '0');
            stored_done <= '0';
            current_state <= GET_AandB;
        elsif rising_edge(clk) then
            case current_state is
                when GET_AandB =>
                    stored_A <= switches(2*N-1 downto (2*N-1)-(N-1));
                    stored_B <= switches(N-1 downto 0);
                    if start = '1' then
                        current_state <= GET_OPERATOR;
                    end if;
                when GET_OPERATOR =>
                    stored_operator <= switches(1 downto 0);
                    if start = '1' then
                        current_state <= FINISHED;
                    end if;
                when FINISHED =>
                    A_out <= stored_A;
                    B_out <= stored_B;
                    operator_out <= stored_operator;
                    stored_done <= '1';
                    done <= stored_done;
            end case;
        end if;
    end process;

end Behavioral;