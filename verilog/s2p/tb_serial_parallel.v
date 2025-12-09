module tb_serial_parallel;
    reg clk, rst, start;
    reg [7:0] parallel_in;
    wire serial_out;
    wire [7:0] parallel_out_le, parallel_out_be;
    wire valid_le, valid_be;

    // Parallel to Serial
    parallel_to_serial pts (
        .clk(clk),
        .load(start),
        .parallel_in(parallel_in),
        .serial_out(serial_out)
    );

    // Serial to Parallel - Little Endian
    serial_to_parallel #(.ENDIAN(0)) stp_le (
        .clk(clk),
        .rst(rst),
        .serial_in(serial_out),
        .start(start),
        .parallel_out(parallel_out_le),
        .valid(valid_le)
    );

    // Serial to Parallel - Big Endian
    serial_to_parallel #(.ENDIAN(1)) stp_be (
        .clk(clk),
        .rst(rst),
        .serial_in(serial_out),
        .start(start),
        .parallel_out(parallel_out_be),
        .valid(valid_be)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0; rst = 1; start = 0;
        parallel_in = 8'b10101011;
        
        #10 rst = 0;
        #10 start = 1;
        #10 start = 0;
        
        wait(valid_le);
        #10;
        
        $display("Input: %b", parallel_in);
        $display("Little-endian output: %b", parallel_out_le);
        $display("Big-endian output: %b", parallel_out_be);
        
        if (parallel_out_le == parallel_in)
            $display("Little-endian: PASS");
        else
            $display("Little-endian: FAIL");
            
        $finish;
    end
endmodule
