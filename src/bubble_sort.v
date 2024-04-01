`timescale 1ns / 1ps

// bubble_sort module
// TODO: Use push buttons to control. btnC to stop/continue, btnR for next step, btnL for prev step
module bubble_sort (
    input clk,
    input sw0,
    input sw1, // TODO: Rename switches
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
localparam SORT_DELAY = 100_000_000; // Delay between sort steps (adjust as needed)

reg [6:0] bar_heights [4:0];
reg [6:0] counter;
reg [31:0] delay_counter; // Counter for sorting delay
reg sorting; // Flag to indicate sorting is in progress
reg sorted; // Flag to indicate sorting is complete
integer i, j;
reg random_bars_generated;

always @(posedge clk) begin
    if (!sw0) begin
        // Reset everything when sw0 is turned off
        for (i = 0; i < 5; i = i + 1) begin
            bar_heights[i] <= (i + 1) * 10; // Set increasing heights for the bars
        end
        sorting <= 0;
        delay_counter <= 0;
        j <= 0;
        random_bars_generated <= 0; // Reset the flag
        sorted <= 0; // Reset the sorted flag
    end else if (sw0 && !sw1 && !random_bars_generated) begin
        // Generate random bars when sw0 is turned on and sw1 is off
        counter <= counter + 1; // Increment counter
        for (i = 0; i < 5; i = i + 1) begin
            bar_heights[i] <= (counter * 37 + i * 17) % 64; // Generate more random heights
        end
        sorting <= 0; // Ensure sorting is not started yet
        delay_counter <= 0;
        j <= 0;
        random_bars_generated <= 1; // Set the flag
        sorted <= 0; // Reset the sorted flag
    end else if (sw0 && sw1 && !sorting && !sorted) begin
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
                    sorted <= 1; // Set the sorted flag
                end
            end
        end
    end
end

// Additional color definitions
localparam YELLOW_COLOR = 16'hFFE0; // Yellow color
localparam RED_COLOR = 16'hF800; // Red color
integer bar_index;

// Add more logic in the display block to change colors
always @(*) begin
    bar_index = ((pixel_index % 96) / (BAR_WIDTH + BAR_SPACING)) / 2; // Calculate the bar index

    // Default color is black (background)
    oled_data = BACKGROUND_COLOR;
    
    if ((pixel_index % 96) < (BAR_WIDTH * 10 + BAR_SPACING * 9)) begin // Inside the bar area
        if (((pixel_index % 96) / (BAR_WIDTH + BAR_SPACING)) % 2 == 0) begin // Inside a bar
            if ((63 - (pixel_index / 96)) < bar_heights[bar_index]) begin
                // Default bar color
                oled_data = BAR_COLOR;
    
                // If sorting is in progress, color bars accordingly
                if (sorting) begin
                    // If the bar is currently being compared, color it yellow
                    if (bar_index == j || bar_index == j + 1) begin
                        oled_data = YELLOW_COLOR;
                    end
    
                    // If the bar is in the sorted position, color it red
                    if (bar_index >= 5 - i) begin
                        oled_data = RED_COLOR;
                    end
                end
            end
        end
    end
end


endmodule
