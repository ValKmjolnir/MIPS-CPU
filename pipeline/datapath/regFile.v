module regFile(clk,RegWr,addrA,addrB,addrW,BusA,BusB,BusW);

input wire        clk,RegWr;
input wire[4:0]   addrA,addrB,addrW;
input wire[31:0]  BusW;
output wire[31:0] BusA,BusB;
reg[31:0]         register[0:31];
integer           i;

assign BusA = register[addrA];
assign BusB = register[addrB];

initial begin
    for(i=0;i<32;i=i+1) register[i] <= 32'd0;
end
always@(posedge clk) begin
    if(RegWr && addrW) register[addrW] <= BusW;
end
endmodule