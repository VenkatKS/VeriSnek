
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/03/2015 03:27:03 PM
// Design Name: 
// Module Name: StrobeController
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module StrobeController(
    input CLK10HZ,
    input FLAG,
    output STROBE_CONTROL
    );
    
    reg[23:0] COUNTER;
    reg STROBE_CONTROL;
    reg INTERNAL_FLAG = 1'b0;
    
    reg INTERNAL_COUNTER = 1'b0;
    always @ (posedge CLK10HZ)
    begin
        case (FLAG)
            1'b0: 
                begin
                    if (COUNTER == 24'd1000000000)
                    begin
                        INTERNAL_COUNTER <= 1'b0;
                        STROBE_CONTROL = 1'b0;
                        COUNTER = 24'd1;
                    end
                    else
                    begin
                        COUNTER = COUNTER + 24'd1;
                    end
                end
            1'b1:
                begin
                    
                    if (INTERNAL_COUNTER == 1'b1)
                    begin
                    end
                    else
                    begin
                        COUNTER <= 24'd1;
                        STROBE_CONTROL <= 1'b1;
                        INTERNAL_COUNTER <= 1'b1;
                    end
                end
        endcase        
    end

endmodule