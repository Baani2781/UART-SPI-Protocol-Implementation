`timescale 1ns / 1ps

module clock_divider_tb;
reg clk;
reg rst;
wire sclk_en;
clock_divider uut(
    .clk(clk),
    .rst(rst),
    .sclk_en(sclk_en));

initial
begin
    clk=0;
    forever
        #10 clk=~clk;
end
initial
begin
    rst=1;
    #50;
    rst=0;
    #5000;
    $finish;
end
endmodule
