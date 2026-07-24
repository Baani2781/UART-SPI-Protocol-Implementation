`timescale 1ns / 1ps

module baud_rate_generator(

    input clk,
    output tx_enb,
    output rx_enb

);

    parameter TX_DIV = 5208;
    parameter RX_DIV = 325;
    
    reg [12:0] tx_counter;
    reg [8:0]  rx_counter;
    
    initial begin
        tx_counter = 0;
        rx_counter = 0;
    end
    
    always @(posedge clk)
    begin
        if(tx_counter == TX_DIV-1)
            tx_counter <= 0;
        else
            tx_counter <= tx_counter + 1;
    end
    
    always @(posedge clk)
    begin
        if(rx_counter == RX_DIV-1)
            rx_counter <= 0;
        else
            rx_counter <= rx_counter + 1;
    end
    
    assign tx_enb = (tx_counter == 0);
    assign rx_enb = (rx_counter == 0);

endmodule
