`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/03/2024 09:51:55 PM
// Design Name: 
// Module Name: debouncer
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


module debouncer #(parameter MAX_DEBOUNCE_COUNT = 20000000) (
    input clk,
    input btn,
    output reg btnReady = 1'b1
    );

    reg [31:0] count = 0; // counts debounces

    always @(posedge clk) begin
        if (btn && btnReady) begin
            btnReady <= 1'b0;
        end
        if (!btnReady && (count < MAX_DEBOUNCE_COUNT)) begin
            count <= count + 1;
        end 
        else if (!btnReady) begin
            count <= 0;
            btnReady <= 1'b1;
        end
    end
endmodule