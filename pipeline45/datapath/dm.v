module dm
(
    clk,
    addr,
    wEn,
    BusW,
    BusR,
    ByteWidth,
    DmSignExt
);

input wire       clk,wEn,DmSignExt;
input wire[31:0] addr,BusW;
input wire[1:0]  ByteWidth;
output reg[31:0] BusR;
reg[31:0]        memory[0:1023];// use little-endian
integer          i;

initial begin
    for(i=0;i<1024;i=i+1) memory[i]<=0;
    BusR <= 0;
end

always@(*) begin
    if(ByteWidth==2'b11) begin// 4 bytes
        BusR <= memory[addr>>2];
    end
    else if(ByteWidth==2'b01) begin// 1 byte
        case (addr[1:0])
            2'b00:BusR <= {DmSignExt?(memory[addr>>2][7 ]? 24'hffffff:24'h000000):24'h000000,memory[addr>>2][7:0]  };
            2'b01:BusR <= {DmSignExt?(memory[addr>>2][15]? 24'hffffff:24'h000000):24'h000000,memory[addr>>2][15:8] };
            2'b10:BusR <= {DmSignExt?(memory[addr>>2][23]? 24'hffffff:24'h000000):24'h000000,memory[addr>>2][23:16]};
            2'b11:BusR <= {DmSignExt?(memory[addr>>2][31]? 24'hffffff:24'h000000):24'h000000,memory[addr>>2][31:24]};
        endcase
    end
    else
        BusR <= 32'd0;
end

always@(posedge clk) begin
    if(wEn) begin
        if(ByteWidth==2'b11) begin// 4 bytes
            memory[addr>>2] <= BusW;
        end
        else if(ByteWidth==2'b01) begin// 1 byte
            case (addr[1:0])
                2'b00:memory[addr>>2][7:0]   <= BusW[7:0];
                2'b01:memory[addr>>2][15:8]  <= BusW[7:0];
                2'b10:memory[addr>>2][23:16] <= BusW[7:0];
                2'b11:memory[addr>>2][31:24] <= BusW[7:0];
            endcase
        end
        else
            memory[addr>>2] <= 32'd0;
    end
end
endmodule