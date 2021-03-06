`timescale 1ns / 1ps
`default_nettype none

module blink #(
   parameter INIT=1,
   parameter CDIV=50_000_000
)(
   input clk,
   input rst,
   output reg led
);
   reg [31:0] counter;

   always @(posedge clk or posedge rst) begin
      if (rst) begin
         counter <= 0;
         led <= INIT;
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
