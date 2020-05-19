// 2020/5/14 tested
module MIPSIFU(clk,reset,Branch,Jump,ConfirmBr,IR,imm16,imm26);
    input wire        clk,reset,Branch,Jump,ConfirmBr;
    input wire[15:0]  imm16;
    input wire[25:0]  imm26;
    output wire[31:0] IR;
    reg[29:0]    PC;
    wire[29:0]   adderA,adderB;
    wire[29:0]   muxA,muxB;
    wire[29:0]   jmp;
    assign adderA=PC+1;
    assign adderB=adderA+{14'b0,imm16};
    assign jmp={PC[29:26],imm26};
    assign muxA=(Branch && ConfirmBr)?adderB:adderA;
    assign muxB=Jump?jmp:muxA;
    MIPSInstMem InstructionMemory({PC,2'b00},IR);
initial begin
    PC<=0;
end
always@(posedge clk or negedge reset) begin
    if(!reset) PC<=0;
    else PC=muxB;
end
endmodule