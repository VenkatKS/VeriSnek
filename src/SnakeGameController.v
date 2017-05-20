`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/07/2015 11:54:56 AM
// Design Name: 
// Module Name: SnakeGameController
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


module SnakeGameController(
    input CLK40HZ, // 40 HZ clock
    input ESC,
    input R,
    input S,
    input P,
    input UP,
    input DOWN,
    input LEFT,
    input RIGHT,
    output[9:0] XPOS,
    output[9:0] YPOS,
    output[1:0] SnakeDir,
    output[2:0] GAME_DONEX
    );
    
    reg GAME_RUNNING = 1'b1;
    reg GAME_DONE    = 1'b0;
    reg SNAKE_HIT    = 1'd0;
    assign GAME_DONEX[0] = SNAKE_HIT;
    assign GAME_DONEX[1] = GAME_DONE;
    assign GAME_DONEX[2] = GAME_PAUSED;
    reg GAME_PAUSED = 1'd0;
    
    reg[9:0] SnakeX     = 10'd100;
    reg[9:0] SnakeY     = 10'd100;
    reg[1:0] SnDir_INT  = 2'd00;
    reg[1:0] DR_HOLD;
    //assign XPOS = SnakeX;
    //assign YPOS = SnakeY;
    
    assign SnakeDir = SnDir_INT;
    assign XPOS = (SnDir_INT == 2'd0) ? SnakeX : ((SnDir_INT == 2'd2) ? (SnakeX - 33) : (SnakeX - 7));
    assign YPOS = (SnDir_INT == 2'd1) ? (SnakeY + 17) : ((SnDir_INT == 2'd3) ? (SnakeY-17) : SnakeY); 
    always @ (P or R)
    begin
        if (P == 1'd1) 
        begin
            DR_HOLD = SnDir_INT;
            GAME_PAUSED = 1'b1;
        end
        if (R == 1'd1) 
        begin
            GAME_PAUSED = 1'b0;
        end
    end
    
    always @ (ESC or S)
    begin
        if (S == 1) GAME_DONE = 1'b0;
        if (ESC == 1) GAME_DONE = 1'b1;    
    end
    
    always @ (posedge CLK40HZ)
    begin
        if (SnakeX <  10'd2 || SnakeX >= 10'd639)
        begin
            SNAKE_HIT = 1'b1;
        end
        
        if (SnakeY < 10'd2 || SnakeY >= 10'd479)
        begin
            SNAKE_HIT = 1'b1;
        end
            
        if (S == 1)
        begin
            SnakeX = 10'd100;
            SnakeY = 10'd100;
            SNAKE_HIT = 1'b0;
        end
        if (GAME_DONE == 1'b1 && ESC == 1)
        begin
            SnakeX = 10'd700;
            SnakeY = 10'd500;
        end
        
        case (SnakeDir)
            2'b00: // Right
            begin
                if (GAME_DONE == 1'b0 && SNAKE_HIT == 1'b0) 
                begin
                    if (GAME_PAUSED == 1'b0) SnakeX = SnakeX + 10'd1;
                    else SnakeX = SnakeX;
                end 
                else 
                begin
                    SnakeX = SnakeX;
                end
            end
            2'b01: // Down
            begin
                if ((GAME_DONE == 1'b0) && SNAKE_HIT == 1'b0) 
                begin
                    if (GAME_PAUSED == 1'b0) SnakeY = SnakeY + 10'd1;
                    else SnakeY = SnakeY;
                end 
                else
                begin
                    SnakeY = SnakeY;
                end
            end
            2'b10: // Left
            begin
                if ((GAME_DONE == 1'b0) && SNAKE_HIT == 1'b0) 
                begin
                    if (GAME_PAUSED == 1'b0) SnakeX = SnakeX - 10'd1;
                    else SnakeX = SnakeX;
                end
                else
                begin
                    SnakeX = SnakeX;
                end
            end
            2'b11: // Up
            begin
                if (GAME_DONE == 1'b0 && SNAKE_HIT == 1'b0) 
                begin
                    if (GAME_PAUSED == 1'b0) SnakeY = SnakeY - 10'd1;
                    else SnakeY = SnakeY;
                end
                else
                begin
                    SnakeY = SnakeY;
                end
            end
        endcase
    end
    
    always @ (UP or DOWN or LEFT or RIGHT or S)
    begin
        if (S == 1)
        begin
            SnDir_INT = 2'b00;
        end

        if (UP == 1)
        begin
            if (GAME_PAUSED == 1'b0 && GAME_DONE == 1'b0 && SNAKE_HIT == 1'b0)  SnDir_INT = 2'b11; 
            else SnDir_INT = SnDir_INT;
        end
        else if (DOWN == 1)
        begin
            if (GAME_PAUSED == 1'b0 && GAME_DONE == 1'b0 && SNAKE_HIT == 1'b0)  SnDir_INT = 2'b01;
            else SnDir_INT = SnDir_INT;
        end
        else if (LEFT == 1'b1)
        begin
            if (GAME_PAUSED == 1'b0 && GAME_DONE == 1'b0 && SNAKE_HIT == 1'b0)  SnDir_INT = 2'b10;
            else SnDir_INT = SnDir_INT;
        end
        else if (RIGHT == 1'b1)
        begin
             if (GAME_PAUSED == 1'b0 && GAME_DONE == 1'b0 && SNAKE_HIT == 1'b0) SnDir_INT = 2'b00;
             else SnDir_INT = SnDir_INT;
        end
        else
        begin
            SnDir_INT = SnDir_INT;
        end
    end
    
    //assign SnakeDir = (UP == 1'b1) ? 2'b11 : (DOWN == 1'b1) ? 2'b01 : (LEFT == 1'b1) ? 2'b10 : 2'b00; 

endmodule
