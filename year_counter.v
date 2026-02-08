module year_counter (
    input clk,
    input rst_n,
    input up, down,
    input signal,
    input manual_set,
    output reg [13:0] year
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            year <= 14'd2025;
        end
        else begin
            if (manual_set) begin
                if (up) year <= (year == 14'd3025) ? 14'd2025 : (year + 14'd1);
                else if (down) year <= (year == 14'd2025) ? 14'd3025 : (year - 14'd1);
            end
            else if (signal) begin
                if (year == 14'd3025) begin
                    year <= 14'd2025;
                end
                else begin
                    year <= year + 14'd1;
                end
            end
            else begin
                year <= year;
            end
        end
    end
endmodule