`timescale 1ns / 1ps
`default_nettype none

`define WRITE_INIT 0
`define READ_INIT 1
`define READ_DONE 2

module rwtest #(
  parameter CDIV = 50_000_000
)(
  input wire clk,
  input wire rst,
  output reg [15:0] addr,
  inout wire [7:0] data,
  output wire cs, oe,
  output reg we,
  output reg [7:0] led
);
  reg [31:0] counter;
  reg [15:0] tick;

  reg [7:0] data_out;
  reg [3:0] state;

  assign cs = 1;
  assign oe = ~we;
  assign data = we ? data_out : 8'bzzzzzzzz;

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      counter <= 0;
      tick <= 0;
      addr <= 0;
      we <= 0;
      led <= 0;
      state <= `WRITE_INIT;
    end
    else begin
      counter <= counter + 1;
      if (counter == CDIV) begin
        counter <= 0;
        tick <= tick + 1;

        case (state)
        `WRITE_INIT: begin
          data_out <= tick;
          we <= 1;
          state <= `READ_INIT;
        end

        `READ_INIT: begin
          we <= 0;
          led <= data;
          state <= `READ_DONE;
        end

        `READ_DONE: begin
          addr <= addr + 1;
          state <= `WRITE_INIT;
        end
        endcase

      end
    end
  end
endmodule

`default_nettype wire
