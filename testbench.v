
module testbench;
    reg clk,reset;
    MIPSCU CU(clk,reset);
initial begin
    clk   <= 0;
    reset <= 1;
    #5 reset <=0;
    #5 reset <=1;
end
always begin
    #5 clk <= 1;
    #5 clk <= 0;
end
endmodule
