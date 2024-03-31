`timescale 1ns / 1ps

// bubble_sort module
module bubble_sort (
    input clk,
    input sw0,
    input sw1,
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

// Parameters for bar display
localparam BAR_WIDTH = 8;
localparam BAR_SPACING = 2;
localparam BAR_COLOR = 16'h07E0; // Green color
localparam BACKGROUND_COLOR = 16'h0000; // Black background
localparam SORT_DELAY = 50000000; // Delay between sort steps (adjust as needed)

reg [6:0] bar_heights [4:0];
reg [6:0] counter;
reg [31:0] delay_counter; // Counter for sorting delay
reg sorting; // Flag to indicate sorting is in progress
integer i, j;
reg random_bars_generated;

always @(posedge clk) begin
    if (!sw0) begin
        for (i = 0; i < 5; i = i + 1) begin
            bar_heights[i] <= (i + 1) * 10; // Set increasing heights for the bars
        end
        sorting <= 0;
        delay_counter <= 0;
        j <= 0;
        random_bars_generated <= 0; // Reset the flag
    end else if (sw0 && !sw1 && !random_bars_generated) begin
        counter <= counter + 1; // Increment counter
        for (i = 0; i < 5; i = i + 1) begin
            bar_heights[i] <= (counter * 37 + i * 17) % 64; // Generate more random heights
        end
        sorting <= 0;
        delay_counter <= 0;
        j <= 0;
        random_bars_generated <= 1; // Set the flag
    end else if (sw0 && sw1 && !sorting) begin
        sorting <= 1; // Start sorting
        i <= 0; // Initialize indices for bubble sort
        j <= 0;
    end else if (sorting) begin
        if (delay_counter < SORT_DELAY) begin
            delay_counter <= delay_counter + 1; // Increment delay counter
        end else begin
            delay_counter <= 0; // Reset delay counter
            if (j < 4 - i) begin
                if (bar_heights[j] > bar_heights[j + 1]) begin
                    // Swap adjacent bars if they are in the wrong order
                    {bar_heights[j], bar_heights[j + 1]} <= {bar_heights[j + 1], bar_heights[j]};
                end
                j <= j + 1; // Move to the next pair
            end else begin
                if (i < 3) begin
                    i <= i + 1; // Move to the next pass of the bubble sort
                    j <= 0; // Reset the inner loop counter
                end else begin
                    sorting <= 0; // Sorting is complete
                end
            end
        end
    end
end


always @(*) begin
    // Set the color of the current pixel based on its horizontal position
    if ((pixel_index % 96) < (BAR_WIDTH * 10 + BAR_SPACING * 9)) begin
        // Inside the bar area
        if (((pixel_index % 96) / (BAR_WIDTH + BAR_SPACING)) % 2 == 0) begin
            // Calculate the bar index
            if ((63 - (pixel_index / 96)) < bar_heights[((pixel_index % 96) / (BAR_WIDTH + BAR_SPACING)) / 2]) begin
                oled_data = BAR_COLOR;
            end else begin
                oled_data = BACKGROUND_COLOR;
            end
        end else begin
            oled_data = BACKGROUND_COLOR;
        end
    end else begin
        // Outside the bar area
        oled_data = BACKGROUND_COLOR;
    end
end

endmodule
