`timescale 1ns / 1ps

module chargen #(
   parameter CDIV = 5208 /* 50_000_000 / 9600 */
)(
   input clk,
   input rst,
   output reg tx
);

   reg [31:0] clk_cnt;
   reg [5:0] bit_cnt;
   reg [7:0] chr;
   
   always @(posedge clk or posedge rst) begin
      if (rst) begin
         chr <= "a";
         tx <= 1;
         clk_cnt <= 0;
         bit_cnt <= 0;
      end
      else begin
         clk_cnt <= clk_cnt + 1;
         
         if (clk_cnt == CDIV - 1) begin
            clk_cnt <= 0;

            bit_cnt <= bit_cnt + 1;
            case (bit_cnt)
                0: tx <= 0; /* START bit */
                1,2,3,4,5,6,7,8: tx <= chr[bit_cnt - 1];
                9: tx <= 1; /* STOP bit */
                12: begin
                    bit_cnt <= 0;
                    chr <= chr == "z" ? "a" : (chr + 1);
                end
                default: ;
            endcase
         end
      end
   end

endmodule
