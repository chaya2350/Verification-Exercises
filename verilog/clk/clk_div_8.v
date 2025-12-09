module clk_div_8 (
    input clk,
    output reg clk_out
);

    reg [2:0] cnt;

    initial begin
        cnt = 0;
        clk_out = 0;
    end

    always @(posedge clk) begin
        cnt <= cnt + 1;
        clk_out <= cnt[2];
    end

endmodule