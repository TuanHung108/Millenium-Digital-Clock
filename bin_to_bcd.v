module bin_to_bcd (
    input [13:0] bin_in,  // 0 - 9999
    output reg [3:0] thousands,  // hang nghin
    output reg [3:0] hundreds, // hang tram
    output reg [3:0] tens,  // hang chuc
    output reg [3:0] ones  // hang don vi
);
    integer i;

    reg [3:0] bcd_thousands;
    reg [3:0] bcd_hundreds;
    reg [3:0] bcd_tens;
    reg [3:0] bcd_ones;
    reg [13:0] binary;

    always @(bin_in) begin
        bcd_thousands = 4'd0;
        bcd_hundreds = 4'd0;
        bcd_tens = 4'd0;
        bcd_ones = 4'd0;
        binary = bin_in;

        for (i = 13; i >= 0; i = i - 1) begin
            if (bcd_thousands >= 5) bcd_thousands = bcd_thousands + 4'd3;
            if (bcd_hundreds >= 5) bcd_hundreds = bcd_hundreds + 4'd3;
            if (bcd_tens >= 5) bcd_tens = bcd_tens + 4'd3;
            if (bcd_ones >= 5) bcd_ones = bcd_ones + 4'd3;

            bcd_thousands = {bcd_thousands[2:0], bcd_hundreds[3]};
            bcd_hundreds = {bcd_hundreds[2:0], bcd_tens[3]};
            bcd_tens = {bcd_tens[2:0], bcd_ones[3]};
            bcd_ones = {bcd_ones[2:0], binary[i]};
        end

        thousands = bcd_thousands;
        hundreds = bcd_hundreds;
        tens = bcd_tens;
        ones = bcd_ones;
    end
endmodule