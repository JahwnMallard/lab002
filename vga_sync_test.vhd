
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
 
ENTITY vga_sync_test IS
END vga_sync_test;
 
ARCHITECTURE behavior OF vga_sync_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)  

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';

 	--Outputs
   signal h_sync : std_logic;
   signal v_sync : std_logic;
   signal v_completed : std_logic;
   signal blank : std_logic;
   signal row : unsigned(10 downto 0);
   signal column : unsigned(10 downto 0);
   signal h_sync2 : std_logic;
   signal v_sync2 : std_logic;
   signal v_completed2 : std_logic;
   signal blank2 : std_logic;
   signal row2 : unsigned(10 downto 0);
   signal column2 : unsigned(10 downto 0);
   -- Clock period definitions
   constant clk_period : time := 1 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: entity work.vga_sync(Cooper) PORT MAP (
          clk => clk,
          reset => reset,
          h_sync => h_sync,
          v_sync => v_sync,
          v_completed => v_completed,
          blank => blank,
          row => row,
          column => column
        );
	 uut2: entity work.vga_sync(moore) PORT MAP (
          clk => clk,
          reset => reset,
          h_sync => h_sync2,
          v_sync => v_sync2,
          v_completed => v_completed2,
          blank => blank2,
          row => row2,
          column => column2
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
      wait for 100 ns;	
      wait for clk_period*10.25;
		reset<='1';
		wait for clk_period;
		reset<='0';
      -- insert stimulus here 

      wait;
   end process;

END;
