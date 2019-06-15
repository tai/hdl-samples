
`timescale 1ns/1ps
`default_nettype none

`include "common.v"

// Ticks needed to send (START + bytes + STOP * N)
`define BYTE_TICK ((1 + 8 + 5) * 10)

module uart_tb;
    `test_init(clk);

    reg clk, rst;
    wire tx;

    reg [7:0] data;
    reg valid;
    wire ready;

    uart #(.CDIV(10), .BUFFER_SIZE(4)) dut(.*);

    initial begin : logging
`define HEADER(s) \
        $display s; \
        $display("# time x RST C V R STATE RP WP BC TX")
        $monitor("%6t %1b %3b %1c %1b %1b %5d %2d %2d %2d %2b",
            $time, `TICK_X, rst, data, valid, ready, dut.recv_state, dut.rp, dut.wp, dut.bit_cnt, tx);
        $timeformat(-9, 0, "", 6);

        $dumpfile("uart_tb.vcd");
        $dumpvars(1, dut);
        $dumplimit(1_000_000); // stop dump at 1MB
    end

    // insert header for readability
    //always #(`TF * 10) begin `HEADER(("")); end

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
        `test_ok("Counter should reset to 0", dut.bit_cnt === 0);
        `test_ok("TX should be 1", tx === 1);
        `test_ok("WP and RP should be 0", dut.rp === 0 && dut.wp === 0);
        `test_ok("Should not be full", dut.is_full === 0);
        `test_ok("READY should be 1", ready === 1);
    end endtask

    task test_gen; begin : test_gen
        integer i, j, k, l, m, n;
        reg [7:0] c, d;

        `HEADER(("# T=test_gen"));
        do_reset();

        for (c = "a"; c <= "e"; c++) begin
            `OUT(("# Queueing [%c:%08b]", c, c));

            // start transfer
            data = c;
            valid = 1;

            i = dut.wp;
            `test_event("READY should be 0 in 2T", 2, ready === 0);
            `test_ok("Buffer should be set", dut.buffer[i] === c);

            d = dut.buffer[dut.rp];
            `OUT(("# On wire [%c:%08b]", d, d));

            // end transfer
            // NOTE: UART bittime == (START + 8B + (STOP * 2)) * CDIV
            valid = 0;
            if (dut.is_full) begin
                `test_event("READY should be 1 in 1-char UART bittime", `BYTE_TICK, dut.ready === 1);
            end
            else begin
                `test_event("READY should be 1 in 2T", 2, dut.ready === 1);                
            end
        end

        `test_event("Buffer should go empty in 4-char UART bittime", `BYTE_TICK * 4, dut.rp === dut.wp);
    end endtask
endmodule

`default_nettype wire
