// Top module for display control in Millennium Clock

module display_control (  
    input clk, rst_n,
    input mode_time,
    input [2:0] select_item, // select item and blink
    input [5:0] second, minute, hour, day, 
    input [3:0] month, 
    input [13:0] year,
    output [6:0] HEX7,
    output [6:0] HEX6,
    output [6:0] HEX5,
    output [6:0] HEX4,
    output [6:0] HEX3,
    output [6:0] HEX2,
    output [6:0] HEX1,
    output [6:0] HEX0
);

    wire [55:0] seg_decoded;

    display_decoder decoder (
        .mode_time(mode_time),
        .second_in(second), .minute_in(minute), .hour_in(hour),
        .day_in(day), .month_in(month), .year_in(year),
        .seg_out(seg_decoded)
    );

    wire [55:0] seg_blinked;

    display_blink blink (
        .clk(clk),
        .rst_n(rst_n),
        .mode_time(mode_time),
        .select_item(select_item),
        .seg_decoded(seg_decoded),
        .seg_blinked(seg_blinked)
    );

    assign HEX7 = seg_blinked[55:49];
    assign HEX6 = seg_blinked[48:42];
    assign HEX5 = seg_blinked[41:35];
    assign HEX4 = seg_blinked[34:28];
    assign HEX3 = seg_blinked[27:21];
    assign HEX2 = seg_blinked[20:14];
    assign HEX1 = seg_blinked[13:7];
    assign HEX0 = seg_blinked[6:0];

endmodule