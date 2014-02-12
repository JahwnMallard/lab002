
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity h_sync_gen is
    port ( clk       : in  std_logic;
           reset     : in  std_logic;
           h_sync    : out std_logic;
           blank     : out std_logic;
           completed : out std_logic;
           column    : out unsigned(10 downto 0)
     );
end h_sync_gen;

architecture Cooper of h_sync_gen is
	type states is (activeVideo, frontPorch, sync, backPorch);
	signal state_reg, state_next: states;
	signal clock_state, clock_next: unsigned(10 downto 0);
begin

	-- state register
   process(clk,reset)
   begin
      if (reset='1') then
         state_reg <= activeVideo;
			clock_state <= (others => '0');
      elsif (clk'event and clk='1') then
         state_reg <= state_next;
			clock_state <= clock_next;
      end if;
   end process;
	
	--Next State Logic
	process(clk) is
	begin
			clock_next <= clock_state +1;
			state_next <= state_next;
			if(clock_state = 799) then
				state_next <= activeVideo;
				clock_next <= (others => '0');
			elsif(clock_state = 639) then
				state_next <= frontPorch;
			elsif(clock_state = 655) then
				state_next <= sync;
			elsif(clock_state = 751) then
				state_next <= backPorch;
			end if;
	end process;
	
	--Output Logic
	h_sync <= '0' when state_reg = sync else
				 '1';
	blank  <= '0' when state_reg = activeVideo else
	          '1';
	column <= clock_state when clock_state < 640 else
				 (others => '0');
	completed <= '1' when clock_state = 799 else
					 '0';

end Cooper;

