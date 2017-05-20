module GameController(CLK, UP, DOWN, LEFT, RIGHT, Escape, Pause, Start, Resume, X, Y, Size, Dir, Playing);

input CLK, UP, DOWN, LEFT, RIGHT, Escape, Start, Pause, Resume;
output X, Y, Size, Dir, Playing;

wire [9:0] X;
wire [9:0] Y;
reg [9:0] Xin = 60;
reg [9:0] Yin = 60;
reg [3:0] Size = 2;
reg [1:0] Dir = 0;		//convention: 00 is right, 01 (1) is down, 10 (2) is left, 11 (3) is up
reg Paused = 0;
reg Playing = 0;
reg oldDir = 1;
//reg [1:0] turn;			//this code is used to see if there is a current turn that needs to be taken. 
//assign statments for X and Y based on Xin and Yin go here
assign X = (Dir == 2'd0) ? Xin : ((Dir == 2'd2) ? (Xin - 83) : (Xin - 42));
assign Y = (Dir == 2'd1) ? (Yin - 38) : ((Dir == 2'd3) ? (Yin+38) : Yin); 


always @(posedge CLK)
begin
	

	//following code increments position based on current direction 
	if (Playing && !Paused) begin
		if (Dir == 2'd0) begin
			Xin = Xin + 1;
		end
		else if (Dir == 2'd1) begin
			Yin = Yin - 1;
		end
		else if (Dir == 2'd2) begin
			Xin = Xin - 1;
		end
		else begin
			Yin = Yin + 1;
		end

	end
	else if (!Playing) begin
		Xin = 60;
		Yin = 60;		//initialize to start coordinates for once the game begins again
	end


end

always @(Escape, Start, Pause, Resume)
begin
	
if (Playing == 0)		//game is currently  black screen - not playing 
begin
	if (Start ==1)		// check to see if start button is pressed, if so, start the game
	begin
		Playing = 1;	//start button is pressed - start the game 
	
	end

end

else begin                //so game is currently playing right now 

	if (Escape == 1) begin    //escape is pressed while game is playing, so end the game 
		Playing = 0;
	end
	
	else if (Paused == 0)     //check to see if it is not paused 
	begin
		if (Pause == 1)		//pause is pressed while game is playing and unpaused
		begin
			Paused = 1;		//pause the game 
		end
		else if ((Dir == 2'd1)||(Dir == 2'd3))	//snake is moving vertically - need to check for horizontal keypresses
		begin
			if (LEFT)
			begin
				oldDir = Dir;
				Dir = 2'd2;
			end
			else if (RIGHT)
			begin
				oldDir = Dir;
				Dir = 2'd0;
			end			
		end
		else begin   //snake must be moving horizontally - check for vertical key presses
			if (UP) begin
				oldDir = Dir;
				Dir = 2'd3;
			end
			if (DOWN) begin
				oldDir = Dir;
				Dir = 2'd1;
			end
		end
	end
	else begin   //so the game is paused - check to see if resume has been pressed 
		if (Resume == 1) begin
			Paused = 0;
		end	
	end
end


end

endmodule


//notes:
//need to 40 pixels per second. 
//each screen takes .0168 seconds to display.
//this means that hte game is incrementing about every .0168 seconds
//40 pixels/second ---->  .672 pixels/.0168 seconds. damn 
//will estimate to 1 pixel/.0168 seconds