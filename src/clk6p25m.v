`timescale 1ns / 1ps

module clk6p25m(input clk, output reg clk_6p25m);
    reg [3:0] counter = 4'd0;

    always @(posedge clk) begin
        if (counter == 4'd15) begin
            counter <= 4'd0;
            clk_6p25m <= ~clk_6p25m;
        end else begin
            counter <= counter + 1;
        end
    end
endmodule