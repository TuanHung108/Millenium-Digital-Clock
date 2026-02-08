module minute_counter (
    input clk,
    input rst_n,
    input up, down,
    input signal,
    input manual_set,
    output reg [5:0] minute,
    output reg signal_out
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            minute <= 6'd0;
            signal_out <= 0;
        end
        else begin
            signal_out <= 0;
            if (manual_set) begin
                if (up) minute <= (minute == 6'd59) ? 6'd0 : (minute + 6'd1);
                else if (down) minute <= (minute == 6'd0) ? 6'd59 : (minute - 6'd1);
            end
            else if (signal) begin
                if (minute == 6'd59) begin
                    signal_out <= 1;
                    minute <= 6'd0;
                end
                else begin
                    minute <= minute + 6'd1;
                end
            end
            else begin
                minute <= minute;
            end
        end
    end
endmodule