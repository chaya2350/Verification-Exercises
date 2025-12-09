

class apb_base_seq extends uvm_sequence #(apb_packet);
  
  // Required macro for sequences automation
  `uvm_object_utils(apb_base_seq)

  // Constructor
  function new(string name="apb_base_seq");
    super.new(name);
  endfunction

  task pre_body();
    uvm_phase phase;
    `ifdef UVM_VERSION_1_2
      // in UVM1.2, get starting phase from method
      phase = get_starting_phase();
    `else
      phase = starting_phase;
    `endif
    if (phase != null) begin
      phase.raise_objection(this, get_type_name());
      `uvm_info(get_type_name(), "raise objection", UVM_MEDIUM)
    end
  endtask : pre_body

  task post_body();
    uvm_phase phase;
    `ifdef UVM_VERSION_1_2
      // in UVM1.2, get starting phase from method
      phase = get_starting_phase();
    `else
      phase = starting_phase;
    `endif
    if (phase != null) begin
      phase.drop_objection(this, get_type_name());
      `uvm_info(get_type_name(), "drop objection", UVM_MEDIUM)
    end
  endtask : post_body

endclass : apb_base_seq

class apb_rand_seq extends apb_base_seq;
 `uvm_object_utils(apb_rand_seq)
 rand int count;
 apb_packet req;

 constraint count_limit {count inside{[1:10]};}

  function new (string name = "apb_rand_seq");
    super.new(name);
  endfunction:new

  virtual task body();
      if (!randomize()) begin
        `uvm_error(get_type_name(), "Randomization failed!");
        return;
    end
    `uvm_info(get_type_name(), $sformatf("Executing apb_rand_seq %0d times",count), UVM_LOW)
    repeat(count)
    `uvm_do(req)
    
  endtask

endclass:apb_rand_seq