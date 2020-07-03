module id_ex_decoder(idex_reg,OverflowCheck,ALUopr,ALU_Cp0_Ch);

input wire[159:0] idex_reg;
wire[5:0]         op,funct;
output wire       OverflowCheck,ALU_Cp0_Ch;
output reg[4:0]   ALUopr;

assign op=idex_reg[31:26];
assign funct=idex_reg[5:0];
assign OverflowCheck=((op==6'b000000 & (funct==6'b100000 | funct==6'b100010)) | op==6'b001000);
assign ALU_Cp0_Ch=(op==6'b000000 & (funct==6'b010010 | funct==6'b010000))|(op==6'b010000 & idex_reg[25:21]==5'b00000);

always@(*) begin
    case(op)
        6'b000000:
            case(funct)
            6'b100000: ALUopr<=5'b00001;
            6'b100001: ALUopr<=5'b00001;
            6'b100010: ALUopr<=5'b00010;
            6'b100011: ALUopr<=5'b00010;
            6'b101010: ALUopr<=5'b00111;
            6'b101011: ALUopr<=5'b01000;
            6'b100100: ALUopr<=5'b00011;
            6'b100101: ALUopr<=5'b00100;
            6'b100110: ALUopr<=5'b00101;
            6'b100111: ALUopr<=5'b00110;
            6'b000000: ALUopr<=5'b01001;
            6'b000010: ALUopr<=5'b01010;
            6'b000011: ALUopr<=5'b01011;
            6'b000100: ALUopr<=5'b01001;
            6'b000110: ALUopr<=5'b01010;
            6'b000111: ALUopr<=5'b01011;
            endcase
        6'b001000: ALUopr<=5'b00001;
        6'b001001: ALUopr<=5'b00001;
        6'b001010: ALUopr<=5'b00111;
        6'b001011: ALUopr<=5'b01000;
        6'b001100: ALUopr<=5'b00011;
        6'b001101: ALUopr<=5'b00100;
        6'b001110: ALUopr<=5'b00101;
        6'b001111: ALUopr<=5'b10010;
        6'b100011: ALUopr<=5'b00001;
        6'b101011: ALUopr<=5'b00001;
        6'b100000: ALUopr<=5'b00001;
        6'b100100: ALUopr<=5'b00001;
        6'b101000: ALUopr<=5'b00001;
        6'b000100: ALUopr<=5'b01100;
        6'b000101: ALUopr<=5'b01101;
        6'b000001: ALUopr<=(idex_reg[20:16]==5'b00001)?5'b01110:5'b10001;
        6'b000111: ALUopr<=5'b01111;
        6'b000110: ALUopr<=5'b10000;
    endcase
end

endmodule