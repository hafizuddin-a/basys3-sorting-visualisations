`timescale 1ns / 1ps

// 4-bit Linear Feedback Shift Register - genreates random number
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

module bubble_sort (
    input clk,
    input rst,
    input load_num,
    input sort_trigger,
    output reg [6:0] seg,
    output reg [3:0] an
);

wire [3:0] random_num;
reg [3:0] nums [0:3];
reg [1:0] count;
reg sorting_done;
integer i, j;
reg [3:0] temp;

lfsr lfsr_inst (
    .clk(clk),
    .rst(rst),
    .random_num(random_num)
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
    end
end

// 7-segment display control
reg [16:0] display_count;
reg [3:0] display_num;

always @(posedge clk) begin
    display_count <= display_count + 1;
end

always @(*) begin
    case (display_count[16:15])
        2'b00: begin
            an <= 4'b0111;
            if (sorting_done)
                display_num <= nums[3];
            else
                display_num <= nums[0];
        end
        2'b01: begin
            an <= 4'b1011;
            if (sorting_done)
                display_num <= nums[2];
            else
                display_num <= nums[1];
        end
        2'b10: begin
            an <= 4'b1101;
            if (sorting_done)
                display_num <= nums[1];
            else
                display_num <= nums[2];
        end
        2'b11: begin
            an <= 4'b1110;
            if (sorting_done)
                display_num <= nums[0];
            else
                display_num <= nums[3];
        end
    endcase
end

always @(*) begin
    case (display_num)
        4'd0: seg <= 7'b1000000;
        4'd1: seg <= 7'b1111001;
        4'd2: seg <= 7'b0100100;
        4'd3: seg <= 7'b0110000;
        4'd4: seg <= 7'b0011001;
        4'd5: seg <= 7'b0010010;
        4'd6: seg <= 7'b0000010;
        4'd7: seg <= 7'b1111000;
        4'd8: seg <= 7'b0000000;
        4'd9: seg <= 7'b0010000;
        default: seg <= 7'b1111111;
    endcase
end

endmodule
