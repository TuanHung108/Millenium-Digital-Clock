module hour_counter (
    input clk,
    input rst_n,
    input up, down,
    input signal,
    input manual_set,
    output reg [5:0] hour,
    output reg signal_out
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            hour <= 6'd0;
            signal_out <= 0;
        end
        else begin
            signal_out <= 0;
            if (manual_set) begin
                if (up) hour <= (hour == 6'd23) ? 6'd0 : (hour + 6'd1);
                else if (down) hour <= (hour == 6'd0) ? 6'd23 : (hour - 6'd1);
            end
            else if (signal) begin
                if (hour == 6'd23) begin
                    signal_out <= 1;
                    hour <= 6'd0;
                end
                else begin
                    hour <= hour + 6'd1;
                end
            end
            else begin
                hour <= hour;
            end
        end
    end
endmodule