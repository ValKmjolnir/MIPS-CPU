module forwarding
(
    ifid_reg,
    idex_reg,
    exmem_reg,
    memwr_reg,
    idexBusAChange,
    idexBusBChange,
    exmemBusAChange,
    exmemBusBChange,
    ALUinAChange,
    ALUinBChange,
    LoadChange,
    JalAChange,
    JalBChange
);

input wire[63:0] ifid_reg;
wire[5:0] ifid_op;
wire[4:0] ifid_rs,ifid_rt,ifid_rd;
input wire[159:0] idex_reg;
wire[5:0] idex_op,idex_funct;
wire[4:0] idex_rs,idex_rt,idex_rd;
input wire[127:0] exmem_reg,memwr_reg;
wire[5:0] exmem_op,exmem_funct,memwr_op,memwr_funct;
wire[4:0] exmem_rt,exmem_rd,memwr_rt;
wire idex_is_slsr;
wire ifid_is_rtype,ifid_is_itype,ifid_is_store;
wire idex_is_rtype,idex_is_itype,idex_is_jal;
wire exmem_is_rtype,exmem_is_itype;
wire memwr_is_load,memwr_is_jal;
wire ShiftA,ShiftB;
output reg idexBusAChange,idexBusBChange;
output reg exmemBusAChange,exmemBusBChange;
output reg ALUinAChange,ALUinBChange;
output reg LoadChange,JalAChange,JalBChange;

assign ifid_op=ifid_reg[31:26];
assign ifid_rs=ifid_reg[25:21];
assign ifid_rt=ifid_reg[20:16];
assign idex_op=idex_reg[31:26];
assign idex_rs=idex_reg[25:21];
assign idex_rt=idex_reg[20:16];
assign idex_rd=idex_reg[15:11];
assign idex_funct=idex_reg[5:0];
assign exmem_op=exmem_reg[31:26];
assign exmem_funct=exmem_reg[5:0];
assign exmem_rt=exmem_reg[20:16];
assign exmem_rd=exmem_reg[15:11];
assign memwr_op=memwr_reg[31:26];
assign memwr_funct=memwr_reg[5:0];
assign memwr_rt=memwr_reg[20:16];

assign ifid_is_rtype=(ifid_op==6'b000000);
assign ifid_is_itype=(ifid_op!=6'b000000 & ifid_op!=6'b000010 & ifid_op!=6'b000011);
assign ifid_is_store=(ifid_op==6'b101011 | ifid_op==6'b101000);
assign idex_is_rtype=(idex_op==6'b000000);
assign idex_is_itype=(idex_op!=6'b000000 & idex_op!=6'b000010 & idex_op!=6'b000011 & idex_op!=6'b101011 & idex_op!=6'b101000);
assign exmem_is_rtype=(exmem_op==6'b000000);
assign exmem_is_itype=(exmem_op!=6'b000000 & exmem_op!=6'b000010 & exmem_op!=6'b000011 & exmem_op!=6'b101011 & exmem_op!=6'b101000);
assign memwr_is_load=(memwr_op==6'b100011 | memwr_op==6'b100000 | memwr_op==6'b100100);
assign memwr_is_jal=((memwr_op==6'b000000 & memwr_funct==6'b001001) | memwr_op==6'b000011);
assign ShiftA=(
    idex_op==6'b000000 &&(
    idex_funct==6'b000000 |
    idex_funct==6'b000010 |
    idex_funct==6'b000011 |
    idex_funct==6'b000100 |
    idex_funct==6'b000110 |
    idex_funct==6'b000111
));
assign ShiftB=(
    idex_op==6'b000000 &&(
    idex_funct==6'b000100 |
    idex_funct==6'b000110 |
    idex_funct==6'b000111
));


always@(*) begin
    if(ifid_is_rtype & idex_is_rtype) begin
        idexBusAChange <= (idex_rd==ifid_rs && idex_rd!=5'd0);
        idexBusBChange <= (idex_rd==ifid_rt && idex_rd!=5'd0);
    end
    else if(ifid_is_itype & idex_is_rtype) begin
        idexBusAChange <= (idex_rd==ifid_rs && idex_rd!=5'd0);
        idexBusBChange <= (ifid_is_store && idex_rd==ifid_rt && idex_rd!=5'd0);
    end
    else if(ifid_is_rtype & idex_is_itype) begin
        idexBusAChange <= (idex_rt==ifid_rs && idex_rt!=5'd0);
        idexBusBChange <= (idex_rt==ifid_rt && idex_rt!=5'd0);
    end
    else if(ifid_is_itype & idex_is_itype) begin
        idexBusAChange <= (idex_rt==ifid_rs && idex_rt!=5'd0);
        idexBusBChange <= (ifid_is_store && idex_rt==ifid_rt && idex_rt!=5'd0);
    end
    else begin
        idexBusAChange <= 0;
        idexBusBChange <= 0;
    end

    if(ifid_is_rtype && idex_is_jal) begin
        JalAChange <= (ifid_rs==5'd31);
        JalBChange <= (ifid_rt==5'd31);
    end
    else if(ifid_is_itype) begin
        JalAChange <= (ifid_rs==5'd31);
        JalBChange <= (ifid_is_store && ifid_rt==5'd31);
    end
    else begin
        JalAChange <= 0;
        JalBChange <= 0;
    end

    if(ifid_is_rtype & exmem_is_rtype) begin
        exmemBusAChange <= (exmem_rd==ifid_rs && exmem_rd!=5'd0);
        exmemBusBChange <= (exmem_rd==ifid_rt && exmem_rd!=5'd0);
    end
    else if(ifid_is_itype & exmem_is_rtype) begin
        exmemBusAChange <= (exmem_rd==ifid_rs && exmem_rd!=5'd0);
        exmemBusBChange <= (ifid_is_store && exmem_rd==ifid_rt && exmem_rd!=5'd0);
    end
    else if(ifid_is_rtype & exmem_is_itype) begin
        exmemBusAChange <= (exmem_rt==ifid_rs && exmem_rt!=5'd0);
        exmemBusBChange <= (exmem_rt==ifid_rt && exmem_rt!=5'd0);
    end
    else if(ifid_is_itype & exmem_is_itype) begin
        exmemBusAChange <= (exmem_rt==ifid_rs && exmem_rt!=5'd0);
        exmemBusBChange <= (ifid_is_store && exmem_rt==ifid_rt && exmem_rt!=5'd0);
    end
    else begin
        exmemBusAChange <= 0;
        exmemBusBChange <= 0;
    end

    if(memwr_is_load & idex_is_rtype) begin
        ALUinAChange <= (memwr_rt==(ShiftA?idex_rt:idex_rs) && memwr_rt!=5'd0);
        if(ShiftB)
            ALUinBChange <= (memwr_rt==idex_rs && memwr_rt!=5'd0);
        else if(ShiftA)
            ALUinBChange <= 0;
        else
            ALUinBChange <= (memwr_rt==idex_rt && memwr_rt!=5'd0);
        LoadChange   <= 0;
    end
    else if(memwr_is_jal & idex_is_rtype) begin
        ALUinAChange <= ((ShiftA?idex_rt:idex_rs)==5'd31);
        if(ShiftB)
            ALUinBChange <= (idex_rs==5'd31);
        else if(ShiftA)
            ALUinBChange <= 0;
        else
            ALUinBChange <= (idex_rt==5'd31);
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