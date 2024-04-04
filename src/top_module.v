`timescale 1ns / 1ps

// top_module module
//module top_module (
//    input clk,
//    input sw0,
//    input btnL,
//    output [7:0] Jx,
//    output [7:0] JXADC
//);

//cocktail_sort inst(
//    .clk(clk),
//    .sw0(sw0),
//    .btnL(btnL),
//    .Jx(Jx),
//    .JXADC(JXADC)
//);

`timescale 1ns / 1ps

// top_module module
module top_module (
    input btnC,
    input btnU,
    input btnD, 
    input btnL, 
    input btnR,
    input [0:9] sw,
    output reg [8:0] led,
    
    input clk,
    output [7:0] Jx,
    output [7:0] JXADC,
    output reg [0:3] an = 4'b1111,
    output reg [0:6] seg = 7'b1111111
);

    wire frame_begin, sending_pixels, sample_pixel;
    wire frame_begin2, sending_pixels2, sample_pixel2;    
    wire [12:0] pixel_index;
    wire [12:0] pixel_index2;
    reg [15:0] oled_data;
    reg [15:0] oled_data2;
    wire clk_6p25m;
    

    // 7 seg display 
    reg [16:0] seven_seg_counter = 0;
    reg [1:0] anode_index = 0;
    reg [3:0] sorting_algorithm = 0; // 0001 = bubble; 0010 = selection; 0100 = insertion; 1000 = qucick
    
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
    
    Oled_Display unit_oled2 (
    .clk(clk_6p25m), 
    .reset(0), 
    .frame_begin(frame_begin2), 
    .sending_pixels(sending_pixels2),
    .sample_pixel(sample_pixel2), 
    .pixel_index(pixel_index2), 
    .pixel_data(oled_data2), 
    .cs(JXADC[0]), 
    .sdin(JXADC[1]), 
    .sclk(JXADC[3]), 
    .d_cn(JXADC[4]), 
    .resn(JXADC[5]), 
    .vccen(JXADC[6]), 
    .pmoden(JXADC[7])
    );
    
    // Parameters for bar display
    localparam BAR_WIDTH = 8;
    localparam BAR_SPACING = 2;
    localparam BAR_COLOR = 16'h07E0; // Green color
    localparam BACKGROUND_COLOR = 16'h0000; // Black background
    localparam SORT_DELAY = 100_000_000; // Delay between sort steps (adjust as needed)
    
    reg [6:0] key;
    reg [6:0] bar_heights [4:0];
    reg [6:0] counter;
    reg [31:0] delay_counter; // Counter for sorting delay
    reg sorting; // Flag to indicate sorting is in progress
    reg [4:0] is_bar_sorted = 5'b00000; // if true, green; yellow otherwise
    reg sorted; // Flag to indicate sorting is complete
    integer i, j, min_index;
    reg dir; // Flag for direction of sorting
    reg random_bars_generated;
    reg [3:0] curr_digit_manual; // digit to manually input from 1 - 9
    reg [2:0] curr_index_manual = 3'b000; // digit index for manual input
    // reg [4:0] one_hot_led_index = 5'b00001;
    wire btnC_debouncer;
    reg is_finished_manual_input = 0;
    debouncer centre_debouncer(clk, btnC, btnC_debouncer);

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
        if (sorting_algorithm == 4'b0001) begin // bubble sorting
            case (anode_index) 
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
            if (!sw[0] && !is_finished_manual_input) begin // manual input mode 
                sorting <= 0;
                delay_counter <= 0;
                j <= 0;
                random_bars_generated <= 0; // Reset the flag
                sorted <= 0; // Reset the sorted flag
                if (!btnC && curr_index_manual < 5) begin 
                    curr_digit_manual = sw[1] ? 1 : sw[2] ? 2 : sw[3] ? 3 : sw[4] ? 4 : sw[5] ? 5 :
                                        sw[6] ? 6 : sw[7] ? 7 : sw[8] ? 8 : sw[9] ? 9 : 0;
                    bar_heights[curr_index_manual] <= curr_digit_manual * 7;
                    led[curr_index_manual] <= 1;
                end else if (btnC_debouncer) begin
                    led[curr_index_manual] <= 1;
                    curr_index_manual <= curr_index_manual + 1;
                    if (curr_index_manual == 5) 
                        is_finished_manual_input <= 1;
                end
            end else if (sw[0] && !btnU && !random_bars_generated) begin // random input mode
                counter <= counter + 1; // Increment counter
                is_finished_manual_input = 0;
                for (i = 0; i < 5; i = i + 1) begin
                    bar_heights[i] <= (counter * 37 + i * 17) % 63 + 1; // Generate more random heights
                end
                sorting <= 0; // Ensure sorting is not started yet
                delay_counter <= 0;
                j <= 0;
                random_bars_generated <= 1; // Set the flag
                sorted <= 0; // Reset the sorted flag
            end else if (btnU && !sorting && !sorted && (is_finished_manual_input || random_bars_generated)) begin
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
                            is_finished_manual_input <= 0;
                        end
                    end
                end
            end
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
            if (!sw[0] && !is_finished_manual_input) begin // manual input mode 
                sorting <= 0;
                delay_counter <= 0;
                j <= 0;
                random_bars_generated <= 0; // Reset the flag
                sorted <= 0; // Reset the sorted flag
                if (!btnC && curr_index_manual < 5) begin 
                    curr_digit_manual = sw[1] ? 1 : sw[2] ? 2 : sw[3] ? 3 : sw[4] ? 4 : sw[5] ? 5 :
                                        sw[6] ? 6 : sw[7] ? 7 : sw[8] ? 8 : sw[9] ? 9 : 0;
                    bar_heights[curr_index_manual] <= curr_digit_manual * 7;
                    led[curr_index_manual] <= 1;
                end else if (btnC_debouncer) begin
                    led[curr_index_manual] <= 1;
                    curr_index_manual <= curr_index_manual + 1;
                    if (curr_index_manual == 5) 
                        is_finished_manual_input <= 1;
                end
            end else if (sw[0] && !btnD && !random_bars_generated) begin // random input mode
                counter <= counter + 1; // Increment counter
                is_finished_manual_input = 0;
                for (i = 0; i < 5; i = i + 1) begin
                    bar_heights[i] <= (counter * 37 + i * 17) % 63 + 1; // Generate more random heights
                end
                sorting <= 0; // Ensure sorting is not started yet
                delay_counter <= 0;
                j <= 0;
                random_bars_generated <= 1; // Set the flag
                sorted <= 0; // Reset the sorted flag
            end else if (btnD && !sorting && !sorted && (is_finished_manual_input || random_bars_generated)) begin
                sorting <= 1; // Start sorting
                i <= 0; // Initialize indices for bubble sort
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
                            if (min_index != i) begin
                                {bar_heights[i], bar_heights[min_index]} <= {bar_heights[min_index], bar_heights[i]}; // Uncomment the swap operation
                            end
                            i <= i + 1; // Move to the next pass of the selection sort
                            j <= i + 1; // Reset inner loop counter
                            min_index <= i + 1; // Reset min_index
                        end
                    end else begin
                        sorting <= 0; // Sorting is complete
                        sorted <= 1; // Set sorted flag
                        is_finished_manual_input <= 0;
                    end
                end
            end
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
            if (!sw[0] && !is_finished_manual_input) begin // manual input mode 
                sorting <= 0;
                delay_counter <= 0;
                j <= 0;
                random_bars_generated <= 0; // Reset the flag
                sorted <= 0; // Reset the sorted flag
                is_bar_sorted <= 0;
                if (!btnC && curr_index_manual < 5) begin 
                    curr_digit_manual = sw[1] ? 1 : sw[2] ? 2 : sw[3] ? 3 : sw[4] ? 4 : sw[5] ? 5 :
                                        sw[6] ? 6 : sw[7] ? 7 : sw[8] ? 8 : sw[9] ? 9 : 0;
                    bar_heights[curr_index_manual] <= curr_digit_manual * 7;
                    led[curr_index_manual] <= 1;
                end else if (btnC_debouncer) begin
                    led[curr_index_manual] <= 1;
                    curr_index_manual <= curr_index_manual + 1;
                    if (curr_index_manual == 5) 
                        is_finished_manual_input <= 1;
                end
            end else if (sw[0] && !btnR && !random_bars_generated) begin // random input mode
                counter <= counter + 1; // Increment counter
                is_finished_manual_input = 0;
                for (i = 0; i < 5; i = i + 1) begin
                    bar_heights[i] <= (counter * 37 + i * 17) % 63 + 1; // Generate more random heights
                end
                sorting <= 0; // Ensure sorting is not started yet
                delay_counter <= 0;
                j <= 0;
                random_bars_generated <= 1; // Set the flag
                sorted <= 0; // Reset the sorted flag
            end else if (btnR && !sorting && !sorted && (is_finished_manual_input || random_bars_generated)) begin
                sorting <= 1; // Start sorting
                i <= 1; // Initialize indices for bubble sort
                j <= 1;
                is_bar_sorted <= 5'b10000;
            end else if (sorting) begin // insertion sorting 
                if (delay_counter < SORT_DELAY) begin
                    delay_counter <= delay_counter + 1; // Increment delay counter
                end else begin
                    delay_counter <= 0; // Reset delay counter
                    if (i < 5) begin
                        if (j > 0 && bar_heights[j] < bar_heights[j - 1]) begin
                            {bar_heights[j], bar_heights[j - 1]} <= {bar_heights[j - 1], bar_heights[j]};
                            j <= j - 1;
                        end else begin
                            case (i)
                            0: is_bar_sorted <= is_bar_sorted + 5'b01000;
                            1: is_bar_sorted <= is_bar_sorted + 5'b00100;
                            2: is_bar_sorted <= is_bar_sorted + 5'b00010;
                            3: is_bar_sorted <= is_bar_sorted + 5'b00001;
                            endcase
                            i = i + 1;
                            j = i;
                        end
                    end else begin 
                        sorted <= 1;
                        sorting <= 0;
                        is_finished_manual_input <= 0;
                    end
                end
            end
        end
        else if (sorting_algorithm == 4'b1000) begin //cocktail sorting 
            case (anode_index) 
                2'b00: begin
                    an = 4'b0111;
                    seg = 7'b1010000;
                end
                2'b01: begin
                    an = 4'b1011;
                    seg = 7'b0110001;
                end
                2'b10: begin
                    an = 4'b1101;
                    seg = 7'b0000001;
                end
                2'b11: begin
                    an = 4'b1110;
                    seg = 7'b0110001;
                end
            endcase
            if (!sw[0] && !is_finished_manual_input) begin // manual input mode 
                sorting <= 0;
                delay_counter <= 0;
                j <= 0;
                random_bars_generated <= 0; // Reset the flag
                sorted <= 0; // Reset the sorted flag
                if (!btnC && curr_index_manual < 5) begin 
                    curr_digit_manual = sw[1] ? 1 : sw[2] ? 2 : sw[3] ? 3 : sw[4] ? 4 : sw[5] ? 5 :
                                        sw[6] ? 6 : sw[7] ? 7 : sw[8] ? 8 : sw[9] ? 9 : 0;
                    bar_heights[curr_index_manual] <= curr_digit_manual * 7;
                    led[curr_index_manual] <= 1;
                end else if (btnC_debouncer) begin
                    led[curr_index_manual] <= 1;
                    curr_index_manual <= curr_index_manual + 1;
                    if (curr_index_manual == 5) 
                        is_finished_manual_input <= 1;
                end
            end else if (sw[0] && !btnL && !random_bars_generated) begin // random input mode
                counter <= counter + 1; // Increment counter
                is_finished_manual_input = 0;
                for (i = 0; i < 5; i = i + 1) begin
                    bar_heights[i] <= (counter * 37 + i * 17) % 63 + 1; // Generate more random heights
                end
                sorting <= 0; // Ensure sorting is not started yet
                delay_counter <= 0;
                j <= 0;
                random_bars_generated <= 1; // Set the flag
                sorted <= 0; // Reset the sorted flag
            end else if (btnL && !sorting && !sorted && (is_finished_manual_input || random_bars_generated)) begin
                sorting <= 1; // Start sorting
                i <= 0; // Initialize indices for bubble sort
                j <= 0;
                dir <= 0;
            end else if (sorting) begin
                if (delay_counter < SORT_DELAY) begin
                    delay_counter <= delay_counter + 1; // Increment delay counter
                end else begin
                    delay_counter <= 0; // Reset delay counter
                        if (dir == 0 && j < 4 - i) begin
                            if (bar_heights[j] > bar_heights[j + 1]) begin
                                // Swap adjacent bars if they are in the wrong order
                                {bar_heights[j], bar_heights[j + 1]} <= {bar_heights[j + 1], bar_heights[j]};
                            end
                            j <= j + 1; // Move to the next pair
                        end
                        else if (dir == 1 && j >= i - 1) begin 
                            if (bar_heights[j] > bar_heights[j + 1]) begin
                            // Swap adjacent bars if they are in the wrong order
                            {bar_heights[j], bar_heights[j + 1]} <= {bar_heights[j + 1], bar_heights[j]};
                        end
                        j <= j - 1; // Move to the next pair
                        end 
                    else begin
                        if (i < 3) begin
                            //i <= i + 1; // Move to the next pass of the bubble sort
                            if (dir == 0) begin
                                j <= 3 - i; // Reset the inner loop counter //change here
                                dir <= 1;
                                i <= i + 1;
                            end else begin
                                j <= 0;
                                dir <= 0;
                            end
                        end 
                        else begin
                            sorting <= 0; // Sorting is complete
                            sorted <= 1; // Set the sorted flag
                            is_finished_manual_input <= 0;
                        end
                    end
                end
            end 
        end
    end
    
    //additional color definitions
    localparam YELLOW_COLOR = 16'hFFE0; // Yellow color
    localparam RED_COLOR = 16'hF800; // Red color
    integer bar_index;
    
    // Add more logic in the display block to change colors
    always @(*) begin
        if (sorting_algorithm == 4'b0010) begin // selection sorting
            if ((pixel_index % 96) < (BAR_WIDTH * 10 + BAR_SPACING * 9)) begin
                // Inside the bar area
                if (((pixel_index % 96) / (BAR_WIDTH + BAR_SPACING)) % 2 == 0) begin
                    if ((63 - (pixel_index / 96)) < bar_heights[((pixel_index % 96) / (BAR_WIDTH + BAR_SPACING)) / 2]) begin
                        if ((((pixel_index % 96) / (BAR_WIDTH + BAR_SPACING)) / 2) == j - 1 && sorting) begin // If this is the selected bar, make it yellow
                            oled_data = YELLOW_COLOR;
                        end else if (((pixel_index % 96) / (BAR_WIDTH + BAR_SPACING)) / 2 < i) begin
                            oled_data = BAR_COLOR;
                        end else begin
                            oled_data = RED_COLOR;
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
        end else begin
            bar_index = ((pixel_index % 96) / (BAR_WIDTH + BAR_SPACING)) / 2; // Calculate the bar index
        
            // Default color is black (background)
            oled_data = BACKGROUND_COLOR;
            
            if ((pixel_index % 96) < (BAR_WIDTH * 10 + BAR_SPACING * 9)) begin // Inside the bar area
                if (((pixel_index % 96) / (BAR_WIDTH + BAR_SPACING)) % 2 == 0) begin // Inside a bar
                    if ((63 - (pixel_index / 96)) < bar_heights[bar_index]) begin
                        if (sorting_algorithm == 4'b0001) begin // bubble sorting
                            oled_data = BAR_COLOR;
                            // If sorting is in progress, color bars accordingly
                            if (sorting) begin
                                oled_data = RED_COLOR;
                                // If the bar is currently being compared, color it yellow
                                if (bar_index == j || bar_index == j + 1) begin
                                    oled_data = YELLOW_COLOR;
                                end
                                // If the bar is in the sorted position, color it red
                                if (bar_index >= 5 - i) begin
                                    oled_data = BAR_COLOR;
                                end
                            end
                        end
                        else if (sorting_algorithm == 4'b0100) begin //insertion sort
                            // Default bar color
                            oled_data = BAR_COLOR;
                            // If sorting is in progress, color bars accordingly
                            if (sorting) begin
                                oled_data = RED_COLOR; 
                                if (bar_index < i)
                                    oled_data = BAR_COLOR;   
                                if (bar_index == j || bar_index == j - 1)
                                    oled_data = YELLOW_COLOR;                             
                            end else if (sorted) begin
                                oled_data <= BAR_COLOR;
                            end
                        end else if (sorting_algorithm == 4'b1000) begin //cocktail sort
                            oled_data = BAR_COLOR;
                            // If sorting is in progress, color bars accordingly
                            if (sorting) begin
                            //default sorting color = red
                                oled_data = RED_COLOR;
                                // If the bar is currently being compared, color it yellow
                                if (bar_index == j || bar_index == j + 1) begin
                                    oled_data = YELLOW_COLOR;
                                end    
                
                                // If the bar is in the sorted position, color it red
                                if (bar_index >= 5 - i || bar_index < i && i==1 && dir == 0
                                || bar_index < i - 1 && i==2 && dir == 1
                                || bar_index < i && i==2 && dir == 0
                                || bar_index < i && i==3 && dir == 1
                                ) begin
                                    oled_data = BAR_COLOR;
                                end
                            end
                        end 
                    end
                end
            end
        end
    end

endmodule 