module edge_detector #(parameter POSEDGE=1) (
  input clk,
  input in,
  output reg edge_detect
);
  reg prev_in;
  always @(posedge clk) begin
    prev_in <= in;
    if (POSEDGE)
      edge_detect <= (in == 1 && prev_in == 0);
    else
      edge_detect <= (in == 0 && prev_in == 1);
  end
endmodule