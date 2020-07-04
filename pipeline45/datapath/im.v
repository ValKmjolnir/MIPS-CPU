module im(addr,out);

input wire[31:0]  addr;
output wire[31:0] out;
reg[31:0]         memory[0:1023];

assign out = memory[addr>>2];

initial begin
    $readmemh("code45.txt",memory);
end
endmodule