module mips;

reg clk,reset;

cu mips_cu(clk,reset);

initial begin
    clk   <=0;
    reset <=1;
end

always begin
    #2 clk <= 1;
    #2 clk <= 0;
end

endmodule