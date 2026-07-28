`timescale 1ns / 1ps

module clock_divider(
    input clk,
    input rst,
    output reg sclk_en);

parameter DIV = 25;

reg [7:0] counter;

always @(posedge clk or posedge rst)
begin
    if(rst)
    begin
        counter<= 0;
        sclk_en<= 0;
    end
    else
    begin
        if(counter == DIV-1)
        begin
            counter<= 0;
            sclk_en<=1'b1;
        end
        else
        begin
            counter <=counter+1'b1;
            sclk_en <= 1'b0;
        end
    end
end

endmodule
