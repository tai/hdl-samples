`timescale 1ns / 1ps
`default_nettype none

module blink #(
   parameter CDIV = 50_000_000
)(
   input wire clk,
   input wire rst,
   output reg led
);
   reg [31:0] counter;
   
   always @(posedge clk or posedge rst) begin
      if (rst) begin
         led <= 0;
         counter <= 0;
      end
      else begin
         counter <= counter + 1;
         
         if (counter == CDIV - 1) begin
            counter <= 0;
            led <= ~led;
         end
      end
   end
endmodule

`default_nettype wire
