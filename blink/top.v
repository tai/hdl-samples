`timescale 1ns / 1ps
`default_nettype none

module top(
    input clk,
    input rst,
    output led
    );

  blink blink0(.clk(clk), .rst(rst), .led(led));
endmodule

`default_nettype wire
