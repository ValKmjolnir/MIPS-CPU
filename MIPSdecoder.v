module MIPSdecoder
(
    OprCtr,        // operand
    BrCh,          // IR[20:16] used to choose BGEZ or BLTZ
    funct,         // function
    IoprCh,        // choose R-type or I-type rd
    RegWr,         // register write
    ExtOp,         // extend imm16 opr
    ALUsrc,        // choose imm16 or BusB
    ALUctr,        // ALU opr
    OverflowCheck, // check overflow
    MemWr,         // memory write(sw)
    MemtoReg,      // memory to register(lw)
    Cin,           // ALU cin
    Branch,        // beq bne
    Jump,          // jump
    JrWr,          // jump register write
    ShamtCtr,      // use shamt(choose ALUsrc-out or shamt)
    JumpReg,       // jump register
    ByteWidth,     // data memory I/O width
    DmSignExt      // data memory output extend mode
);
input wire[5:0] OprCtr,funct;
input wire[4:0] BrCh;
output reg
    IoprCh,
    RegWr,
    ExtOp,
    ALUsrc,
    OverflowCheck,
    MemWr,
    MemtoReg,
    Cin,
    Branch,
    Jump,
    JrWr,
    ShamtCtr,
    JumpReg,
    DmSignExt;
output reg[1:0] ByteWidth;
output reg[4:0] ALUctr;

initial begin
    ByteWidth <= 2'b00;
    DmSignExt <= 0;
end

