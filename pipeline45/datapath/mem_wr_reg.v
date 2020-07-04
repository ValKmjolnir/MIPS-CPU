module mem_wr_reg(clk,PC,Res,Dout,IR,out);

input wire clk;
input wire[31:0] PC,Res,Dout,IR;
output reg[127:0] out;

initial begin
    out <= 128'd0;
end

always@(negedge clk)begin
    out <= {PC,Res,Dout,IR};
end

endmodule