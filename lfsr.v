`timescale 1ns / 1ps

// lfsr module (unchanged)
module lfsr (
    input clk,
    input rst,
    output reg [3:0] random_num
);

reg [3:0] lfsr_reg;

always @(posedge clk) begin
    if (rst) begin
        lfsr_reg <= 4'b1001; // Initial seed value
    end else begin
        lfsr_reg <= {lfsr_reg[2:0], lfsr_reg[3] ^ lfsr_reg[2]};
    end
end

always @(posedge clk) begin
    random_num <= lfsr_reg;
end

endmodule