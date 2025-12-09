module clk_div_3 (
    input clk,
    input wire rst,
    output reg clk_out
);

    reg [1:0] cnt;

    initial begin
        cnt = 0;
        clk_out = 0;
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            cnt     <= 2'd0;
            clk_out  <= 1'b0;
        end else begin
            cnt <= (cnt == 2'd2) ? 0 : cnt + 1;
            case (cnt)
                2'd0, 1: clk_out <= 1; // שני מחזורי שעון גבוה
                2'd2:       clk_out <= 0; // מחזור אחד נמוך
            endcase
        end
    end

endmodule
