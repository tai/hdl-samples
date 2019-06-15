`timescale 1ns / 1ps
`default_nettype none

module blink(
    input wire clk,
    input wire rst,
    output reg led
    );

   reg [31:0] cnt_reg;
   
   always @(posedge clk or posedge rst) begin
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

`default_nettype wire
