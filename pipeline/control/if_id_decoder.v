module if_id_decoder(ifid_reg,ExtOp,ImmCh,ShamtCh,ShiftCtr,Jump,JumpReg);

input wire[63:0] ifid_reg;
wire[5:0]        op,funct;
output wire      ExtOp,ImmCh,ShamtCh,ShiftCtr,Jump,JumpReg;

assign op=ifid_reg[31:26];
assign funct=ifid_reg[5:0];
assign ExtOp=(
    op==6'b001000 |
    op==6'b001001 |
    op==6'b000100 |
    op==6'b000101 |
    op==6'b100011 |
    op==6'b101011 |
    op==6'b001010 |
    op==6'b001011 |
    op==6'b000001 |
    op==6'b000111 |
    op==6'b000110 |
    op==6'b100000 |
    op==6'b100100 |
    op==6'b101000
);
assign ImmCh=(
    op==6'b001000 |
    op==6'b001001 |
    op==6'b001010 |
    op==6'b001011 |
    op==6'b001100 |
    op==6'b001101 |
    op==6'b001110 |
    op==6'b001111 |
    op==6'b100011 |
    op==6'b101011 |
    op==6'b100000 |
    op==6'b100100 |
    op==6'b101000
);
assign ShamtCh=(op==6'b000000 &&(
    funct==6'b000000 |
    funct==6'b000010 |
    funct==6'b000011
));
assign ShiftCtr=(op==6'b000000 &&(
    funct==6'b000000 |
    funct==6'b000010 |
    funct==6'b000011 |
    funct==6'b000100 |
    funct==6'b000110 |
    funct==6'b000111
));
assign Jump=(op==6'b000010 | op==6'b000011);
assign JumpReg=(op==6'b000000 && (funct==6'b001000 | funct==6'b001001));

endmodule