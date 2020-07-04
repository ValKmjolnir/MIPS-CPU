module dm
(
    clk,
    addr,
    wEn,
    BusW,
    BusR,
    ByteWidth,
    DmSignExt,
    DmError
);

input wire       clk,wEn,DmSignExt;
input wire[31:0] addr,BusW;
input wire[1:0]  ByteWidth;
output reg       DmError;
output reg[31:0] BusR;
reg[31:0]        memory[0:1023];// use little-endian
integer          i;

initial begin
    for(i=0;i<1024;i=i+1) memory[i]<=0;
    BusR    <= 0;
    DmError <= 0;
end

always@(*) begin
    if(ByteWidth==2'b11) begin// 4 bytes
        DmError <= (addr[1:0]>2'd0);
        BusR <= memory[addr>>2];
    end
    else if(ByteWidth==2'b10) begin// 2 bytes
        DmError <= (addr[0]!=0);
        case (addr[0])
            0:BusR <= {DmSignExt?(memory[addr>>2][15]? 16'hffff:16'h0000):16'h0000,memory[addr>>2][15:0] };
            1:BusR <= {DmSignExt?(memory[addr>>2][31]? 16'hffff:16'h0000):16'h0000,memory[addr>>2][31:16]};
        endcase
    end
    else if(ByteWidth==2'b01) begin// 1 byte
        case (addr[1:0])
            2'b00:BusR <= {DmSignExt?(memory[addr>>2][7 ]? 24'hffffff:24'h000000):24'h000000,memory[addr>>2][7:0]  };
            2'b01:BusR <= {DmSignExt?(memory[addr>>2][15]? 24'hffffff:24'h000000):24'h000000,memory[addr>>2][15:8] };
            2'b10:BusR <= {DmSignExt?(memory[addr>>2][23]? 24'hffffff:24'h000000):24'h000000,memory[addr>>2][23:16]};
            2'b11:BusR <= {DmSignExt?(memory[addr>>2][31]? 24'hffffff:24'h000000):24'h000000,memory[addr>>2][31:24]};
        endcase
    end
end

always@(posedge clk) begin
    if(wEn) begin
        if(ByteWidth==2'b11) begin// 4 bytes
            DmError <= (addr[1:0]>2'd0);
            memory[addr>>2] <= BusW;
        end
        else if(ByteWidth==2'b10) begin// 2 bytes
            DmError <= (addr[0]!=0);
            case (addr[0])
                0:memory[addr>>2][15:0]  <= BusW[15:0];
                1:memory[addr>>2][31:16] <= BusW[15:0];
            endcase
        end
        else if(ByteWidth==2'b01) begin// 1 byte
            case (addr[1:0])
                2'b00:memory[addr>>2][7:0]   <= BusW[7:0];
                2'b01:memory[addr>>2][15:8]  <= BusW[7:0];
                2'b10:memory[addr>>2][23:16] <= BusW[7:0];
                2'b11:memory[addr>>2][31:24] <= BusW[7:0];
            endcase
        end
    end
end
endmodule