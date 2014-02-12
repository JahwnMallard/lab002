LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
 
ENTITY v_sync_test IS
END v_sync_test;
 
ARCHITECTURE behavior OF v_sync_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT v_sync_gen
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         h_blank : IN  std_logic;
         h_completed : IN  std_logic;
         v_sync : OUT  std_logic;
         blank : OUT  std_logic;
         completed : OUT  std_logic;
         row : OUT  unsigned(10 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal h_blank : std_logic := '0';
   signal h_completed : std_logic := '0';

 	--Outputs
   signal v_sync : std_logic;
   signal blank : std_logic;
   signal completed : std_logic;
   signal row : unsigned(10 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: v_sync_gen PORT MAP (
          clk => clk,
          reset => reset,
          h_blank => h_blank,
          h_completed => h_completed,
          v_sync => v_sync,
          blank => blank,
          completed => completed,
          row => row
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
	
   h_proc :process
   begin
		h_completed <= '0';
		wait for clk_period * 799;
		h_completed <= '1';
		wait for clk_period;
   end process; 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
		h_blank<= '0';
		reset <= '1';
      wait for clk_period*(7/4);
		reset <= '0';
		for I in 0 to 525 loop
			if(I=525) then
				assert completed = '1'
					report "VSyn did not correctly assert the completed signal when count was 800"
					severity error;
			else
				assert completed = '0'
					report "VSyn incorrectly asserted that completed was done before count reached 800."
					severity error;
			end if;	
			wait for clk_period;			
		end loop;

      wait;
   end process;

END;