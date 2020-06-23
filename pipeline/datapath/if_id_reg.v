module if_id_reg(clk,PC,IR,out,HazardCtr);

input wire clk,HazardCtr;
input wire[31:0] PC,IR;
output reg[63:0] out;

initial begin
    out <= 64'd0;
    #1 out <= {PC+4,IR};
end

always@(negedge clk) begin
    out <= HazardCtr? 64'd0:{PC+4,IR};
end

endmodule