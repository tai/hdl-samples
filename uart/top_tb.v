
`timescale 1ns/1ps
`default_nettype none

`include "common.v"

// Ticks needed to send (START + bytes + STOP * N)
`define BYTE_TICK ((1 + 8 + 5) * 10)

module top_tb;
    `test_init(clk);

    reg clk, rst;
    wire tx;

    wire [7:0] data;
    wire valid;
    wire ready;

    chargen chargen0(.*);
    uart #(.CDIV(10), .BUFFER_SIZE(4)) uart0(.*);

    initial begin : logging
`define HEADER(s) \
        $display s; \
        $display("# time x RST C V R STATE RP WP BC TX")
        $monitor("%6t %1b %3b %1c %1b %1b %5d %2d %2d %2d %2b",
            $time, `TICK_X, rst, data, valid, ready, uart0.recv_state, uart0.rp, uart0.wp, uart0.bit_cnt, tx);
        $timeformat(-9, 0, "", 6);

        $dumpfile("uart_tb.vcd");
        $dumpvars(1, uart0);
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
        rst = `pT; #1;
        rst = `pF;
    end endtask

    task test_reset; begin
        `HEADER(("# T=test_reset"));
        `TICK(1);
        do_reset();
        `test_ok("Counter should reset to 0", uart0.bit_cnt === 0);
        `test_ok("TX should be 1", tx === 1);
        `test_ok("WP and RP should be 0", uart0.rp === 0 && uart0.wp === 0);
        `test_ok("Should not be full", uart0.is_full === 0);
        `test_ok("READY should be 1", ready === 1);
    end endtask

    task test_gen; begin : test_gen
        integer i, j, k, l, m, n;
        reg [7:0] c, d;

        `HEADER(("# T=test_gen"));
        do_reset();

        `test_event("[g] should get queued in 7-char UART bittime", 7 * `BYTE_TICK, uart0.data === `STR(g));
    end endtask
endmodule

`default_nettype wire
