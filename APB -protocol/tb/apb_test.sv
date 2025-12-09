
class base_test extends uvm_test;
	`uvm_component_utils(base_test)

    apb_agent master_agent;

	function new(string name, uvm_component parent);
		super.new(name,parent);
	endfunction:new


	function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    uvm_config_db#(int)::set(this, "*", "recording_detail", 1);

    master_agent = apb_agent::type_id::create("master_agent", this);
    master_agent.is_active = UVM_ACTIVE;
    master_agent.is_master = 1;

    `uvm_info("MSG", "Test build_phase executed", UVM_HIGH)
  endfunction : build_phase

	task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    phase.phase_done.set_drain_time(this, 200ns);
    `uvm_info("RUN", "Base test running...", UVM_LOW)
    phase.drop_objection(this);
  endtask : run_phase

	function void end_of_elaboration_phase(uvm_phase phase);
	  uvm_top.print_topology();
  endfunction: end_of_elaboration_phase

	function void check_phase (uvm_phase phase);
    check_config_usage();
  endfunction:check_phase


endclass:base_test

class rand_seq_test extends base_test;
  `uvm_component_utils(rand_seq_test)

  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction:new
 
  function void build_phase(uvm_phase phase);
    uvm_config_db#(uvm_object_wrapper)::set(
      this,
      "master_agent.sequencer.run_phase",
      "default_sequence",
      apb_rand_seq::type_id::get()
    );

    super.build_phase(phase);
  endfunction : build_phase
endclass:rand_seq_test
