module MIPSalu32
(
    A,       // input A
    B,       // input B
    Cin,     // carry in
    Extbit,  // carry out/extra bit
    Res,     // result
    opr,     // ALUctr
    ZF,      // zero flag
    OF,      // overflow flag
    ConfirmBr// confirm branch
);
input wire[4:0]  opr;
input wire       Cin;
input wire[31:0] A,B;
output reg       Extbit;
output wire      ZF,OF,ConfirmBr;
output reg[31:0] Res;

parameter 
    ADD =5'b00001,
    SUB =5'b00010,
    AND =5'b00011,
    OR  =5'b00100,
    XOR =5'b00101,
    NOR =5'b00110,
    SLT =5'b00111,
    SLTU=5'b01000,
    SLL =5'b01001,
    SRL =5'b01010,
    SRA =5'b01011,
    BEQ =5'b01100,
    BNE =5'b01101,
    BGEZ=5'b01110,
    BGTZ=5'b01111,
    BLEZ=5'b10000,
    BLTZ=5'b10001,
    LUI =5'b10010;

assign ZF=(Res==0);
assign OF=(Extbit^Res[31]);
assign ConfirmBr=(opr==BEQ || opr==BNE || opr==BGEZ || opr==BGTZ || opr==BLEZ || opr==BLTZ) && (!ZF);

always@(*) begin
    case(opr)
        ADD: {Extbit,Res}=A+B;
        SUB: {Extbit,Res}=A+(~B+1);
        AND: Res=A & B;
        OR : Res=A | B;
        XOR: Res=A ^ B;
        NOR: Res=~(A|B);
        SLT: Res=$signed(A) < $signed(B);
        SLTU:Res=A < B;
        SLL: Res=A << B[4:0];
        SRL: Res=A >> B[4:0];
        SRA: Res=$signed(A) >> B[4:0];
        BEQ: Res=(A == B);
        BNE: Res=(A != B);
        BGEZ:Res=($signed(A)>=$signed(0));
        BGTZ:Res=($signed(A)> $signed(0));
        BLEZ:Res=($signed(A)<=$signed(0));
        BLTZ:Res=($signed(A)< $signed(0));
        LUI: Res=(B<<16);
    endcase
end
endmodule