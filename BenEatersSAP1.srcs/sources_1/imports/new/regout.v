`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/21/2024 01:39:14 PM
// Design Name: 
// Module Name: regout
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


module regout(
    input mainclk,
    input muxclk,
    input clkin,
    input issigned,
    input w_enable,
    input resetpin,
    input [7:0] busdata,
    output [3:0] dispcommon,
    output [6:0] dispseg,
    output dp
    );

    reg [7:0] data;
    reg f_clkin;
    
    initial begin

        f_clkin = 0;
        data = 0;
    end

    disp7seg_drv_8bit DRV1 (.mainclk(mainclk),
                            .muxclk(muxclk), 
                            .indatabin(data),
                            .issigned(issigned),
                            .dispcommon(dispcommon),
                            .dispseg(dispseg), 
                            .dp(dp));

    always @ (posedge mainclk) begin
    
        if (resetpin) data = 0;
        else
        if (clkin) begin
        
            if (!f_clkin) begin
            
                f_clkin = 1;
                if (w_enable) data = busdata;    
            end
        end else f_clkin = 0;
    end

endmodule
