// 2020/5/14 tested
module MIPSInstMem(addr,out);
    input[31:0]  addr;
    output[31:0] out;
    wire[31:0]   out;
    reg[7:0]     memory[0:1023];
    assign out={memory[addr],memory[addr+1],memory[addr+2],memory[addr+3]};
initial begin
    memory[0]<=8'h00;  memory[1]<=8'h00;  memory[2]<=8'h80;  memory[3]<=8'h20;
    memory[4]<=8'h20;  memory[5]<=8'h11;  memory[6]<=8'h00;  memory[7]<=8'h0a;
    memory[8]<=8'h20;  memory[9]<=8'h12;  memory[10]<=8'h00; memory[11]<=8'h14;
    memory[12]<=8'h02; memory[13]<=8'h20; memory[14]<=8'h40; memory[15]<=8'h20;
    memory[16]<=8'h20; memory[17]<=8'h09; memory[18]<=8'h00; memory[19]<=8'haa;
    memory[20]<=8'h22; memory[21]<=8'h2a; memory[22]<=8'h00; memory[23]<=8'h0a;
    memory[24]<=8'had; memory[25]<=8'h09; memory[26]<=8'h00; memory[27]<=8'h00;
    memory[28]<=8'h21; memory[29]<=8'h08; memory[30]<=8'h00; memory[31]<=8'h01;
    memory[32]<=8'h11; memory[33]<=8'h48; memory[34]<=8'h00; memory[35]<=8'h01;
    memory[36]<=8'h08; memory[37]<=8'h00; memory[38]<=8'h00; memory[39]<=8'h06;
    memory[40]<=8'h02; memory[41]<=8'h40; memory[42]<=8'h40; memory[43]<=8'h20;
    memory[44]<=8'h20; memory[45]<=8'h09; memory[46]<=8'h00; memory[47]<=8'hff;
    memory[48]<=8'h22; memory[49]<=8'h4a; memory[50]<=8'h00; memory[51]<=8'h0a;
    memory[52]<=8'had; memory[53]<=8'h09; memory[54]<=8'h00; memory[55]<=8'h00;
    memory[56]<=8'h21; memory[57]<=8'h08; memory[58]<=8'h00; memory[59]<=8'h01;
    memory[60]<=8'h11; memory[61]<=8'h48; memory[62]<=8'h00; memory[63]<=8'h01;
    memory[64]<=8'h08; memory[65]<=8'h00; memory[66]<=8'h00; memory[67]<=8'h0d;
    memory[68]<=8'h02; memory[69]<=8'h00; memory[70]<=8'h40; memory[71]<=8'h20;
    memory[72]<=8'h02; memory[73]<=8'h20; memory[74]<=8'h48; memory[75]<=8'h20;
    memory[76]<=8'h02; memory[77]<=8'h40; memory[78]<=8'h50; memory[79]<=8'h20;
    memory[80]<=8'h22; memory[81]<=8'h0b; memory[82]<=8'h00; memory[83]<=8'h0a;
    memory[84]<=8'h8d; memory[85]<=8'h2c; memory[86]<=8'h00; memory[87]<=8'h00;
    memory[88]<=8'h8d; memory[89]<=8'h4d; memory[90]<=8'h00; memory[91]<=8'h00;
    memory[92]<=8'h01; memory[93]<=8'h8d; memory[94]<=8'h70; memory[95]<=8'h20;
    memory[96]<=8'had; memory[97]<=8'h0e; memory[98]<=8'h00; memory[99]<=8'h00;
    memory[100]<=8'h21; memory[101]<=8'h08; memory[102]<=8'h00; memory[103]<=8'h01;
    memory[104]<=8'h21; memory[105]<=8'h29; memory[106]<=8'h00; memory[107]<=8'h01;
    memory[108]<=8'h21; memory[109]<=8'h4a; memory[110]<=8'h00; memory[111]<=8'h01;
    memory[112]<=8'h11; memory[113]<=8'h68; memory[114]<=8'h00; memory[115]<=8'h01;
    memory[116]<=8'h08; memory[117]<=8'h00; memory[118]<=8'h00; memory[119]<=8'h15;
end
endmodule