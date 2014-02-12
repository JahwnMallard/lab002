LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
 
ENTITY h_sync_test IS
END h_sync_test;
 
ARCHITECTURE behavior OF h_sync_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT h_sync_gen
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         h_sync : OUT  std_logic;
         blank : OUT  std_logic;
         completed : OUT  std_logic;
         column : OUT unsigned(10 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';

 	--Outputs
   signal h_sync : std_logic;
   signal blank : std_logic;
   signal completed : std_logic;
   signal column : unsigned(10 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: h_sync_gen PORT MAP (
          clk => clk,
          reset => reset,
          h_sync => h_sync,
          blank => blank,
          completed => completed,
          column => column
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      reset <='1';
      wait for 10 ns;	
      wait for clk_period*(3/4);
		reset <= '0';
		for I in 1 to 800 loop
			if(I=800) then
				assert completed = '1'
					report "HSyn did not correctly assert the completed signal when count was 800"
					severity error;
			else
				assert completed = '0'
					report "HSyn incorrectly asserted that completed was done before count reached 800."
					severity error;
			end if;	
			wait for clk_period;			
		end loop;

      -- insert stimulus here 

      wait;
   end process;

END;
