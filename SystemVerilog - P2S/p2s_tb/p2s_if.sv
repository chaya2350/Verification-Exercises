interface p2s_if(input logic clk);
    logic        rstn;
    logic        load;
    logic [7:0]  parallel_in;
    logic        serial_out;

    // Clocking block for driver
    clocking cb_drv @(posedge clk);
        output load, parallel_in;
        input  rstn;
    endclocking

    // Clocking block for monitor
    clocking cb_mon @(posedge clk);
        input load, parallel_in, serial_out, rstn;
    endclocking

    // Modports
    modport drv_mp (clocking cb_drv, input rstn);
    modport mon_mp (clocking cb_mon);
endinterface
