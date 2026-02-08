module counter_control (
    input clk, rst_n,
    input mode_time,
    input up, down,
    input manual_set,
    input [2:0] select_item,
    output [5:0] second, minute, hour, day, 
    output [3:0] month, 
    output [13:0] year
);
    wire signal_sec, signal_min, signal_hour;
    wire signal_day, signal_month, signal_year;

    gen_clock gen_clock_inst (
        .clk(clk),
        .rst_n(rst_n),
        .manual_set(manual_set),
        .signal(signal_sec)
    );


    reg [5:0] max_day;
    reg leap_year;

    // Determine if the year is a leap year
    always @(year) begin
        if (year[1:0] == 2'b00) begin
            case (year)
                14'd2100, 14'd2200, 14'd2300, 14'd2500, // Century years not leap years
                14'd2600, 14'd2700, 14'd2900, 14'd3000: 
                         leap_year = 0;
                default: leap_year = 1; // Other years are leap years
            endcase
        end else begin
            leap_year = 0;
        end
    end

    // Determine the maximum number of days in the current month
    always @(month or year or leap_year) begin
        case (month) 
            1,3,5,7,8,10,12: max_day = 31;
            4,6,9,11:        max_day = 30;
            2:               max_day = leap_year ? 29: 28;
            default:         max_day = 31;
        endcase
    end


    // Signals for up and down counters
    reg up_sec, up_min, up_hour, up_day, up_month, up_year;
    reg down_sec, down_min, down_hour, down_day, down_month, down_year;

    always @(select_item, manual_set, up, down) begin
            up_sec = 0; down_sec = 0;
            up_min = 0; down_min = 0;
            up_hour = 0; down_hour = 0;
            up_day = 0; down_day = 0;
            up_month = 0; down_month = 0;
            up_year = 0; down_year = 0;
        
        if (manual_set) begin
            if (mode_time == 1'b0) begin
                case (select_item)
                    3'b011: begin
                        up_hour = up; down_hour = down;
                    end
                    3'b010: begin
                        up_min = up; down_min = down;
                    end
                    3'b001: begin
                        up_sec = up; down_sec = down;
                    end
                    default: begin
                        up_sec = 0; down_sec = 0;
                        up_min = 0; down_min = 0;
                        up_hour = 0; down_hour = 0;
                    end
                endcase
            end
            else begin
                case (select_item)
                    3'b100: begin 
                        up_day = up; down_day = down;
                    end
                    3'b101: begin
                        up_month = up; down_month = down;
                    end
                    3'b110: begin
                        up_year = up; down_year = down;
                    end
                    default: begin
                        up_day = 0; down_day = 0;
                        up_month = 0; down_month = 0;
                        up_year = 0; down_year = 0;
                    end
                endcase
            end
        end
    end

    second_counter sec_counter_inst (
        .clk(clk),
        .rst_n(rst_n),
        .up(up_sec),
        .down(down_sec),
        .signal(signal_sec),
        .manual_set(manual_set && (select_item == 3'b001)),
        .second(second),
        .signal_out(signal_min)
    );

    minute_counter minute_counter_inst (
        .clk(clk),
        .rst_n(rst_n),
        .up(up_min),
        .down(down_min),
        .signal(signal_min),
        .manual_set(manual_set && (select_item == 3'b010)),
        .minute(minute),
        .signal_out(signal_hour)
    );

    hour_counter hour_counter_inst (
        .clk(clk),
        .rst_n(rst_n),
        .up(up_hour),
        .down(down_hour),
        .signal(signal_hour),
        .manual_set(manual_set && (select_item == 3'b011)),
        .hour(hour),
        .signal_out(signal_day)
    );

    day_counter day_counter_inst (
        .clk(clk),
        .rst_n(rst_n),
        .up(up_day),
        .down(down_day),
        .signal(signal_day),
        .max_day(max_day),
        .manual_set(manual_set && (select_item == 3'b100)),
        .day(day),
        .signal_out(signal_month)
    );

    month_counter month_counter_inst (
        .clk(clk),
        .rst_n(rst_n),
        .up(up_month),
        .down(down_month),
        .signal(signal_month),
        .manual_set(manual_set && (select_item == 3'b101)),
        .month(month),
        .signal_out(signal_year)
    );

    year_counter year_counter_inst (
        .clk(clk),
        .rst_n(rst_n),
        .up(up_year),
        .down(down_year),
        .manual_set(manual_set && (select_item == 3'b110)),
        .signal(signal_year),
        .year(year)
    );


endmodule