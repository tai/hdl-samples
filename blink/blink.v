`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:05:04 06/01/2019 
// Design Name: 
// Module Name:    blink 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module blink(
    input clk,
    input rst,
    output reg led
    );

   reg [31:0] cnt_reg;
   
   always @(negedge clk or posedge rst) begin
      if (rst) begin
         led <= 0;
         cnt_reg <= 0;
      end
      else begin
         cnt_reg <= cnt_reg + 1;
         
         if (cnt_reg >= 50_000_000) begin
            cnt_reg <= 0;
            led <= ~led;
         end
      end
   end

endmodule
