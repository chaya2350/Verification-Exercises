/*-----------------------------------------------------------------
File name     : run.f
Description   : lab01_data simulator run template file
Notes         : From the Cadence "SystemVerilog Advanced Verification with UVM" training
              : Set $UVMHOME to install directory of UVM library
-------------------------------------------------------------------
Copyright Cadence Design Systems (c)2015
-----------------------------------------------------------------*/
// 64 bit option for AWS labs
-64
-uvmhome /tools/cadence/XCELIUM/24.09.011/tools/methodology/UVM/CDNS-1.1d

-timescale 1ns/1ns

// -----------------------------
// Include directories
// -----------------------------
+incdir+../sv
+incdir+../tb
+incdir+../dut

// -----------------------------
// APB UVC Components
// -----------------------------
../sv/apb_if.sv
../sv/apb_pkg.sv 

// -----------------------------
// DUT (Device Under Test)
// -----------------------------
../dut/apb_slave.sv

// -----------------------------
// Top-level Testbench
// -----------------------------
 apb_tb_top.sv

+UVM_TESTNAME=rand_seq_test
+UVM_VERBOSITY=UVM_HIGH
+ntb_random_seed=auto








