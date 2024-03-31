`timescale 1ns / 1ps

// bubble_sort module
module bubble_sort (
    input clk,
    input rst,
    input sort_trigger,
    output [7:0] Jx
);

wire frame_begin, sending_pixels, sample_pixel;
wire [12:0] pixel_index;
reg [15:0] oled_data;
wire clk_6p25m;

clk6p25m clock_display(clk, clk_6p25m);

Oled_Display unit_oled (
    .clk(clk_6p25m), 
    .reset(0), 
    .frame_begin(frame_begin), 
    .sending_pixels(sending_pixels),
    .sample_pixel(sample_pixel), 
    .pixel_index(pixel_index), 
    .pixel_data(oled_data), 
    .cs(Jx[0]), 
    .sdin(Jx[1]), 
    .sclk(Jx[3]), 
    .d_cn(Jx[4]), 
    .resn(Jx[5]), 
    .vccen(Jx[6]), 
    .pmoden(Jx[7])
);

wire [6:0] random_num;
reg generate_num;
reg [3:0] count;

random_number_generator rng (
    .clk(clk),
    .rst(rst),
    .generate_num(generate_num),
    .random_num(random_num)
);

reg [6:0] nums [0:9];
integer i, j;
reg [6:0] temp;
reg sorting_done;
reg sorting_active;

always @(posedge clk) begin
    if (rst) begin
        for (i = 0; i < 10; i = i + 1) begin
            nums[i] <= 0;
        end
        count <= 0;
        generate_num <= 1;
        sorting_active <= 0;
    end else if (count < 10) begin
        generate_num <= 1;
        nums[count] <= random_num;
        count <= count + 1;
    end else if (!sorting_active && count == 10) begin
        generate_num <= 0;
        display_bars();
    end else if (sort_trigger && !sorting_active) begin
        sorting_active <= 1;
        sorting_done <= 0;
    end else if (sorting_active && !sorting_done) begin
        sorting_done <= 1; // Assume sorting is done initially
        for (i = 0; i < 9; i = i + 1) begin
            for (j = 0; j < 9 - i; j = j + 1) begin
                if (nums[j] > nums[j + 1]) begin
                    // Swap elements using a temporary variable
                    temp = nums[j];
                    nums[j] <= nums[j + 1];
                    nums[j + 1] <= temp;
                    sorting_done <= 0; // Set sorting_done to 0 if a swap occurs
                end
            end
            // Display the current state of the bars on the OLED
            display_bars();
        end
        if (sorting_done) begin
            sorting_active <= 0;
        end
    end
end

// Task to display the bars on the OLED
task display_bars;
    integer bar_width;
    integer bar_spacing;
    integer x, y;
begin
    bar_width = 12; // Adjust as needed
    bar_spacing = 2; // Adjust as needed
    
    // Clear the OLED display
    oled_data = 16'h0000;
    
    // Draw the bars
    for (x = 0; x < 10; x = x + 1) begin
        for (y = 0; y < nums[x]; y = y + 1) begin
            oled_data[((x * (bar_width + bar_spacing)) + y) / 8] = 16'h07E0;
        end
    end
end
endtask

endmodule