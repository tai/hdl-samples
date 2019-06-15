`timescale 1ns / 1ps
`default_nettype none

module clockdiv #(
    parameter CDIV=50_000
)(
    input clk,
    output reg out
);
    reg [31:0] counter;
   
    always @(posedge clk) begin
        counter <= counter + 1;
         
        if (counter >= CDIV - 1) begin
            counter <= 0;
            out <= ~out;
        end
    end
endmodule

`default_nettype wire