always@(*) begin
    if(OprCtr==6'b000000) begin
        IoprCh <= 0;
        RegWr  <= (funct!=6'b001000);// only jr doesn't need write enable
        ExtOp  <= 0;
        ALUsrc <= 0;
        case(funct)
            6'b100000:ALUctr <= 5'b00001;// add
            6'b100001:ALUctr <= 5'b00001;// addu
            6'b100010:ALUctr <= 5'b00010;// sub
            6'b100011:ALUctr <= 5'b00010;// subu
            6'b100100:ALUctr <= 5'b00011;// and
            6'b100101:ALUctr <= 5'b00100;// or
            6'b100110:ALUctr <= 5'b00101;// xor
            6'b100111:ALUctr <= 5'b00110;// nor
            6'b101010:ALUctr <= 5'b00110;// slt
            6'b101011:ALUctr <= 5'b01000;// sltu
            6'b000000:ALUctr <= 5'b01001;// sll
            6'b000010:ALUctr <= 5'b01010;// srl
            6'b000011:ALUctr <= 5'b01011;// sra
            6'b000100:ALUctr <= 5'b01001;// sllv
            6'b000110:ALUctr <= 5'b01010;// srlv
            6'b000111:ALUctr <= 5'b01011;// srav
        endcase
        OverflowCheck <= (funct==6'b100000 || funct==6'b100010);
        Branch   <= 0;
        Jump     <= 0;
        MemWr    <= 0;
        MemtoReg <= 0;
        JrWr     <= (funct==6'b001001);// jalr
        ShamtCtr <= (funct==6'b000000 || funct==6'b000010 || funct==6'b000011);
        JumpReg  <= (funct==6'b001000 || funct==6'b001001);// jr \ jalr
    end
    else if(OprCtr==6'b001000) begin// addi
        IoprCh   <= 1;
        RegWr    <= 1;
        ExtOp    <= 1;
        ALUsrc   <= 1;
        ALUctr   <= 5'b00001;
        OverflowCheck <= 1;
        Branch   <= 0;
        Jump     <= 0;
        MemWr    <= 0;
        MemtoReg <= 0;
        JrWr     <= 0;
        ShamtCtr <= 0;
        JumpReg  <= 0;
    end
    else if(OprCtr==6'b001001) begin// addiu
        IoprCh   <= 1;
        RegWr    <= 1;
        ExtOp    <= 1;
        ALUsrc   <= 1;
        ALUctr   <= 5'b00001;
        OverflowCheck <= 0;
        Branch   <= 0;
        Jump     <= 0;
        MemWr    <= 0;
        MemtoReg <= 0;
        JrWr     <= 0;
        ShamtCtr <= 0;
        JumpReg  <= 0;
    end
    else if(OprCtr==6'b001010) begin// slti
        IoprCh   <= 1;
        RegWr    <= 1;
        ExtOp    <= 1;
        ALUsrc   <= 1;
        ALUctr   <= 5'b00111;
        OverflowCheck <= 0;
        Branch   <= 0;
        Jump     <= 0;
        MemWr    <= 0;
        MemtoReg <= 0;
        JrWr     <= 0;
        ShamtCtr <= 0;
        JumpReg  <= 0;
    end
    else if(OprCtr==6'b001011) begin// sltiu
        IoprCh   <= 1;
        RegWr    <= 1;
        ExtOp    <= 1;
        ALUsrc   <= 1;
        ALUctr   <= 5'b01000;
        OverflowCheck <= 0;
        Branch   <= 0;
        Jump     <= 0;
        MemWr    <= 0;
        MemtoReg <= 0;
        JrWr     <= 0;
        ShamtCtr <= 0;
        JumpReg  <= 0;
    end
    else if(OprCtr==6'b001100) begin// andi
        IoprCh   <= 1;
        RegWr    <= 1;
        ExtOp    <= 0;
        ALUsrc   <= 1;
        ALUctr   <= 5'b00011;
        OverflowCheck <= 0;
        Branch   <= 0;
        Jump     <= 0;
        MemWr    <= 0;
        MemtoReg <= 0;
        JrWr     <= 0;
        ShamtCtr <= 0;
        JumpReg  <= 0;
    end
    else if(OprCtr==6'b001101) begin// ori
        IoprCh   <= 1;
        RegWr    <= 1;
        ExtOp    <= 0;
        ALUsrc   <= 1;
        ALUctr   <= 5'b00100;
        OverflowCheck <= 0;
        Branch   <= 0;
        Jump     <= 0;
        MemWr    <= 0;
        MemtoReg <= 0;
        JrWr     <= 0;
        ShamtCtr <= 0;
        JumpReg  <= 0;
    end
    else if(OprCtr==6'b001110) begin// xori
        IoprCh   <= 1;
        RegWr    <= 1;
        ExtOp    <= 0;
        ALUsrc   <= 1;
        ALUctr   <= 5'b00101;
        OverflowCheck <= 0;
        Branch   <= 0;
        Jump     <= 0;
        MemWr    <= 0;
        MemtoReg <= 0;
        JrWr     <= 0;
        ShamtCtr <= 0;
        JumpReg  <= 0;
    end
    else if(OprCtr==6'b001111) begin// lui
        IoprCh   <= 1;
        RegWr    <= 1;
        ExtOp    <= 0;
        ALUsrc   <= 1;
        ALUctr   <= 5'b10010;
        OverflowCheck <= 0;
        Branch   <= 0;
        Jump     <= 0;
        MemWr    <= 0;
        MemtoReg <= 0;
        JrWr     <= 0;
        ShamtCtr <= 0;
        JumpReg  <= 0;
    end
    else if(OprCtr==6'b100011) begin// lw
        IoprCh   <= 1;
        RegWr    <= 1;
        ExtOp    <= 1;
        ALUsrc   <= 1;
        ALUctr   <= 5'b00001;
        OverflowCheck <= 0;
        Branch   <= 0;
        Jump     <= 0;
        MemWr    <= 0;
        MemtoReg <= 1;
        JrWr     <= 0;
        ShamtCtr <= 0;
        JumpReg  <= 0;
        ByteWidth <= 2'b11;
        DmSignExt <= 0;
    end
    else if(OprCtr==6'b101011) begin// sw
        IoprCh   <= 1;
        RegWr    <= 0;
        ExtOp    <= 1;
        ALUsrc   <= 1;
        ALUctr   <= 5'b00001;
        OverflowCheck <= 0;
        Branch   <= 0;
        Jump     <= 0;
        MemWr    <= 1;
        MemtoReg <= 0;
        JrWr     <= 0;
        ShamtCtr <= 0;
        JumpReg  <= 0;
        ByteWidth <= 2'b11;
        DmSignExt <= 0;
    end
    else if(OprCtr==6'b100000) begin// lb
        IoprCh   <= 1;
        RegWr    <= 1;
        ExtOp    <= 1;
        ALUsrc   <= 1;
        ALUctr   <= 5'b00001;
        OverflowCheck <= 0;
        Branch   <= 0;
        Jump     <= 0;
        MemWr    <= 0;
        MemtoReg <= 1;
        JrWr     <= 0;
        ShamtCtr <= 0;
        JumpReg  <= 0;
        ByteWidth <= 2'b01;
        DmSignExt <= 1;
    end
    else if(OprCtr==6'b100100) begin// lbu
        IoprCh   <= 1;
        RegWr    <= 1;
        ExtOp    <= 1;
        ALUsrc   <= 1;
        ALUctr   <= 5'b00001;
        OverflowCheck <= 0;
        Branch   <= 0;
        Jump     <= 0;
        MemWr    <= 0;
        MemtoReg <= 1;
        JrWr     <= 0;
        ShamtCtr <= 0;
        JumpReg  <= 0;
        ByteWidth <= 2'b01;
        DmSignExt <= 0;
    end
    else if(OprCtr==6'b101000) begin// sb
        IoprCh   <= 1;
        RegWr    <= 0;
        ExtOp    <= 1;
        ALUsrc   <= 1;
        ALUctr   <= 5'b00001;
        OverflowCheck <= 0;
        Branch   <= 0;
        Jump     <= 0;
        MemWr    <= 1;
        MemtoReg <= 0;
        JrWr     <= 0;
        ShamtCtr <= 0;
        JumpReg  <= 0;
        ByteWidth <= 2'b01;
        DmSignExt <= 0;
    end
    else if(OprCtr==6'b000100 ||
            OprCtr==6'b000101 ||
            OprCtr==6'b000001 ||
            OprCtr==6'b000111 ||
            OprCtr==6'b000110) begin
        IoprCh   <= 1;
        RegWr    <= 0;
        ExtOp    <= 1;
        ALUsrc   <= 0;
        case(OprCtr)
            6'b000100:ALUctr <= 5'b01100;// beq
            6'b000101:ALUctr <= 5'b01101;// bne
            6'b000001:begin
                if(BrCh==5'd1) ALUctr <= 5'b01110;// bgez
                else           ALUctr <= 5'b10001;// bltz
            end
            6'b000111:ALUctr <= 5'b01111;// bgtz
            6'b000110:ALUctr <= 5'b10000;// blez
        endcase
        OverflowCheck <= 0;
        Branch   <= 1;
        Jump     <= 0;
        MemWr    <= 0;
        MemtoReg <= 0;
        JrWr     <= 0;
        ShamtCtr <= 0;
        JumpReg  <= 0;
    end
    else if(OprCtr==6'b000010) begin// j
        IoprCh   <= 0;
        RegWr    <= 0;
        ExtOp    <= 0;
        ALUsrc   <= 0;
        ALUctr   <= 5'b00000;
        OverflowCheck <= 0;
        Branch   <= 0;
        Jump     <= 1;
        MemWr    <= 0;
        MemtoReg <= 0;
        JrWr     <= 0;
        ShamtCtr <= 0;
        JumpReg  <= 0;
    end
    else if(OprCtr==6'b000011) begin// jal
        IoprCh   <= 0;
        RegWr    <= 0;
        ExtOp    <= 0;
        ALUsrc   <= 0;
        ALUctr   <= 5'b00000;
        OverflowCheck <= 0;
        Branch   <= 0;
        Jump     <= 1;
        MemWr    <= 0;
        MemtoReg <= 0;
        JrWr     <= 1;
        ShamtCtr <= 0;
        JumpReg  <= 0;
    end
end
endmodule