`timescale 1ns / 1ps
`default_nettype none

module top #(
  parameter RWTEST_CDIV = 50_000_000
)(
  input wire clk,
  input wire rst,
  output wire [7:0] led
);
  wire [15:0] addr;
  wire [7:0] data;
  wire cs, oe, we;

  ram ram0(.clk(clk),
    .addr(addr), .data(data), .cs(cs), .oe(oe), .we(we));

  rwtest #(.CDIV(RWTEST_CDIV)) rwtest0(.clk(clk), .rst(rst),
    .addr(addr), .data(data), .cs(cs), .oe(oe), .we(we), .led(led));

endmodule

`default_nettype wire
