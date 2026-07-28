`timescale 1ns / 1ps

module spi_master_tb;
reg clk;
reg rst;
reg start;
reg [7:0] tx_data;
reg miso;
wire sclk_en;
wire mosi;
wire sclk;
wire ss;
wire [7:0] rx_data;
wire busy;
wire done;

//------------------------------------------------
// Clock Divider
//------------------------------------------------

clock_divider clk_div(
    .clk(clk),
    .rst(rst),
    .sclk_en(sclk_en)
);

//------------------------------------------------
// SPI Master
//------------------------------------------------

spi_master uut(
    .clk(clk),
    .rst(rst),
    .sclk_en(sclk_en),
    .start(start),
    .tx_data(tx_data),
    .miso(miso),
    .mosi(mosi),
    .sclk(sclk),
    .ss(ss),
    .rx_data(rx_data),
    .busy(busy),
    .done(done)
);
//------------------------------------------------
// 50 MHz Clock
//------------------------------------------------
initial
begin
    clk = 0;
    forever
        #10 clk = ~clk;
end
//------------------------------------------------
// Stimulus
//------------------------------------------------
initial
begin
    rst=1;
    start=0;
    tx_data=8'hA5;
    miso=0;

    #50;

    rst=0;

    #100;

    start=1;

    #20;

    start=0;

end
//------------------------------------------------
// MISO generation
//------------------------------------------------
initial
begin
    miso= 1'b0;

    wait(ss==0);

    miso=1;
    #1000;

    miso=0;
    #1000;

    miso=1;
    #1000;

    miso= 0;
    #1000;

    miso=1;
    #1000;

    miso=0;
    #1000;

    miso =1;
    #1000;
  
    miso =0;
end

initial
begin
    #12000;
    $finish;
end

endmodule
