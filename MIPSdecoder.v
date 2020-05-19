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
output reg[4:0] ALUctr;

always@(*) begin
    if(OprCtr==6'b000000) begin
        RegDst <= 0;
        RegWr  <= 1;
        ExtOp  <= 0;
        ALUsrc <= 0;
        case(funct)
            6'b100000:ALUctr <= 5'b00001;// add
            6'b100010:ALUctr <= 5'b00010;// sub
            6'b100100:ALUctr <= 5'b00011;// and
            6'b100101:ALUctr <= 5'b00100;// or
            6'b100110:ALUctr <= 5'b00101;// xor
            6'b100111:ALUctr <= 5'b00110;// nor
            6'b101010:ALUctr <= 5'b00110;// slt
            6'b101011:ALUctr <= 5'b01000;// sltu
            6'b000000:ALUctr <= 5'b01001;// sll
            6'b000010:ALUctr <= 5'b01010;// srl
            6'b000011:ALUctr <= 5'b01011;// sra
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
        ALUctr   <= 5'b00001;
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
        ALUctr   <= 5'b00001;
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
        ALUctr   <= 5'b00001;
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
        ALUctr   <= 5'b01100;
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
        ALUctr   <= 5'b00000;
        Branch   <= 0;
        Jump     <= 1;
        MemWr    <= 0;
        MemtoReg <= 0;
    end
end
endmodule