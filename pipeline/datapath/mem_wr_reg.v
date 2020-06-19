module mem_wr_reg(clk,PC,Res,Dout,IR,out);

input wire clk;
input wire[31:0] PC,Res,Dout,IR;
output reg[127:0] out;

always@(negedge clk)begin
    out <= {PC,Res,Dout,IR};
end

endmodule