module MIPSCU(clk,reset);
input      clk,reset;
wire       RegDst,RegWr,ExtOp,ALUsrc,MemWr,MemtoReg;
wire       Cin,Cout,ZF,OF,Branch,Jump;
wire[2:0]  ALUctr;
wire[4:0]  rs,rdR,rdI,rt,Muxrd,shamt;
wire[5:0]  OprCtr,funct;
wire[15:0] imm16;
wire[25:0] imm26;
wire[31:0] BusA,BusB,BusW,IR,ALUinB,ALUout,DataBusR;

MIPSdecoder decoder(OprCtr,funct,RegDst,RegWr,ExtOp,ALUsrc,ALUctr,MemWr,MemtoReg,Cin,Branch,Jump);

assign OprCtr=IR[31:26];
assign shamt=IR[10:6];
assign funct=IR[5:0];
assign rs=IR[25:21];
assign rt=IR[20:16];
assign rdR=IR[15:11];
assign rdI=IR[20:16];
assign imm16=IR[15:0];
assign imm26=IR[25:0];
assign Muxrd=RegDst?rdI:rdR;
assign ALUinB=ALUsrc?(ExtOp?{16'hffff,imm16}:{16'h0000,imm16}):BusB;
assign BusW=MemtoReg?DataBusR:ALUout;

MIPSIFU InsFetchUnit(clk,reset,Branch,Jump,ZF,IR,imm16,imm26);
MIPSregFile regFile(clk,Muxrd,rs,rt,RegWr,BusW,BusA,BusB);
MIPSalu32 ALU(BusA,ALUinB,Cin,Cout,ALUout,ALUctr,ZF,OF);
MIPSDataMem DataMemory(clk,ALUout,MemWr,BusB,DataBusR);

endmodule