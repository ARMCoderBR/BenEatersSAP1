`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/19/2024 07:27:12 PM
// Design Name: 
// Module Name: reg8bit
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

module reg8bit(
    input mainclk,
    input clkin,
    input w_enable,
    input r_enable,
    input resetpin,
    inout [7:0] busdata,
    output reg [7:0] data
    );
    
    reg [7:0] regbusdata;
    assign busdata = regbusdata;    
    reg f_clkin;
    
    initial begin

        f_clkin = 0;
        data = 0;
    end

    always @ (posedge mainclk) begin
    
        if (resetpin) data = 0;
        else
        if (clkin) begin
        
            if (!f_clkin) begin
            
                f_clkin = 1;
                if (w_enable && !r_enable) data = busdata;    
            end
        end else f_clkin = 0;

        if (r_enable && !w_enable) regbusdata = data;
        if (!r_enable) regbusdata = 8'bz;
    end

endmodule
