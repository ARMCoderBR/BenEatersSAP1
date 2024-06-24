`timescale 1ns / 10ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/11/2024 05:09:16 PM
// Design Name: 
// Module Name: decoderbcd
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

module decoderbcd_coan(
    input [4:0]data,
    output reg [6:0]seg
    );
    
    initial begin
        seg = ~7'h00;
    end
    
    always @ (data) begin
        case (data)
                     //     .GFEDCBA    
         5'b00000: seg = ~7'b0111111;
         5'b00001: seg = ~7'b0000110;
         5'b00010: seg = ~7'b1011011;
         5'b00011: seg = ~7'b1001111;
         5'b00100: seg = ~7'b1100110;
         5'b00101: seg = ~7'b1101101;
         5'b00110: seg = ~7'b1111101;
         5'b00111: seg = ~7'b0000111;
         5'b01000: seg = ~7'b1111111;
         5'b01001: seg = ~7'b1101111;
         5'b01010: seg = ~7'b1110111;
         5'b01011: seg = ~7'b1111100;
         5'b01100: seg = ~7'b0111001;
         5'b01101: seg = ~7'b1011110;
         5'b01110: seg = ~7'b1111001;
         5'b01111: seg = ~7'b1110001;
         5'b10000: seg = ~7'b1000000;
         default:  seg = ~7'b0000000;
    
        endcase
    end
endmodule
