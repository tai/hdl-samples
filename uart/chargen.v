//
// chargen source
//

`timescale 1ns / 1ps
`default_nettype none

`define SEND_WAIT 0
`define SEND_DONE 1

module chargen #(
    parameter CHAR_START = "a",
    parameter CHAR_END = "z"
)(
    input wire clk,
    input wire rst,
    output reg [7:0] data,
    output reg valid,
    input wire ready
);

    reg [1:0] send_state;
    reg [7:0] chr;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            chr <= CHAR_START;
            valid <= 0;
            send_state <= `SEND_WAIT;
        end
        else begin
            case (send_state)
            `SEND_WAIT: begin
                if (ready) begin
                    data <= chr;
                    valid <= 1;
                    send_state <= `SEND_DONE; 
                end
            end

            `SEND_DONE: begin
                if (! ready) begin
                    data <= 0;
                    valid <= 0;
                    chr <= (chr == CHAR_END) ? CHAR_START : (chr + 1);
                    send_state <= `SEND_WAIT;
                end
            end
            endcase
        end
    end
endmodule

`default_nettype wire
