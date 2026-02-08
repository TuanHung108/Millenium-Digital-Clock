module seg_decoder (
    input [3:0] hex_digits,
    output reg  [6:0] seg_data
);

    always @(hex_digits) begin
        case (hex_digits) // g f e d c b a
            4'b0000: seg_data = 7'b0000001;  //0
            4'b0001: seg_data = 7'b1001111;  //1
            4'b0010: seg_data = 7'b0010010;  //2
            4'b0011: seg_data = 7'b0000110;  //3
            4'b0100: seg_data = 7'b1001100;  //4
            4'b0101: seg_data = 7'b0100100;  //5
            4'b0110: seg_data = 7'b0100000;  //6
            4'b0111: seg_data = 7'b0001111;  //7
            4'b1000: seg_data = 7'b0000000;  //8
            4'b1001: seg_data = 7'b0001100;  //9
            default: seg_data = 7'b1111111;
        endcase
    end
endmodule
