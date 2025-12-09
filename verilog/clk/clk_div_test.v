module tb_clk_divs;
    reg clk;
    reg rst;
    wire clk_out_2;
    wire clk_out_8;
    wire clk_out_3;
    wire clk_out_3_50;

    // Instantiate clk_div_2
    clk_div_2 uut2 (
        .clk(clk),
        .clk_out(clk_out_2)
    );

    // Instantiate clk_div_8
    clk_div_8 uut8 (
        .clk(clk),
        .clk_out(clk_out_8)
    );

    // Instantiate clk_div_3
    clk_div_3 uut3 (
        .clk(clk),
        .rst(rst),
        .clk_out(clk_out_3)
    );

    // Instantiate clk_div_3_50
    clk_div_3_50 uut (
        .clk(clk),
        .clk_out(clk_out_3_50)
    );

    // Generate clock: period 10 time units
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Generate reset
    initial begin
        rst = 1;
        #12 rst = 0;   // release reset after some time
    end

    // Monitor outputs
    initial begin
        $monitor("Time=%0t | clk=%b | clk_out_2=%b | clk_out_8=%b | clk_out_3=%b | clk_out_3_50=%b",
                 $time, clk, clk_out_2, clk_out_8, clk_out_3, clk_out_3_50);
    end

    // Dump waves for GTKWave
    initial begin
        $dumpfile("clk_divs.vcd");
        $dumpvars(0, tb_clk_divs);
        #400 $finish;   // run longer to observe clk/8 and clk/3_50
    end
endmodule
