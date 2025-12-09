module parallel_to_serial(
    input clk,
    input load,
    input [7:0] parallel_in,
    output serial_out
);
    reg [7:0] shift_register;
    integer i;
    always @(posedge clk) begin
        for (i = 0; i < 7; i = i + 1)
            shift_register[i] <= load ? parallel_in[i] : shift_register[i+1];
        shift_register[7] <= parallel_in[7];
    end
    assign serial_out = shift_register[0];
endmodule