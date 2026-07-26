`timescale 1ns / 1ps

module uart_top(

    input clk,
    input rst,
    input tx_start,
    input  [7:0]tx_data,
    output tx,
    output tx_busy,
    output [7:0]rx_data,
    output data_ready
);

    //--------------------------------------------------
    // Internal Signals
    //--------------------------------------------------

    wire tx_enb;
    wire rx_enb;

    //--------------------------------------------------
    // Baud Rate Generator
    //--------------------------------------------------

    baud_rate_generator baud_gen(
        .clk(clk),
        .tx_enb(tx_enb),
        .rx_enb(rx_enb) );

    //--------------------------------------------------
    // UART Transmitter
    //--------------------------------------------------

    transmitter tx_module(
        .clk(clk),
        .rst(rst),
        .tx_enb(tx_enb),
        .tx_start(tx_start),
        .data_in(tx_data),
        .tx(tx),
        .tx_busy(tx_busy)
    );
    //--------------------------------------------------
    // UART Receiver
    //--------------------------------------------------
    receiver rx_module(
        .clk(clk),
        .rst(rst),
        .rx_enb(rx_enb),
        .rx(tx),          // Loopback connection
        .data_out(rx_data),
        .data_ready(data_ready)

    );

endmodule
