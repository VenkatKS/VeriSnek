`timescale 1ns / 1ps

module SevenSegmentDriver(
    input slow128,
    input[3:0] ones,
    input[3:0] tens,
    output[7:0] seg,
    output an,
    input DISPLAY_EN
    );
  
localparam  SEG1 = 4'b1110,
            SEG2 = 4'b1101;
            //SEG3 = 4'b1011,
            //SEG4 = 4'b0111;

reg[3:0] an = SEG1;
reg[3:0] pbInt;
wire slowCLKOut;
reg[3:0] multiPlex;
    
    always @ (an)
    begin
        if (an == SEG1)
        begin
            multiPlex = ones;
        end
        else if (an == SEG2)
        begin
            multiPlex = tens;
        end
    end    
    
    always@ (posedge slow128)
    begin
        if (an == SEG1)
        begin
            an = SEG2;
        end
        else if (an == SEG2)
        begin
            an = SEG1;
        end
        else
        begin
            an = SEG1;
        end
    end
    

    CathodeDriver segOne(multiPlex, displaySw, seg, DISPLAY_EN);
    
endmodule


module CathodeDriver (
  input[3:0] pbInt,
  input display,
  output [7:0] segInt,
  input Blinker);
  
localparam			OUT_ZERO 	 = 8'b11000000,
					OUT_ONE  	 = 8'b11111001,
					OUT_TWO  	 = 8'b10100100,
					OUT_THREE	 = 8'b10110000,
					OUT_FOUR 	 = 8'b10011001,
					OUT_FIVE     = 8'b10010010,
					OUT_SIX      = 8'b10000010,
					OUT_SEVEN    = 8'b11111000,
					OUT_EIGHT    = 8'b10000000,
					OUT_NINE     = 8'b10011000,
					OUT_TEN      = 8'b10001000,
					OUT_ELEVEN   = 8'b10000011,
					OUT_TWELVE   = 8'b11000110,
					OUT_THIRTEEN = 8'b10100001,
					OUT_FOURTEEN = 8'b10000110,
					OUT_FIFTEEN  = 8'b10001110,
					SWITCH_OFF   = 8'b11111111;

reg[7:0] segInt;

 always @* begin 
    if (Blinker == 1'd0) begin
        segInt[7:0] = SWITCH_OFF;
    end
    else if (pbInt == 4'h0) begin
      //segInt[7:0] = 8'b00001111;
      segInt[7:0] = OUT_ZERO;
      //anInt[0] = segInt;
    end
    else if (pbInt == 4'd1)
    begin
      segInt[7:0] = OUT_ONE;
    end

    else if (pbInt == 4'd2)
    begin
    	segInt[7:0] = OUT_TWO;
    end

    else if (pbInt == 4'd3)
    begin
    	segInt[7:0] = OUT_THREE;
    end
    
    else if (pbInt == 4'd4)
    begin
        segInt[7:0] = OUT_FOUR;
    end
    
    else if (pbInt == 4'd5)
    begin
        segInt[7:0] = OUT_FIVE;
    end
    
    else if (pbInt == 4'd6)
    begin
        segInt[7:0] = OUT_SIX;
    end
    
    else if (pbInt == 4'd7)
    begin
        segInt[7:0] = OUT_SEVEN;
    end
    
    else if (pbInt == 4'd8)
    begin
        segInt[7:0] = OUT_EIGHT;
    end
    
    else if (pbInt == 4'd9)
    begin
        segInt[7:0] = OUT_NINE;
    end
    else if (pbInt == 4'ha)
    begin
        segInt[7:0] = OUT_TEN;
    end
    else if (pbInt == 4'hb)
    begin
        segInt[7:0] = OUT_ELEVEN;
    end
    else if (pbInt == 4'hc)
    begin
        segInt[7:0] = OUT_TWELVE;
    end
    else if (pbInt == 4'hd)
    begin
        segInt[7:0] = OUT_THIRTEEN;
    end
    else if (pbInt == 4'he)
    begin
        segInt[7:0] = OUT_FOURTEEN;
    end
    else if (pbInt == 4'hf)
    begin
        segInt[7:0] = OUT_FIFTEEN;
    end
    else
    begin
        segInt[7:0] = OUT_ZERO;
    end



    
   end

endmodule
