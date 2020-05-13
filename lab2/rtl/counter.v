`timescale 1ns / 1ps

module counter(
    input         clk100_i,
    input  [9:0]      sw_i,
    input  [2:0]     key_i,
    output [9:0]    ledr_o,
    output [6:0]    hex0_o,
    output [6:0]    hex1_o,
    output [6:0]    hex2_o,
    output [6:0]    hex3_o);

reg [9:0] register;
reg [15:0] counter;

wire bt_down;

pinched btdown(
  .bt_i   (    !key_i[0] & !key_i[2] ),
  .rst_i  (    key_i[1]              ),
  .clk_i  (    clk100_i              ),
  .btnd_o (    bt_down               )
);

always @ ( posedge clk100_i or negedge key_i[1] )
 begin
   if ( !key_i[1] )
     register <= 10'b0;
  else if ( bt_down )
     register <= sw_i;
 end 
 
always @ ( posedge clk100_i or negedge key_i[1] )
  begin
    if ( !key_i[1] )
      counter <= 16'd0;
    else if ( bt_down && ( sw_i > 10'd20 ) )
      counter <= counter + 1;
  end

assign ledr_o = register;

dectohex dec0
( .in  ( counter[3:0] ),
  .out ( hex0_o       )
);
  
dectohex dec1
( .in  ( counter[7:4] ),
  .out ( hex1_o       )
);

dectohex dec2
( .in  ( counter[11:8] ),
  .out ( hex2_o        )
);

dectohex dec3
( .in  ( counter[15:12] ),
  .out ( hex3_o         )
);

endmodule