// 2020/5/14 tested
module MIPSInstMem(addr,out);
    input[31:0]       addr;
    output wire[31:0] out;
    reg[31:0]         memory[0:1023];
    assign out=memory[addr>>2];
initial begin
    $readmemh("code.txt",memory);
end
endmodule