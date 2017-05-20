`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/02/2015 05:43:43 PM
// Design Name: 
// Module Name: CLKSignals
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


module CLKSignals(
    input CLKFast,
    output HZ1,
    output HZ2,
    output HZ128,
    output HZ25M,
    output HZ5,
    output HZ40
    );
    
    HUNDREDHZCLK hz128clk(CLKFast, HZ128);
    ONEHZCLK hz1clk(CLKFast, HZ1);
    TWOHZCLK hz2clk(CLKFast, HZ2);
    TWENTYFIVEMEGCLK hz25mclk(CLKFast, HZ25M);
    FIVEHZCLK CLKFst(CLKFast, HZ5);
    FORTYHZCLK Clk40(CLKFast, HZ40);
endmodule

module FORTYHZCLK(clk100Mhz, slow40HZ);
input clk100Mhz; //fast clock
output reg slow40HZ; //slow clock
reg[27:0] counter;
initial
begin
  counter = 0;
  slow40HZ = 0;
end

always @ (posedge clk100Mhz)
begin
  if(counter == 1250000) begin
    counter <= 1;
    slow40HZ <= ~slow40HZ;
  end
  else begin
    counter <= counter + 1;
  end
end
endmodule

module FIVEHZCLK(clk100Mhz, slowClk50M);
input clk100Mhz; //fast clock
output reg slowClk50M; //slow clock
reg[27:0] counter;
initial
begin
  counter = 0;
  slowClk50M = 0;
end

always @ (posedge clk100Mhz)
begin
  if(counter == 10000000) begin
    counter <= 1;
    slowClk50M <= ~slowClk50M;
  end
  else begin
    counter <= counter + 1;
  end
end
endmodule


module TWENTYFIVEMEGCLK(clk100Mhz, slowClk50M);
input clk100Mhz; //fast clock
output reg slowClk50M; //slow clock
reg[27:0] counter;
initial
begin
  counter = 0;
  slowClk50M = 0;
end

always @ (posedge clk100Mhz)
begin
  if(counter == 2) begin
    counter <= 1;
    slowClk50M <= ~slowClk50M;
  end
  else begin
    counter <= counter + 1;
  end
end
endmodule

module HUNDREDHZCLK(clk100Mhz, slowClk128);
  input clk100Mhz; //fast clock
  output reg slowClk128; //slow clock

  reg[27:0] counter;
     
  initial
  begin
    counter = 0;
    slowClk128 = 0;
  end

  always @ (posedge clk100Mhz)
  begin
    if(counter == 195312) begin
      counter <= 1;
      slowClk128 <= ~slowClk128;
    end
    else begin
      counter <= counter + 1;
    end
  end
endmodule

module ONEHZCLK(clk100Mhz, slowClk);
  input clk100Mhz; //fast clock
  output reg slowClk; //slow clock

  reg[27:0] counter;
     
  initial
  begin
    counter = 0;
    slowClk = 0;
  end

  always @ (posedge clk100Mhz)
  begin
    if(counter == 50000000) begin
      counter <= 1;
      slowClk <= ~slowClk;
    end
    else begin
      counter <= counter + 1;
    end
  end
endmodule

module TWOHZCLK(clk100Mhz, slowCLKTwoHz);
  input clk100Mhz; //fast clock
  output reg slowCLKTwoHz; //slow clock

  reg[27:0] counter;
     
  initial
  begin
    counter = 0;
    slowCLKTwoHz = 0;
  end

  always @ (posedge clk100Mhz)
  begin
    if(counter == 25000000) begin
      counter <= 1;
      slowCLKTwoHz <= ~slowCLKTwoHz;
    end
    else begin
      counter <= counter + 1;
    end
  end
endmodule
 