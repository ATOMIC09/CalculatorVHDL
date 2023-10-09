-- ENTITY SimpleFSM IS
--     PORT (
--         clock : IN STD_LOGIC;
--         P : IN STD_LOGIC;
--         reset : IN STD_LOGIC;
--         R : OUT STD_LOGIC);
-- END SimpleFSM;

-- -- Architecture definition for the SimpleFSM entity
-- ARCHITECTURE RTL OF SimpleFSM IS
--     TYPE State_type IS (A, B, C, D); -- Define the states
--     SIGNAL State : State_Type; -- Create a signal that uses 
--     -- the different states
-- BEGIN
--     PROCESS (clock, reset)
--     BEGIN
--         IF (reset = '1') THEN -- Upon reset, set the state to A
--             State <= A;

--         ELSIF rising_edge(clock) THEN -- if there is a rising edge of the
--             CASE State IS
--                 WHEN A =>
--                     IF P = '1' THEN
--                         State <= B;
--                     END IF;

--                     -- If the current state is B and P is set to 1, then the
--                     -- next state is C
--                 WHEN B =>
--                     IF P = '1' THEN
--                         State <= C;
--                     END IF;

--                     -- If the current state is C and P is set to 1, then the
--                     -- next state is D
--                 WHEN C =>
--                     IF P = '1' THEN
--                         State <= D;
--                     END IF;

--                     -- If the current state is D and P is set to 1, then the
--                     -- next state is B.
--                     -- If the current state is D and P is set to 0, then the
--                     -- next state is A.
--                 WHEN D =>
--                     IF P = '1' THEN
--                         State <= B;
--                     ELSE
--                         State <= A;
--                     END IF;
--                 WHEN OTHERS =>
--                     State <= A;
--             END CASE;
--         END IF;
--     END PROCESS;

--     -- Decode the current state to create the output
--     -- if the current state is D, R is 1 otherwise R is 0
--     R <= ‘1’ WHEN State = D ELSE
--         ‘0’;
-- END rtl;
-- TYPE State_type IS (A, B, C, D); -- the 4 different states
-- SIGNAL State : State_Type; -- Create a signal that uses 
-- -- the 4 different states

-- PROCESS (clock, reset)
-- BEGIN
--     IF (reset = ‘1’) THEN -- Upon reset, set the state to A
--         State <= A;

--     ELSIF rising_edge(clock) THEN

--         WHEN A =>
--         IF P = '1' THEN
--             State <= B;
--         END IF;
--         WHEN OTHERS =>
--         State <= A;
--         R <= ‘1’ WHEN State = D ELSE
--             ‘0’;




-- Old Multiply
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Multiplier is
    generic (
        n : integer := 5
    );
    Port (
        clk : in STD_LOGIC;
        enable : in STD_LOGIC; -- will be used to enable the multiplier
        A : in STD_LOGIC_VECTOR(n-1 downto 0);
        B : in STD_LOGIC_VECTOR(n-1 downto 0);
        result : out STD_LOGIC_VECTOR(2*n-1 downto 0); -- 2n bit result of multiplication
        calDONE : out STD_LOGIC -- will be used to indicate that the multiplication is done
    );
end Multiplier;

architecture Behavioral of Multiplier is
    type listState is (s0,s1);
    signal state : listState := s0;
    signal count : integer := 0;
    signal Data_A : STD_LOGIC_VECTOR(2*n-1 downto 0) := (others => '0');
    signal Data_B : STD_LOGIC_VECTOR(n-1 downto 0) := (others => '0');
    signal Data_Product : STD_LOGIC_VECTOR(2*n-1 downto 0) := (others => '0');

begin
    process (enable, clk)
    begin
        if rising_edge(clk) then
            case state is
                when s0 =>
                    if enable = '1' then
                        Data_A (n-1 downto 0) <= A; -- keep data A
                        Data_B <= B; -- keep data B
                        state <= s1;
                    else
                        state <= s0;
                        calDONE <= '0';
                    end if;

                when s1 =>
                    if count < n+1 then
                        state <= s1;
                        if (Data_B(count) = '1') then
                            Data_Product <= Data_Product + Data_A; -- plus one then shift
                            Data_A <= std_logic_vector(shift_left(unsigned(Data_A),1)); -- shift data_a to the left by one bit
                            result <= Data_Product;
                            count <= count + 1;
                        else -- no plus one then shift
                            Data_A <= std_logic_vector(shift_left(unsigned(Data_A),1));
                            result <= Data_Product;
                            count <= count + 1;
                        end if;
                    else
                        count <= 0;
                        Data_Product <= (others => '0');
                        Data_A <= (others => '0');
                        Data_B <= (others => '0');
                        state <= s0;
                        calDONE <= '1';
                    end if;
                when others =>
                    state <= s0;
            end case;
        end if;
    end process;

end Behavioral;
