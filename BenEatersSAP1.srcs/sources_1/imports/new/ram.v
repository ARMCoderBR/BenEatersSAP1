`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/22/2024 11:11:50 AM
// Design Name: 
// Module Name: ram
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

module mar(
    input mainclk,
    input clkin,
    input w_enable,
    input resetpin,
    input [3:0] busdata,
    input progrun,
    input [3:0] progaddr,
    output reg [3:0] addr,
    output [3:0] addrleds
    );
    
    assign addrleds = addr;
    reg [7:0] data;
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
                if (w_enable) data = busdata;    
            end
        end else f_clkin = 0;

        if (!progrun) addr = data;
        else addr = progaddr;
    end
        
endmodule

module ram(
    input mainclk,
    input clkin,
    input w_enable,
    input r_enable,
    input [3:0] addr,
    input progrun,
    input progwrite,
    input [7:0] progdata,
    inout [7:0] busdata,
    output reg [7:0] dataleds
    );
    
    reg [7:0] regbusdata;
    assign busdata = regbusdata;    
    reg f_clkin;

    reg [7:0] data [15:0];
    integer i;
        
    initial begin

        f_clkin = 0;
        for (i = 0; i < 16; i = i + 1) data[i] = 0;

//        0x00,     /*OUT*/         0xE0,
//        0x01,     /*ADD 15*/      0x2F,
//        0x02,     /*JC 4*/        0x74,
//        0x03,     /*JMP 0*/       0x60,
//        0x04,     /*SUB 15*/      0x3F,
//        0x05,     /*OUT*/         0xE0,
//        0x06,     /*JZ 0*/        0x80,
//        0x07,     /*JMP 4*/       0x64,
//        0x0F,     /*1*/           0x01,
        data[0] = 8'he0;
        data[1] = 8'h2f;
        data[2] = 8'h74;
        data[3] = 8'h60;
        data[4] = 8'h3f;
        data[5] = 8'he0;
        data[6] = 8'h80;
        data[7] = 8'h64;
        data[15] = 8'h01;
        
//        data[0]  = 8'b00011111;      // LDA [15]
//        data[1]  = 8'b11100000;      // OUT
//        data[2]  = 8'b00101111;      // ADD [15]
//        data[3]  = 8'b10000101;      // JZ 5
//        data[4]  = 8'b01100001;      // JMP 1
//        data[5]  = 8'b11100000;      // OUT
//        data[6]  = 8'b11110000;      // HLT
//        data[15] = 8'b00000001;
    end

    always @ (posedge mainclk) begin
    
        if (clkin) begin
        
            if (!f_clkin) begin
            
                f_clkin = 1;

                if (!progrun)
                    if (w_enable && !r_enable) data[addr] = busdata;    
            end
        end else f_clkin = 0;

        if (r_enable && !w_enable) regbusdata = data[addr];
        if (!r_enable) regbusdata = 8'bz;

        if (progrun && progwrite)
            data[addr] = progdata;
            
        dataleds = data[addr];
    end

endmodule

