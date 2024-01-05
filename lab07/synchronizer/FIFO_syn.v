module FIFO_syn #(parameter WIDTH=32, parameter WORDS=64) (
    wclk,
    rclk,
    rst_n,
    winc,
    wdata,
    wfull,
    rinc,
    rdata,
    rempty,

    clk2_fifo_flag1,
    clk2_fifo_flag2,
    clk2_fifo_flag3,
    clk2_fifo_flag4,

    fifo_clk3_flag1,
    fifo_clk3_flag2,
    fifo_clk3_flag3,
    fifo_clk3_flag4
);

input wclk, rclk;
input rst_n;
input winc;
input [WIDTH-1:0] wdata;
output reg wfull;
input rinc;
output reg [WIDTH-1:0] rdata;
output reg rempty;

// You can change the input / output of the custom flag ports
input clk2_fifo_flag1;
input clk2_fifo_flag2;
output clk2_fifo_flag3;
output clk2_fifo_flag4;

input fifo_clk3_flag1;
input fifo_clk3_flag2;
output fifo_clk3_flag3;
output fifo_clk3_flag4;

wire [WIDTH-1:0] rdata_q;
// Remember: 
//   wptr and rptr should be gray coded
//   Don't modify the signal name
reg [$clog2(WORDS):0] wptr;
reg [$clog2(WORDS):0] rptr;
reg [6:0] waddr, waddr_dff;
reg [6:0] raddr, raddr_dff;
reg [6:0] wq2_rptr, rq2_wptr;
reg write_enable;
reg read_enable;
reg wfull_comb;
integer i, j;
reg [6:0] wptr_binary;
// rdata
//  Add one more register stage to rdata
always @(posedge rclk) begin
    if (rinc)
        rdata <= rdata_q;
end

