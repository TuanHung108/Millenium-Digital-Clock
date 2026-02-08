module debounce_button (
    input  wire clk,
    input  wire rst_n,
    input  wire btn_in,      // nút nhấn thô (có nhiễu)
    output reg  btn_pulse    // xung 1 clk khi nhấn
);

    reg [15:0] cnt;
    reg btn_sync0, btn_sync1;
    reg btn_stable;
    reg btn_stable_d;

    // đồng bộ hóa0
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            btn_sync0 <= 0;
            btn_sync1 <= 0;
        end else begin
            btn_sync0 <= btn_in;
            btn_sync1 <= btn_sync0;
        end
    end

    // debounce bằng counter
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 0;
            btn_stable <= 0;
        end else begin
            if (btn_sync1 == btn_stable)
                cnt <= 0; // không thay đổi trạng thái
            else begin
                cnt <= cnt + 1;
                if (cnt == 16'hffff) begin
                    btn_stable <= btn_sync1; // chốt trạng thái mới
                    cnt <= 0;
                end
            end
        end
    end

    // phát hiện cạnh lên → tạo pulse 1 clk
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            btn_stable_d <= 0;
            btn_pulse <= 0;
        end else begin
            btn_stable_d <= btn_stable;
            btn_pulse <= (btn_stable & ~btn_stable_d);  // cạnh lên
        end
    end

endmodule
