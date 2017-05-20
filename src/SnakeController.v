
module DisplayDriver(
    input      CLK,
    input      TRANSMIT,
    input[9:0] SnakeX,
    input[9:0] SnakeY,
    input[3:0] SnakeSize,
    input[1:0] SnakeDir,
    output reg[3:0]     DATA_R,
    output reg[3:0]     DATA_B,
    output reg[3:0]     DATA_G
    );
    
    localparam  WIDTH_PIXEL_SIZE    = 10'd10,
                LENGTH_PIXEL_SIZE   = 10'd50,
                LEFT                = 2'b10,
                RIGHT               = 2'b00,
                UP                  = 2'b11,
                DOWN                = 2'b01,
                BG_RED              = 4'b0000,
                BG_BLUE             = 4'b1111,
                BG_GREEN            = 4'b0000,
                SNAKE_RED           = 4'b1111,
                SNAKE_BLUE          = 4'b0000,
                SNAKE_GREEN         = 4'b0000;
                               
    
    reg[9:0] hcount   = 10'd0;     // Horizontal Axis
    reg[9:0] vcount   = 10'd0;     // veritcal axis
            
    
    // Position updates
    reg[9:0] CORNER_1_X;
    reg[9:0] CORNER_1_Y;
    
    reg[9:0] CORNER_2_X;
    reg[9:0] CORNER_2_Y;
    
    reg[9:0] CORNER_3_X;
    reg[9:0] CORNER_3_Y;
    
    reg[9:0] CORNER_4_X;
    reg[9:0] CORNER_4_Y;

    always @ (SnakeDir or SnakeX or SnakeY)
    begin
        if (SnakeDir == DOWN) // Going right and then turning down
        begin
            CORNER_1_X = SnakeX + 10'd5;
            CORNER_1_Y = SnakeY;
            
            CORNER_2_X = SnakeX - 10'd5;
            CORNER_2_Y = SnakeY;
            
            CORNER_3_X = SnakeX + 10'd5;
            CORNER_3_Y = SnakeY - (LENGTH_PIXEL_SIZE / 10'd2);
            
            CORNER_4_X = SnakeX - 10'd5;
            CORNER_4_Y = SnakeY - (LENGTH_PIXEL_SIZE / 10'd2);
        end 
        else if (SnakeDir == UP)
        begin
            CORNER_1_X = SnakeX + 10'd5;
            CORNER_1_Y = SnakeY;
        
            CORNER_2_X = SnakeX - 10'd5;
            CORNER_2_Y = SnakeY;
        
            CORNER_3_X = SnakeX + 10'd5;
            CORNER_3_Y = SnakeY + (LENGTH_PIXEL_SIZE / 10'd2);
        
            CORNER_4_X = SnakeX - 10'd5;
            CORNER_4_Y = SnakeY + (LENGTH_PIXEL_SIZE / 10'd2);
        end
        
        else if (SnakeDir == RIGHT)
        begin
            CORNER_1_X = SnakeX;
            CORNER_1_Y = SnakeY - 10'd5;
        
            CORNER_2_X = SnakeX;
            CORNER_2_Y = SnakeY + 10'd5;
        
            CORNER_3_X = SnakeX - (LENGTH_PIXEL_SIZE/10'd2);
            CORNER_3_Y = SnakeY - 10'd5;
        
            CORNER_4_X = SnakeX - (LENGTH_PIXEL_SIZE/10'd2);
            CORNER_4_Y = SnakeY + 10'd5;
        end
        
        else if (SnakeDir == LEFT)
        begin
            CORNER_1_X = SnakeX;
            CORNER_1_Y = SnakeY - 10'd5;
    
            CORNER_2_X = SnakeX;
            CORNER_2_Y = SnakeY + 10'd5;
    
            CORNER_3_X = SnakeX + (LENGTH_PIXEL_SIZE/10'd2);
            CORNER_3_Y = SnakeY - 10'd5;
    
            CORNER_4_X = SnakeX + (LENGTH_PIXEL_SIZE/10'd2);
            CORNER_4_Y = SnakeY + 10'd5;
        end

    end

    always @ (posedge CLK)
    begin
        if (TRANSMIT == 1'b1)
        begin
            if (hcount == 10'd639)
            begin
                hcount = 10'd0;        //reached end of horizontal row
                if (vcount == 10'd479)
                begin
                    vcount = 10'd0;
                end
                else 
                begin
                    vcount = vcount + 1;
                end
            end
            else 
            begin
                hcount = hcount + 1;    
            end
        end
        
        case(SnakeDir)
            2'b00: // Right
            begin
                if ((hcount < CORNER_1_X && vcount > CORNER_1_Y) && (hcount < CORNER_2_X && vcount < CORNER_2_Y) && (hcount > CORNER_3_X && vcount > CORNER_3_Y) && (hcount > CORNER_4_X && vcount < CORNER_4_Y))
                begin
                    DATA_R <= SNAKE_RED;
                    DATA_B <= SNAKE_BLUE;
                    DATA_G <= SNAKE_GREEN;
                end 
                else
                begin
                    DATA_R <= 4'b0000;
                    DATA_B <= 4'b0000;
                    DATA_G <= 4'b0000;
                end
             end
             2'b01: // Down
             begin
                if ((hcount < CORNER_1_X && vcount < CORNER_1_Y) && (hcount > CORNER_2_X && vcount < CORNER_2_Y) && (hcount < CORNER_3_X && vcount > CORNER_3_Y) && (hcount > CORNER_4_X && vcount > CORNER_4_Y))
                begin
                    DATA_R <= SNAKE_RED;
                    DATA_B <= SNAKE_BLUE;
                    DATA_G <= SNAKE_GREEN;
                end
                else
                begin
                    DATA_R <= 4'b0000;
                    DATA_B <= 4'b0000;
                    DATA_G <= 4'b0000;
                end
             end
             2'b10: // Left
             begin
                if ((hcount > CORNER_1_X && vcount > CORNER_1_Y) && (hcount > CORNER_2_X && vcount < CORNER_2_Y) && (hcount < CORNER_3_X && vcount > CORNER_3_Y) && (hcount < CORNER_4_X && vcount < CORNER_4_Y))
                begin
                    DATA_R <= SNAKE_RED;
                    DATA_B <= SNAKE_BLUE;
                    DATA_G <= SNAKE_GREEN;
                end 
                else
                begin
                    DATA_R <= 4'b0000;
                    DATA_B <= 4'b0000;
                    DATA_G <= 4'b0000;
                end 
             end
             2'b11: //Up
             begin
                if ((hcount < CORNER_1_X && vcount > CORNER_1_Y) && (hcount > CORNER_2_X && vcount > CORNER_2_Y) && (hcount < CORNER_3_X && vcount < CORNER_3_Y) && (hcount > CORNER_4_X && vcount < CORNER_4_Y))
                begin
                    DATA_R <= SNAKE_RED;
                    DATA_B <= SNAKE_BLUE;
                    DATA_G <= SNAKE_GREEN;
                end
                else
                begin
                    DATA_R <= 4'b0000;
                    DATA_B <= 4'b0000;
                    DATA_G <= 4'b0000;
                end              
             end
             default:
             begin
                    DATA_R <= 4'b0000;
                    DATA_B <= 4'b0000;
                    DATA_G <= 4'b0000;
             end
        endcase
    end

 
 
 
 
 
 
 
 
 
 
 
 
    
    
    
        
    
    
    
    
    
endmodule