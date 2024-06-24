`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/12/2024 08:18:13 PM
// Design Name: 
// Module Name: disp7seg_drv
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

////////////////////////////////////////////////////////////////////////////////
module disp7seg_drv_8bit(
    input mainclk,
    input muxclk,
    input [7:0] indatabin,
    input issigned,
    output reg [3:0] dispcommon,
    output [6:0] dispseg,
    output reg dp
    );
    
    reg isneg;
    reg [7:0] databin;
    reg [4:0] dighex, digleft;
    reg [1:0] commonseq;
    reg [15:0] databcd;
    wire [15:0] dbcd_dec_wire;
    reg muxpulse;
    
    initial begin
    
        dp = 1;
        commonseq = 0;
        dispcommon = 4'b1110;
        muxpulse = 0;
    end

    bin2bcd B2BCD1 (.bin(databin), .bcd(dbcd_dec_wire));    

    always @ (posedge mainclk) begin
    
        if (muxclk) begin

            if (!muxpulse) begin
            
                muxpulse = 1;
                
                if (issigned && indatabin[7]) begin databin = 1 + (~indatabin); isneg = 1; end
                else begin databin = indatabin[7:0]; isneg = 0; end
    
                databcd = dbcd_dec_wire; 

                digleft = isneg? 5'b10000 : 5'b11111;
                
                case (commonseq)
                    2'b00: begin dispcommon = 4'b1110; dighex = databcd[3:0]; end
                    2'b01: begin dispcommon = 4'b1101; dighex = databcd[7:4]; end
                    2'b10: begin dispcommon = 4'b1011; dighex = databcd[11:8]; end
                    2'b11: begin dispcommon = 4'b0111; dighex = digleft; end                    
                endcase

                commonseq = commonseq + 1;
            end
        end else muxpulse = 0;    
    end
    
    decoderbcd_coan DEC1 (.data (dighex), .seg(dispseg));
    
endmodule
