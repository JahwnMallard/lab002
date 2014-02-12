----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library UNISIM;
use UNISIM.VComponents.all;

entity pong_pixel_gen is
    Port ( row : in  unsigned (10 downto 0);
           column : in  unsigned (10 downto 0);
           blank : in  STD_LOGIC;
           ball_x : in  unsigned (10 downto 0);
           ball_y : in  unsigned (10 downto 0);
           paddle_y : in  unsigned (10 downto 0);
           r : out  STD_LOGIC_VECTOR (7 downto 0);
           g : out  STD_LOGIC_VECTOR (7 downto 0);
           b : out  STD_LOGIC_VECTOR (7 downto 0));
end pong_pixel_gen;

architecture cooper of pong_pixel_gen is

begin

b<="00000000"  when blank ='1' else
	"11111111" when (column<=200 and column>=160) and (row>=100 and row<=380) else
	"11111111" when (column<=260 and column>=200) and (row>=100 and row<=130) else
	"11111111" when (column<=260 and column>=200) and (row>=230 and row<=260) else
	"11111111" when (column<=300 and column>=260) and (row>=100 and row<=380) else
	"11111111" when (column<=400 and column>=360) and (row>=100 and row<=380) else
	"11111111" when (column<=500 and column>=400) and (row>=100 and row<=130) else
	"11111111" when (column<=500 and column>=400) and (row>=230 and row<=260) else
	"00000000";
r<= "00000000" when blank ='1' else
	 "11111111" when (column<=10) and (row>=paddle_y and row<=paddle_y+50) else
	 "00000000";
g <="00000000" when blank='1' else
	 "11111111" when (column>=ball_x-30 and column<=ball_x+30) and (row<=ball_y+30 and row>=ball_y-30) else
	 "00000000";

end cooper;

