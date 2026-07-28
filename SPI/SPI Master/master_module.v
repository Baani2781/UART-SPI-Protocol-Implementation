`timescale 1ns / 1ps

module spi_master(
    input clk,
    input rst,
    input sclk_en,
    input start,
    input [7:0] tx_data,
    input miso,
    output reg mosi,
    output reg sclk,
    output reg ss,
    output reg [7:0] rx_data,
    output reg busy,
    output reg done);

parameter IDLE_STATE= 2'b00;
parameter TRANSFER_STATE= 2'b01;
parameter FINISH_STATE= 2'b10;

reg [1:0]state;
reg [7:0]tx_shift;
reg [7:0]rx_shift;
reg [3:0]bit_count;
always @(posedge clk or posedge rst)
begin
    if(rst)
    begin
        state<= IDLE_STATE;
        ss<=1'b1;
        sclk<=1'b0;
        mosi <= 1'b0;
        busy<=1'b0;
        done<=1'b0;
        bit_count <=4'd7;
        tx_shift<=8'd0;
        rx_shift<=8'd0;
        rx_data<=8'd0;
    end

    else
    begin
        done<=1'b0;
        case(state)
        IDLE_STATE:
        begin
            ss<=1'b1;
            sclk<=1'b0;
            busy<=1'b0;
            if(start)
            begin
                ss<=1'b0;
                busy<=1'b1;
                tx_shift<=tx_data;
                bit_count<=3'd7;
                mosi <= tx_data[7];
                state <= TRANSFER_STATE;
            end
        end
        
        TRANSFER_STATE:
        begin
            if(sclk_en)
            begin       
                if(sclk == 1'b0)
                begin
                    sclk <= 1'b1;
                    rx_shift[bit_count] <= miso;
                end
                else
                begin
                    sclk <= 1'b0;
                    if(bit_count == 0)
                    begin
                        state <= FINISH_STATE;
                    end
                    else
                    begin
                        bit_count <= bit_count - 1'b1;
                        tx_shift <= {tx_shift[6:0],1'b0};
                        mosi <= tx_shift[6];
                    end
                end
            end
        end
        //---------------------------------------
        FINISH_STATE:
        begin
            ss<=1'b1;
            busy<=1'b0;
            sclk<=1'b0;
            rx_data<=rx_shift;
            done<=1'b1;
            state <= IDLE_STATE;
        end
        endcase
    end
end

endmodule
