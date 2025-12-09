module clk_div_3_50 (
    input clk,
    output reg clk_out
);
    reg [1:0] cnt = 0;
    reg neg_shift = 0;
    wire clk_33;

    always @(posedge clk) begin
        if (cnt[1])
            cnt <= 2'd0;
        else
            cnt <= cnt + 1'b1;
    end

    assign clk_33 = cnt[1];

    always @(negedge clk) begin
        neg_shift <= clk_33;
    end

    always @(posedge clk or negedge clk) begin
        clk_out <= clk_33 | neg_shift;
    end
endmodule