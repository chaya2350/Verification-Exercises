interface apb_if #(parameter addr_width = 32,
                   parameter data_width = 32)
                  (input logic pclk,
                   input logic presetn);

  logic [addr_width-1:0] paddr;   
  logic                  pwrite;   
  logic [data_width-1:0] pwdata;   
  logic [data_width-1:0] prdata;   
  logic                  psel;     
  logic                  penable;  
  logic                  pready;   
  logic                  pslverr;  


  modport master_drv_mp (
    input  pready, prdata, pslverr, presetn, pclk,
    output paddr, pwrite, pwdata, psel, penable
  );

  modport slave_drv_mp (
    input  paddr, pwrite, pwdata, psel, penable, presetn, pclk,
    output prdata, pready, pslverr
  );

  modport mon_mp (
    input paddr, pwrite, pwdata, prdata,
          psel, penable, pready, pslverr,
          presetn, pclk
  );

  

endinterface




