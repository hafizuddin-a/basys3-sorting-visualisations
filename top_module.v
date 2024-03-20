`timescale 1ns / 1ps

// top_module module
module top_module (
    input clk,
    input rst,
    input load_num,
    input bubble_sort,
    output [6:0] seg,
    output [3:0] an
);

wire [3:0] random_num;
wire [3:0] sorted_nums [0:3];
wire sorting_done;

lfsr lfsr_inst (
    .clk(clk),
    .rst(rst),
    .random_num(random_num)
);

bubble_sort bubble_sort_inst (
    .clk(clk),
    .rst(rst),
    .load_num(load_num),
    .sort_trigger(bubble_sort),
    .random_num(random_num),
    .sorted_nums(sorted_nums),
    .sorting_done(sorting_done)
);

seg_display seg_display_inst (
    .clk(clk),
    .sorting_done(sorting_done),
    .unsorted_nums(random_num),
    .sorted_nums(sorted_nums),
    .seg(seg),
    .an(an)
);

endmodule