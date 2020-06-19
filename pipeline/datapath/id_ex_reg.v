module id_ex_reg(clk,PC,BusA,BusB,Dmin,IR,out);

input wire clk;
input wire[31:0] PC,BusA,BusB,Dmin,IR;
output reg[159:0] out;

always@(negedge clk)begin
    out <= {PC,BusA,BusB,Dmin,IR};
end

endmodule