`timescale 1ns / 1ps

/* 50_000_000 / 9600 */
`define BAUDCONFIG 5208

module chargen(
    input clk,
    input rst,
    output tx
    );

   reg [31:0] clk_cnt;
   reg [5:0] bit_cnt;
   reg [7:0] chr;
   
   reg tx_reg;
   assign tx = tx_reg;

   always @(negedge clk or posedge rst) begin
      if (rst) begin
         chr <= "a";
         tx_reg <= 1;
         clk_cnt <= 0;
         bit_cnt <= 0;
      end
      else begin
         clk_cnt <= clk_cnt + 1;
         
         if (clk_cnt == `BAUDCONFIG) begin
            clk_cnt <= 0;

            bit_cnt <= bit_cnt + 1;
            case (bit_cnt)
                0: tx_reg <= 0;
                1,2,3,4,5,6,7,8,9: tx_reg <= chr[bit_cnt - 1];
                10,11,12,13,14: tx_reg <= 1; /* extra STOP bit */
                default: begin
                    tx_reg <= 1;
                    bit_cnt <= 0;

                    chr <= chr + 1;
                    if (chr >= "z") begin
                        chr <= "a";
                    end
                end
            endcase
         end
      end
   end

endmodule
