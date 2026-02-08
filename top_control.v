module top_control (
    input clk, 
    input btn_rst_n,
    input btn_up, btn_down,
    input sw_mode,
    input sw_start_manual,
    input [2:0] sw_select_item,
    output [6:0] HEX7,
    output [6:0] HEX6,
    output [6:0] HEX5,
    output [6:0] HEX4,
    output [6:0] HEX3,
    output [6:0] HEX2,
    output [6:0] HEX1,
    output [6:0] HEX0
);

    // Debounce buttons
    wire btn_up_db, btn_down_db;

    debounce_button db_up (
        .clk(clk),
        .rst_n(btn_rst_n),
        .btn_in(~btn_up),
        .btn_pulse(btn_up_db)
    );

    debounce_button db_down (
        .clk(clk),
        .rst_n(btn_rst_n),
        .btn_in(~btn_down),
        .btn_pulse(btn_down_db)
    );
    

    wire [5:0] second, minute, hour, day;
    wire [3:0] month;
    wire [13:0] year;

    counter_control counter (
        .clk(clk),  // Input
        .rst_n(btn_rst_n),
        .mode_time(sw_mode),
        .up(btn_up_db),
        .down(btn_down_db),
        .manual_set(sw_start_manual),
        .select_item(sw_select_item),  
        .second(second),  // Output
        .minute(minute),
        .hour(hour),
        .day(day),
        .month(month),
        .year(year)
    );

    display_control display (
        .clk(clk),  // Input
        .rst_n(btn_rst_n),
        .mode_time(sw_mode),
        .select_item(sw_select_item),
        .second(second),
        .minute(minute),
        .hour(hour),
        .day(day),
        .month(month),
        .year(year),
        .HEX7(HEX7),  // Output
        .HEX6(HEX6),
        .HEX5(HEX5),
        .HEX4(HEX4),
        .HEX3(HEX3),
        .HEX2(HEX2),
        .HEX1(HEX1),
        .HEX0(HEX0)
    );


endmodule