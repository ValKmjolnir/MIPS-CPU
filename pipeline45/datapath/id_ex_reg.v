module id_ex_reg(clk,PC,BusA,BusB,Dmin,IR,out);

input wire clk;
input wire[31:0] PC,BusA,BusB,Dmin,IR;
output reg[159:0] out;

initial begin
    out <=160'd0;
end

always@(negedge clk)begin
    out <= {PC,BusA,BusB,Dmin,IR};
end

endmodule