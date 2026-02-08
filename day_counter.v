module day_counter (
    input clk, rst_n,
    input up, down,
    input signal,
    input manual_set,
    input [5:0] max_day,
    output reg [5:0] day,
    output reg signal_out
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            day <= 6'd1;
            signal_out <= 0;
        end
        else begin
            signal_out <= 0;

            if (manual_set) begin
                if (up) begin
                    day <= (day == max_day) ? 6'd1 : (day + 6'd1);
                end
                else if (down) begin 
                    day <= (day == 6'd1) ? max_day : (day - 6'd1);
                end
            end
            else if (signal) begin
                if (day == max_day) begin
                    day <= 6'd1;
                    signal_out <= 1;
                end 
                else begin
                    day <= day + 6'd1;
                end
            end
            else day <= day;
        end
    end
endmodule 
