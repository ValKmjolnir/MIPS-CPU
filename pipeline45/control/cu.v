module cu(clk,reset);

input wire  clk,reset;
wire        JumpReg,Jump,JrWr,syscall,eret; // j/jr/jal/jalr syscall/eret
wire        Branch;                         // branch
wire        IoprCtr,RegWr;                  // I-type instruction/regFile wEn
wire        ExtOp,ImmCh,ShamtCh,ShiftCtr;   // imm16 extend-mode/choose imm16/choose shamt/swap BusA & BusB
wire        MemWr,MemtoReg;                 // memory write/memory to regFile
wire        Cout,ZF,OF,OverflowCheck;       // ALU used signals
wire        DmSignExt,DmError;              // data memory used signals
wire        ALU_Cp0_outCh;                  // choose ALUres or Cp0Out as the input of ex/mem register
wire        HazardCtr;
wire        idexBusAChange,idexBusBChange;
wire        exmemBusAChange,exmemBusBChange;
wire        ALUinAChange,ALUinBChange;
wire        LoadChange,JalAChange,JalBChange;
wire        RaAChange,RaBChange;            // mem/wr jal/jalr ra register is changed
wire[1:0]   ByteWidth;                      // load/store mode(width of data)
wire[4:0]   ALUopr;                         // choose calculation mode of ALU
wire[4:0]   addrA,addrB,addrW;              // addrA/addrB->regFile outA/outB addrW->regFile in
wire[15:0]  imm16;                          // immediate 16bit(used in I-type instructions)
wire[25:0]  imm26;                          // immediate 26bit(used in jump)
wire[31:0]  nPC,PC,IR,BusA,BusB,BusW,idexALUinA,idexALUinB,ALUinA,ALUinB,ALUres,Cp0PCout,EXres,Cp0Out,Dmout,realBusA,realBusB,immediate,shamt;
wire[63:0]  ifid_out;
wire[159:0] idex_out;
wire[127:0] exmem_out,memwr_out;

assign nPC =
    eret?
    Cp0PCout:
    (
        syscall?
        32'd0:
        (
            JumpReg?
            ALUinA:
            (
                Jump?
                {idex_out[159:156],idex_out[25:0],2'b00}:
                (
                    Branch?
                    idex_out[159:128]+{idex_out[15]? 14'h3fff:14'h0000,idex_out[15:0],2'b00}:
                    PC+4
                )
            )
        )
    );
assign addrA = ifid_out[25:21];
assign addrB = ifid_out[20:16];
assign addrW = JrWr? 5'd31:(IoprCtr? memwr_out[20:16]:memwr_out[15:11]);
assign BusW  = JrWr? memwr_out[127:96]+4:(MemtoReg? memwr_out[63:32]:memwr_out[95:64]);
assign shamt = {27'd0,ifid_out[10:6]};
assign imm16 = ifid_out[15:0];
assign imm26 = ifid_out[25:0];
assign ALUinA = (ALUinAChange?BusW:idex_out[127:96]);
assign ALUinB = (ALUinBChange?BusW:idex_out[95:64]);
assign realBusA = JalAChange? idex_out[159:128]:RaAChange? BusW:idexBusAChange? EXres:(exmemBusAChange? exmem_out[95:64]:BusA);
assign realBusB = JalBChange? idex_out[159:128]:RaBChange? BusW:idexBusBChange? EXres:(exmemBusBChange? exmem_out[95:64]:BusB);
assign immediate = ExtOp? (imm16[15]? {16'hffff,imm16}:{16'h0000,imm16}):{16'h0000,imm16};

assign idexALUinA = ShiftCtr?realBusB:realBusA;// used to set idex register
assign idexALUinB = ShamtCh?shamt:(ImmCh? immediate:(ShiftCtr? realBusA:realBusB));// used to set idex register

assign EXres = (ALU_Cp0_outCh? Cp0Out:ALUres);// output of ex stage

ifu        mips_ifu(clk,reset,nPC,PC,IR,HazardCtr);
if_id_reg  mips_ifid(
    clk,
    PC,  // in ifid_out the PC is changed to PC+4
    IR,
    ifid_out,
    HazardCtr
);
if_id_decoder mips_ifid_dec(
    ifid_out,
    ExtOp,   // imm16 sign extend
    ImmCh,   // choose extended imm16 as BusB
    ShamtCh, // choose shamt as BusB
    ShiftCtr // swap BusA and BusB
);
hazard mips_hazard(ifid_out,HazardCtr);

regFile    mips_regfile(clk,RegWr,addrA,addrB,addrW,BusA,BusB,BusW);
id_ex_reg  mips_idex(clk,ifid_out[63:32],idexALUinA,idexALUinB,realBusB,ifid_out[31:0],idex_out);
id_ex_decoder mips_idex_dec(
    idex_out,
    OverflowCheck,// check overflow
    ALUopr,       // choose alu function type
    ALU_Cp0_outCh,// choose Cp0Out instead of ALUres
    Jump,         // set PC = {PC[31:28],imm26,2'b00} to jump
    JumpReg,      // set PC = BusA to jump
    syscall,      // syscall
    eret          // eret
);
cp0 mips_cp0(
    clk,
    idex_out[159:128],
    idex_out[31:0],
    ALUinA,
    ALUinB,
    Cp0PCout,
    Cp0Out
);
alu mips_alu(
    ALUinA,
    ALUinB,
    Cout,
    ALUres,
    ALUopr,
    ZF,
    OF,
    Branch,
    OverflowCheck
);

ex_mem_reg mips_exmem(clk,idex_out[159:128],EXres,(LoadChange?BusW:idex_out[63:32]),idex_out[31:0],exmem_out);
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
    JalAChange,       // change $31 if used id/ex->if/id
    JalBChange,       // change $31 if used id/ex->if/id
    RaAChange,        // change $31 if used mem/wr->if/id
    RaBChange         // change $31 if used mem/wr->if/id
);

endmodule