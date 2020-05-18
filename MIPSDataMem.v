// 2020/5/14 tested
module MIPSDataMem(clk,addr,wEn,BusW,BusR);

input wire       clk,wEn;
input wire[31:0] addr,BusW;
output reg[31:0] BusR;
reg[31:0]    memory[0:1023];
integer i;

initial begin
    for(i=0;i<1024;i=i+1) memory[i]<=0;
end

always@(*) begin
    BusR <= memory[addr];
end

always@(posedge clk) begin
    if(wEn) memory[addr] <= BusW;
end
endmodule