//==============================================================
//  APB Testbench Top - FIXED for DUT port names
//==============================================================

import uvm_pkg::*;
`include "uvm_macros.svh"

import apb_pkg::*;
`include "apb_test.sv"

module apb_tb_top;

  logic pclk;
  logic presetn;

  initial begin
    pclk = 0;
    forever #5 pclk = ~pclk; 
  end

  initial begin
    presetn = 0;
    #20 presetn = 1;
  end

  apb_if apb_master_if(.pclk(pclk), .presetn(presetn));

  apb_slave dut(
    .pclk(pclk),
    .rst_n(presetn),
    .paddr(apb_master_if.paddr),
    .psel(apb_master_if.psel),
    .penable(apb_master_if.penable),
    .pwrite(apb_master_if.pwrite),
    .pwdata(apb_master_if.pwdata),
    .pready(apb_master_if.pready),
    .prdata(apb_master_if.prdata)
  );

  initial begin
    uvm_config_db#(virtual apb_if.mon_mp)::set(null, "*.monitor", "vif", apb_master_if.mon_mp);
    uvm_config_db#(virtual apb_if.master_drv_mp)::set(null, "*.m_driver", "vif", apb_master_if.master_drv_mp);
    uvm_config_db#(virtual apb_if.slave_drv_mp)::set(null, "*.s_driver", "vif", apb_master_if.slave_drv_mp);
    run_test();
  end
endmodule

