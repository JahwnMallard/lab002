library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library UNISIM;
use UNISIM.VComponents.all;

entity pong_control is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           up : in  STD_LOGIC;
           down : in  STD_LOGIC;
           v_completed : in  STD_LOGIC;
           ball_x : out  unsigned (10 downto 0);
           ball_y : out  unsigned (10 downto 0);
           paddle_y : out  unsigned (10 downto 0));
end pong_control;

architecture cooper of pong_control is

--Ball signals
signal posX, posX_next, posY, posY_next : unsigned(10 downto 0);
type states is (pos, neg, over);
signal x_reg, x_next: states;
signal y_reg, y_next: states;
signal count_reg, count_next: unsigned(10 downto 0);

begin
	
	--State register
	process (clk, reset) is
	begin
		if (reset = '1') then
			x_reg <= pos;
			y_reg <= pos;
			posX<="00111100000";
			posY<="00000010000";
			--padd_y <= (others => '1');
		elsif (rising_edge(clk)) then
			x_reg <= x_next;
			y_reg <= y_next;
			posX <= posX_next;
			posY <= posY_next;
		end if;
	end process;
	
	
	--Next state logic
   posX_next <= posX + 1 when (x_reg = pos) else
					 posX - 1;
	
	posY_next <= posY + 1 when (y_reg = pos) else
					 posY - 1;
	x_next<= pos when posX<15 else
				neg when posX>625 else
				x_reg;
	y_next<= pos when posY<15 else
				neg when posY>455 else
				y_reg;
				
	--Output logic
	ball_x <= posX;
	ball_y <= posY;
	paddle_y <= "00000000000";


end cooper;

