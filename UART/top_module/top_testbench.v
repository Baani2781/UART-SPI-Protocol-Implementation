`timescale 1ns / 1ps

module uart_top_tb;
    //==================================================
    // Inputs
    //==================================================
    reg clk;
    reg rst;
    reg tx_start;
    reg [7:0] tx_data;
    //==================================================
    // Outputs
    //==================================================
    wire tx;
    wire tx_busy;
    wire [7:0] rx_data;
    wire data_ready;
    //==================================================
    // Device Under Test
    //==================================================
    uart_top uut (
        .clk(clk),
        .rst(rst),
        .tx_start(tx_start),
        .tx_data(tx_data),
        .tx(tx),
        .tx_busy(tx_busy),
        .rx_data(rx_data),
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
    // Test Sequence
    //==================================================
    initial begin

        // Initialize inputs
        rst      = 1;
        tx_start = 0;
        tx_data  = 8'hA5;

        // Hold reset
        #100;
        rst = 0;

        // Wait a little
        #100;

        // Start transmission
        tx_start = 1;
        #20;
        tx_start = 0;

        // Wait until transmitter starts
        wait(tx_busy);

        // Wait until transmission finishes
        wait(!tx_busy);

        // Wait until receiver receives the byte
        wait(data_ready);
        // Give one extra clock
        #20;
        // Display received data
        $display("------------------------------------");
        $display("Received Data = %h", rx_data);
        $display("------------------------------------");
        if (rx_data == 8'hA5)
            $display("UART LOOPBACK TEST PASSED");
        else
            $display("UART LOOPBACK TEST FAILED");
        #100;
        $finish;
    end

endmodule
