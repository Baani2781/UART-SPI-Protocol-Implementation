`timescale 1ns / 1ps

module transmitter(

    input clk,
    input rst,
    input tx_enb, // Baud tick from baud rate generator
    input tx_start,     // Start transmission
    input [7:0]data_in,// Parallel data input

    output reg tx,  // Serial output
    output tx_busy);

    //====================================================
    // State Encoding
    //====================================================
    localparam IDLE_STATE  =2'b00;
    localparam START_STATE =2'b01;
    localparam DATA_STATE  =2'b10;
    localparam STOP_STATE  = 2'b11;

    //====================================================
    // Registers
    //====================================================
    reg [1:0]state;
    reg [7:0]tx_data;
    reg [2:0]bit_index;

    //====================================================
    // UART Transmitter FSM
    //====================================================
    always @(posedge clk)
    begin

        if(rst)
        begin
            state <=IDLE_STATE;
            tx <= 1'b1;
            tx_data<= 8'd0;
            bit_index <=3'd0;
        end

        else
        begin

            case(state)

            //============================================
            // IDLE
            //============================================
            IDLE_STATE:
            begin
                tx <=1'b1;
                if(tx_start)
                begin
                    tx_data<= data_in;
                    bit_index <= 3'd0;
                    state<= START_STATE;
                end
            end

            //============================================
            // START BIT
            //============================================
            START_STATE:
            begin
                if(tx_enb)
                begin
                    tx<= 1'b0;
                    state<= DATA_STATE;
                 end
            end

            //============================================
            // DATA BITS (LSB FIRST)
            //============================================
            DATA_STATE:
            begin
                if(tx_enb)
                begin
                    tx <= tx_data[bit_index];

                  
                    if(bit_index == 3'd7)
                        state <= STOP_STATE;
                    else
                        bit_index <= bit_index + 1'b1;
                end
            end

            //============================================
            // STOP BIT
            //============================================
            STOP_STATE:
            begin
                if(tx_enb)
                begin
                    tx<= 1'b1;
                    state<= IDLE_STATE;
                    bit_index <= 3'd0;
                end
            end
            default:
            begin
                state<= IDLE_STATE;
                tx<= 1'b1;
                tx_data <= 8'd0;
                bit_index <= 3'd0;
            end
            endcase
        end
    end
    assign tx_busy = (state != IDLE_STATE);

endmodule
