module second_counter (
    input clk,
    input rst_n,
    input up, down,
    input signal,
    input manual_set,
    output reg [5:0] second,
    output reg signal_out
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            second <= 6'd0;
            signal_out <= 0;
        end
        else begin
            signal_out <= 0;
            if (manual_set) begin
                if (up) second <= (second == 6'd59) ? 6'd0 : (second + 6'd1);
                else if (down) second <= (second == 6'd0) ? 6'd59 : (second - 6'd1);
            end
            else if (signal) begin
                if (second == 6'd59) begin
                    signal_out <= 1;
                    second <= 6'd0;
                end
                else begin
                    second <= second + 6'd1;
                end
            end
            else begin
                second <= second;
            end
        end
    end
endmodule