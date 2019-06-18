`timescale 1ns / 1ps
`default_nettype none

module ram (
  input wire clk,
  input wire [15:0] addr,
  inout [7:0] data,
  input wire cs, oe, we
);
  reg [7:0] mem [1023:0]; // 1KB RAM
  wire [9:0] ra = addr[9:0]; // effective address

  assign data = (cs && oe) ? mem[ra] : 8'bzzzzzzzz;

  always @(posedge clk) begin
    if (cs && ! oe && we) begin
      mem[ra] <= data;
    end
  end

endmodule

`default_nettype wire
