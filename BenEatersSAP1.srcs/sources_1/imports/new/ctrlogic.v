`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/23/2024 11:58:15 AM
// Design Name: 
// Module Name: ctrlogic
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

module ctrlogic(
    input mainclk,
    input clkin,
    input resetpin,
    input [3:0] opcode,
    input zr,
    input cy,
    output hlt,
    output mi,
    output ri,
    output ro,
    output io,
    output ii,
    output ai,
    output ao,
    output so,
    output su,
    output bi,
    output oi,
    output ce,
    output co,
    output j,
    output fi   
    );
    
    reg [2:0] phase;
    reg f_clkin;
    reg [15:0] ctrlword;
    
    parameter OPCODE_NOP = 4'b0000;
    parameter OPCODE_LDA = 4'b0001;
    parameter OPCODE_ADD = 4'b0010;
    parameter OPCODE_SUB = 4'b0011;
    parameter OPCODE_STA = 4'b0100;
    parameter OPCODE_LDI = 4'b0101;
    parameter OPCODE_JMP = 4'b0110;
    parameter OPCODE_JC  = 4'b0111;
    parameter OPCODE_JZ  = 4'b1000;
    parameter OPCODE_OUT = 4'b1110;
    parameter OPCODE_HLT = 4'b1111;

    parameter HLT = 16'b1000000000000000;
    parameter MI  = 16'b0100000000000000;
    parameter RI  = 16'b0010000000000000;
    parameter RO  = 16'b0001000000000000;
    parameter IO  = 16'b0000100000000000;
    parameter II  = 16'b0000010000000000;
    parameter AI  = 16'b0000001000000000;
    parameter AO  = 16'b0000000100000000;
    parameter SO  = 16'b0000000010000000;
    parameter SU  = 16'b0000000001000000;
    parameter BI  = 16'b0000000000100000;
    parameter OI  = 16'b0000000000010000;
    parameter CE  = 16'b0000000000001000;
    parameter CO  = 16'b0000000000000100;
    parameter J   = 16'b0000000000000010;
    parameter FI  = 16'b0000000000000001;
    
    parameter CWORD_FETCH_PH0 = MI|CO;
    parameter CWORD_FETCH_PH1 = RO|II|CE;
    reg [15:0] CWORD_PH2[15:0];
    reg [15:0] CWORD_PH3[15:0];
    reg [15:0] CWORD_PH4[15:0];
    reg [15:0] CWORD_PH5[15:0];

    integer i;

    assign hlt = ctrlword[15];
    assign mi  = ctrlword[14];
    assign ri  = ctrlword[13];
    assign ro  = ctrlword[12];
    assign io  = ctrlword[11];
    assign ii  = ctrlword[10];
    assign ai  = ctrlword[9];
    assign ao  = ctrlword[8];
    assign so  = ctrlword[7];
    assign su  = ctrlword[6];
    assign bi  = ctrlword[5];
    assign oi  = ctrlword[4];
    assign ce  = ctrlword[3];
    assign co  = ctrlword[2];
    assign j   = ctrlword[1];
    assign fi  = ctrlword[0];
    
    initial begin

        CWORD_PH2[ 0] = 16'b0;  //NOP
        CWORD_PH2[ 1] = IO|MI;  //LDA
        CWORD_PH2[ 2] = IO|MI;  //ADD
        CWORD_PH2[ 3] = IO|MI;  //SUB
        CWORD_PH2[ 4] = IO|MI;  //STA
        CWORD_PH2[ 5] = IO|AI;  //LDI
        CWORD_PH2[ 6] = IO|J;   //JMP
        CWORD_PH2[ 7] = IO|J;   //JC
        CWORD_PH2[ 8] = IO|J;   //JZ
        CWORD_PH2[14] = AO|OI;  //OUT
        CWORD_PH2[15] = HLT;    //HLT
        
        for (i = 9; i < 14; i = i + 1)
            CWORD_PH2[i] = 16'b0;
    
        CWORD_PH3[ 0] = 16'b0;  //NOP
        CWORD_PH3[ 1] = RO|AI;  //LDA
        CWORD_PH3[ 2] = RO|BI;  //ADD
        CWORD_PH3[ 3] = RO|BI|SU;  //SUB
        CWORD_PH3[ 4] = AO|RI;  //STA
        
        for (i = 5; i < 16; i = i + 1)
            CWORD_PH3[i] = 16'b0;
    
        CWORD_PH4[ 0] = 16'b0;  //NOP
        CWORD_PH4[ 1] = 16'b0;  //LDA
        CWORD_PH4[ 2] = FI;  //ADD
        CWORD_PH4[ 3] = SU|FI;  //SUB
    
        for (i = 4; i < 16; i = i + 1)
            CWORD_PH4[i] = 16'b0;
    
        CWORD_PH5[ 0] = 16'b0;  //NOP
        CWORD_PH5[ 1] = 16'b0;  //LDA
        CWORD_PH5[ 2] = SO|AI;  //ADD
        CWORD_PH5[ 3] = SU|SO|AI;  //SUB
    
        for (i = 4; i < 16; i = i + 1)
            CWORD_PH5[i] = 16'b0;

        phase = 0;
        f_clkin = 0;
        ctrlword = 0;    
    end

    always @ (posedge mainclk) begin
    
        if (resetpin) begin phase = 0; ctrlword = 0; end 
        else 
        if (clkin) begin
        
            if (!f_clkin) begin
            
                f_clkin = 1;

                case(phase)
                
                    3'b000: ctrlword = CWORD_FETCH_PH0;
                    3'b001: ctrlword = CWORD_FETCH_PH1;
                    3'b010: ctrlword = ((opcode == OPCODE_JC) && !cy) ? 16'b0 : 
                                           ((opcode == OPCODE_JZ) && !zr) ? 16'b0 : 
                                                CWORD_PH2[opcode];   // Checando condicionais JC e JZ
                    3'b011: ctrlword = CWORD_PH3[opcode];
                    3'b100: ctrlword = CWORD_PH4[opcode];
                    3'b101: ctrlword = CWORD_PH5[opcode];
                endcase
    
                
                if ((phase == 5)||(!ctrlword)) phase = 0; else phase = phase + 1;
            end
        end else f_clkin = 0;
    end        
endmodule
