// 2020/5/14 tested
module MIPSregFile(clk,addrW,addrA,addrB,wEn,BusW,BusA,BusB);

input wire       clk,wEn;
input wire[4:0]  addrW,addrA,addrB;
input wire[31:0] BusW;
output reg[31:0] BusA,BusB;
reg[31:0]    register[0:31];
integer i;

initial begin
    for (i=0;i<32;i=i+1) register[i] <= 0;
end
always@(*)begin
    BusA <= register[addrA];
    BusB <= register[addrB];
end
always@(posedge clk) begin
    if(wEn && addrW!=5'd0) register[addrW] <= BusW;
end
endmodule