module top(
    input clk,
    input rst,
    output led
    );

  blink blink0(.clk(clk), .rst(rst), .led(led));

endmodule
