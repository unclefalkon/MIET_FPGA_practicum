`timescale 1ns / 1ps

module stopwatch_tb(

    );
    
localparam CLK_SEMIPERIOD = 5;

reg              rstn_i;
reg            clk100_i;
reg        start_stop_i;
reg               set_i;
reg            change_i;
wire [6:0]       hex0_o;
wire [6:0]       hex1_o;
wire [6:0]       hex2_o;
wire [6:0]       hex3_o;  

stopwatch DUT (
  .rstn_i       ( rstn_i       ),
  .clk100_i     ( clk100_i     ),
  .start_stop_i ( start_stop_i ),
  .set_i        ( set_i        ),
  .change_i     ( change_i     ),
  .hex0_o       ( hex0_o       ),
  .hex1_o       ( hex1_o       ),
  .hex2_o       ( hex2_o       ),
  .hex3_o       ( hex3_o       )
);
    
initial begin
  clk100_i = 1'b1;
  forever begin
    #CLK_SEMIPERIOD
    clk100_i=~clk100_i;
  end
end

initial begin
  rstn_i = 1;
  #( CLK_SEMIPERIOD * 10 );
  rstn_i = 0;
  #( CLK_SEMIPERIOD * 10 ); 
  rstn_i = 1;
end

initial begin
  start_stop_i = 0;
  #CLK_SEMIPERIOD; 
  start_stop_i = 1;
  #( CLK_SEMIPERIOD * 10 );
  start_stop_i = 0;
  #CLK_SEMIPERIOD; 
  start_stop_i = 1;
end

initial begin
  set_i = 0;
  #6;
  set_i = 1;
  #23;
  set_i = 0;
  #47;
  set_i = 1;
end

initial begin
  change_i = 0;
  #7;
  change_i = 1;
  #13;
  change_i = 0;
  #27;
  change_i = 1;
  #17;
  change_i = 0;
  #15;
  change_i = 1;
  #21;
  change_i = 0;
  #7;
  change_i = 1;
end
    
endmodule
