// 50 MHz = 50 000 000 xung clock per second
module gen_clock #(
    parameter clk_frg = 50_000_000
) (
    input clk,
    input rst_n,
    input manual_set,
    output reg signal
);
    reg [31:0] cnt;
    localparam ONE_SEC = clk_frg - 1; // 49_999_999

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            signal <= 0;
            cnt <= 0;
        end else begin 
            if (!manual_set) begin
                if (cnt == ONE_SEC) begin
                    signal <= 1;  // new_clock = 1 Hz
                    cnt <= 0;
                end
                else begin
                    signal <= 0; 
                    cnt <= cnt + 1;
                end
            end else begin
                signal <= 0;
                cnt <= cnt; // giữ nguyên giá trị đếm khi ở chế độ thủ công
            end
        end
    end
endmodule