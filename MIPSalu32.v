module MIPSalu32(A,B,Cin,Cout,Res,opr,ZF,OF);
    input wire[2:0]  opr;
    input wire       Cin;
    input wire[31:0] A,B;
    output reg       Cout;
    output wire      ZF,OF;
    output reg[31:0] Res;
    assign ZF=(Res==0);
    assign OF=(Cout==1);
    parameter 
        ADD=3'b001,
        SUB=3'b010,
        AND=3'b011,
        OR =3'b100,
        SLT=3'b101;
always@(*) begin
    case(opr)
        ADD: {Cout,Res}=A+B;
        SUB: {Cout,Res}=A-B;
        AND: Res=A & B;
        OR : Res=A | B;
        SLT: Res=(A<B);
    endcase
end
endmodule