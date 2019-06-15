`timescale 1ns / 1ps
`default_nettype none

module top (
    input wire CLK,
    input wire RST,
    output wire [7:0] LED,
    input ROT_CENTER
);
    wire [7:2] nop;
    assign nop = LED[7:2];

    blink blink0(.clk(CLK), .rst(RST), .led(LED[0]));
    button button0(.clk(CLK), .rst(RST), .button(ROT_CENTER), .led(LED[1]));
endmodule

`default_nettype wire