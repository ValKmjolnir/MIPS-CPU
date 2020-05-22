// 2020/5/14 tested
module MIPSInstMem(addr,out);
    input[31:0]       addr;
    output wire[31:0] out;
    reg[31:0]         memory[0:1023];
    assign out=memory[addr>>2];
initial begin
    memory[0]<=32'h24010001;
    memory[1]<=32'h00011100;
    memory[2]<=32'h00411821;
    memory[3]<=32'h00022082;
    memory[4]<=32'h28990005;
    memory[5]<=32'h07210010;
    memory[6]<=32'h00642823;
    memory[7]<=32'hac050014;
    memory[8]<=32'h00a23027;
    memory[9]<=32'h00c33825;
    memory[10]<=32'h00e64026;
    memory[11]<=32'hac08001c;
    memory[12]<=32'h11030002;
    memory[13]<=32'h00c7482a;
    memory[14]<=32'h24010008;
    memory[15]<=32'h8c2a0014;
    memory[16]<=32'h15450004;
    memory[17]<=32'h00415824;
    memory[18]<=32'hac2b001c;
    memory[19]<=32'hac240010;
    memory[20]<=32'h0c000019;
    memory[21]<=32'h3c0c000c;
    memory[22]<=32'h004cd007;
    memory[23]<=32'h003ad804;
    memory[24]<=32'h0360f809;
    memory[25]<=32'ha07a0005;
    memory[26]<=32'h0063682b;
    memory[27]<=32'h1da00003;
    memory[28]<=32'h00867004;
    memory[29]<=32'h000e7883;
    memory[30]<=32'h002f8006;
    memory[31]<=32'h1a000008;
    memory[32]<=32'h002f8007;
    memory[33]<=32'h240b008c;
    memory[34]<=32'h06000006;
    memory[35]<=32'h8d5c0003;
    memory[36]<=32'h179d0007;
    memory[37]<=32'ha0af0008;
    memory[38]<=32'h80b20008;
    memory[39]<=32'h90b30008;
    memory[40]<=32'h2df8ffff;
    memory[41]<=32'h0185e825;
    memory[42]<=32'h01600008;
    memory[43]<=32'h31f4ffff;
    memory[44]<=32'h35f5ffff;
    memory[45]<=32'h39f6ffff;
    memory[46]<=32'h08000000;
end
endmodule