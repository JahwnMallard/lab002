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
			  faster: in STD_LOGIC;
			  random: in STD_LOGIC;
           v_completed : in  STD_LOGIC;
           ball_x : out  unsigned (10 downto 0);
           ball_y : out  unsigned (10 downto 0);
           paddle_y : out  unsigned (10 downto 0));
end pong_control;

architecture cooper of pong_control is

--Constants
constant ball_width: integer := 10;
constant paddle_height: integer :=50;
constant screen_height: integer := 480;
constant screen_width: integer := 640;
constant paddle_width: integer :=10;

--Ball signals
signal posX, posX_next, posY, posY_next, posPad, posPad_next : unsigned(10 downto 0);
type states is (pos, neg, over);
signal x_reg, x_next: states;
signal y_reg, y_next: states;
signal count_reg, count_next: unsigned(15 downto 0);

begin
	
	--State register
	process (clk, reset) is
	begin
		if (reset = '1') then
			x_reg <= pos;
			y_reg <= pos;
			posX<="00111100000";
			posY<="00000010000";
			posPad<="00000000000";
		elsif (rising_edge(clk)) then
			x_reg <= x_next;
			y_reg <= y_next;
			posX <= posX_next;
			posY <= posY_next;
			posPad<= posPad_next;
		end if;
	end process;
	
	--counter register	
	count_next <= count_reg + 1;
	process(clk, reset)
	begin
		if(reset='1') then
			count_reg <= (others =>'1');
		elsif(rising_edge(clk) and v_completed='1') then
			if(count_reg=1001) then
				count_reg <= (others=>'0');
			else
				count_reg <= count_next;
			end if;
		end if;
	end process;

	--Next position logic
   posX_next <= posX when x_reg = over else
					 posX + 1  when ((x_reg = pos) and (count_reg=1000)) or ( x_reg=pos and faster ='1' and (count_reg mod 200 =0)) else
					 posX - 1  when (count_reg=1000 and x_reg=neg) or (faster='1' and (count_reg mod 200 =0) and x_reg=neg) else
					 posX;
	
	posY_next <= posy when y_reg = over else
					 posY + 1  when ((y_reg = pos) and (count_reg=1000))or ( y_reg=pos and faster ='1' and (count_reg mod 200 =0)) else
					 posY - 1  when (count_reg=1000 and y_reg=neg) or (faster='1' and (count_reg mod 200 =0) and y_reg=neg) else
					 posY;
	posPad_next <= posPad when x_reg=over or y_reg=over else
						posPad + 1 when down='1' and posPad<screen_height-paddle_height and (count_reg mod 100=0) else
						posPad -1 when up='1' and posPad>0 and (count_reg mod 100 =0) else
						posPad;
	--Next state logic				
	x_next<= over when x_reg=over else
				over when ((posY+ball_width<posPad) and posX-ball_width<=1) or ((posY-ball_width>posPad+paddle_height) and posX-ball_width<=1) else
				pos when posX<=ball_width else
				neg when posX>=screen_width-ball_width else
				pos when ((posY<posPad+paddle_height) and (posY>posPad)) and (posX-ball_width<paddle_width) else
				x_reg;
	y_next<= over when y_reg=over else
				over when x_next=over or x_reg=over else
				pos when posY<=ball_width else
				neg when posY>=screen_height-ball_width else
				neg when posX_next-ball_width<paddle_width and random='1' and posY<posPad+paddle_height/2 else
				pos when posX_next-ball_width<paddle_width and random='1' and posY>=posPad+paddle_height/2 else
				y_reg;
			
	--Output logic
	ball_x <= posX;
	ball_y <= posY;
	paddle_y <= posPad;


end cooper;

