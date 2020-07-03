module ifu(clk,reset,nPC,PC,IR,HazardCtr);

input wire        clk,reset,HazardCtr;
input wire[31:0]  nPC;
output reg[31:0]  PC;
output wire[31:0] IR;

im instMem(PC,IR);

initial begin
    PC <= 32'd0;        // 36 instructions
    //PC <= 32'h00000034; // 45 instructions
end

always@(posedge clk or negedge reset) begin
    if(!reset)             PC <= 32'd0;
    else if(!HazardCtr)    PC <= nPC;
end

endmodule