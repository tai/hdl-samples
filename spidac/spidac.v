`timescale 1ns / 1ps
`default_nettype none

`define SG_INIT 0
`define SG_SEND 1
`define SG_TRIG 2
`define SG_DONE 3

module spidac #(
  parameter CDIV = 50_000
)(
  input wire clk, rst,
  output reg [7:0] led,
  output reg cs, clr,
  output reg mosi, sck,
  input wire miso
);
  reg [31:0] counter, tick;

  reg   [3:0] dac_cmd;
  reg   [3:0] dac_addr;
  reg  [11:0] dac_data;
  //wire [31:0] dac_frame = {8'b0, dac_data, dac_addr, dac_cmd, 4'b0};
  wire [31:0] dac_frame = {8'b0, dac_cmd, dac_addr, dac_data, 4'b0};

  reg [7:0] bit_cnt;
  reg [3:0] state;

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      counter <= 0;
      tick <= 0;
      cs <= 1;
      clr <= 0;
      sck <= 0;
      led <= 0;
      dac_data <= 0;
      state <= `SG_INIT;
    end
    else begin
      counter <= counter + 1;
      if (counter == CDIV) begin
        counter <= 0;
        tick <= tick + 1;

        case (state)
        `SG_INIT: begin
          cs <= 0;
          clr <= 1;
          dac_cmd <= 4'b0011;
          dac_addr <= 4'b1111;
          dac_data <= dac_data + 1;
          bit_cnt <= 0;
          state <= `SG_SEND;
        end

        `SG_SEND: begin
          sck <= 0;
          bit_cnt <= bit_cnt + 1;
          if (bit_cnt == 32) begin
            bit_cnt <= 0;
            state <= `SG_DONE;
          end
          else begin
            mosi <= dac_frame[31 - bit_cnt];
            state <= `SG_TRIG;
          end
        end

        `SG_TRIG: begin
          sck <= 1;
          state <= `SG_SEND;
        end

        `SG_DONE: begin
          cs <= 1;
          state <= `SG_INIT;
        end

        endcase
      end
    end
  end
endmodule

`default_nettype wire
