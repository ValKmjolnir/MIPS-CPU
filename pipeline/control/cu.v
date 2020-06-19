module cu(clk,reset);

input wire clk,reset;
wire        JumpReg,Jump,Branch,IoprCtr,JrWr,RegWr,ExtOp,ImmCh,ShamtCh,ShiftCtr,MemWr,MemtoReg,Cout,ZF,OF,OverflowCheck,DmSignExt,DmError;
wire[1:0]   ByteWidth;
wire[4:0]   ALUopr,addrA,addrB,addrW,shamt;
wire[15:0]  imm16;
wire[25:0]  imm26;
wire[31:0]  nPC,PC,IR,BusA,BusB,BusW,ALUinA,ALUinB,ALUres,Dmout;
wire[63:0]  ifid_out;
wire[159:0] idex_out;
wire[127:0] exmem_out,memwr_out;

// nPC: if(JumpReg) regFile-BusA else if(Jump) {PC[31:28],imm26} else if(Branch) PC+signext(imm16) else PC+4
assign nPC   = JumpReg? BusA:(Jump? {ifid_out[63:60],ifid_out[25:0],2'b00}:(Branch? PC+{idex_out[15]? 14'h3fff:14'h0000,idex_out[15:0],2'b00}:PC+4));
assign addrA = ifid_out[25:21];
assign addrB = ifid_out[20:16];
assign addrW = JrWr? (IoprCtr? memwr_out[20:16]:memwr_out[15:11]):5'd31;
assign BusW  = JrWr? memwr_out[127:96]:(MemtoReg? memwr_out[63:32]:memwr_out[95:64]);
assign shamt = ifid_out[10:6];
assign imm16 = ifid_out[15:0];
assign imm26 = ifid_out[25:0];
assign ALUinA = ShiftCtr? BusB:BusA;
assign ALUinB = ShamtCh? (ImmCh? {(ExtOp? (imm16[15]? 16'hffff:16'h0000):16'h0000),imm16}:(ShiftCtr? BusA:BusB)):{27'd0,shamt};

ifu        mips_ifu(clk,reset,nPC,PC,IR);
if_id_reg  mips_ifid(clk,PC,IR,ifid_out);
if_id_decoder mips_ifid_dec(
    ifid_out,
    ExtOp,   // imm16 sign extend
    ImmCh,   // choose extended imm16 as BusB
    ShamtCtr,// choose shamt as BusB
    ShiftCtr,// swap BusA and BusB
    Jump,    // set PC = {PC[31:28],imm26,2'b00} to jump
    JumpReg  // set PC = BusA to jump
);
regFile    mips_regfile(clk,RegWr,addrA,addrB,addrW,BusA,BusB,BusW);
id_ex_reg  mips_idex(clk,ifid_out[63:32],ALUinA,ALUinB,BusB,ifid_out[31:0],idex_out);
id_ex_decoder mips_idex_dec(
    idex_out,
    OverflowCheck,// check overflow
    ALUopr        // choose alu function type
);
alu        mips_alu(idex_out[127:96],idex_out[95:64],Cout,ALUres,ALUopr,ZF,OF,Branch,OverflowCheck);
ex_mem_reg mips_exmem(clk,idex_out[159:128],ALUres,idex_out[63:32],idex_out[31:0],exmem_out);
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

endmodule