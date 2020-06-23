module mem_wr_decoder(memwr_reg,IoprCtr,JrWr,RegWr,MemtoReg);

input wire[127:0] memwr_reg;
wire[5:0]         op,funct;
output wire       IoprCtr,JrWr,RegWr,MemtoReg;

assign op=memwr_reg[31:26];
assign funct=memwr_reg[5:0];
assign IoprCtr=(
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
    op==6'b101000 |
    op==6'b000100 |
    op==6'b000101 |
    op==6'b000001 |
    op==6'b000111 |
    op==6'b000110
);
assign JrWr=((op==6'b000000 & funct==6'b001001) | (op==6'b000011));
assign RegWr=!(
    (op==6'b000000 & funct==6'b001000) |
    op==6'b101011 |
    op==6'b101000 |
    op==6'b000100 |
    op==6'b000101 |
    op==6'b000001 |
    op==6'b000111 |
    op==6'b000110 |
    op==6'b000010
);
assign MemtoReg=(
    op==6'b100011 |
    op==6'b100000 |
    op==6'b100100
);

endmodule