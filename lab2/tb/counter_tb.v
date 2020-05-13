`timescale 1ns / 1ps

module counter_tb(

    );
    
localparam CLK_SEMIPERIOD = 5;

reg         clk100_i;
reg  [9:0]      sw_i;
reg  [2:0]     key_i;
wire [9:0]    ledr_o;
wire [6:0]    hex0_o;
wire [6:0]    hex1_o;
wire [6:0]    hex2_o;
wire [6:0]    hex3_o;

counter DUT(
  .sw_i      (  sw_i      ),
  .clk100_i  (  clk100_i  ),
  .key_i     (  key_i     ),
  .ledr_o    (  ledr_o    ),
  .hex0_o    (  hex0_o    ),
  .hex1_o    (  hex1_o    ),
  .hex2_o    (  hex2_o    ),
  .hex3_o    (  hex3_o    )  
);  

initial begin
  clk100_i = 1'b1;
  forever begin
            #CLK_SEMIPERIOD clk100_i = ~clk100_i;
          end
end

initial begin
  key_i[1] = 1'b1;
  #( 8*CLK_SEMIPERIOD );
  key_i[1] = 1'b0;
  #( 8*CLK_SEMIPERIOD );
  key_i[1] = 1'b1;
end  

initial begin
  sw_i [9:0]  = 10'b0;
  key_i[0]    = 1'b1;
  key_i[2]    = 1'b1;
  repeat ( 40 ) begin
    #( CLK_SEMIPERIOD - 1 );
    sw_i = $random();
    #( 5 * CLK_SEMIPERIOD );
    key_i[0] = 1'b0;
    #( 10 * CLK_SEMIPERIOD );
    key_i[2] = 1'b0;
    #( 5 * CLK_SEMIPERIOD );
    key_i[0] = 1'b1;
    #( 10 * CLK_SEMIPERIOD );
    key_i[2] = 1'b1;
  end
end   
 
endmodule
