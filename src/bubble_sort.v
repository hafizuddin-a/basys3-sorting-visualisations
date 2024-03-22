`timescale 1ns / 1ps

// bubble_sort module
module bubble_sort (
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
integer i, j;
reg [3:0] temp;

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
        sorting_done <= 1; // Assume sorting is done initially
        for (i = 0; i < 3; i = i + 1) begin
            for (j = 0; j < 3 - i; j = j + 1) begin
                if (nums[j] > nums[j + 1]) begin
                    // Swap elements using a temporary variable
                    temp = nums[j];
                    nums[j] <= nums[j + 1];
                    nums[j + 1] <= temp;
                    sorting_done <= 0; // Set sorting_done to 0 if a swap occurs
                end
            end
        end
        
        // Assign sorted numbers to individual outputs
        sorted_nums_0 <= nums[0];
        sorted_nums_1 <= nums[1];
        sorted_nums_2 <= nums[2];
        sorted_nums_3 <= nums[3];
    end
end

endmodule

