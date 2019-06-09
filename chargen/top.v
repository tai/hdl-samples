`timescale 1ns / 1ps

module top (
    input clk,
    input rst,
    output led,
    output tx
);

    blink blink_00(.clk(clk), .rst(rst), .led(led));
    chargen charngen_00(.clk(clk), .rst(rst), .tx(tx));

endmodule
