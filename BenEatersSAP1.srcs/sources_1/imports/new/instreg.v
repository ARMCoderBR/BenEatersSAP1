`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/23/2024 11:41:05 AM
// Design Name: 
// Module Name: instreg
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

module instreg(
    input mainclk,
    input clkin,
    input w_enable,
    input r_enable,
    input resetpin,
    inout [7:0] busdata,
    output wire [7:4] opcode
    );
    
    reg [7:0] data;
    assign opcode = data[7:4];
    
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

        if (r_enable && !w_enable) regbusdata = data & 8'b00001111;
        if (!r_enable) regbusdata = 8'bz;
    end

endmodule
