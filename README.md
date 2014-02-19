#Lab 2
##Introduction
The purpose of this lab was to use the VGA driver previously implemented in order to implement a simplified version of the classic Pong game.  This lab was based a FSM lab from the 6.1111 MIT course.  To verify that the pong functionality had been fully met, several grading criteria were used.  The game needed to implement:

 1. A moving button controlled paddle  
 2. An end game state when the user missed the ball and it hit the left wall  
 3. The ball bouncing off the top, right and bottom wall  
 4. A switch to increase the speed of the ball
 5. Ball bounce determined from the position of the paddle it hits 

##Implementation

##Code

##Testing and Debugging
Several issues arose during the implementation of the prong control.
###Ball Speed Problem
The first significant problem was the movement speed of the ball being incredibly fast.  After testing a couple different methods, using a counter with the V_Completed signal allowed for the speed of the ball to be slowed down to a reasonable speed.  The follow fix is contained in a process statement to ensure it stays synchronous.  The magic number in this instance should be replaced during a refactor of the code.
```vhdl
1 elsif(rising_edge(clk) and v_completed='1') then
2  			if(count_reg=1001) then
3  				count_reg <= (others=>'1');
4  			else
5  				count_reg <= count_next;
6  			end if;
7  		end if;
```
###Ball Teleportation Problem
However, the keen eye might see that the above code introduced a new bug into the code.  The code segment on line 3 failed to reset the counter back to zero, causing the signal containing the counter to run over and eventually start back at zero.  Again, the problem could be pinpointed to line three in this code:
```vhdl
2  			if(count_reg=1001) then
3  				count_reg <= (others=>'1');
```

##Conclusion
The amount of time needed to implement full functionality for this lab was much less than the first.  This most likely can be attributed to significant decrease in the amount of process statements that were used to implement the design.  The use of constants and a working change log in the current working VHDL file help keep things sane as the amount of code grew in size.  
##Documentation
None