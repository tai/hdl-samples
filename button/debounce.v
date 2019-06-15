`timescale 1ns / 1ps
`default_nettype none

module debounce #(
   parameter CDIV = 50_000,
   parameter THRES = 5,
   parameter WIDTH = 1
)(
   input wire clk,
   input wire rst,
   input wire [WIDTH-1:0] si,
   output reg [WIDTH-1:0] so
);
   reg [WIDTH-1:0] bits;
   reg [9:0] hits;
   reg [31:0] counter;

   always @(posedge clk or posedge rst) begin
      if (rst) begin
         counter <= 0;
         bits <= 0;
         hits <= 0;
      end
      else begin
         counter <= counter + 1;
         if (counter == CDIV - 1) begin
            counter <= 0;

            case (hits)
            0: bits <= si;
            THRES: so <= bits;
            default: begin
               hits <= (bits == si) ? (hits + 1) : 0;
            end
            endcase
         end
      end
   end
endmodule

`default_nettype wire
