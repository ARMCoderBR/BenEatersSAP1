`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/19/2024 07:43:56 PM
// Design Name: 
// Module Name: wbus
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

module wbus_test(
    input mainclk,
    input  [7:0] switches,
    //output [7:0] leds,
    input test_en,
    inout [7:0] bus
    );
    
    reg[7:0] busdata;
    assign bus = busdata;
    //assign bus = 8'bz;
    //assign leds = bus;
    initial begin
    
        busdata = 8'bz;
    end
    
    //always @ bus leds = bus; 
    
    always @ (posedge mainclk) begin
    
        if (test_en) busdata = switches; 
        else busdata = 8'bz;
    end
    
endmodule

module displeds(

    input mainclk,
    input [7:0] wbusleds,
    input [7:0] progleds,
    input progrun,
    output reg [7:0] leds
);

    initial begin
    
    end
    
    always @ (posedge mainclk) begin
    
        if (progrun) leds = progleds;
        else leds = wbusleds;
    
    end
    
endmodule
