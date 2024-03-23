`timescale 1ns/10ps

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/25/2024 06:25:16 PM
// Design Name: 
// Module Name: subtask_a
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module insertion_sort (
	input clk,
	input [9:0] nums_arr,
	output [9:0] nums_sorted,
	output reg sorting_done
);

	reg [3:0] i, j;
	reg [3:0] key;
	
	always @(posedge clk) begin
		for (i = 1; i < 10; i = i + 1) begin
			key = nums_arr[i];
			j = i - 1;
			while (j >= 0 && nums_arr[j] > key) begin
				nums_arr[j + 1] = nums_arr[j];
				j = j - 1;
			end
			nums_arr[j + 1] = key;
		end
		sorting_done = 1;
	end

endmodule
