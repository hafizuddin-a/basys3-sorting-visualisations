`timescale 1ns / 1ps

module random_number_generator (
    input clk,
    input rst,
    input generate_num,
    output reg [6:0] random_num
);

always @(posedge clk) begin
    if (rst) begin
        random_num <= 0;
    end else if (generate_num) begin
        random_num <= $random % 64; // Generate a random number between 0 and 63
    end
end

endmodule