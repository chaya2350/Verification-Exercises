class apb_master_driver extends uvm_driver #(apb_packet);

    virtual apb_if.master_drv_mp vif;
    int num_sent;
    apb_packet req; 

    `uvm_component_utils_begin(apb_master_driver)
        `uvm_field_int(num_sent, UVM_ALL_ON)
    `uvm_component_utils_end

    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction

    function void connect_phase(uvm_phase phase);
        if (!uvm_config_db#(virtual apb_if.master_drv_mp)::get(this, "", "vif", vif) || vif == null)
            `uvm_error("NOVIF", {"Virtual interface must be set for: ", get_full_name(), " .vif"})
    endfunction

    task run_phase(uvm_phase phase);
        @(posedge vif.presetn);
        vif.psel    <= 0;
        vif.penable <= 0;
        vif.paddr   <= '0;
        vif.pwdata  <= '0;

        forever begin
            seq_item_port.get_next_item(req);

            `uvm_info(get_type_name(),
                      $sformatf("Sending APB Master Packet: addr=%0h, cmd=%s, data=%0h",
                                req.addr, (req.command==WRITE)?"WRITE":"READ", req.data),
                      UVM_HIGH)

            drive_to_dut(req);
            num_sent++;
            seq_item_port.item_done();
        end
    endtask

    virtual task drive_to_dut(apb_packet pkt);
        @(posedge vif.pclk);
        void'(begin_tr(pkt, "Driver_APB_Master"));

        // Setup phase
        vif.psel    <= 1'b1;
        vif.penable <= 1'b0;
        vif.paddr   <= pkt.addr;
        vif.pwrite  <= (pkt.command == WRITE);
        if (pkt.command == WRITE)
            vif.pwdata <= pkt.data;

        @(posedge vif.pclk);
        vif.penable <= 1'b1;

        @(posedge vif.pclk);
        while (!vif.pready)
            @(posedge vif.pclk);

        if (pkt.command == READ)
            pkt.data = vif.prdata;

        @(negedge vif.pclk);
        vif.psel    <= 1'b0;
        vif.penable <= 1'b0;

        if (vif.pslverr)
            `uvm_warning("APB_MASTER_DRV", "Transaction error detected on slave")

        end_tr(pkt);
    endtask

    function void report_phase(uvm_phase phase);
        `uvm_info(get_type_name(),
                  $sformatf("APB Master driver sent %0d packets", num_sent),
                  UVM_LOW)
    endfunction

endclass : apb_master_driver
