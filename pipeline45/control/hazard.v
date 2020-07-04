module hazard(ifid_reg,HazardCtr);

input wire[63:0] ifid_reg;
wire[4:0] rs;
wire[5:0] op,funct;
output wire HazardCtr;

assign rs=ifid_reg[25:21];
assign op=ifid_reg[31:26];
assign funct=ifid_reg[5:0];
assign HazardCtr=(
    op==6'b100011 |
    op==6'b100000 |
    op==6'b100100 |                      // load
    (op==6'b010000 & rs==5'b00000) |     // mfc0
    (op==6'b000000 & funct==6'b001100) | // syscall
    (op==6'b010000 & funct==6'b011000)   // eret
);

endmodule