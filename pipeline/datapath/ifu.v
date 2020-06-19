module ifu(clk,reset,nPC,PC,IR);

input wire        clk,reset;
input wire[31:0]  nPC;
output reg[31:0]  PC;
output wire[31:0] IR;

im instMem(PC,IR);

initial begin
    PC <= 32'd0;
end

always@(posedge clk or negedge reset) begin
    if(!reset) PC <= 32'd0;
    else       PC <= nPC;
end

endmodule