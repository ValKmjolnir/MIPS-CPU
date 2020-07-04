module ex_mem_decoder(exmem_reg,MemWr,DmSignExt,ByteWidth);

input wire[127:0] exmem_reg;
wire[5:0]         op;
output wire       MemWr,DmSignExt;
output wire[1:0]  ByteWidth;

assign op=exmem_reg[31:26];
assign MemWr=(op==6'b101011 | op==6'b101000);
assign DmSignExt=(op==6'b100000);
assign ByteWidth=(op==6'b100011 | op==6'b101011)? 2'b11:((op==6'b100000 | op==6'b100100 | op==6'b101000)? 2'b01:2'b00);

endmodule