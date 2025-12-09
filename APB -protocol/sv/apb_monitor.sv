class apb_monitor extends uvm_monitor;

    apb_packet pkt;
    int num_pkt_col;
    virtual apb_if.mon_mp vif;

    uvm_analysis_port #(apb_packet) item_collected_port;

    `uvm_component_utils_begin(apb_monitor)
        `uvm_field_int(num_pkt_col, UVM_ALL_ON)
    `uvm_component_utils_end

    function new (string name , uvm_component parent);
        super.new(name, parent);
        item_collected_port = new("item_collected_port", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        `uvm_info("DEBUG",
                  $sformatf("Monitor full name: %s", get_full_name()),
                  UVM_LOW)

        if (!uvm_config_db#(virtual apb_if.mon_mp)::get(this, "", "vif", vif) || vif == null)
            `uvm_error("NOVIF",
                       {"Virtual interface must be set for: ", get_full_name(), " .vif"})
    endfunction

    task run_phase(uvm_phase phase);
        @(posedge vif.presetn);
        `uvm_info(get_type_name(), "Detected Reset Done", UVM_MEDIUM)

        forever begin
            collect_packet(pkt);
            `uvm_info(get_type_name(),
                      $sformatf("Packet Collected:\n%s", pkt.sprint()),
                      UVM_LOW)
            item_collected_port.write(pkt);
            num_pkt_col++;
        end
    endtask

    virtual task collect_packet(output apb_packet pkt);
        pkt = apb_packet::type_id::create("pkt", this);

        @(posedge vif.pclk);
        wait (vif.psel && !vif.penable);
        void'(begin_tr(pkt, "Monitor_APB_Packet"));

        pkt.addr    = vif.paddr;
        pkt.command = (vif.pwrite) ? WRITE : READ;
        pkt.data    = (vif.pwrite) ? vif.pwdata : 'hx;

        @(posedge vif.pclk);
        wait (vif.penable && vif.pready);

        if (!vif.pwrite)
            pkt.data = vif.prdata;

        if (vif.pslverr)
            `uvm_warning("APB_MON", "Transaction error detected on slave")

        end_tr(pkt);
        `uvm_info(get_type_name(),
                  $sformatf("APB Transaction detected: addr=%0h data=%0h",
                            pkt.addr, pkt.data),
                  UVM_LOW)
    endtask

    function void report_phase(uvm_phase phase);
        `uvm_info(get_type_name(),
                  $sformatf("Report: APB Monitor Collected %0d Packets", num_pkt_col),
                  UVM_LOW)
    endfunction

endclass : apb_monitor
