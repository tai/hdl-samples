//
// Simple buffered UART controller for quick logging
//

`timescale 1ns / 1ps
`default_nettype none

`define RECV_WAIT 0
`define RECV_DONE 1

module uart #(
   parameter CDIV = 5208 /* 50_000_000 / 9600 */,
   parameter BUFFER_SIZE = 32
)(
   input wire clk,
   input wire rst,
   output reg tx,
   input wire [7:0] data,
   input wire valid,
   output wire ready
);

   reg [31:0] clk_cnt;
   reg [5:0] bit_cnt;

   reg [1:0] recv_state;

   reg [7:0] buffer [0:BUFFER_SIZE - 1];
   reg [7:0] txchar;
   reg [7:0] rp, wp;

   wire is_full = next_p(wp) == rp;
   assign ready = recv_state == `RECV_DONE ? 0 : ! is_full;

   // next position in ring buffer
   function [7:0] next_p(input [7:0] curr_p); begin
      next_p = (curr_p + 1) % BUFFER_SIZE;
   end
   endfunction

   // DATA recv
   always @(posedge clk or posedge rst) begin
      if (rst) begin
         wp <= 0;
         recv_state <= `RECV_WAIT; 
      end
      else begin
         case (recv_state)
         `RECV_WAIT: begin
            if (valid) begin
               buffer[wp] <= data;
               wp <= next_p(wp);
               recv_state <= `RECV_DONE; 
            end
         end

         `RECV_DONE: begin
            if (! valid) begin
               recv_state <= `RECV_WAIT;
            end
         end
         endcase
      end
   end

   // send each UART bit
   task do_send_tx_bit; begin
      bit_cnt <= bit_cnt + 1;
      case (bit_cnt)
      0: begin
         tx <= 0; /* START bit */

         // NOTE: XILINX ISE behaved badly with direct "buffer[rp][bitpos]" access.
         txchar <= buffer[rp];
      end
      1,2,3,4,5,6,7,8: tx <= txchar[bit_cnt - 1];
      9: tx <= 1; /* STOP bit */
      12: begin
         bit_cnt <= 0;
         rp <= next_p(rp);
      end
      default: ;
      endcase
   end
   endtask

   // UART send
   always @(posedge clk or posedge rst) begin
      if (rst) begin
         rp <= 0;
         tx <= 1;
         clk_cnt <= 0;
         bit_cnt <= 0;
      end
      else begin
         clk_cnt <= clk_cnt + 1;
         if (clk_cnt == CDIV - 1) begin
            clk_cnt <= 0;

            if (rp != wp) begin
               do_send_tx_bit();
            end
         end
      end
   end
endmodule

`default_nettype wire
