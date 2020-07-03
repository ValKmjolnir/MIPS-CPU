module cp0(clk,PC,ifid_IR,idex_IR,DataA,DataB,ifid_out,idex_out);

input wire clk;
input wire[31:0] PC,ifid_IR,idex_IR,DataA,DataB;
output reg[31:0] idex_out;
reg[31:0] register[0:13];
reg[31:0] HI,LO;

wire[4:0] idex_cs,idex_cd;
wire[5:0] ifid_op,idex_op;
wire[5:0] ifid_funct,idex_funct;
output wire[31:0] ifid_out;

assign ifid_op=ifid_IR[31:26];
assign ifid_funct=ifid_IR[5:0];
assign idex_cs=idex_IR[15:11];
assign idex_cd=idex_IR[15:11];
assign idex_op=idex_IR[31:26];
assign idex_funct=idex_IR[5:0];

assign ifid_out=(ifid_op==6'b010000 && ifid_funct==6'b011000)? register[14]:32'd0;

always@(posedge clk) begin
    if(idex_op==6'b000000 && idex_funct==6'b011000)
        {HI,LO} <= $signed(DataA)*$signed(DataB); // MULT calculation multi
    else if(idex_op==6'b000000 && idex_funct==6'b010010)
        idex_out <= LO;                           // MFLO output/wr
    else if(idex_op==6'b000000 && idex_funct==6'b010000)
        idex_out <= HI;                           // MFHI output/wr
    else if(idex_op==6'b000000 && idex_funct==6'b010011)
        LO <= DataA;                              // MTLO input
    else if(idex_op==6'b000000 && idex_funct==6'b010001)
        HI <= DataA;                              // MTHI input
    else if(idex_op==6'b010000 && idex_IR[25:21]==5'b00000)
        idex_out <= register[idex_cs];            // MFC0 output/wr
    else if(idex_op==6'b010000 && idex_IR[25:21]==5'b00100)
        register[idex_cd] <= DataB;               // MTC0 input
    else if(ifid_op==6'b000000 && ifid_funct==6'b001100) begin
        register[14] <= PC;
        register[13][6:2] <= 5'b01000;
        register[12][1] <= 1;
    end                                           // syscall
    else if(ifid_op==6'b010000 && ifid_funct==6'b011000)
        register[12][1] <= 0;                     // eret
end

endmodule