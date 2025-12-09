module parallel_to_serial (
    input  logic clk,
    input  logic rstn,           // reset active low
    input  logic load,
    input  logic [7:0] parallel_in,
    output logic serial_out
);
    logic [7:0] shift_register;

    always_ff @(posedge clk or negedge rstn) begin
        if (!rstn)
            shift_register <= '0;
        else begin
            for (int i=0; i<7; i++)
                shift_register[i] <= load ? parallel_in[i] : shift_register[i+1];
            shift_register[7] <= parallel_in[7];
        end
    end

    assign serial_out = shift_register[0];
endmodule
