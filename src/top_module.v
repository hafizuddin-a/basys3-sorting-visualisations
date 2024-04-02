`timescale 1ns / 1ps

// top_module module
module top_module (
    input btnU,
    input btnD, 
    input btnL, 
    input btnR,
    
    input clk,
    input sw0,
    input sw1,
    output [7:0] Jx,
    output reg [0:3] an = 4'b1111,
    output reg [0:6] seg = 7'b1111111
);

    // 7 seg display 
    reg [16:0] seven_seg_counter = 0;
    reg [1:0] anode_index = 0;
    reg [3:0] sorting_algorithm = 0; // 0001 = bubble; 0010 = selection; 0100 = insertion; 1000 = qucick
    
    always @ (posedge clk) begin 
        sorting_algorithm = btnU ? 4'b0001 : 
                            btnD ? 4'b0010 :
                            btnR ? 4'b0100 : 
                            btnL ? 4'b1000 : sorting_algorithm;
        seven_seg_counter <= seven_seg_counter + 1;
        if (seven_seg_counter == 100_000) begin 
            seven_seg_counter <= 0;
            anode_index <= anode_index + 1;
        end
        if (sorting_algorithm == 4'b0001) begin // buuble sorting
            case(anode_index) 
                2'b00: begin 
                    an = 4'b0111;
                    seg = 7'b1110001;
                end
                2'b01: begin 
                    an = 4'b1011;
                    seg = 7'b1100000;
                end
                2'b10: begin 
                    an = 4'b1101;
                    seg = 7'b1000001;
                end
                2'b11: begin 
                    an = 4'b1110;
                    seg = 7'b1100000;
                end
            endcase
        end
        else if (sorting_algorithm == 4'b0010) begin //selection sorting
            case (anode_index) 
                2'b00: begin
                    an = 4'b0111;
                    seg = 7'b0110001;
                end
                2'b01: begin
                    an = 4'b1011;
                    seg = 7'b1110001;
                end
                2'b10: begin
                    an = 4'b1101;
                    seg = 7'b0110000;
                end
                2'b11: begin
                    an = 4'b1110;
                    seg = 7'b0100100;
                end
            endcase
        end
        else if (sorting_algorithm == 4'b0100) begin //insertion sorting
            case (anode_index) 
                2'b00: begin
                    an = 4'b0111;
                    seg = 7'b1111010;
                end
                2'b01: begin
                    an = 4'b1011;
                    seg = 7'b0100100;
                end
                2'b10: begin
                    an = 4'b1101;
                    seg = 7'b1101010;
                end
                2'b11: begin
                    an = 4'b1110;
                    seg = 7'b1001111;
                end
            endcase
        end
        else if (sorting_algorithm == 4'b1000) begin //quick sorting (?)
            case (anode_index) 
                2'b00: begin
                    an = 4'b0111;
                    seg = 7'b0110001;
                end
                2'b01: begin
                    an = 4'b1011;
                    seg = 7'b1001111;
                end
                2'b10: begin
                    an = 4'b1101;
                    seg = 7'b1000001;
                end
                2'b11: begin
                    an = 4'b1110;
                    seg = 4'b0001100;
                end
            endcase
        end
    end
    

    //bubble_sort bubble_sort_inst (
    insertion_sort insertion_sort_inst (
        .clk(clk),
        .sw0(sw0),
        .sw1(sw1),
        .Jx(Jx)
    );

endmodule