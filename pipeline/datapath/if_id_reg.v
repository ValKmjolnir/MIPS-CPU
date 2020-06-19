module if_id_reg(clk,PC,IR,out,HazardCtr);

input wire clk,HazardCtr;
input wire[31:0] PC,IR;
output reg[63:0] out;

always@(negedge clk) begin
    out <= HazardCtr? 64'd0:{PC,IR};
end

endmodule