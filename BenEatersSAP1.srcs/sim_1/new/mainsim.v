`timescale 1ns / 10ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/11/2024 04:45:02 PM
// Design Name: 
// Module Name: SAP-1
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

module mainsim( //input CLK100MHZ, 
                input [15:0] sw,
                input btnU,
                input btnL,
                input btnR,
                input btnD,
                input btnC,
                output [15:0] led, 
                output [3:0] an, 
                output [6:0] seg,
                output dp
    );

    reg CLK100MHZ;

    wire ck1M, ck1k;
    wire sapclk;
    wire sapclkn;
    wire reset;

    wire [7:0] regAdata;
    wire [7:0] regBdata;
    wire [3:0] ramaddr;
    wire [7:0] ramdataleds;

    wire [7:0] mainwbus;
    wire progrun;
    wire progrunled;
    wire [3:0] progaddr;
    wire [7:0] progdata;
    wire test_sw;
    wire issig;
    
    wire ZR,  // ZR FLAG
         CY,  // CY FLAG
         HLT, // Halt 
         MI,  // RegMemAddr IN
         RI,  // RAM IN
         RO,  // RAM OUT
         IO,  // RegInst OUT
         II,  // RegInst IN
         AI,  // RegA IN 
         AO,  // RegA OUT
         SO,  // ALU OUT
         SU,  // ALU Subtract
         BI,  // RegB IN
         OI,  // RegOut IN
         CE,  // PC Count ENABLE
         CO,  // PC OUT
         J,   // JMP
         FI;  // FLAGS IN

    secclockgen CLK1 (.mainclk (CLK100MHZ), 
                      .secclk1MHz (ck1M), 
                      .secclk1kHz (ck1k));
    
//    sapclock SAPCLK1 (.mainclk(CLK100MHZ),
//                      .inclkslow(ck1k), 
//                      .inclkfast(ck1M),
//                      .progrun(progrun),
//                      .butpausestep(btnL), 
//                      .butresume(btnR),
//                      .butfaster(btnU),
//                      .butslower(btnD),
//                      .butreset(btnC),
//                      .halt(HLT),
//                      .outclk(sapclk), 
//                      .outclkn(sapclkn),
//                      .outreset(reset),
//                      .progrunled(progrunled));
            
//    wbus_test WB1 (.mainclk(CLK100MHZ),
//                   .switches(progdata), 
//                   .test_en(test_sw), 
//                   .bus(mainwbus));

    reg8bit regA (.mainclk(CLK100MHZ),
                  .clkin(sapclk),
                  .w_enable(AI),
                  .r_enable(AO),
                  .resetpin(reset),
                  .busdata(mainwbus),
                  .data(regAdata));

    reg8bit regB (.mainclk(CLK100MHZ),
                  .clkin(sapclk),
                  .w_enable(BI),
                  .r_enable(0),
                  .resetpin(reset),
                  .busdata(mainwbus),
                  .data(regBdata));

    regout regOUT1 (.mainclk(CLK100MHZ),
                    .muxclk(ck1k),
                    .clkin(sapclk),
                    .issigned(issig),
                    .w_enable(OI),
                    .resetpin(reset),
                    .busdata(mainwbus),
                    .dispcommon(an),
                    .dispseg(seg), 
                    .dp(dp));
           
    alu ALU1 (.mainclk(CLK100MHZ),
              .clkin(sapclk),
              .resetpin(reset),
              .ina(regAdata),
              .inb(regBdata),
              .r_enable(SO),
              .su(SU),
              .fi(FI),
              .busdata(mainwbus),
              .zr(ZR),
              .cy(CY));
              
    pcounter PC1 (.mainclk(CLK100MHZ),
                  .clkin(sapclk),
                  .resetpin(reset),
                  .ctenable(CE),
                  .wr_enable(J),
                  .rd_enable(CO),
                  .busdata(mainwbus));

    mar MAR1 (.mainclk(CLK100MHZ),
              .clkin(sapclk),
              .w_enable(MI),
              .resetpin(reset),
              .busdata(mainwbus),
              .progrun(progrun),
              .progaddr(progaddr),
              .addr(ramaddr),
              .addrleds(led[3:0]));
    
    ram RAM1 (.mainclk(CLK100MHZ),
              .clkin(sapclk),
              .w_enable(RI),
              .r_enable(RO),
              .addr(ramaddr),
              .progrun(progrun),
              .progwrite(progwrite),
              .progdata(progdata),
              .busdata(mainwbus),
              .dataleds(ramdataleds));

    displeds DS1 (.mainclk(CLK100MHZ),
                  .wbusleds(mainwbus),
                  .progleds(ramdataleds),
                  .progrun(progrun),
                  .leds(led[15:8]));
    
    wire [3:0] opcode;
    
    instreg IR1 (.mainclk(CLK100MHZ),
                 .clkin(sapclk),
                 .w_enable(II),
                 .r_enable(IO),
                 .resetpin(reset),
                 .busdata(mainwbus),
                 .opcode(opcode));
    
    ctrlogic CTR1(.mainclk(CLK100MHZ),
                  .clkin(sapclkn),
                  .resetpin(reset),
                  .opcode(opcode),
                  .zr(ZR),
                  .cy(CY),
                  .hlt(HLT),
                  .mi(MI),
                  .ri(RI),
                  .ro(RO),
                  .io(IO),
                  .ii(II),
                  .ai(AI),
                  .ao(AO),
                  .so(SO),
                  .su(SU),
                  .bi(BI),
                  .oi(OI),
                  .ce(CE),
                  .co(CO),
                  .j(J),
                  .fi(FI));
    
    ////////////////////////////////////////////////////////////////////////////

    assign led[4] = progrunled;
    assign led[5] = sapclk;
    assign led[6] = sapclkn;
    assign led[7] = HLT;
    //assign progrun = sw[4];
    //assign issig = sw[5];    
    //assign progaddr = sw[3:0];            
    //assign progdata = sw[15:8];
    //assign progwrite = btnL;
    assign test_sw = 0;
    
    initial begin
        
        CLK100MHZ = 0;
    end

    assign sapclk = ck1M;
    assign sapclkn = ~ck1M;
    assign reset = 0;
    assign progrun = 0;
    assign issig = 0;    
    assign progaddr = 0;            
    assign progdata = 0;
    assign progwrite = 0;
        
    always #5 begin

        CLK100MHZ = ~CLK100MHZ;
    end
    
endmodule
