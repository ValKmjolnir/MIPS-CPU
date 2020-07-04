module mips;

reg clk,reset;

cu mips_cu(clk,reset);

initial begin
    #4 reset <=1;
end

always begin
    #2 clk <= 0;
    #2 clk <= 1;
end

endmodule