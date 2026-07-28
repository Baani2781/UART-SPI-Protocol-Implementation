`timescale 1ns / 1ps

module spi_slave(
    input rst,
    input sclk,
    input ss,
    input mosi,
    input [7:0] tx_data,
    output reg miso,
    output reg [7:0] rx_data,
    output reg done
);

reg [7:0] tx_shift;
reg [7:0] rx_shift;
reg [3:0] bit_count;

always @(negedge ss or posedge rst)
begin
    if(rst)
    begin
        tx_shift <= 8'd0;
        rx_shift <= 8'd0;
        rx_data <= 8'd0;
        bit_count <= 4'd7;
        miso <= 1'b0;
        done <= 1'b0;
    end

    else
    begin
        tx_shift <= tx_data;
        bit_count <= 4'd7;
        miso <= tx_data[7];
        done <= 1'b0;
    end
end


always @(posedge sclk)
begin
    if(!ss)
    begin
        rx_shift[bit_count] <= mosi;
        if(bit_count == 0)
        begin
            rx_data <= {rx_shift[7:1], mosi};
            done <= 1'b1;
        end
    end
end

always @(negedge sclk)
begin
    if(!ss)
    begin
        if(bit_count != 0)
        begin
            bit_count <= bit_count - 1'b1;
            tx_shift <= {tx_shift[6:0],1'b0};
            miso <= tx_shift[6];
        end
    end
    else
    begin
        done <= 1'b0;
    end
end
endmodule
