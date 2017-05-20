`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/02/2015 05:45:37 PM
// Design Name: 
// Module Name: Driver
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


module Driver(
    CLKBoard,
    KEYSIG_DATA,
    KEYSIG_CLK,
    KEYSIG_STROBE,
    seg,
    an,
    R_VAL,
    G_VAL,
    B_VAL,
    hSYNC,
    vSYNC,
    S0,
    S1,
    S2,
    S3,
    S4,
    S5,
    S6,
    S7,
    debugger
   );
    
    input CLKBoard;
    input KEYSIG_DATA;
    input KEYSIG_CLK;
    input S0, S1, S2, S3, S4, S5, S6, S7;
    output KEYSIG_STROBE;
    wire[7:0] LED_DATA;
    output[7:0] seg;
    output[3:0] an;
    
    // Port definitions
    // CLKBoard: 100 MHz clock from the board
    
    // Clock speeds are self descriptive
    
    // Clock Architecture
    wire HZ1_CLK;
    wire HZ2_CLK;
    wire HZ128_CLK;
    wire HZ25M_CLK;
    wire HZ5_CLK;
    wire HZ40_CLK;
    
    CLKSignals CLKController(CLKBoard, HZ1_CLK, HZ2_CLK, HZ128_CLK, HZ25M_CLK, HZ5_CLK, HZ40_CLK);
    
    // PS2 Controller   
    wire NewData; 
    
    wire KEYPRESS_S,
    KEYPRESS_P,
    KEYPRESS_R,
    KEYPRESS_ESC,
    KEYPRESS_UP,
    KEYPRESS_DOWN,
    KEYPRESS_LEFT,
    KEYPRESS_RIGHT;
    
    output[3:0] debugger;

    assign debugger[0] = GAME_RUN[0];
    assign debugger[1] = GAME_RUN[1];
    assign debugger[2] = GAME_RUN[2];
    assign debugger[3] = KEYPRESS_ESC;
    
    PS2Controller KeyboardDriver(KEYSIG_CLK, KEYSIG_DATA, LED_DATA, HZ5_CLK, NewData, KEYPRESS_S,
    KEYPRESS_P, KEYPRESS_R, KEYPRESS_ESC, KEYPRESS_UP, KEYPRESS_DOWN, KEYPRESS_LEFT, KEYPRESS_RIGHT);
    // 7 Segment Display
    SevenSegmentDriver LcdMod(HZ128_CLK, LED_DATA[3:0], LED_DATA[7:4], seg, an, 1'b1);
    // Strobe light controller
    StrobeController  Blinker(CLKBoard, NewData, KEYSIG_STROBE);
    
    // VGA Driver    
    output wire[3:0] R_VAL;
    output wire[3:0] B_VAL;
    output wire[3:0] G_VAL;
    output wire hSYNC;
    output wire vSYNC;
    wire RDY;
    
    wire[3:0] SnakeRed;
    wire[3:0] SnakeBlue;
    wire[3:0] SnakeGreen;
    wire TEMP;

    // Replace with game logic
    wire[9:0] XPOS;
    wire[9:0] YPOS;
    wire[9:0] SIZE;
    wire[1:0] SNDIR;
    wire      ACTIVE = 1'd1;
    wire[2:0]      GAME_RUN;
    
    //GameController SnakeGameSystem(TEMP, KEYPRESS_UP, KEYPRESS_DOWN, KEYPRESS_LEFT, KEYPRESS_RIGHT, KEYPRESS_ESC, KEYPRESS_P, KEYPRESS_S, KEYPRESS_R, XPOS, YPOS, SIZE, SNDIR,ACTIVE);

    DisplayDriver     DDriver(HZ25M_CLK, RDY, XPOS, YPOS, SIZE, SNDIR, SnakeRed, SnakeBlue, SnakeGreen);

    VGADriver         MonitorDriver(HZ25M_CLK, S0, S1, S2, S3, S4, S5, S6, S7, R_VAL, G_VAL, B_VAL, hSYNC, vSYNC, TEMP, RDY, SnakeRed, SnakeGreen, SnakeBlue, ACTIVE);
    
    // Game controller
    SnakeGameController Snake(HZ40_CLK, KEYPRESS_ESC, KEYPRESS_R, KEYPRESS_S, KEYPRESS_P, KEYPRESS_UP, 
                                KEYPRESS_DOWN, KEYPRESS_LEFT, KEYPRESS_RIGHT, XPOS, YPOS, SNDIR, GAME_RUN);
     

endmodule
