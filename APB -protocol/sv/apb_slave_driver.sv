//====================================================================
//  APB Slave Driver
//====================================================================
`ifndef APB_SLAVE_DRIVER_SV
`define APB_SLAVE_DRIVER_SV

class apb_slave_driver extends uvm_driver #(apb_packet);
  
  virtual apb_if.slave_drv_mp vif;
  int num_sent;
  typedef bit [31:0] mem_t [bit [31:0]];
  mem_t mem;

  `uvm_component_utils_begin(apb_slave_driver)
    `uvm_field_int(num_sent, UVM_ALL_ON)
  `uvm_component_utils_end

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void connect_phase(uvm_phase phase);
    if (!uvm_config_db#(virtual apb_if.slave_drv_mp)::get(this, "", "vif", vif))
      `uvm_fatal("NOVIF", {"Virtual interface must be set for: ", get_full_name(), " .vif"})
  endfunction

  task run_phase(uvm_phase phase);
  @(posedge vif.presetn);
  reset_signals();

  forever begin
    seq_item_port.get_next_item(req);

    `uvm_info(get_type_name(),
              $sformatf("APB Slave Responding: addr=%0h, cmd=%s, data=%0h",
                        req.addr, (req.command==WRITE)?"WRITE":"READ", req.data),
              UVM_MEDIUM)

    drive_to_dut(req);
    num_sent++;
    seq_item_port.item_done();
  end
  endtask

  virtual task drive_to_dut(apb_packet pkt);
  @(posedge vif.pclk);
  void'(begin_tr(pkt, "Driver_APB_Slave"));


  wait (vif.psel && !vif.penable);
  @(posedge vif.pclk);
  wait (vif.penable);

  if (vif.pwrite)
    mem[vif.paddr] = vif.pwdata;
  else
    vif.prdata <= mem.exists(vif.paddr) ? mem[vif.paddr] : pkt.data;

  vif.pready  <= 1'b1;
  vif.pslverr <= 1'b0;

  @(posedge vif.pclk);
  vif.pready  <= 1'b0;
  vif.pslverr <= 1'b0;

  end_tr(pkt);
endtask

  task reset_signals();
    vif.pready  <= 1'b0;
    vif.prdata  <= '0;
    vif.pslverr <= 1'b0;
  endtask


  function void report_phase(uvm_phase phase);
    `uvm_info(get_type_name(),
              $sformatf("APB Slave driver sent %0d responses", num_sent),
              UVM_LOW)
  endfunction

endclass : apb_slave_driver

`endif
