class apb_agent extends uvm_agent;
  apb_monitor monitor;
  apb_master_driver m_driver;
  apb_slave_driver s_driver;
  apb_sequencer sequencer;

  virtual apb_if vif;

  bit is_master; // 1 = Master mode, 0 = Slave mode

  `uvm_component_utils_begin(apb_agent)
   `uvm_field_int(is_master, UVM_ALL_ON)
  `uvm_component_utils_end

  function new (string name , uvm_component parent);
    super.new(name,parent);
  endfunction: new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    monitor = apb_monitor::type_id::create("monitor",this);
    if(is_active == UVM_ACTIVE) begin
      sequencer = apb_sequencer::type_id::create ("sequencer", this);
      if(is_master)
      m_driver = apb_master_driver::type_id::create("m_driver", this);
      else
      s_driver = apb_slave_driver::type_id::create("s_driver", this);
    end
  endfunction: build_phase

  function void connect_phase (uvm_phase phase);
    if(is_active == UVM_ACTIVE) begin
      if(is_master)
        m_driver.seq_item_port.connect(sequencer.seq_item_export);
      else
        s_driver.seq_item_port.connect(sequencer.seq_item_export);
    end
    if (is_active == UVM_ACTIVE) begin
       if (is_master)
          uvm_config_db#(virtual apb_if.master_drv_mp)::set(this, "m_driver", "vif", vif);
       else
          uvm_config_db#(virtual apb_if.slave_drv_mp)::set(this, "s_driver", "vif", vif);
    end
    uvm_config_db#(virtual apb_if.mon_mp)::set(this, "monitor", "vif", vif);

  endfunction: connect_phase

 endclass: apb_agent

