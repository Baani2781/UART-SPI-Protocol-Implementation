`timescale 1ns / 1ps

module baud_rate_generator_tb;

    // Inputs
    reg clk;

    // Outputs
    wire tx_enb;
    wire rx_enb;

    // Instantiate the DUT
    baud_rate_generator uut (
        .clk(clk),
        .tx_enb(tx_enb),
        .rx_enb(rx_enb)
    );

    // 50 MHz clock (20 ns period)
    initial begin
        clk = 0;
        forever #10 clk = ~clk;
    end

    // Running simulation for 300 us
    initial begin
        #300000;
        $finish;
    end

endmodule
