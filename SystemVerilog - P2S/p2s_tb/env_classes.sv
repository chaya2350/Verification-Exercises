
package env_pkg;
    class generator;
        rand bit [7:0] data;
        function new(); endfunction
    endclass

    class driver;
        virtual p2s_if.drv_mp drv_if;
        generator gen;
        function new(virtual p2s_if.drv_mp drv_if, generator gen);
            this.drv_if = drv_if;
            this.gen    = gen;
        endfunction
        task run(int num_items);
            wait (drv_if.rstn == 1);
            repeat(num_items) begin
                void'(gen.randomize());
                @(drv_if.cb_drv);
                drv_if.cb_drv.load <= 1;
                drv_if.cb_drv.parallel_in <= gen.data;
                @(drv_if.cb_drv);
                drv_if.cb_drv.load <= 0;
                repeat (8) @(drv_if.cb_drv);
            end
        endtask
    endclass

    class monitor;
        virtual p2s_if.mon_mp mon_if;
        bit [7:0] exp_data [$];
        bit [7:0] act_data [$];
        function new(virtual p2s_if.mon_mp mon_if);
            this.mon_if = mon_if;
        endfunction
        task run();
            wait (mon_if.cb_mon.rstn == 1);
            forever begin
                @(mon_if.cb_mon);
                if (mon_if.cb_mon.load) begin
                    bit [7:0] tmp_in;
                    bit [7:0] tmp_out;
                    tmp_in = mon_if.cb_mon.parallel_in;
                    exp_data.push_back(tmp_in);
                    for (int i = 0; i < 8; i++) begin
                        @(mon_if.cb_mon);
                        tmp_out[i] = mon_if.cb_mon.serial_out;
                    end
                    act_data.push_back(tmp_out);
                end
            end
        endtask
    endclass

    class scoreboard;
        monitor mon;
        function new(monitor mon);
            this.mon = mon;
        endfunction
        task run();
            int errors;
            #1;
            errors = 0;
            for (int i=0; i<mon.exp_data.size(); i++) begin
                for (int j=0; j<8; j++) begin
                    if (mon.exp_data[i][j] !== mon.act_data[i][j]) begin
                        $error("Mismatch at item %0d bit %0d : exp=%b act=%b",
                               i,j,mon.exp_data[i][j],mon.act_data[i][j]);
                        errors++;
                    end
                end
            end
            if (errors==0)
                $display("\n\nTEST PASS\n\n");
            else
                $display("\n\nTEST FAIL\n\n");
        endtask
    endclass
endpackage
