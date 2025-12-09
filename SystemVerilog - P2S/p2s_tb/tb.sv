import env_pkg::*;

module tb;
    logic clk;
    p2s_if intf(clk);

    generator gen;
    driver    drv;
    monitor   mon;
    scoreboard sb;

    // Clock generation
    initial begin
        clk = 0;
        forever #10 clk = ~clk;
    end

    // Reset generation
    initial begin
        intf.rstn = 0;
        repeat (3) @(posedge clk);
        intf.rstn = 1;
    end

    // DUT instantiation
    parallel_to_serial dut (
        .clk        (clk),
        .rstn       (intf.rstn),
        .load       (intf.load),
        .parallel_in(intf.parallel_in),
        .serial_out (intf.serial_out)
    );

    initial begin
        gen = new();
        drv = new(intf.drv_mp, gen);
        mon = new(intf.mon_mp);
        sb  = new(mon);

        fork
            drv.run(10);
            mon.run();
        join_any

        #200;
        sb.run();
        $finish;
    end
endmodule
