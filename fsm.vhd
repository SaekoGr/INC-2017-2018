-- fsm.vhd: Finite State Machine
-- Author(s): Sabína Gregušová
--
library ieee;
use ieee.std_logic_1164.all;
-- ----------------------------------------------------------------------------
--                        Entity declaration
-- ----------------------------------------------------------------------------
entity fsm is
port(
   CLK         : in  std_logic;
   RESET       : in  std_logic;

   -- Input signals
   KEY         : in  std_logic_vector(15 downto 0);
   CNT_OF      : in  std_logic;

   -- Output signals
   FSM_CNT_CE  : out std_logic;
   FSM_MX_MEM  : out std_logic;
   FSM_MX_LCD  : out std_logic;
   FSM_LCD_WR  : out std_logic;
   FSM_LCD_CLR : out std_logic
);
end entity fsm;

-- ----------------------------------------------------------------------------
--                      Architecture declaration
-- ----------------------------------------------------------------------------
architecture behavioral of fsm is
   type t_state is (
	PRINT_CORRECT, PRINT_INCORRECT, WRONG, -- possible final states
	TEST_01, TEST_02, TEST_03, TEST_04, TEST_05, TEST_06, -- the same
	CHOOSE_BRANCH, -- decides the branch for next state
	TEST_12, TEST_13, TEST_14, -- original for 1. code
	TEST_22, TEST_23, TEST_24, TEST_25, -- original for 2. code
	FINISH, LAST_CHAR
	);
   signal present_state, next_state : t_state;
	

