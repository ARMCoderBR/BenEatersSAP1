`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/12/2024 11:06:06 AM
// Design Name: 
// Module Name: clock2
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

module secclockgen(input mainclk,
    output reg secclk1MHz,
    output reg secclk1kHz
    );
    
    reg[6:0] divider1;
    reg[9:0] divider2;
    
    reg ctwait;
    parameter DIVIDER1 = 100;
    parameter DIV2_1 = (DIVIDER1/2)-1;

    parameter DIVIDER2 = 1000;
    parameter DIV2_2 = (DIVIDER2/2);
    
    initial begin
    
        ctwait = 1;
        secclk1MHz = 0;
        divider1 = 0;
        secclk1kHz = 0;
        divider2 = 0;
    end
    
    always @ (posedge mainclk) begin
        
        if (ctwait) ctwait = ctwait - 1;
        else begin
            divider1 = divider1 + 1;
            
            if (divider1 == DIVIDER1) begin
    
                divider1 = 0;
                divider2 = divider2 + 1;
                if (divider2 == DIVIDER2) divider2 = 0;
            end
    
            if (divider2 >= DIV2_2) secclk1kHz = 0;
            else secclk1kHz = 1;
    
            if (divider1 > DIV2_1) secclk1MHz = 0;
            else secclk1MHz = 1;
        end
    end

endmodule

////////////////////////////////////////////////////////////////////////////////
module sapclock(input mainclk,
                input inclkslow,
                input inclkfast, 
                input butpausestep, 
                input butresume,
                input butfaster,
                input butslower,
                input butreset,
                input halt,
                input progrun,
                output reg outclk, 
                output reg outclkn,
                output reg outreset,
                output reg progrunled);

    parameter MAX_DIVIDER_SEL = 6;

    reg running;
    reg step;
    reg [3:0]divider_sel;
    reg[9:0]counter;
    
    reg [6:0] debounce;
    reg [4:0] buttons; 
    reg [4:0] buttons_o;
    reg [1:0] validkey; 
    
    reg pre_out_clk;
    reg reset;
    
    reg clkfast, clkslow;

    reg [8:0] counter_progrunled;
    
    initial begin
    
        buttons[0] = butpausestep; 
        buttons[1] = butresume;
        buttons[2] = butfaster;
        buttons[3] = butslower;
        buttons[4] = butreset;

        buttons_o[0] = buttons[0]; 
        buttons_o[1] = buttons[1];
        buttons_o[2] = buttons[2];
        buttons_o[3] = buttons[3];
        buttons_o[4] = buttons[4];

        validkey = 0;
        reset = 0;
        outreset = 0;
        pre_out_clk = 0;
        outclk = 0;
        outclkn = 0;
        running = 1;
        step = 0;
        divider_sel = 0;
        counter = 0;
        clkfast = 0;
        clkslow = 0;
        
        counter_progrunled = 0;
    end
    
    always @ (posedge mainclk) begin
    
        if (divider_sel == MAX_DIVIDER_SEL) begin

            if (running) begin
                
                if (!halt && !progrun) begin
                    
                    outclk = inclkfast;
                    outclkn = ~inclkfast;
                end
            end
        end else begin

            if (inclkfast) begin
        
                if (!clkfast) begin
                
                    clkfast = 1;
                    // clock fast (1MHz)
                    if (!halt && !progrun) begin 
                        
                        outclk = pre_out_clk;
                        outclkn = ~pre_out_clk; 
                    end
                    // clock fast (1MHz) END
                end
            end else clkfast = 0;
        end

        if (inclkslow) begin
    
            if (!clkslow) begin
    
                clkslow = 1;
                // clock slow (1kHz)
                
                if (progrun) begin
                
                    counter_progrunled = counter_progrunled + 1;
                    if (counter_progrunled[8:5] == 3'b1111) progrunled = 1;
                    else progrunled = 0;

                end else progrunled = 0;

                buttons[0] = butpausestep; 
                buttons[1] = butresume;
                buttons[2] = butfaster;
                buttons[3] = butslower;
                buttons[4] = butreset;
        
                outreset = reset;
                
                if (buttons_o == buttons) begin
        
                    if (!validkey) begin
                        
                        debounce = debounce + 1;
                        if (debounce == 50) validkey = 1;
                    end
                end else begin
                
                    debounce = 0;
                    validkey = 0;
                    buttons_o = buttons;
                end
            
                if (running && (divider_sel != MAX_DIVIDER_SEL)) counter = counter + 1;
                
                if (
                    ( counter == (  (divider_sel==0) ? 500:
                                    (divider_sel == 1) ? 250:
                                    (divider_sel == 2)? 100:
                                    (divider_sel == 3)? 25:
                                    (divider_sel == 4)? 10:1
                                 ) 
                    ) || (step == 1)
                   ) begin
                
                    pre_out_clk = ~pre_out_clk;
                    counter = 0;
                    step = 0;
                end
            
                if (validkey == 1) begin            
                
                    validkey = 2;
                    reset = buttons[4];
                    
                    case (buttons[3:0])
                    
                        4'b1000: begin // slower
                        
                            if (divider_sel != 0) begin counter = 0; divider_sel = divider_sel - 1; end
                        end
                        
                        4'b0100: begin // faster
                        
                            if (divider_sel != MAX_DIVIDER_SEL) begin counter = 0; divider_sel = divider_sel + 1; end
                        end
                        
                        4'b0010: begin  // resume
                        
                            running = 1;            
                        end
                        
                        4'b0001: begin // pause/step
                            
                            if (running) running = 0;
                            else step = 1;
                        end
                    endcase
                end
                // clock slow (1kHz) END
            end
        end else clkslow = 0;
    end

endmodule