DUAL_64X32X1BM1 u_dual_sram (
    .CKA(wclk),
    .CKB(rclk),
    .WEAN(~write_enable),
    .WEBN(1'b1),
    .CSA(1'b1),
    .CSB(1'b1),
    .OEA(1'b1),
    .OEB(1'b1),
    .A0(waddr_dff[0]),
    .A1(waddr_dff[1]),
    .A2(waddr_dff[2]),
    .A3(waddr_dff[3]),
    .A4(waddr_dff[4]),
    .A5(waddr_dff[5]),
    .B0(raddr_dff[0]),
    .B1(raddr_dff[1]),
    .B2(raddr_dff[2]),
    .B3(raddr_dff[3]),
    .B4(raddr_dff[4]),
    .B5(raddr_dff[5]),
    .DIA0(wdata[0]),
    .DIA1(wdata[1]),
    .DIA2(wdata[2]),
    .DIA3(wdata[3]),
    .DIA4(wdata[4]),
    .DIA5(wdata[5]),
    .DIA6(wdata[6]),
    .DIA7(wdata[7]),
    .DIA8(wdata[8]),
    .DIA9(wdata[9]),
    .DIA10(wdata[10]),
    .DIA11(wdata[11]),
    .DIA12(wdata[12]),
    .DIA13(wdata[13]),
    .DIA14(wdata[14]),
    .DIA15(wdata[15]),
    .DIA16(wdata[16]),
    .DIA17(wdata[17]),
    .DIA18(wdata[18]),
    .DIA19(wdata[19]),
    .DIA20(wdata[20]),
    .DIA21(wdata[21]),
    .DIA22(wdata[22]),
    .DIA23(wdata[23]),
    .DIA24(wdata[24]),
    .DIA25(wdata[25]),
    .DIA26(wdata[26]),
    .DIA27(wdata[27]),
    .DIA28(wdata[28]),
    .DIA29(wdata[29]),
    .DIA30(wdata[30]),
    .DIA31(wdata[31]),
    .DOB0(rdata_q[0]),
    .DOB1(rdata_q[1]),
    .DOB2(rdata_q[2]),
    .DOB3(rdata_q[3]),
    .DOB4(rdata_q[4]),
    .DOB5(rdata_q[5]),
    .DOB6(rdata_q[6]),
    .DOB7(rdata_q[7]),
    .DOB8(rdata_q[8]),
    .DOB9(rdata_q[9]),
    .DOB10(rdata_q[10]),
    .DOB11(rdata_q[11]),
    .DOB12(rdata_q[12]),
    .DOB13(rdata_q[13]),
    .DOB14(rdata_q[14]),
    .DOB15(rdata_q[15]),
    .DOB16(rdata_q[16]),
    .DOB17(rdata_q[17]),
    .DOB18(rdata_q[18]),
    .DOB19(rdata_q[19]),
    .DOB20(rdata_q[20]),
    .DOB21(rdata_q[21]),
    .DOB22(rdata_q[22]),
    .DOB23(rdata_q[23]),
    .DOB24(rdata_q[24]),
    .DOB25(rdata_q[25]),
    .DOB26(rdata_q[26]),
    .DOB27(rdata_q[27]),
    .DOB28(rdata_q[28]),
    .DOB29(rdata_q[29]),
    .DOB30(rdata_q[30]),
    .DOB31(rdata_q[31])
);

NDFF_BUS_syn #(.WIDTH(7))N1(.D(wptr), .Q(rq2_wptr), .clk(rclk), .rst_n(rst_n));
NDFF_BUS_syn #(.WIDTH(7))N2(.D(rptr), .Q(wq2_rptr), .clk(wclk), .rst_n(rst_n));
//=================================================================================================//
//                                      FIFO  wptr & Full                                          //
//=================================================================================================//
always @(posedge wclk or negedge rst_n) begin
    if(!rst_n)begin
        wptr <= 0;
        waddr_dff <= 0;
    end
    else begin
        waddr_dff <= waddr;
        for(i = 0; i < 6; i = i + 1)begin
            wptr[i] <= waddr_dff[i] ^ waddr_dff[i + 1];
        end
        wptr[6] <= waddr_dff[6];
    end
end
assign write_enable = (winc & (~wfull_comb));
always @(*) begin
    if(write_enable)begin
        waddr = waddr_dff + 1;
    end
    else begin
        waddr = waddr_dff;
    end
end
reg [6:0] rptr_binary;
reg [6:0] gray_code;
assign gray_code  = (waddr_dff>>1) ^ waddr_dff;
always @(*) begin
    rptr_binary[6] = wq2_rptr[6];
    for(i = 5; i >= 0; i = i - 1)begin
        rptr_binary[i] = wq2_rptr[i] ^ rptr_binary[i + 1];
    end
end

//assign wfull_comb = (wq2_rptr== {~gray_code[6:5], gray_code[4:0]});
assign wfull_comb = (waddr_dff[5:0] == (rptr_binary[5:0] )) && (waddr_dff[6] != rptr_binary[6]);
always @(posedge wclk or negedge rst_n) begin
    //if(rptr_binary[5:0] == waddr_dff[5:0] && (rptr_binary[6] != waddr_dff[6]))begin
	if(!rst_n)begin
		wfull <= 0;
	end
	else begin
		wfull <= wfull_comb;
	end
end  
/* always@(*)begin
	if(wq2_rptr == {~gray_code[6:5] , gray_code[4:0]})begin
		wfull = 1;
	end
	else begin
		wfull = 0;
	end
end */
//=================================================================================================//
//                                      FIFO rptr & empty                                          //
//=================================================================================================//
always @(posedge rclk or negedge rst_n) begin
    if(!rst_n)begin
        rptr <= 0;
        raddr_dff <= 0;
    end
    else begin
        raddr_dff <= raddr;
        for(i = 0; i < 6; i = i + 1)begin
            rptr[i] <= raddr_dff[i] ^ raddr_dff[i + 1];
        end
        rptr[6] <= raddr_dff[6];
    end
end

always @(*) begin
    if(wptr_binary[5:0] == raddr_dff[5:0] && (wptr_binary[6] == raddr_dff[6]))begin
        raddr = raddr_dff;
    end
    else begin
        raddr = raddr_dff + 1;
    end
end

always @(*) begin
    wptr_binary[6] = rq2_wptr[6];
    for(i = 5; i >= 0; i = i - 1)begin
        wptr_binary[i] = rq2_wptr[i] ^ wptr_binary[i + 1];
    end
end
always @(posedge rclk or negedge rst_n) begin
    if(!rst_n)begin
		rempty <= 1;
	end
	else begin
		if(wptr_binary[5:0] == raddr_dff[5:0] && (wptr_binary[6] == raddr_dff[6]))begin//here
			rempty <= 1;
		end
		else begin
			rempty <= 0;
		end
	end
end
endmodule
