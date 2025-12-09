
typedef enum {READ, WRITE} apb_command_e;

class apb_packet extends uvm_sequence_item;

  rand bit [31:0] addr;          
  rand bit [31:0] data;           
  rand apb_command_e command; 

  `uvm_object_utils_begin(apb_packet)
    `uvm_field_int(addr, UVM_ALL_ON)
    `uvm_field_int(data, UVM_ALL_ON)
    `uvm_field_enum(apb_command_e, command, UVM_ALL_ON)
  `uvm_object_utils_end


  function new (string name="apb_packet");
    super.new(name);
  endfunction
endclass:apb_packet
