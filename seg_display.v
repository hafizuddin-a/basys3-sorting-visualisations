`timescale 1ns / 1ps

// seg_display module
module seg_display (
    input clk,
    input sorting_done,
    input [3:0] unsorted_nums,
    input [3:0] sorted_nums [0:3],
    output reg [6:0] seg,
    output reg [3:0] an
);

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
                display_num <= sorted_nums[3];
            else
                display_num <= unsorted_nums;
        end
        2'b01: begin
            an <= 4'b1011;
            if (sorting_done)
                display_num <= sorted_nums[2];
            else
                display_num <= 4'b0000;
        end
        2'b10: begin
            an <= 4'b1101;
            if (sorting_done)
                display_num <= sorted_nums[1];
            else
                display_num <= 4'b0000;
        end
        2'b11: begin
            an <= 4'b1110;
            if (sorting_done)
                display_num <= sorted_nums[0];
            else
                display_num <= 4'b0000;
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