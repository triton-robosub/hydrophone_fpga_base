`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/10/2021 04:58:09 PM
// Design Name: 
// Module Name: ad5263_interface
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


module ad5263_interface(
    output wire sck,
    output wire sdo,
    output wire cs_n,
    input wire [1:0] channel,
    input wire [7:0] value,
    input wire clk,
    input wire rst_n,
    input wire transmit
    );    

reg[4:0] counter;
reg transmitting;
assign cs_n = ~transmitting;

reg[9:0] full_packet;
assign sdo = full_packet[9 - counter[4:1]];
assign sck = counter[0];

always @(posedge clk)
begin
    if(~rst_n) begin
        transmitting <= 0;
        full_packet <= 0;
    end else begin
        if(transmit & ~transmitting) begin
            transmitting <= 1;
            //latch in channel and data
            full_packet <= {channel, value};
        end else if(counter == 20) begin
            transmitting <= 0;
        end else begin
            transmitting <= transmitting;
        end
    end
end

reg[10:0] freq_div;

always @(posedge clk)
begin
    if(~rst_n | ~transmitting) begin
        counter <= 0;
        freq_div <= 0;
    end else begin
        freq_div <= (freq_div == 999) ? 0 : freq_div + 1;
        if(freq_div == 999) begin
            counter <= counter + 1;
        end
    end
end

endmodule
