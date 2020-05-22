module MIPSCU(clk,reset);

input      clk,reset;
wire       IoprCh,RegWr,ExtOp,ALUsrc,MemWr,MemtoReg,JrWr,ShamtCtr,JumpReg,Branch,Jump;
wire       Cin,Cout,ZF,OF,ConfirmBr,OverflowCheck,ShiftCtr;
wire[1:0]  ByteWidth;
wire       DmSignExt,DmError;
wire[4:0]  ALUctr;
wire[4:0]  rs,rt,rd,Muxrd,shamt;
wire[5:0]  OprCtr,funct;
wire[15:0] imm16;
wire[25:0] imm26;
wire[29:0] PC;
wire[31:0] ShiftRs,ShiftRt,BusA,BusB,BusW,IR,ALUinB,ALUout,DataBusR;

assign OprCtr=IR[31:26];
assign shamt=IR[10:6];
assign funct=IR[5:0];
assign rs=IR[25:21];
assign rt=IR[20:16];
assign rd=IR[15:11];
assign imm16=IR[15:0];
assign imm26=IR[25:0];
assign ShiftRs=ShiftCtr?rt:rs;// if sll/srl/sra/sllv/srlv/srav rs and rt are reversed
assign ShiftRt=ShiftCtr?rs:rt;// if sll/srl/sra/sllv/srlv/srav rs and rt are reversed
assign Muxrd=JrWr?5'b11111:(IoprCh?rt:rd);// input to regFile addrW
assign ALUinB=ShamtCtr?{27'd0,shamt}:(ALUsrc?(ExtOp?{imm16[15]?16'hffff:16'h0000,imm16}:{16'h0000,imm16}):BusB);// ALU in B
assign BusW=JrWr?{PC+1,2'b00}:(MemtoReg?DataBusR:ALUout);

MIPSdecoder decoder
(
    OprCtr,   // IR[31:26]
    IR[20:16],// rt
    funct,    // IR[5:0]
    IoprCh,   // this wire chooses rd(R instruction) or rt(I instruction) as addrW
    RegWr,    // register write enable signal
    ExtOp,    // this will choose ways of extending imm16(signed or zero extend)
    ALUsrc,   // this will choose extended imm16 or BusB as output
    ALUctr,   // ALUctr chooses calculation functions of ALU
    OverflowCheck,// add and sub will use OF flag
    MemWr,    // write value from a register to data memory
    MemtoReg, // read value from data memory and write it to a register
    Cin,      // carry in,used in ALU
    Branch,   // used when beq/bne/bgez/bgtz/blez/bltz
    Jump,     // set PC as {PC[39:26],imm26}
    JrWr,     // jal or jalr uses $ra to store PC+4,this will choose #31 as addrW
    ShamtCtr, // this will choose shamt as input B to ALU
    ShiftCtr, // this is used when sll/srl/sra/sllv/srlv/srav are in progress,swap rs and rt
    JumpReg,  // this will set PC as register's value
    ByteWidth,// this will used when write/read value into data memory,can w/r 1/2/4 byte(s)
    DmSignExt // signed extend if true
);
MIPSIFU InsFetchUnit
(
    clk,      // clock
    reset,    // reset
    Branch,   // branch instruction switch
    Jump,     // jump instruction switch
    ConfirmBr,// outputed by ALU.Branch&ConfirmBr will make beq/bne/... jump to a calculated address
    JumpReg,  // jump register instruction switch,
    PC,       // program counter
    IR,       // instruction register
    imm16,    // immediate value 16 bit
    imm26,    // immediate value 26 bit
    BusA      // get value from regFile and if JumpReg is true,PC=BusA[31:2]
);
MIPSregFile regFile
(
    clk,    // clock
    Muxrd,  // addrW
    ShiftRs,// addrA
    ShiftRt,// addrB
    RegWr,  // write enbale signal
    BusW,   // BusW
    BusA,   // BusA
    BusB    // BusB
);
MIPSalu32 ALU
(
    BusA,        // ALU input A
    ALUinB,      // ALU input B
    Cin,         // Carry in
    Cout,        // Carri out/Extra bit
    ALUout,      // result
    ALUctr,      // function choice
    ZF,          // zero flag
    OF,          // overflow flag
    ConfirmBr,   // branch confirm signal
    OverflowCheck// overflow check
);
MIPSDataMem DataMemory
(
    clk,
    ALUout,   // address input
    MemWr,    // memory write enable signal
    BusB,     // value input
    DataBusR, // value output
    ByteWidth,// byte width
    DmSignExt,// extend mode
    DmError   // error output when address does not match byte width
);

endmodule