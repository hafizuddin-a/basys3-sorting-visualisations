`timescale 1ns / 1ps

// top_module module
module top_module (
    input clk,
    input sw0,
    output [7:0] Jx
);

bubble_sort bubble_sort_inst (
    .clk(clk),
    .sw0(sw0),
    .sw1(sw1),
    .Jx(Jx)
);

endmodule