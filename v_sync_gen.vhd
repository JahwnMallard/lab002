
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity v_sync_gen is
    port ( clk         : in  std_logic;
           reset       : in std_logic;
           h_blank     : in std_logic;
           h_completed : in std_logic;
           v_sync      : out std_logic;
           blank       : out std_logic;
           completed   : out std_logic;
           row         : out unsigned(10 downto 0)
     );
end v_sync_gen;

architecture Cooper of v_sync_gen is
	type states is (activeVideo, frontPorch, sync, backPorch);
	signal state_reg, state_next: states;
	signal clock_state, clock_next: unsigned(10 downto 0);
begin

	clock_next <= clock_state + 1;
	
	-- state register
   process(clk,reset)
   begin
		--clock_next <= clock_state +1;
      if (reset='1') then
         state_reg <= activeVideo;
			clock_state <= (others => '0');
      elsif (rising_edge(clk) and h_completed='1') then
         state_reg <= state_next;
			if(clock_state = 524) then
				clock_state <= (others => '0');
			else
				clock_state <= clock_next;
			end if;
      end if;
   end process;
	
	--Next State Logic
	process(clock_state) is
	begin
		state_next <= state_next;
		if(clock_state = 524) then
			state_next <= activeVideo;
		elsif(clock_state = 479) then
			state_next <= frontPorch;
		elsif(clock_state = 489) then
			state_next <= sync;
		elsif(clock_state = 491) then
			state_next <= backPorch;
		end if;
	end process;
	
	--Output Logic
	v_sync <= '0' when state_reg = sync else
				 '1';
	blank  <= '0' when state_reg = activeVideo else
	          '1';
	row <= clock_state when clock_state < 480 else
				 (others => '0');
	completed <= '1' when clock_state = 524 else
					 '0';
end Cooper;
