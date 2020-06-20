module forwarding
(
    ifid_reg,
    idex_reg,
    memwr_reg,
    BusAchange,
    BusBchange,
    ALUinAchange,
    ALUinBchange
);

input wire[43:0] ifid_reg;
wire[5:0] ifid_op;
input wire[159:0] idex_reg;
wire[5:0] idex_op;
input wire[127:0] memwr_reg;
wire[5:0] memwr_op;
output wire BusAchange,BusBchange,ALUinAchange,ALUinBchange;

assign ifid_op=ifid_reg[31:26];
assign idex_op=idex_reg[31:26];
assign memwr_op=memwr_reg[31:26];

endmodule