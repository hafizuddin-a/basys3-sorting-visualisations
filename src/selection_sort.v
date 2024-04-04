`timescale 1ns / 1ps

// selection_sort module
module selection_sort (
    input clk,
    input rst,
    input load_num,
    input sort_trigger,
    input [3:0] random_num,
    output reg [3:0] sorted_nums_0,
    output reg [3:0] sorted_nums_1,
    output reg [3:0] sorted_nums_2,
    output reg [3:0] sorted_nums_3,
    output reg sorting_done
);

reg [3:0] nums [0:3];
reg [1:0] count;
integer i, j, min_idx;
reg [3:0] temp;

wire frame_begin, sending_pixels, sample_pixel;
wire [12:0] pixel_index;
reg [15:0] oled_data;

Oled_Display runOled(clk, rst, frame_begin, sending_pixels,
        sample_pixel, pixel_index, oled_data, Jx[0], Jx[1], Jx[3], Jx[4], Jx[5], Jx[6],
        Jx[7]
    );

always @(posedge clk) begin
    if (rst) begin
        for (i = 0; i < 4; i = i + 1) begin
            nums[i] <= 0;
        end
        count <= 0;
        sorting_done <= 0;
    end else if (load_num) begin
        nums[count] <= random_num % 10;
        count <= count + 1;
    end else if (sort_trigger && !sorting_done) begin
        for (i = 0; i < 3; i = i + 1) begin
            min_idx = i;
            for (j = i + 1; j < 4; j = j + 1) begin
                if (nums[j] < nums[min_idx]) begin
                    min_idx = j;
                end
            end
            if (min_idx != i) begin
                temp = nums[i];
                nums[i] <= nums[min_idx];
                nums[min_idx] <= temp;
            end
        end
        
        sorting_done <= 1;
        
        // Assign sorted numbers to individual outputs
        sorted_nums_0 <= nums[0];
        sorted_nums_1 <= nums[1];
        sorted_nums_2 <= nums[2];
        sorted_nums_3 <= nums[3];
    end
end

endmodule
