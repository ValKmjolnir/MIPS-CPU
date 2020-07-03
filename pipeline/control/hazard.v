module hazard(ifid_reg,HazardCtr);

input wire[63:0] ifid_reg;
wire[5:0] op,funct;
output wire HazardCtr;

assign op=ifid_reg[31:26];
assign funct=ifid_reg[5:0];
assign HazardCtr=(
    op==6'b100011 |
    op==6'b100000 |
    op==6'b100100 | // load
    op==6'b000100 |
    op==6'b000101 |
    op==6'b000001 |
    op==6'b000111 |
    op==6'b000110   // branch
);

endmodule