`timescale 1ns / 1ps
`default_nettype none

module button (
   input wire clk,
   input wire rst,
   input wire button,
   output led
);
    wire button_out;
    assign led = button_out;

    debounce deb0(.clk(clk), .rst(rst), .si(button), .so(button_out));

endmodule

`default_nettype wire
