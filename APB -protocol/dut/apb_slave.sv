//==============================================================
//  Fixed Version - APB Slave DUT
//==============================================================
`timescale 1ns/1ps

module apb_slave (
  input  logic         pclk,
  input  logic         rst_n,
  input  logic [31:0]  paddr,
  input  logic         psel,
  input  logic         penable,
  input  logic         pwrite,
  input  logic [31:0]  pwdata,
  output logic         pready,
  output logic [31:0]  prdata
);

  logic [31:0] mem [0:255];      
  logic [1:0]  apb_st;

  localparam SETUP     = 2'b00;
  localparam W_ENABLE  = 2'b01;
  localparam R_ENABLE  = 2'b10;

  always_ff @(posedge pclk or negedge rst_n) begin
    if (!rst_n) begin
      apb_st <= SETUP;
      prdata <= 32'b0;
      pready <= 1'b1;

      // Initialize memory
      for (int i = 0; i < 256; i++)
        mem[i] <= i;
    end
    else begin
      case (apb_st)
        SETUP: begin
          prdata <= 32'b0;
          pready <= 1'b0;
          if (psel && !penable) begin
            if (pwrite)
              apb_st <= W_ENABLE;
            else begin
              apb_st <= R_ENABLE;
              prdata <= mem[paddr[7:0]];  // שימוש רק ב־8 ביטים לכתובת
            end
          end
        end

        W_ENABLE: begin
          if (psel && penable && pwrite) begin
            mem[paddr[7:0]] <= pwdata;
          end
          pready <= 1'b1;
          apb_st <= SETUP;
        end

        R_ENABLE: begin
          pready <= 1'b1;
          apb_st <= SETUP;
        end

        default: apb_st <= SETUP;
      endcase
    end
  end

endmodule : apb_slave
