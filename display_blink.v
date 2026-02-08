    module display_blink (
        input clk, rst_n,
        input mode_time,
        input [2:0] select_item,
        input [55:0] seg_decoded,
        output reg [55:0] seg_blinked
    );
    
    // Creater blink_toggle with 1Hz frequency
    reg blink_toggle;
    reg [31:0] blink_cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            blink_cnt <= 0;
            blink_toggle <= 0;
        end
        else begin
            if (blink_cnt == 24_999_999) begin
                blink_cnt <= 0;
                blink_toggle <= ~blink_toggle;
            end
            else begin
                blink_cnt <= blink_cnt + 1;
            end
        end
    end


    always @(select_item, mode_time, blink_toggle, seg_decoded) begin
        seg_blinked = seg_decoded; // Default to no blink

        if (mode_time == 1'b0) begin
            case (select_item) 
                3'b011: // Hour
                    if (blink_toggle) seg_blinked[55:42] = seg_decoded[55:42];
                    else seg_blinked[55:42] = {14{1'b1}};
                3'b010:  // Minute
                    if (blink_toggle) seg_blinked[41:28] = seg_decoded[41:28];
                    else seg_blinked[41:28] = {14{1'b1}};
                3'b001:  // Second
                    if (blink_toggle) seg_blinked[27:14] = seg_decoded[27:14];
                    else seg_blinked[27:14] = {14{1'b1}};
                default:
                    seg_blinked = seg_decoded; // No blink
            endcase

        end else begin // Date mode
            case (select_item)
                3'b100: // Day
                    if (blink_toggle) seg_blinked[55:42] = seg_decoded[55:42];
                    else seg_blinked[55:42] = {14{1'b1}};
                3'b101:  // Month
                    if (blink_toggle) seg_blinked[41:28] = seg_decoded[41:28];
                    else seg_blinked[41:28] = {14{1'b1}};
                3'b110:  // Year
                    if (blink_toggle) seg_blinked[27:0] = seg_decoded[27:0];
                    else seg_blinked[27:0] = {28{1'b1}};
                default:
                    seg_blinked = seg_decoded; // No blink
            endcase
        end
    end

endmodule 