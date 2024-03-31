`timescale 1ns / 1ps

// top_module module
module top_module (
    input clk,
    output [7:0] Jx
);

bubble_sort bubble_sort_inst (
    .clk(clk),
    .Jx(Jx)
);

endmodule