`timescale 1ns / 1ps

module transmitter_tb;

    //==================================================
    // Inputs
    //==================================================
    reg clk;
    reg rst;
    reg tx_enb;
    reg tx_start;
    reg [7:0] data_in;

    //==================================================
    // Outputs
    //==================================================
    wire tx;
    wire tx_busy;

    //==================================================
    // Device Under Test
    //==================================================
    transmitter uut (
        .clk(clk),
        .rst(rst),
        .tx_enb(tx_enb),
        .tx_start(tx_start),
        .data_in(data_in),
        .tx(tx),
        .tx_busy(tx_busy)
    );

    //==================================================
    // 50 MHz Clock (20 ns period)
    //==================================================
    initial begin
        clk= 0;
        forever #10 clk = ~clk;
    end

    //==================================================
    // Baud Enable Pulse
    // 9600 baud = 104166 ns per bit
    // Pulse width = one clock cycle (20 ns)
    //==================================================
    initial begin
        tx_enb = 0;
        forever begin
            #104146;
            tx_enb = 1;
            #20;
            tx_enb = 0;
        end
    end

    //==================================================
    // Test Sequence
    //==================================================
    initial begin

        // Initialize inputs
        rst = 1;
        tx_start= 0;
        data_in= 8'b10100101;

        // Hold reset
        #40;
        rst =0;

        // Wait before transmission
        #40;

        // Start transmission
        tx_start = 1;
        #20;
        tx_start = 0;

        // Wait until transmission starts
        wait(tx_busy);

        // Wait until transmission completes
        wait(!tx_busy);

        // Small delay before ending simulation
        #100;

        $finish;

    end

endmodule
