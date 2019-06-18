`timescale 1ns / 1ps
`default_nettype none

`include "board.v"

module top #(
  parameter SPI_CDIV = 50
)
`ifdef BOARD_S3ESK
(
  input wire CLK_50MHZ,
  input wire BTN_SOUTH,
  output wire [7:0] LED,
  output wire DAC_CS,
  output wire DAC_CLR,
  output wire SPI_SCK,
  output wire SPI_MOSI,
  input  wire SPI_MISO,

  /* other wires that needs to be pinned down to use SPI bus */
  output wire SPI_SS_B,
  output wire AMP_CS,
  output wire AD_CONV,
  output wire SF_CE0,
  output wire FPGA_INIT_B
);

wire CLK = CLK_50MHZ;
wire RST = BTN_SOUTH;

// Disable Other Devices on the SPI Bus to Avoid Contention
// - Spartan-3E FPGA Starter Kit Board User Guide, Table 9-2 / us230.pdf
assign SPI_SS_B = 1;
assign AMP_CS = 1;
assign AD_CONV = 0;
assign SF_CE0 = 1;
assign FPGA_INIT_B = 1;

`else
(
  input wire CLK,
  input wire RST,
  output wire [7:0] LED,
  output wire DAC_CS,
  output wire DAC_CLR,
  output wire SPI_SCK,
  output wire SPI_MOSI,
  input  wire SPI_MISO
);
`endif

  spidac #(.CDIV(SPI_CDIV)) dac0(.clk(CLK), .rst(RST), .led(LED),
    .cs(DAC_CS), .clr(DAC_CLR), .mosi(SPI_MOSI), .miso(SPI_MISO), .sck(SPI_SCK));

endmodule

`default_nettype wire
