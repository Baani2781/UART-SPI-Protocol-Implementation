`timescale 1ns / 1ps

module receiver(

    input clk,
    input rst,
    input rx_enb,      // 16x baud enable
    input rx,          // Serial input
    output reg [7:0] data_out,
    output reg data_ready);

    //====================================================
    // State Encoding
    //====================================================
    localparam IDLE_STATE = 2'b00;
    localparam START_STATE = 2'b01;
    localparam DATA_STATE= 2'b10;
    localparam STOP_STATE= 2'b11;

    //====================================================
    // Registers
    //====================================================
    reg [1:0]state;
    reg [3:0] sample_count;      // Counts 0-15
    reg [2:0] bit_index;
    reg [7:0] rx_shift;

    //====================================================
    // UART Receiver FSM
    //====================================================

    always @(posedge clk)
    begin

        if(rst)
        begin
            state <= IDLE_STATE;
            sample_count <= 4'd0;
            bit_index <= 3'd0;
            rx_shift <=8'd0;
            data_out <=8'd0;
            data_ready <=1'b0;
        end
        else
        begin
            data_ready <= 1'b0;
            if(rx_enb)
            begin
                case(state)

                //----------------------------------------
                // IDLE
                //----------------------------------------
                IDLE_STATE:
                begin
                    sample_count <=4'd0;

                    if(rx ==1'b0)
                        state <= START_STATE;
                end

                //----------------------------------------
                // START BIT
                //----------------------------------------
                START_STATE:
                begin
                    if(sample_count == 4'd7)
                    begin
                        if(rx == 1'b0)
                        begin
                            sample_count<= 4'd0;
                            bit_index <=3'd0;
                            state <= DATA_STATE;
                        end
                        else
                        begin
                            state <= IDLE_STATE;
                        end

                    end
                    else
                    begin
                        sample_count <= sample_count+1'b1;
                    end
                end

                //----------------------------------------
                // DATA
                //----------------------------------------
                DATA_STATE:
                begin

                    if(sample_count == 4'd15)
                    begin

                        sample_count <= 4'd0;

                        rx_shift[bit_index] <= rx;

                        if(bit_index == 3'd7)
                            state <= STOP_STATE;
                        else
                            bit_index <= bit_index+1'b1;

                    end
                    else
                    begin
                        sample_count <= sample_count + 1'b1;
                    end

                end

                //----------------------------------------
                // STOP BIT
                //----------------------------------------
                STOP_STATE:
                begin

                    if(sample_count==4'd15)
                    begin
                        sample_count <= 4'd0;
                        if(rx == 1'b1)
                        begin
                            data_out<= rx_shift;
                            data_ready <= 1'b1;
                        end
                        state <= IDLE_STATE;
                    end
                    else
                    begin
                        sample_count <= sample_count + 1'b1;
                    end
                end
                default:
                    state <= IDLE_STATE;
                endcase
            end
        end
    end

endmodule
