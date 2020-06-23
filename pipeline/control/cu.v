module cu(clk,reset);

input wire clk,reset;
wire        JumpReg,Jump,Branch,IoprCtr,JrWr,RegWr,ExtOp,ImmCh,ShamtCh,ShiftCtr,MemWr,MemtoReg,Cout,ZF,OF,OverflowCheck,DmSignExt,DmError;
wire        HazardCtr,JumpHazardCtr;
wire        idexBusAChange,idexBusBChange;
wire        exmemBusAChange,exmemBusBChange;
wire        ALUinAChange,ALUinBChange;
wire        LoadChange,JalAChange,JalBChange;
wire[1:0]   ByteWidth;
wire[4:0]   ALUopr,addrA,addrB,addrW;
wire[15:0]  imm16;
wire[25:0]  imm26;
wire[31:0]  nPC,PC,IR,BusA,BusB,BusW,idexALUinA,idexALUinB,ALUinA,ALUinB,ALUres,Dmout,realBusA,realBusB,immediate,shamt;
wire[63:0]  ifid_out;
wire[159:0] idex_out;
wire[127:0] exmem_out,memwr_out;

assign nPC   = JumpReg? realBusA:(Jump? {ifid_out[63:60],ifid_out[25:0],2'b00}:(Branch? PC+{idex_out[15]? 14'h3fff:14'h0000,idex_out[15:0],2'b00}:PC+4));
assign addrA = ifid_out[25:21];
assign addrB = ifid_out[20:16];
assign addrW = JrWr? 5'd31:(IoprCtr? memwr_out[20:16]:memwr_out[15:11]);
assign BusW  = JrWr? memwr_out[127:96]:(MemtoReg? memwr_out[63:32]:memwr_out[95:64]);
assign shamt = {27'd0,ifid_out[10:6]};
assign imm16 = ifid_out[15:0];
assign immediate = ExtOp? (imm16[15]? {16'hffff,imm16}:{16'h0000,imm16}):{16'h0000,imm16};
assign imm26 = ifid_out[25:0];
assign realBusA = JalAChange? idex_out[159:128]:idexBusAChange?ALUres:(exmemBusAChange?exmem_out[95:64]:BusA);
assign realBusB = JalBChange? idex_out[159:128]:idexBusBChange?ALUres:(exmemBusBChange?exmem_out[95:64]:BusB);
assign idexALUinA = ShiftCtr?realBusB:realBusA;
assign idexALUinB = ShamtCh?shamt:(ImmCh? immediate:(ShiftCtr? realBusA:realBusB));
assign ALUinA = (ALUinAChange?BusW:idex_out[127:96]);
assign ALUinB = (ALUinBChange?BusW:idex_out[95:64]);

ifu        mips_ifu(clk,reset,nPC,PC,IR,HazardCtr);
if_id_reg  mips_ifid(clk,PC,IR,ifid_out,HazardCtr);
if_id_decoder mips_ifid_dec(
    ifid_out,
    ExtOp,   // imm16 sign extend
    ImmCh,   // choose extended imm16 as BusB
    ShamtCh, // choose shamt as BusB
    ShiftCtr,// swap BusA and BusB
    Jump,    // set PC = {PC[31:28],imm26,2'b00} to jump
    JumpReg  // set PC = BusA to jump
);
hazard mips_hazard(ifid_out,HazardCtr);

regFile    mips_regfile(clk,RegWr,addrA,addrB,addrW,BusA,BusB,BusW);
id_ex_reg  mips_idex(clk,ifid_out[63:32],idexALUinA,idexALUinB,realBusB,ifid_out[31:0],idex_out);
id_ex_decoder mips_idex_dec(
    idex_out,
    OverflowCheck,// check overflow
    ALUopr        // choose alu function type
);

alu        mips_alu(ALUinA,ALUinB,Cout,ALUres,ALUopr,ZF,OF,Branch,OverflowCheck);
ex_mem_reg mips_exmem(clk,idex_out[159:128],ALUres,(LoadChange?BusW:idex_out[63:32]),idex_out[31:0],exmem_out);
ex_mem_decoder mips_exmem_dec(
    exmem_out,
    MemWr,    // dm write enable
    DmSignExt,// dm data sign extend
    ByteWidth // byte width
);

dm         mips_dm(clk,exmem_out[95:64],MemWr,exmem_out[63:32],Dmout,ByteWidth,DmSignExt,DmError);
mem_wr_reg mips_memwr(clk,exmem_out[127:96],exmem_out[95:64],Dmout,exmem_out[31:0],memwr_out);
mem_wr_decoder    mips_memwr_dec(
    memwr_out,
    IoprCtr,  // choose rt as addrW
    JrWr,     // jal/jalr will store PC to register#31
    RegWr,    // regFile write enable       
    MemtoReg  // write dm data to register
);

forwarding mips_fwd(
    ifid_out,
    idex_out,
    exmem_out,
    memwr_out,
    idexBusAChange,   // change BusA
    idexBusBChange,   // change BusB
    exmemBusAChange,  // change BusA
    exmemBusBChange,  // change BusB
    ALUinAChange,     // change ALUinA
    ALUinBChange,     // change ALUinB
    LoadChange,       // change exmem:Din
    JalAChange,       // change $31 if used
    JalBChange        // change $31 if used
);

endmodule