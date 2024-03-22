`timescale 1ns / 1ps

// top_module module
module top_module (
    input clk,
    input rst,
    input load_num,
    input sort_trigger_bubble,
    input sort_trigger_selection,
    output [6:0] seg,
    output [3:0] an
);

wire [3:0] random_num;
wire [3:0] sorted_nums_bubble [0:3];
wire [3:0] sorted_nums_selection [0:3];
wire sorting_done_bubble;
wire sorting_done_selection;

lfsr lfsr_inst (
    .clk(clk),
    .rst(rst),
    .random_num(random_num)
);

bubble_sort bubble_sort_inst (
    .clk(clk),
    .rst(rst),
    .load_num(load_num),
    .sort_trigger(sort_trigger_bubble),
    .random_num(random_num),
    .sorted_nums_0(sorted_nums_bubble[0]),
    .sorted_nums_1(sorted_nums_bubble[1]),
    .sorted_nums_2(sorted_nums_bubble[2]),
    .sorted_nums_3(sorted_nums_bubble[3]),
    .sorting_done(sorting_done_bubble)
);

selection_sort selection_sort_inst (
    .clk(clk),
    .rst(rst),
    .load_num(load_num),
    .sort_trigger(sort_trigger_selection),
    .random_num(random_num),
    .sorted_nums_0(sorted_nums_selection[0]),
    .sorted_nums_1(sorted_nums_selection[1]),
    .sorted_nums_2(sorted_nums_selection[2]),
    .sorted_nums_3(sorted_nums_selection[3]),
    .sorting_done(sorting_done_selection)
);

seg_display seg_display_inst (
    .clk(clk),
    .sorting_done_bubble(sorting_done_bubble),
    .sorting_done_selection(sorting_done_selection),
    .unsorted_nums(random_num),
    .sorted_nums_bubble_0(sorted_nums_bubble[0]),
    .sorted_nums_bubble_1(sorted_nums_bubble[1]),
    .sorted_nums_bubble_2(sorted_nums_bubble[2]),
    .sorted_nums_bubble_3(sorted_nums_bubble[3]),
    .sorted_nums_selection_0(sorted_nums_selection[0]),
    .sorted_nums_selection_1(sorted_nums_selection[1]),
    .sorted_nums_selection_2(sorted_nums_selection[2]),
    .sorted_nums_selection_3(sorted_nums_selection[3]),
    .seg(seg),
    .an(an)
);

endmodule