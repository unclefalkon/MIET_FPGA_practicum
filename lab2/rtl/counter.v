`timescale 1ns / 1ps
module counter(
    input         clk_i,
    input  [9:0]   sw_i,
    input  [1:0]  key_i,
    output [9:0] ledr_o,
    output [6:0] hex1_o,
    output [6:0] hex0_o);

reg [9:0] register;
reg [7:0] counter;

wire bt_down;

pinched btdown(
  .bt_i  ( !key_i[0] ),
  .rst_i  ( key_i[1] ),
  .clk_i     ( clk_i ),
  .btnd_o  ( bt_down )
);

always @ ( posedge clk_i or negedge key_i[1]) begin
  if ( !key_i[1] ) begin
   register <= 10'b0;
   counter  <=  8'd0;
  end
  else
    if ( bt_down ) begin
      register <=        sw_i;
      counter  <= counter + 1;
    end
end 

assign ledr_o = register;

dectohex dec0
( .in ( counter[7:4] ),
  .out( hex0_o       )
);
  
dectohex dec1
( .in ( counter[3:0] ),
  .out( hex1_o       )
);

endmodule
