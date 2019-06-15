
`timescale 1ns/1ps
`default_nettype none

`include "common.v"

module chargen_tb;
    `test_init(clk);

    reg clk, n_rst;
    wire tx;
    wire rst;

    assign rst = ~n_rst;

    chargen #(.CDIV(10)) chargen0(.*);

    initial begin : logging
`define HEADER(s) \
        $display(s); \
        $display("# time x nRST TX BIT CHR")
        $monitor("%6t %1b %4b %2b %3d %3c",
            $time, `TICK_X, n_rst, tx, chargen0.bit_cnt, chargen0.chr);
        $timeformat(-9, 0, "", 6);

        $dumpfile("chargen_tb.vcd");
        $dumpvars(1, chargen0);
        $dumplimit(1_000_000); // stop dump at 1MB
    end

    // insert header for readability
    always #(`TF * 5) begin `HEADER(""); end

    // force finish at given time
    //always #4000 begin $finish; end

    //////////////////////////////////////////////////////////////////////

    initial begin : test_main
        test_reset();
        test_gen();
        `test_pass();
    end

    task do_reset; begin
        n_rst = `nT; #1;
        n_rst = `nF;
    end endtask

    task test_reset; begin
        `HEADER("### test_reset ###");
        `TICK(1);
        do_reset();
        `test_ok("Counter should reset to 0", chargen0.bit_cnt === 0);
        `test_ok("TX should be 1", tx === 1'b1);
    end endtask

    task test_gen; begin
        `HEADER("### test_gen ###");
        do_reset();

        //
        // tick-based tests (kept as a record - better use state-based tests)
        //

        `TICK(10);
        `test_ok("Counter should be 1", chargen0.bit_cnt === 1);
        `TICK(10);
        `test_ok("Counter should be 2", chargen0.bit_cnt === 2);

        //
        // better state-based behaviour tests
        //
        `test_event("Counter should be 0 in 200T", 200, chargen0.bit_cnt === 0);

        // each char should be followed by many STOP bits
        `test_ok("CHR should be [b]", chargen0.chr === `STR(b));
        `test_state("CHR should stay [b] for 10T", 10, chargen0.chr === `STR(b));

        // should wraparound after z
        wait(chargen0.chr === `STR(z));
        `test_event("CHR should wraparound from [z] to [a]", 200, chargen0.chr === `STR(a));
    end endtask
endmodule

`default_nettype wire
