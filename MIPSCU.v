module MIPSCU(clk,reset);

input      clk,reset;
wire       IoprCh,RegWr,ExtOp,ALUsrc,MemWr,MemtoReg,JrWr,ShamtCtr,JumpReg,Branch,Jump;
wire       Cin,Cout,ZF,OF,ConfirmBr;
wire[1:0]  ByteWidth;
wire       DmSignExt,DmError;
wire[4:0]  ALUctr;
wire[4:0]  rs,rt,rd,Muxrd,shamt;
wire[5:0]  OprCtr,funct;
wire[15:0] imm16;
wire[25:0] imm26;
wire[31:0] BusA,BusB,BusW,PC,IR,ALUinB,ALUout,DataBusR;

assign OprCtr=IR[31:26];
assign shamt=IR[10:6];
assign funct=IR[5:0];
assign rs=IR[25:21];
assign rt=IR[20:16];
assign rd=IR[15:11];
assign imm16=IR[15:0];
assign imm26=IR[25:0];
assign Muxrd=JrWr?5'b11111:(IoprCh?rt:rd);// input to regFile addrW
assign ALUinB=ShamtCtr?{27'd0,shamt}:(ALUsrc?(ExtOp?{imm16[15]?16'hffff:16'h0000,imm16}:{16'h0000,imm16}):BusB);// ALU in BusB
assign BusW=JrWr?{PC,2'b00}:(MemtoReg?DataBusR:ALUout);

MIPSdecoder decoder
(
    OprCtr,
    IR[20:16],
    funct,
    IoprCh,
    RegWr,
    ExtOp,
    ALUsrc,
    ALUctr,
    MemWr,
    MemtoReg,
    Cin,
    Branch,
    Jump,
    JrWr,
    ShamtCtr,
    JumpReg,
    ByteWidth,
    DmSignExt
    );
MIPSIFU InsFetchUnit(clk,reset,Branch,Jump,ConfirmBr,JumpReg,PC,IR,imm16,imm26,BusA);
MIPSregFile regFile(clk,Muxrd,rs,rt,RegWr,BusW,BusA,BusB);
MIPSalu32 ALU(BusA,ALUinB,Cin,Cout,ALUout,ALUctr,ZF,OF,ConfirmBr);
MIPSDataMem DataMemory(clk,ALUout,MemWr,BusB,DataBusR,ByteWidth,DmSignExt,DmError);

endmodule