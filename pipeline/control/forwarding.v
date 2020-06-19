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
input wire[159:0] idex_reg;
input wire[127:0] memwr_reg;
output wire BusAchange,BusBchange,ALUinAchange,ALUinBchange;

endmodule