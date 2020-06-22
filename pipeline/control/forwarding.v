module forwarding
(
    ifid_reg,
    idex_reg,
    memwr_reg,
    BusAChange,
    BusBChange,
    ALUinAChange,
    ALUinBChange,
    LoadChange
);

input wire[63:0] ifid_reg;
wire[5:0] ifid_op;
wire[4:0] ifid_rs,ifid_rt,ifid_rd;
input wire[159:0] idex_reg;
wire[5:0] idex_op,idex_funct;
wire[4:0] idex_rs,idex_rt,idex_rd;
input wire[127:0] memwr_reg;
wire[5:0] memwr_op,memwr_funct;
wire[4:0] memwr_rt;
wire idex_is_slsr;
wire ifid_is_rtype,idex_is_rtype,ifid_is_itype,idex_is_itype;
wire memwr_is_load,memwr_is_jal;
output reg BusAChange,BusBChange,ALUinAChange,ALUinBChange,LoadChange;

assign ifid_op=ifid_reg[31:26];
assign ifid_rs=ifid_reg[25:21];
assign ifid_rt=ifid_reg[20:16];
assign idex_op=idex_reg[31:26];
assign idex_rs=idex_reg[25:21];
assign idex_rt=idex_reg[20:16];
assign idex_rd=idex_reg[15:11];
assign idex_funct=idex_reg[5:0];
assign memwr_op=memwr_reg[31:26];
assign memwr_funct=memwr_reg[5:0];
assign memwr_rt=memwr_reg[20:16];

assign idex_is_slsr=(
    idex_op==6'b000000 &
    (
        idex_funct==6'b000000 |
        idex_funct==6'b000010 |
        idex_funct==6'b000011 |
        idex_funct==6'b000100 |
        idex_funct==6'b000110 |
        idex_funct==6'b000111
    )
);
assign ifid_is_rtype=(ifid_op==6'b000000);
assign idex_is_rtype=(idex_op==6'b000000);
assign ifid_is_itype=(ifid_op!=6'b000000 & ifid_op!=6'b000010 & ifid_op!=6'b000011);
assign idex_is_itype=(idex_op!=6'b000000 & idex_op!=6'b000010 & idex_op!=6'b000011);
assign memwr_is_load=(memwr_op==6'b100011 | memwr_op==6'b100000 | memwr_op==6'b100100);
assign memwr_is_jal=((memwr_op==6'b000000 & memwr_funct==6'b001001) | memwr_op==6'b000011);

always@(*) begin
    if(ifid_is_rtype & idex_is_rtype) begin
        BusAChange <= (idex_rd==ifid_rs && idex_rd!=5'd0);
        BusBChange <= (idex_rd==ifid_rt && idex_rd!=5'd0);
    end
    else if(ifid_is_itype & idex_is_rtype) begin
        BusAChange <= (idex_rd==ifid_rs && idex_rd!=5'd0);
        BusBChange <= 0;
    end
    else if(ifid_is_rtype & idex_is_itype) begin
        BusAChange <= (idex_rt==ifid_rs && idex_rt!=5'd0);
        BusBChange <= (idex_rt==ifid_rt && idex_rt!=5'd0);
    end
    else if(ifid_is_itype & idex_is_itype) begin
        BusAChange <= (idex_rt==ifid_rs && idex_rd!=5'd0);
        BusBChange <= 0;
    end
    else begin
        BusAChange <= 0;
        BusBChange <= 0;
    end

    if(memwr_is_load & idex_is_rtype) begin
        ALUinAChange <= (memwr_rt==(idex_is_slsr?idex_rt:idex_rs) && memwr_rt!=5'd0);
        ALUinBChange <= (memwr_rt==(idex_is_slsr?idex_rs:idex_rt) && memwr_rt!=5'd0);
        LoadChange   <= 0;
    end
    else if(memwr_is_jal & idex_is_rtype) begin
        ALUinAChange <= ((idex_is_slsr?idex_rt:idex_rs)==5'd31);
        ALUinBChange <= ((idex_is_slsr?idex_rs:idex_rt)==5'd31);
        LoadChange   <= 0;
    end
    else if(memwr_is_load & idex_is_itype) begin
        ALUinAChange <= (memwr_rt==idex_rs && memwr_rt!=5'd0);
        ALUinBChange <= 0;
        LoadChange   <= (memwr_rt==idex_rt && memwr_rt!=5'd0);
    end
    else if(memwr_is_jal & idex_is_itype) begin
        ALUinAChange <= (idex_rs==5'd31);
        ALUinBChange <= 0;
        LoadChange   <= (idex_rt==5'd31);
    end
    else begin
        ALUinAChange <= 0;
        ALUinBChange <= 0;
        LoadChange   <= 0;
    end
end

endmodule