`timescale 1ns / 1ps

module stopwatch(
  input            clk100_i,
  input              rstn_i,
  input        start_stop_i,
  input               set_i,
  input            change_i,
  output     [6:0]   hex0_o,
  output     [6:0]   hex1_o,
  output     [6:0]   hex2_o,
  output     [6:0]   hex3_o);

wire start_pushed;
wire set_pushed;
wire change_pushed;

//Синхронизация обработки нажатия кнопок
pinched b0(
  .clk_i  ( clk100_i      ),
  .rst_i  ( rstn_i        ),
  .bt_i   ( !start_stop_i ),
  .btnd_o ( start_pushed  )
  );
  
pinched b1(
  .clk_i  ( clk100_i    ),
  .rst_i  ( rstn_i      ),
  .bt_i   ( !set_i      ),
  .btnd_o ( set_pushed  )
  );

pinched b2(
  .clk_i  ( clk100_i       ),
  .rst_i  ( rstn_i         ),
  .bt_i   ( !change_i      ),
  .btnd_o ( change_pushed  )
  );

reg       device_running;
wire      device_stopped;
reg [3:0] counter;

always @ ( posedge clk100_i or negedge rstn_i ) begin
  if ( !rstn_i ) begin
    counter <= 4'd0;
  end
  else
    if ( device_stopped ) begin
      if ( !start_pushed & set_pushed & counter < 4 )
        counter <= counter + 1;
      else
        if ( set_pushed & counter == 4 )
          counter <= 4'd0;
     end
   end

//Выработка признака "device_running"
assign device_stopped = ( device_running ) ? 1'b0 : 1'b1;

always @ ( posedge clk100_i or negedge rstn_i ) begin
  if ( !rstn_i )
    device_running <= 1'b0;
  else
    begin
      if ( start_pushed & device_running )
        device_running <= 1'b0;
      else
        if ( start_pushed & device_stopped & counter == 0 )
          device_running = 1'b1;
    end
end

wire check;
assign check = device_stopped & !set_pushed & change_pushed;

//Счетчик импульсов и признак истечения 0,01 сек
reg [16:0] pulse_counter;
wire       hundredth_of_second_passed;

assign hundredth_of_second_passed = ( pulse_counter == 17'd259999 );

always @ (posedge clk100_i or negedge rstn_i ) begin
  if ( !rstn_i ) 
    pulse_counter <= 17'd0;
  else
    if ( device_running | hundredth_of_second_passed ) 
      if ( hundredth_of_second_passed )
        pulse_counter <= 17'd0;
      else
        pulse_counter <= pulse_counter + 1;
end

//Основные счетчики 1.сотая доля секунды; 2.десятая доля секунды; 3.секунда; 4.десяток секунд;
//1.
reg  [3:0] hundredths_counter;
wire       tenth_of_second_passed;

assign tenth_of_second_passed = ( ( hundredths_counter == 4'd9 ) & hundredth_of_second_passed );

always @( posedge clk100_i or negedge rstn_i ) begin
  if( !rstn_i )
    hundredths_counter <= 4'd0;
 else
    if( check ) begin
      if( counter == 1 & ( hundredths_counter < 4'd9 ) )
        hundredths_counter <= hundredths_counter + 1;
      else
        if( counter == 1 )
          hundredths_counter <= 0;
    end
      else
        if( hundredth_of_second_passed )
          if( tenth_of_second_passed )
            hundredths_counter <= 4'd0;
          else
            hundredths_counter <= hundredths_counter + 1;
end

//2.
reg [3:0] tenths_counter;
wire      second_passed;

assign second_passed = ( ( tenths_counter == 4'd9 ) & tenth_of_second_passed );

always @( posedge clk100_i or negedge rstn_i ) begin
  if( !rstn_i )
    tenths_counter <= 4'd0;
  else
    if( check ) begin
      if( counter == 2 & tenths_counter < 4'd9 )
        tenths_counter <= tenths_counter + 1;
      else
        if( counter == 2 )
          tenths_counter <= 0;
    end
      else
        if( tenth_of_second_passed )
          if( second_passed )
            tenths_counter <= 4'd0;
          else
            tenths_counter <= tenths_counter + 1;
end

//3.
reg  [3:0] seconds_counter;
wire       ten_seconds_passed;

assign ten_seconds_passed = ( ( seconds_counter == 4'd9 ) & second_passed );

always @( posedge clk100_i or negedge rstn_i ) begin
  if( !rstn_i )
    seconds_counter <= 4'd0;
  else
    if( check ) begin
      if( counter == 3 & seconds_counter < 4'd9 )
        seconds_counter <= seconds_counter + 1;
      else
        if( counter == 3 )
          seconds_counter <= 0;
    end
      else
        if( second_passed )
          if( ten_seconds_passed )
            seconds_counter <= 4'd0;
          else
            seconds_counter <= seconds_counter + 1;
end

//4.
reg [3:0] ten_seconds_counter;

always @( posedge clk100_i or negedge rstn_i ) begin
  if( !rstn_i )
    ten_seconds_counter <= 4'd0;
  else
    if( check ) begin
      if( counter == 4 & ten_seconds_counter < 4'd9 )
        ten_seconds_counter <= ten_seconds_counter + 1;
      else
        if( counter == 4 )
          ten_seconds_counter <= 0;
    end
      else
        if( ten_seconds_passed )
          if( ten_seconds_counter == 4'd9 )
            ten_seconds_counter <= 4'd0;
          else
            ten_seconds_counter <= ten_seconds_counter + 1;
end

//Подключените дешифраторов
dectohex dec0(
  .in ( hundredths_counter ),
  .out( hex0_o             )
);

dectohex dec1(
  .in ( tenths_counter     ),
  .out( hex1_o             )
);

dectohex dec2(
  .in ( seconds_counter     ),
  .out( hex2_o              )
);

dectohex dec3(
  .in ( ten_seconds_counter ),
  .out( hex3_o              )
);


endmodule