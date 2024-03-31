`timescale 1ns / 1ps

// top_module module
module top_module (
    input clk,
    input rst,
    input sort_trigger,
    output [7:0] Jx
);

bubble_sort bubble_sort_inst (
    .clk(clk),
    .rst(rst),
    .load_num(load_num),
    .sort_trigger(sort_trigger),
    .Jx(Jx)
);

endmodule