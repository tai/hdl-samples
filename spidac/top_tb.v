
`timescale 1ns/1ps
`default_nettype none

`include "common.v"

module top_tb;
  `test_init(CLK);

  reg CLK, RST;
  wire [7:0] LED;
  wire DAC_CS, DAC_CLR;
  wire SPI_MOSI, SPI_SCK;
  wire SPI_MISO;

  top #(.SPI_CDIV(10)) top0(.*);

    initial begin : logging
`define HEADER(s) \
        $display s; \
        $display("# time x RST LED CS SCK MOSI BC")
        $monitor("%6t %1b %3b %3d %2b %3b %4b %2d",
            $time, `TICK_X, RST, LED, top0.dac0.cs, top0.dac0.sck, top0.dac0.mosi, top0.dac0.bit_cnt);
        $timeformat(-9, 0, "", 6);

        $dumpfile("top_tb.vcd");
        $dumpvars(1, top0);
        $dumplimit(1_000_000); // stop dump at 1MB
    end

    // insert header for readability
    always #(`TF * 100) begin `HEADER(("")); end

    // force finish at given time
    //always #4000 begin $finish; end

    //////////////////////////////////////////////////////////////////////

    initial begin : test_main
        `HEADER(("# %s\n# FILE=%s", `SEP, `__FILE__));
        test_reset();
        test_gen();
        `test_pass();
    end

    task do_reset; begin
        RST = `pT; #1;
        RST = `pF;
    end endtask

    task test_reset; begin
        `HEADER(("# T=test_reset"));
        `TICK(1);
        do_reset();
        `test_ok("LED should be 0", LED === 0);
    end endtask

    task test_gen; begin : test_gen
        integer i, j, k, l, m, n;
        reg [7:0] c, d;

        `HEADER(("# T=test_gen"));
        do_reset();

        `TICK(2000);
    end endtask
endmodule

`default_nettype wire
