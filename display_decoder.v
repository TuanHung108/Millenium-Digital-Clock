module display_decoder (
    // input clk, rst_n,
    input mode_time, // 0: hh:mm:ss, 1: dd:mm:yyyy
    input [5:0] second_in, minute_in, hour_in, day_in, 
    input [3:0] month_in, 
    input [13:0] year_in,
    output reg [55:0] seg_out // 8 segments, each 7 bits
);

    // BCD wires
    wire [3:0] bcd_sec [0:1];
    wire [3:0] bcd_min [0:1];
    wire [3:0] bcd_hour [0:1];
    wire [3:0] bcd_day [0:1];
    wire [3:0] bcd_month [0:1];
    wire [3:0] bcd_year [0:3];

    // Convert from binary to BCD
    bin_to_bcd year_converter (
        .bin_in(year_in),
        .thousands(bcd_year[3]),
        .hundreds(bcd_year[2]),
        .tens(bcd_year[1]),
        .ones(bcd_year[0])
    );

    bin_to_bcd month_converter (
        .bin_in(month_in),
        .thousands(),
        .hundreds(),
        .tens(bcd_month[1]),
        .ones(bcd_month[0])
    );

    bin_to_bcd day_converter (
        .bin_in(day_in),
        .thousands(),
        .hundreds(),
        .tens(bcd_day[1]),
        .ones(bcd_day[0])
    );

    bin_to_bcd hour_converter (
        .bin_in(hour_in),
        .thousands(),
        .hundreds(),
        .tens(bcd_hour[1]),
        .ones(bcd_hour[0])
    );

    bin_to_bcd minute_converter (
        .bin_in(minute_in),
        .thousands(),
        .hundreds(),
        .tens(bcd_min[1]),
        .ones(bcd_min[0])
    );

    bin_to_bcd second_converter (
        .bin_in(second_in),
        .thousands(),
        .hundreds(),
        .tens(bcd_sec[1]),
        .ones(bcd_sec[0])
    );

    // Decoder from BCD to Seven Segment
    wire [6:0] seg_sec [0:1];
    wire [6:0] seg_min [0:1];
    wire [6:0] seg_hour [0:1];
    wire [6:0] seg_day [0:1];
    wire [6:0] seg_month [0:1];
    wire [6:0] seg_year [0:3];
    
    // Year
    seg_decoder seg_year_thousands (
        .hex_digits(bcd_year[3]),
        .seg_data(seg_year[3])
    );

    seg_decoder seg_year_hundreds (
        .hex_digits(bcd_year[2]),
        .seg_data(seg_year[2])
    );
    seg_decoder seg_year_tens (
        .hex_digits(bcd_year[1]),
        .seg_data(seg_year[1])
    );

    seg_decoder seg_year_ones (
        .hex_digits(bcd_year[0]),
        .seg_data(seg_year[0])
    );

    // Month
    seg_decoder seg_month_tens (
        .hex_digits(bcd_month[1]),
        .seg_data(seg_month[1])
    );

    seg_decoder seg_month_ones (
        .hex_digits(bcd_month[0]),
        .seg_data(seg_month[0])
    );

    // Day
    seg_decoder seg_day_tens (
        .hex_digits(bcd_day[1]),
        .seg_data(seg_day[1])
    );

    seg_decoder seg_day_ones (
        .hex_digits(bcd_day[0]),
        .seg_data(seg_day[0])
    );

    // Hour
    seg_decoder seg_hour_tens (
        .hex_digits(bcd_hour[1]),
        .seg_data(seg_hour[1])
    );

    seg_decoder seg_hour_ones (
        .hex_digits(bcd_hour[0]),
        .seg_data(seg_hour[0])
    );

    // Minute
    seg_decoder seg_min_tens (
        .hex_digits(bcd_min[1]),
        .seg_data(seg_min[1])
    );

    seg_decoder seg_min_ones (
        .hex_digits(bcd_min[0]),
        .seg_data(seg_min[0])
    );

    // Second
    seg_decoder seg_sec_tens (
        .hex_digits(bcd_sec[1]),
        .seg_data(seg_sec[1])
    );

    seg_decoder seg_sec_ones (
        .hex_digits(bcd_sec[0]),
        .seg_data(seg_sec[0])
    );

    // Hiển thị theo chế độ
    always @(*) begin
        if (mode_time == 1'b0) begin // Time mode
            seg_out[55:49] = seg_hour[1]; // Hour tens
            seg_out[48:42] = seg_hour[0]; // Hour ones
            seg_out[41:35] = seg_min[1];   // Minute tens
            seg_out[34:28] = seg_min[0];   // Minute ones
            seg_out[27:21] = seg_sec[1];   // Second tens
            seg_out[20:14] = seg_sec[0];   // Second ones
            seg_out[13:7]  = 7'b1111111;   // Empty segment
            seg_out[6:0]   = 7'b1111111;   // Empty segment
        end else begin // Date mode
            seg_out[55:49] = seg_day[1];  // Day tens
            seg_out[48:42] = seg_day[0];  // Day ones
            seg_out[41:35] = seg_month[1];  // Month tens
            seg_out[34:28] = seg_month[0];  // Month ones
            seg_out[27:21] = seg_year[3];  // Year thousands
            seg_out[20:14] = seg_year[2];  // Year hundreds
            seg_out[13:7]  = seg_year[1];    // Year tens
            seg_out[6:0]   = seg_year[0];    // Year ones
        end
    end

endmodule