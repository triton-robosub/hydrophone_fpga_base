`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/16/2021 01:51:33 PM
// Design Name: 
// Module Name: ltc2325
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ltc2325(

    output reg[15:0] data,
    output reg[1:0] channel,
    output reg new_samp,
    
    input wire aclk,
    input wire rst_n
    );
    
reg[7:0] counter;

always @(posedge aclk) begin
    if(~rst_n) begin
        counter <= 0;
        data <= 0;
        channel <= 0;
    end else begin
        if(counter == 99) begin
            counter <= 0;
            data <= (channel == 3) ? data + 1 : data;
            channel <= channel + 1;
            new_samp <= 1;
        end else begin
            counter <= counter + 1;
            data <= data;
            channel <= channel;
            new_samp <= 0;
        end
    end
end
    
endmodule
