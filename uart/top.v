`timescale 1ns / 1ps
`default_nettype none

module top (
    input wire clk,
    input wire rst,
    output wire led,
    output wire tx
);

    wire [7:0] data;
    wire valid, ready;

    blink blink0(.clk(clk), .rst(rst), .led(led));
    chargen chargen0(.clk(clk), .rst(rst), .data(data), .ready(ready), .valid(valid));
    uart uart0(.clk(clk), .rst(rst), .tx(tx), .data(data), .ready(ready), .valid(valid));

endmodule

`default_nettype wire
