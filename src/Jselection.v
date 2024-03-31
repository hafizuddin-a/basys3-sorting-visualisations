module jselection (
    input clk,
    input sw0,
    input sw2,
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
localparam SELECTED_BAR_COLOR = 16'hFFE0; // Yellow color
localparam BACKGROUND_COLOR = 16'h0000; // Black background
localparam SORT_DELAY = 50000000; // Delay between sort steps (adjust as needed)

reg [6:0] bar_heights [4:0];
reg [6:0] counter;
reg [31:0] delay_counter; // Counter for sorting delay
reg sorting; // Flag to indicate sorting is in progress
reg sorted; //Flag to indicate sorting is done and halts the selections
integer i, j, min_index;
reg random_bars_generated;

always @(posedge clk) begin
    if (!sw0) begin
        for (i = 0; i < 5; i = i + 1) begin
            bar_heights[i] <= (i + 1) * 10; // Set increasing heights for the bars
        end
        sorting <= 0;
        sorted <= 0; // Reset sorted flag
        delay_counter <= 0;
        j <= 0;
        random_bars_generated <= 0; // Reset the flag
    end else if (sw0 && !sw2 && !random_bars_generated) begin
        counter <= counter + 1; // Increment counter
        for (i = 0; i < 5; i = i + 1) begin
            bar_heights[i] <= (counter * 37 + i * 17) % 64; // Generate more random heights
        end
        sorting <= 0;
        sorted <= 0; // Reset sorted flag
        delay_counter <= 0;
        j <= 0;
        random_bars_generated <= 1; // Set the flag
    end else if (sw0 && sw2 && !sorting && !sorted) begin
        sorting <= 1; // Start sorting
        i <= 0; // Initialize indices for selection sort
        j <= 0;
        min_index <= i; // Set min_index to i for the first pass
    end else if (sorting && !sorted) begin
        if (delay_counter < SORT_DELAY) begin
            delay_counter <= delay_counter + 1; // Increment delay counter
        end else begin
            delay_counter <= 0; // Reset delay counter
            if (i < 5) begin // Change condition to iterate for all 5 passes
                if (j < 5) begin
                    if (j > i) begin
                        if (bar_heights[j] < bar_heights[min_index]) begin
                            min_index <= j; // Update the index of the minimum value
                        end
                    end
                    j <= j + 1; // Move to the next index
                end else begin
                    // Swap the values at i and min_index
                    {bar_heights[i], bar_heights[min_index]} <= {bar_heights[min_index], bar_heights[i]}; // Uncomment the swap operation
                    i <= i + 1; // Move to the next pass of the selection sort
                    j <= i + 1; // Reset inner loop counter
                    min_index <= i + 1; // Reset min_index
                end
            end else begin
                sorting <= 0; // Sorting is complete
                sorted <= 1; // Set sorted flag
            end
        end
    end
end


always @(*) begin
    // Set the color of the current pixel based on its horizontal position
    if ((pixel_index % 96) < (BAR_WIDTH * 10 + BAR_SPACING * 9)) begin
        // Inside the bar area
        if (((pixel_index % 96) / (BAR_WIDTH + BAR_SPACING)) % 2 == 0) begin
            if ((63 - (pixel_index / 96)) < bar_heights[((pixel_index % 96) / (BAR_WIDTH + BAR_SPACING)) / 2]) begin
                if ((((pixel_index % 96) / (BAR_WIDTH + BAR_SPACING)) / 2) == j - 1 && sorting) begin // If this is the selected bar, make it yellow
                    oled_data = SELECTED_BAR_COLOR;
                end else begin
                    oled_data = BAR_COLOR;
                end
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
