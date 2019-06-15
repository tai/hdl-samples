
`timescale 1ns/1ps
`default_nettype none

`include "common.v"

module blink_tb;
   `test_init(clk);

   reg clk, n_rst;
   wire led;
   wire rst;

   assign rst = ~n_rst;

   blink #(.CDIV(3), .INIT(1)) blink0(.*);

   initial begin : logging
`define HEADER(s) \
      $display s; \
      $display("# time x nRST LED COUNTER")
      $monitor("%6t %1b %4b %3b %7d",
	       $time, `TICK_X, n_rst, led, blink0.counter);
      $timeformat(-9, 0, "", 6);

      $dumpfile("blink_tb.vcd");
      $dumpvars(1, blink0);
      $dumplimit(1_000_000); // stop dump at 1MB
   end

   //////////////////////////////////////////////////////////////////////

   initial begin : test_main
      `HEADER(("# %s\n# FILE=%s", `SEP, `__FILE__));
      test_reset();
      test_blink();
      `test_pass();
   end
   
   task do_reset; begin
      n_rst = `nT;
      `TICK(0); // async reset does not have to wait for clock edge
      n_rst = `nF;
   end endtask

   task test_reset; begin
      `HEADER(("### test_reset ###"));
      `TICK(1);
      do_reset();
      `test_ok("Counter should reset to 0", blink0.counter === 0);
      `test_ok("LED should be 1", blink0.led === 1'b1);
   end endtask

   task test_blink; begin
      `HEADER(("### test_blink ###"));
      do_reset();

      //
      // tick-based tests (kept as a record - better use state-based tests)
      //

      `TICK(1);
      `test_ok("Counter should be 1", blink0.counter === 1);

      `TICK(1);
      `test_ok("Counter should be 2", blink0.counter === 2);

      `TICK(1);
      `test_ok("Counter should be 0", blink0.counter === 0);
      `test_ok("LED should be 0", blink0.led === 1'b0);

      `TICK(1);
      `test_ok("Counter should be 1", blink0.counter === 1);

      //
      // better state-based behaviour tests
      //
      `test_event("LED should be 1 in 2T", 2, blink0.led === 1'b1);
      `test_state("LED should stay 1 for 2T", 2, blink0.led === 1'b1);
      `test_event("LED should be 0 in 1T", 1, blink0.led === 1'b0);
      `test_state("LED should stay 0 for 2T", 2, blink0.led === 1'b0);
   end endtask
endmodule

`default_nettype wire
