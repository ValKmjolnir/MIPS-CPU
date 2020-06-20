module ex_mem_reg(clk,PC,Res,Dmin,IR,out);

input wire clk;
input wire[31:0] PC,Res,Dmin,IR;
output reg[127:0] out;

initial begin
    out <= 128'd0;
end

always@(negedge clk)begin
    out <= {PC,Res,Dmin,IR};
end

endmodule