module serial_to_parallel #(
    parameter WIDTH = 8,
    parameter ENDIAN = 0  // 0=LSB first, 1=MSB first
)(
    input clk,
    input rst,
    input serial_in,
    input start,
    output reg [WIDTH-1:0] parallel_out,
    output reg valid
);

    reg [WIDTH-1:0] shift_reg;
    reg [$clog2(WIDTH):0] bit_count;
    reg receiving;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            shift_reg <= 0;
            bit_count <= 0;
            valid <= 0;
            receiving <= 0;
        end else if (start) begin
            shift_reg <= 0;
            bit_count <= 0;
            valid <= 0;
            receiving <= 1;
        end else if (receiving) begin
            if (ENDIAN == 0) // Little-endian (LSB first)
                shift_reg <= {serial_in, shift_reg[WIDTH-1:1]};
            else // Big-endian (MSB first)
                shift_reg <= {shift_reg[WIDTH-2:0], serial_in};
                
            bit_count <= bit_count + 1;
            
            if (bit_count == WIDTH-1) begin
                valid <= 1;
                receiving <= 0;
                parallel_out <= (ENDIAN == 0) ? 
                    {serial_in, shift_reg[WIDTH-1:1]} : 
                    {shift_reg[WIDTH-2:0], serial_in};
            end
        end else begin
            valid <= 0;
        end
    end

endmodule
