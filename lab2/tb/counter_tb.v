`timescale 1ns / 1ps

module counter_tb(

    );
    
localparam CLK_SEMIPERIOD = 5;

reg         clk_i;
reg  [9:0]   sw_i;
wire [1:0]  key_i;
wire [9:0] ledr_o;
wire [6:0] hex0_o;
wire [6:0] hex1_o;

counter DUT(
  .sw_i   (   sw_i ),
  .clk_i  (  clk_i ),
  .key_i  (  key_i ),
  .ledr_o ( ledr_o ),
  .hex0_o ( hex0_o ),
  .hex1_o ( hex1_o )
);

reg [1:0] sw = 2'b11;

initial begin
  clk_i = 1'b1;
  forever begin
            #CLK_SEMIPERIOD clk_i = ~clk_i;
          end
end

initial begin
  sw_i[9:0] = 10'd1;
  forever begin
            #( CLK_SEMIPERIOD - 1 );
            sw_i[9:0] = $random();
          end
        end
        
initial begin
          repeat( 16 )
          begin
            #50;
            sw = $random();
          end
        end
        
assign key_i = sw; 
 
endmodule
