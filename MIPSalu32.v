module MIPSalu32(A,B,Cin,Extbit,Res,opr,ZF,OF);
    input wire[2:0]  opr;
    input wire       Cin;
    input wire[31:0] A,B;
    output reg       Extbit;
    output wire      ZF,OF;
    output reg[31:0] Res;
    assign ZF=(Res==0);
    assign OF=(Extbit^Res[31]);
    parameter 
        ADD=3'b001,
        SUB=3'b010,
        AND=3'b011,
        OR =3'b100,
        XOR=3'b101,
        SLT=3'b110;
always@(*) begin
    case(opr)
        ADD: {Extbit,Res}=A+B;
        SUB: {Extbit,Res}=A-B;
        AND: Res=A & B;
        OR : Res=A | B;
        XOR: Res=A ^ B;
        SLT: Res=(A<B);
    endcase
end
endmodule