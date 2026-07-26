`timescale 1ns / 1ps

module receiver_tb;

    //==================================================
    // Inputs
    //==================================================
    reg clk;
    reg rst;
    reg rx_enb;
    reg rx;

    //==================================================
    // Outputs
    //==================================================
    wire [7:0] data_out;
    wire data_ready;

    //==================================================
    // DUT
    //==================================================
    receiver uut (
        .clk(clk),
        .rst(rst),
        .rx_enb(rx_enb),
        .rx(rx),
        .data_out(data_out),
        .data_ready(data_ready)
    );

    //==================================================
    // 50 MHz Clock (20 ns period)
    //==================================================
    initial begin
        clk = 0;
        forever #10 clk = ~clk;
    end
    //==================================================
    // 16x Baud Enable Pulse
    // 9600 baud × 16 = 153600 Hz
    // One pulse every 325 clock cycles
    //==================================================
    initial begin
        rx_enb = 0;
        forever begin
            #6480;      // 324 clock cycles
            rx_enb= 1;
            #20;        // 1 clock cycle pulse
            rx_enb= 0;
        end
    end
    //==================================================
    // UART Frame Generator
    // Sends 8'hA5
    //==================================================
    initial begin

        rst= 1;
        rx = 1;          // Idle line is HIGH

        #100;
        rst = 0;
        // Wait before transmitting
        #10000;
        //-----------------------------
        // Start Bit
        //-----------------------------
        rx = 0;
        #104160;
        //-----------------------------
        // Data Bits (LSB First)
        // A5 = 10100101
        //-----------------------------
        rx = 1;   // Bit0
        #104160;

        rx = 0;   // Bit1
        #104160;

        rx = 1;   // Bit2
        #104160;

        rx = 0;   // Bit3
        #104160;

        rx = 0;   // Bit4
        #104160;

        rx = 1;   // Bit5
        #104160;

        rx = 0;   // Bit6
        #104160;
        rx = 1;   // Bit7
        #104160;
        //-----------------------------
        // Stop Bit
        //-----------------------------
        rx = 1;
        #104160;
        // Wait before finishing
        #50000;
        $finish;
    end
endmodule
