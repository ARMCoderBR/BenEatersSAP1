`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/20/2024 05:01:22 PM
// Design Name: 
// Module Name: alu
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

module alu(
    input mainclk,
    input clkin,
    input resetpin,
    input [7:0] ina,
    input [7:0] inb,
    input r_enable,
    input su,
    input fi,
    output [7:0] busdata,
    output reg zr,
    output reg cy
    );

    reg [8:0] result;
    reg [7:0] outresult;
    assign busdata = outresult;
    reg f_clkin;

    initial begin
    
        f_clkin = 0;
        zr = 0;
        cy = 0;

        result = 8'bz;
    end

    always @ (posedge mainclk) begin
    
        if (!su) result = ina + inb; else result = 1 + ina + ~inb;
        if (r_enable) outresult = result[7:0]; else outresult = 8'bz;

        if (resetpin) begin
        
            zr = 0; cy = 0;
        end

        if (clkin) begin
        
            f_clkin = 1;
            
            if (fi && !resetpin) begin
                
                if (!result[7:0]) zr = 1; else zr = 0;
                cy = result[8];
            end
        end else f_clkin = 0;
    end    

endmodule
