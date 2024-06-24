`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/21/2024 09:06:58 PM
// Design Name: 
// Module Name: pcounter
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

module pcounter(
                input mainclk,
                input clkin,
                input resetpin,
                input ctenable,
                input wr_enable,
                inout rd_enable,
                inout [7:0] busdata);
    
    reg [7:0] regdata;
    reg [7:0] regbusdata;
    assign busdata = regbusdata;
    reg f_clkin;
                
    initial begin
    
        regbusdata = 8'bz;
        regdata = 0;
    end                
                
    always @ (posedge mainclk) begin
    
        if (rd_enable) 
            regbusdata = regdata;
        else
            regbusdata = 8'bz;

        if (resetpin) regdata = 0;
        else
        if (clkin) begin
        
            if (!f_clkin) begin
            
                f_clkin = 1;

                if (wr_enable)
                    regdata = busdata;
                else
                if (ctenable)
                    regdata = (regdata + 1) & 4'b1111;
            end
        end else f_clkin = 0;
    end                                    
endmodule