begin
-- -------------------------------------------------------
sync_logic : process(RESET, CLK)
begin
   if (RESET = '1') then
      present_state <= TEST_01;
   elsif (CLK'event AND CLK = '1') then
      present_state <= next_state;
   end if;
end process sync_logic;

-- -------------------------------------------------------
next_state_logic : process(present_state, KEY, CNT_OF)
begin
   case (present_state) is
   -- - - - - - - - - - - - - - - - - - - - - - -
	
	-- checks each number
	when TEST_01 =>
		next_state <= TEST_01;
		if (KEY(2) = '1') then
			next_state <= TEST_02;
		elsif (KEY(15) = '1') then
         next_state <= PRINT_INCORRECT;
		elsif (KEY(14 downto 0) /= "000000000000000") then
			next_state <= WRONG;
		end if;
		
	when TEST_02 =>
		next_state <= TEST_02;
		if (KEY(0) = '1') then
			next_state <= TEST_03;
		elsif (KEY(15) = '1') then
         next_state <= PRINT_INCORRECT;
		elsif (KEY(14 downto 0) /= "000000000000000") then
			next_state <= WRONG;
		end if;
		
	when TEST_03 =>
		next_state <= TEST_03;
		if (KEY(5) = '1') then
			next_state <= TEST_04;
		elsif (KEY(15) = '1') then
         next_state <= PRINT_INCORRECT;
		elsif (KEY(14 downto 0) /= "000000000000000") then
			next_state <= WRONG;
		end if;
			
	when TEST_04 =>
		next_state <= TEST_04;
		if (KEY(0) = '1') then
			next_state <= TEST_05;
		elsif (KEY(15) = '1') then
         next_state <= PRINT_INCORRECT;
		elsif (KEY(14 downto 0) /= "000000000000000") then
			next_state <= WRONG;

		end if;
		
	when TEST_05 =>
		next_state <= TEST_05;
		if (KEY(9) = '1') then
			next_state <= TEST_06;
		elsif (KEY(15) = '1') then
         next_state <= PRINT_INCORRECT;
		elsif (KEY(14 downto 0) /= "000000000000000") then
			next_state <= WRONG;
		end if;
	
	when TEST_06 =>
		next_state <= TEST_06;
		if (KEY(9) = '1') then
			next_state <= CHOOSE_BRANCH;
		elsif (KEY(15) = '1') then
         next_state <= PRINT_INCORRECT;
		elsif (KEY(14 downto 0) /= "000000000000000") then
			next_state <= WRONG;
		end if;
		
	-- branches between 2 possible codes
	when CHOOSE_BRANCH =>
		next_state <= CHOOSE_BRANCH;
		if (KEY(3) = '1') then
			next_state <= TEST_12;
		elsif (KEY(5) = '1') then
			next_state <= TEST_22;
		elsif (KEY(15) = '1') then
			next_state <= PRINT_INCORRECT;
		elsif (KEY(14 downto 0) /= "000000000000000") then
			next_state <= WRONG;
		end if;
		
	-- first code continues
	when TEST_12 =>
		next_state <= TEST_12;
		if (KEY(8) = '1') then
			next_state <= TEST_13;
		elsif (KEY(15) = '1') then
			next_state <= PRINT_INCORRECT;
		elsif (KEY(14 downto 0) /= "000000000000000") then
			next_state <= WRONG;
		end if;
		
	when TEST_13 =>
		next_state <= TEST_13;
		if (KEY(9) = '1') then
			next_state <= TEST_14;
		elsif (KEY(15) = '1') then
			next_state <= PRINT_INCORRECT;
		elsif (KEY(14 downto 0) /= "000000000000000") then
			next_state <= WRONG;
		end if;
	
	when TEST_14 =>
		next_state <= TEST_14;
		if (KEY(9) = '1') then
			next_state <= LAST_CHAR;
		elsif (KEY(15) = '1') then
			next_state <= PRINT_INCORRECT;
		elsif (KEY(14 downto 0) /= "000000000000000") then
			next_state <= WRONG;
		end if;
	
	-- second code continues
	when TEST_22 =>
		next_state <= TEST_22;
		if (KEY(7) = '1') then
			next_state <= TEST_23;
		elsif (KEY(15) = '1') then
			next_state <= PRINT_INCORRECT;
		elsif (KEY(14 downto 0) /= "000000000000000") then
			next_state <= WRONG;
		end if;
	
	when TEST_23 =>
		next_state <= TEST_23;
		if (KEY(2) = '1') then
			next_state <= TEST_24;
		elsif (KEY(15) = '1') then
			next_state <= PRINT_INCORRECT;
		elsif (KEY(14 downto 0) /= "000000000000000") then
			next_state <= WRONG;
		end if;
		
	when TEST_24 =>
		next_state <= TEST_24;
		if (KEY(9) = '1') then
			next_state <= TEST_25;
		elsif (KEY(15) = '1') then
			next_state <= PRINT_INCORRECT;
		elsif (KEY(14 downto 0) /= "000000000000000") then
			next_state <= WRONG;
		end if;
		
	when TEST_25 =>
		next_state <= TEST_25;
		if (KEY(6) = '1') then
			next_state <= LAST_CHAR;
		elsif (KEY(15) = '1') then
			next_state <= PRINT_INCORRECT;
		elsif (KEY(14 downto 0) /= "000000000000000") then
			next_state <= WRONG;
		end if;
	
	when LAST_CHAR =>
		next_state <= LAST_CHAR;
		if (KEY(15) = '1') then
			next_state <= PRINT_CORRECT;
		elsif (KEY(14 downto 0) /= "000000000000000") then
			next_state <= WRONG;
		end if;
 
	
	-- code got wrong, if it finishes with #, then print incorrect
	-- else cycle through this option until # is pressed
	when WRONG =>
		if (KEY(15) = '1') then
			next_state <= PRINT_INCORRECT;
		else
			next_state <= WRONG;
		end if;
	
	when PRINT_INCORRECT =>
		next_state <= PRINT_INCORRECT;
		if (CNT_OF = '1') then
			next_state <= FINISH;
		end if;
	
	when PRINT_CORRECT =>
		next_state <= PRINT_CORRECT;
		if (CNT_OF = '1') then
			next_state <= FINISH;
		end if;
		
	when FINISH =>
		next_state <= FINISH;
		if (KEY(15) = '1') then
			next_state <= TEST_01;
		end if;
	
   when others =>
      next_state <= TEST_01;
   end case;
end process next_state_logic;

-- -------------------------------------------------------
output_logic : process(present_state, KEY)
begin
	-- everything is implicitly set to 0
   FSM_CNT_CE     <= '0';
   FSM_MX_MEM     <= '0';
   FSM_MX_LCD     <= '0';
   FSM_LCD_WR     <= '0';
   FSM_LCD_CLR    <= '0';

   case (present_state) is
   -- - - - - - - - - - - - - - - - - - - - - - -
   when PRINT_CORRECT =>
      FSM_CNT_CE     <= '1';
      FSM_MX_LCD     <= '1';
      FSM_LCD_WR     <= '1';
		-- choses the correct message
		FSM_MX_MEM		<= '1';
   -- - - - - - - - - - - - - - - - - - - - - - -
	when PRINT_INCORRECT =>
		FSM_CNT_CE     <= '1';
      FSM_MX_LCD     <= '1';
      FSM_LCD_WR     <= '1';
		-- chooses the wrong message
		FSM_MX_MEM		<= '0';
   -- - - - - - - - - - - - - - - - - - - - - - -	
   when FINISH =>
      if (KEY(15) = '1') then
			-- clears the LCD output
         FSM_LCD_CLR    <= '1';
      end if;
   -- - - - - - - - - - - - - - - - - - - - - - -
   when others =>
		if (KEY(15) = '1') then
			-- clears the LCD output when hash is pushed
			FSM_LCD_CLR <= '1';
		end if;
		if (KEY(14 downto 0) /= "000000000000000") then
			FSM_LCD_WR <= '1';
		end if;
		
   end case;
end process output_logic;

end architecture behavioral;

