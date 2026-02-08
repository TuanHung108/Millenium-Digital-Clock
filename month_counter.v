module month_counter (
    input clk,
    input rst_n,
    input up, down,
    input signal,
    input manual_set,
    output reg [3:0] month,
    output reg signal_out
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            month <= 4'd1;
            signal_out <= 0;
        end
        else begin
            signal_out <= 0;
            if (manual_set) begin
                if (up) month <= (month == 4'd12) ? 4'd1 : (month + 4'd1);
                else if (down) month <= (month == 4'd1) ? 4'd12 : (month - 4'd1);
            end
            else if (signal) begin
                if (month == 4'd12) begin
                    signal_out <= 1;
                    month <= 4'd1;
                end
                else begin
                    month <= month + 4'd1;
                end
            end
            else begin
                month <= month;
            end
        end
    end
endmodule