// MIPS 32bit CPU
// 39 instructions
module MIPS;
    reg clk,reset;
    MIPSCU CU(clk,reset);
initial begin
    clk   <= 0;
    reset <= 1;
end
always begin
    #5 clk <= 1;
    #5 clk <= 0;
end
endmodule
