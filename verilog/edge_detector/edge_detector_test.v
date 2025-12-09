module edge_detector_tb;
  reg clk;
  reg in;
  wire posedge_detect;
  wire negedge_detect;

  edge_detector #(1) posedge_inst (
    .clk(clk),
    .in(in),
    .edge_detect(posedge_detect)
  );

  edge_detector #(0) negedge_inst (
    .clk(clk),
    .in(in),
    .edge_detect(negedge_detect)
  );

  initial begin
    clk = 0;
    forever #5 clk = ~clk; // מחזור שעון 10ns
  end

  initial begin
    in = 0;
    
    #20 in = 1; 
    #40 in = 0;  
    #30 in = 1;
    #10 in = 0;
    #20 $finish;
  end

  initial begin
    $monitor("Time=%0t | in=%b | posedge_detect=%b | negedge_detect=%b", $time, in, posedge_detect, negedge_detect);
  end

  initial begin
    $dumpfile("edge_detector_tb.vcd");
    $dumpvars(0, edge_detector_tb);
  end
endmodule