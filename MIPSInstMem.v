// 2020/5/14 tested
module MIPSInstMem(addr,out);
    input[31:0]       addr;
    output wire[31:0] out;
    reg[31:0]         memory[0:1023];
    assign out=memory[addr>>2];
initial begin
    memory[0]<=32'h00008020;
    memory[1]<=32'h2011000a;
    memory[2]<=32'h20120014;
    memory[3]<=32'h02204020;
    memory[4]<=32'h200900aa;
    memory[5]<=32'h222a000a;
    memory[6]<=32'had090000;
    memory[7]<=32'h21080001;
    memory[8]<=32'h11480001;
    memory[9]<=32'h08000006;
    memory[10]<=32'h02404020;
    memory[11]<=32'h200900ff;
    memory[12]<=32'h224a000a;
    memory[13]<=32'had090000;
    memory[14]<=32'h21080001;
    memory[15]<=32'h11480001;
    memory[16]<=32'h0800000d;
    memory[17]<=32'h02004020;
    memory[18]<=32'h02204820;
    memory[19]<=32'h02405020;
    memory[20]<=32'h220b000a;
    memory[21]<=32'h8d2c0000;
    memory[22]<=32'h8d4d0000;
    memory[23]<=32'h018d7020;
    memory[24]<=32'had0e0000;
    memory[25]<=32'h21080001;
    memory[26]<=32'h21290001;
    memory[27]<=32'h214a0001;
    memory[28]<=32'h11680001;
    memory[29]<=32'h08000015;
    //$readmemh("code.txt",memory);
end
endmodule