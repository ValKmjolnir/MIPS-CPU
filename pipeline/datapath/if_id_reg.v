module if_id_reg(clk,PC,IR,out);

input wire clk;
input wire[31:0] PC,IR;
output reg[63:0] out;

always@(negedge clk) begin
    out <= {PC,IR};
end

endmodule