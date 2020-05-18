module MIPSdecoder
(
    OprCtr,  // operand
    funct,   // function
    RegDst,  // choose R-type or I-type rd
    RegWr,   // register write
    ExtOp,   // extend imm16 opr
    ALUsrc,  // ALUinB source choice
    ALUctr,  // ALU opr
    MemWr,   // memory write(sw)
    MemtoReg,// memory to register(lw)
    Cin,     // ALU cin
    Branch,  // beq bne
    Jump     // j
);
input wire[5:0] OprCtr,funct;
output reg      RegDst,RegWr,ExtOp,ALUsrc,MemWr,MemtoReg,Cin,Branch,Jump;
output reg[2:0] ALUctr;

always@(*) begin
    if(OprCtr==6'b000000) begin
        RegDst <= 0;
        RegWr  <= 1;
        ExtOp  <= 0;
        ALUsrc <= 0;
        case(funct)
            6'b100000:ALUctr <= 3'b001;// add
            6'b100010:ALUctr <= 3'b010;// sub
            6'b100100:ALUctr <= 3'b011;// and
            6'b100101:ALUctr <= 3'b100;// or
            6'b100110:ALUctr <= 3'b101;// xor
            6'b101010:ALUctr <= 3'b110;// slt
        endcase
        Branch   <= 0;
        Jump     <= 0;
        MemWr    <= 0;
        MemtoReg <= 0;
    end
    else if(OprCtr==6'b001000) begin// addi
        RegDst   <= 1;
        RegWr    <= 1;
        ExtOp    <= 0;
        ALUsrc   <= 1;
        ALUctr   <= 3'b001;
        Branch   <= 0;
        Jump     <= 0;
        MemWr    <= 0;
        MemtoReg <= 0;
    end
    else if(OprCtr==6'b100011) begin// lw
        RegDst   <= 1;
        RegWr    <= 1;
        ExtOp    <= 0;
        ALUsrc   <= 1;
        ALUctr   <= 3'b001;
        Branch   <= 0;
        Jump     <= 0;
        MemWr    <= 0;
        MemtoReg <= 1;
    end
    else if(OprCtr==6'b101011) begin// sw
        RegDst   <= 1;
        RegWr    <= 0;
        ExtOp    <= 0;
        ALUsrc   <= 1;
        ALUctr   <= 3'b001;
        Branch   <= 0;
        Jump     <= 0;
        MemWr    <= 1;
        MemtoReg <= 0;
    end
    else if(OprCtr==6'b000100) begin// beq
        RegDst   <= 1;
        RegWr    <= 0;
        ExtOp    <= 0;
        ALUsrc   <= 0;
        ALUctr   <= 3'b010;
        Branch   <= 1;
        Jump     <= 0;
        MemWr    <= 0;
        MemtoReg <= 0;
    end
    else if(OprCtr==6'b000010) begin// j
        RegDst   <= 0;
        RegWr    <= 0;
        ExtOp    <= 0;
        ALUsrc   <= 0;
        ALUctr   <= 3'b000;
        Branch   <= 0;
        Jump     <= 1;
        MemWr    <= 0;
        MemtoReg <= 0;
    end
end
endmodule