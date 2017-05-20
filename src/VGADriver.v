module VGADriver(clk, S0, S1, S2, S3, S4, S5, S6, S7, R, G, B, hsync, vsync, Ready, Visible, SnakeRed, SnakeGreen, SnakeBlue, ACTIVE);
 
input clk;
input ACTIVE;
input S0, S1, S2, S3, S4, S5, S6, S7;
input[3:0] SnakeRed;
input[3:0] SnakeGreen;
input[3:0] SnakeBlue;
output reg[3:0] R = 4'd8;
output reg[3:0] G = 4'd0;
output reg[3:0] B = 4'd0; 
output reg Ready;
output hsync;
output vsync;
output Visible;

reg hsync = 1;
reg vsync = 1;
reg [9:0] hcount = 0;
reg [9:0] vcount = 0;
reg Visible;

reg color;
reg [3:0] Rvariable;
reg [3:0] Gvariable;
reg [3:0] Bvariable;


always @(posedge clk)
begin

if (S0 == 1)
begin
Rvariable = 4'd0;
Gvariable = 4'd0;
Bvariable = 4'd0;
end
else if (S1 == 1)
begin
Rvariable = 4'd15;
Gvariable = 4'd0;
Bvariable = 4'd15;
end
else if (S2 == 1)
begin
Rvariable = 4'd0;
Gvariable = 4'd6;
Bvariable = 4'd0;
end
else if (S3 == 1)
begin
Rvariable = 4'd0;
Gvariable = 4'd0;
Bvariable = 4'd10;
end
else if (S4 == 1)
begin
Rvariable = 4'd8;
Gvariable = 4'd0;
Bvariable = 4'd0;
end
else if (S5 == 1)
begin
Rvariable = 4'd15;
Gvariable = 4'd10;
Bvariable = 4'd0;
end
else if (S6 == 1)
begin
Rvariable = 4'd15;
Gvariable = 4'd15;
Bvariable = 4'd0;
end
else if (S7 == 1)
begin
Rvariable = 4'd15;
Gvariable = 4'd15;
Bvariable = 4'd15;
end
else 
begin
if (ACTIVE == 1)
begin
Rvariable = SnakeRed;
Gvariable = SnakeGreen;
Bvariable = SnakeBlue;
end
else
begin
Rvariable = 4'd0;
Gvariable = 4'd0;
Bvariable = 4'd0;
end
end

//hcount and vcount logic
if (hcount == 10'd799)
begin
	hcount = 10'd0;		//reached end of horizontal row
	if (vcount == 10'd524)
	begin
		vcount = 10'd0;
		Ready = 1;
	end
	else begin
		vcount = vcount + 1;
		Ready = 0;
	end
end
else 
begin
	hcount = hcount + 1;	
	Ready = 0;
	end


//logic for determining RGB values and the visible bit 

if ((hcount > 10'd639) || (vcount > 10'd479))
// in the blanking region
begin

//$display("point 1");
	Visible <= 0;
	R = 4'd0;
	G = 4'd0;
	B = 4'd0;

end

else begin
//$display("point 2");
	Visible <= 1;
	R = Rvariable;
	G = Gvariable;
	B = Bvariable;

end

//logic for hsync and vsync

//hsync
if ((hcount>10'd658)&&(hcount<10'd756))
begin
	
	hsync = 1'd0;
end
else begin
	hsync = 1'd1;
end

//vsync

if ((vcount>10'd492)&&(vcount<10'd495))
begin
	vsync = 1'd0;
end

else begin
	vsync = 1'd1;
end




end




endmodule 
