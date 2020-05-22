module MIPSIFU
(
    clk,
    reset,
    Branch,
    Jump,
    ConfirmBr,
    JumpReg,
    PC,
    IR,
    imm16,
    imm26,
    BusA
);

input wire        clk,reset,Branch,Jump,ConfirmBr,JumpReg;
input wire[15:0]  imm16;
input wire[25:0]  imm26;
input wire[31:0]  BusA;
output wire[31:0] IR;
output reg[29:0]  PC;
wire[29:0]   adderA,adderB;
wire[29:0]   muxA,muxB,muxC;
wire[29:0]   JmpAddr;

assign adderA=PC+1;
assign adderB=adderA+{imm16[15]?14'h3fff:14'h0000,imm16};
assign JmpAddr={PC[29:26],imm26};
assign muxA=(Branch && ConfirmBr)?adderB:adderA;
assign muxB=Jump?JmpAddr:muxA;
assign muxC=JumpReg?BusA[31:2]:muxB;
MIPSInstMem InstructionMemory({PC,2'b00},IR);

initial begin
    PC<=0;
end

always@(posedge clk or negedge reset) begin
    if(!reset) PC<=0;
    else PC<=muxC;
end
endmodule