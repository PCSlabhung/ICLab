//############################################################################
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//   (C) Copyright Si2 LAB @NYCU ED430
//   All Right Reserved
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
//   ICLAB 2023 Fall
//   Midterm Proejct            : MRA  
//   Author                     : Lin-Hung, Lai
//
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
//   File Name   : MRA.v
//   Module Name : MRA
//   Release version : V2.0 (Release Date: 2023-10)
//
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//############################################################################

module MRA(
	// CHIP IO
	clk            	,	
	rst_n          	,	
	in_valid       	,	
	frame_id        ,	
	net_id         	,	  
	loc_x          	,	  
    loc_y         	,
	cost	 		,		
	busy         	,

    // AXI4 IO
	     arid_m_inf,
	   araddr_m_inf,
	    arlen_m_inf,
	   arsize_m_inf,
	  arburst_m_inf,
	  arvalid_m_inf,
	  arready_m_inf,
	
	      rid_m_inf,
	    rdata_m_inf,
	    rresp_m_inf,
	    rlast_m_inf,
	   rvalid_m_inf,
	   rready_m_inf,
	
	     awid_m_inf,
	   awaddr_m_inf,
	   awsize_m_inf,
	  awburst_m_inf,
	    awlen_m_inf,
	  awvalid_m_inf,
	  awready_m_inf,
	
	    wdata_m_inf,
	    wlast_m_inf,
	   wvalid_m_inf,
	   wready_m_inf,
	
	      bid_m_inf,
	    bresp_m_inf,
	   bvalid_m_inf,
	   bready_m_inf 
);

// ===============================================================
//  					Input / Output 
// ===============================================================

// << CHIP io port with system >>
input 			  	clk,rst_n;
input 			   	in_valid;
input  [4:0] 		frame_id;
input  [3:0]       	net_id;     
input  [5:0]       	loc_x; 
input  [5:0]       	loc_y; 
output reg [13:0] 	cost;
output reg          busy;       
parameter ID_WIDTH = 4;
parameter DATA_WIDTH = 128;
parameter ADDR_WIDTH = 32; 
//====================================================================//
//                    FSM  parameter                                  //
//====================================================================//
parameter IDLE = 0;
parameter INPUT_DRAM_ADDR = 1;
parameter DRAM_IN_WEIGHT = 2;
parameter DRAM_IN_MAP = 3;
parameter INIT = 4;
parameter FILL = 5;
parameter RETRACE_SRAM_R = 6;
parameter RETRACE_SRAM_W = 7;
parameter CLEAR_MAP = 8;
parameter DRAM_OUT_ADDR = 9;
parameter DRAM_OUT = 10;
parameter OUT = 11;

// AXI Interface wire connecttion for pseudo DRAM read/write
/* Hint:
       Your AXI-4 interface could be designed as a bridge in submodule,
	   therefore I declared output of AXI as wire.  
	   Ex: AXI4_interface AXI4_INF(...);
*/

// ------------------------
// <<<<< AXI READ >>>>>
// ------------------------
// (1)	axi read address channel 
output wire [ID_WIDTH-1:0]      arid_m_inf;
output wire [1:0]            arburst_m_inf;
output wire [2:0]             arsize_m_inf;
output wire [7:0]              arlen_m_inf;
output reg                  arvalid_m_inf;
input  wire                  arready_m_inf;
output reg [ADDR_WIDTH-1:0]  araddr_m_inf;
// ------------------------
// (2)	axi read data channel 
input  wire [ID_WIDTH-1:0]       rid_m_inf;
input  wire                   rvalid_m_inf;
output reg                   rready_m_inf;
input  wire [DATA_WIDTH-1:0]   rdata_m_inf;
input  wire                    rlast_m_inf;
input  wire [1:0]              rresp_m_inf;
// ------------------------
// <<<<< AXI WRITE >>>>>
// ------------------------
// (1) 	axi write address channel 
output wire [ID_WIDTH-1:0]      awid_m_inf;
output wire [1:0]            awburst_m_inf;
output wire [2:0]             awsize_m_inf;
output wire [7:0]              awlen_m_inf;
output reg                  awvalid_m_inf;
input  wire                  awready_m_inf;
output reg [ADDR_WIDTH-1:0]  awaddr_m_inf;
// -------------------------
// (2)	axi write data channel 
output reg                   wvalid_m_inf;
input  wire                   wready_m_inf;
output reg [DATA_WIDTH-1:0]   wdata_m_inf;
output reg                    wlast_m_inf;
// -------------------------
// (3)	axi write response channel 
input  wire  [ID_WIDTH-1:0]      bid_m_inf;
input  wire                   bvalid_m_inf;
output reg                   bready_m_inf;
input  wire  [1:0]             bresp_m_inf;
// -----------------------------
//==========================================================//
//                      AXI interface                       //
//==========================================================//
assign arid_m_inf = 4'd0;
assign arburst_m_inf = 2'd1;
assign arsize_m_inf = 3'b100;
assign arlen_m_inf = 8'd127;

assign awid_m_inf = 4'd0;
assign awburst_m_inf = 2'd1;
assign awsize_m_inf = 3'b100;
assign awlen_m_inf = 8'd127;

integer i,j,k,h;

//===========================================================//
//               input  variable                             //
//===========================================================//
reg [4:0] frame_id_dff, frame_id_comb;
reg [3:0] net_id_dff  [0:14];
reg [3:0] net_id_comb [0:14];

reg [5:0] source_x_dff [0:14];
reg [5:0] source_y_dff [0:14];
reg [5:0] source_x_comb[0:14];
reg [5:0] source_y_comb[0:14];
reg [5:0] sink_x_dff   [0:14];
reg [5:0] sink_x_comb  [0:14];
reg [5:0] sink_y_dff   [0:14];
reg [5:0] sink_y_comb  [0:14];
reg [3:0] net_count_dff, net_count_comb; 

//===========================================================//
//                   FSM  variable                           //
//===========================================================//
reg [3:0] cur_state, nxt_state, cur_state_delay;
reg [6:0] counter_dff, counter_comb;
reg [4:0] big_counter;
reg weight_ready_dff, weight_ready;
//===========================================================//
//                   Filling map                             //
//===========================================================//
reg [6:0] counter_128;
reg [3:0] counter_15;
reg [1:0] Fill_map_dff [0:63][0:63];
reg [1:0] Fill_map_comb[0:63][0:63];
reg [5:0] cur_x_comb, cur_x_dff, cur_y_comb, cur_y_dff;
reg [5:0] nxt_x_comb, nxt_x_dff, nxt_y_comb, nxt_y_dff;
reg [1:0] counter_4;
reg cur_flag;
//===========================================================//
//                    Retrace map                            //
//===========================================================//
reg [3:0] weight_map_out_dff;
reg [13:0] cost_dff;
reg [6:0] weight_map_addr_dff, location_map_addr1_dff;
reg [5:0] target_x, target_y, source_x, source_y, target_x_comb, target_y_comb, source_x_nreg, source_y_nreg;
reg [3:0] target_dff, target_comb;
//===========================================================//
//                    memory variable                        //
//===========================================================//
reg [6:0] location_map_addr1, location_map_addr2;
reg [127:0] location_map_out, location_map_in;
reg location_map_WEB;
reg [6:0] weight_map_addr;
reg [127:0] weight_map_out, weight_map_in;
reg weight_map_WEB;
//===========================================================//
//                     memory                                //
//===========================================================//
location_map location_map1(.A0(location_map_addr1[0]),.A1(location_map_addr1[1]),.A2(location_map_addr1[2]),.A3(location_map_addr1[3]),.A4(location_map_addr1[4]),.A5(location_map_addr1[5]),.A6(location_map_addr1[6]),
					 .DO0(location_map_out[0]),.DO1(location_map_out[1]),.DO2(location_map_out[2]),.DO3(location_map_out[3]),.DO4(location_map_out[4]),.DO5(location_map_out[5]),.DO6(location_map_out[6]),
					 .DO7(location_map_out[7]),.DO8(location_map_out[8]),.DO9(location_map_out[9]),
                     .DO10(location_map_out[10]),.DO11(location_map_out[11]),.DO12(location_map_out[12]),.DO13(location_map_out[13]),.DO14(location_map_out[14]),.DO15(location_map_out[15]),.DO16(location_map_out[16]),
                     .DO17(location_map_out[17]),.DO18(location_map_out[18]),.DO19(location_map_out[19]),.DO20(location_map_out[20]),.DO21(location_map_out[21]),.DO22(location_map_out[22]),.DO23(location_map_out[23]),
                     .DO24(location_map_out[24]),.DO25(location_map_out[25]),.DO26(location_map_out[26]),.DO27(location_map_out[27]),.DO28(location_map_out[28]),.DO29(location_map_out[29]),.DO30(location_map_out[30]),
                     .DO31(location_map_out[31]),.DO32(location_map_out[32]),.DO33(location_map_out[33]),.DO34(location_map_out[34]),.DO35(location_map_out[35]),.DO36(location_map_out[36]),.DO37(location_map_out[37]),
                     .DO38(location_map_out[38]),.DO39(location_map_out[39]),.DO40(location_map_out[40]),.DO41(location_map_out[41]),.DO42(location_map_out[42]),.DO43(location_map_out[43]),.DO44(location_map_out[44]),
                     .DO45(location_map_out[45]),.DO46(location_map_out[46]),.DO47(location_map_out[47]),.DO48(location_map_out[48]),.DO49(location_map_out[49]),.DO50(location_map_out[50]),.DO51(location_map_out[51]),
                     .DO52(location_map_out[52]),.DO53(location_map_out[53]),.DO54(location_map_out[54]),.DO55(location_map_out[55]),.DO56(location_map_out[56]),.DO57(location_map_out[57]),.DO58(location_map_out[58]),
                     .DO59(location_map_out[59]),.DO60(location_map_out[60]),.DO61(location_map_out[61]),.DO62(location_map_out[62]),.DO63(location_map_out[63]),.DO64(location_map_out[64]),.DO65(location_map_out[65]),
                     .DO66(location_map_out[66]),.DO67(location_map_out[67]),.DO68(location_map_out[68]),.DO69(location_map_out[69]),.DO70(location_map_out[70]),.DO71(location_map_out[71]),.DO72(location_map_out[72]),
                     .DO73(location_map_out[73]),.DO74(location_map_out[74]),.DO75(location_map_out[75]),.DO76(location_map_out[76]),.DO77(location_map_out[77]),.DO78(location_map_out[78]),.DO79(location_map_out[79]),
                     .DO80(location_map_out[80]),.DO81(location_map_out[81]),.DO82(location_map_out[82]),.DO83(location_map_out[83]),.DO84(location_map_out[84]),.DO85(location_map_out[85]),.DO86(location_map_out[86]),
                     .DO87(location_map_out[87]),.DO88(location_map_out[88]),.DO89(location_map_out[89]),.DO90(location_map_out[90]),.DO91(location_map_out[91]),.DO92(location_map_out[92]),.DO93(location_map_out[93]),
                     .DO94(location_map_out[94]),.DO95(location_map_out[95]),.DO96(location_map_out[96]),.DO97(location_map_out[97]),.DO98(location_map_out[98]),.DO99(location_map_out[99]),.DO100(location_map_out[100]),
                     .DO101(location_map_out[101]),.DO102(location_map_out[102]),.DO103(location_map_out[103]),.DO104(location_map_out[104]),.DO105(location_map_out[105]),.DO106(location_map_out[106]),
                     .DO107(location_map_out[107]),.DO108(location_map_out[108]),.DO109(location_map_out[109]),.DO110(location_map_out[110]),.DO111(location_map_out[111]),.DO112(location_map_out[112]),
                     .DO113(location_map_out[113]),.DO114(location_map_out[114]),.DO115(location_map_out[115]),.DO116(location_map_out[116]),.DO117(location_map_out[117]),.DO118(location_map_out[118]),
                     .DO119(location_map_out[119]),.DO120(location_map_out[120]),.DO121(location_map_out[121]),.DO122(location_map_out[122]),.DO123(location_map_out[123]),.DO124(location_map_out[124]),
                     .DO125(location_map_out[125]),.DO126(location_map_out[126]),.DO127(location_map_out[127]),
					 .DI0(location_map_in[0]),.DI1(location_map_in[1]),.DI2(location_map_in[2]),.DI3(location_map_in[3]),.DI4(location_map_in[4]),.DI5(location_map_in[5]),
                     .DI6(location_map_in[6]),.DI7(location_map_in[7]),.DI8(location_map_in[8]),.DI9(location_map_in[9]),.DI10(location_map_in[10]),.DI11(location_map_in[11]),.DI12(location_map_in[12]),.DI13(location_map_in[13]),
                     .DI14(location_map_in[14]),.DI15(location_map_in[15]),.DI16(location_map_in[16]),.DI17(location_map_in[17]),.DI18(location_map_in[18]),.DI19(location_map_in[19]),.DI20(location_map_in[20]),
                     .DI21(location_map_in[21]),.DI22(location_map_in[22]),.DI23(location_map_in[23]),.DI24(location_map_in[24]),.DI25(location_map_in[25]),.DI26(location_map_in[26]),.DI27(location_map_in[27]),
                     .DI28(location_map_in[28]),.DI29(location_map_in[29]),.DI30(location_map_in[30]),.DI31(location_map_in[31]),.DI32(location_map_in[32]),.DI33(location_map_in[33]),.DI34(location_map_in[34]),
                     .DI35(location_map_in[35]),.DI36(location_map_in[36]),.DI37(location_map_in[37]),.DI38(location_map_in[38]),.DI39(location_map_in[39]),.DI40(location_map_in[40]),.DI41(location_map_in[41]),
                     .DI42(location_map_in[42]),.DI43(location_map_in[43]),.DI44(location_map_in[44]),.DI45(location_map_in[45]),.DI46(location_map_in[46]),.DI47(location_map_in[47]),.DI48(location_map_in[48]),
                     .DI49(location_map_in[49]),.DI50(location_map_in[50]),.DI51(location_map_in[51]),.DI52(location_map_in[52]),.DI53(location_map_in[53]),.DI54(location_map_in[54]),.DI55(location_map_in[55]),
                     .DI56(location_map_in[56]),.DI57(location_map_in[57]),.DI58(location_map_in[58]),.DI59(location_map_in[59]),.DI60(location_map_in[60]),.DI61(location_map_in[61]),.DI62(location_map_in[62]),
                     .DI63(location_map_in[63]),.DI64(location_map_in[64]),.DI65(location_map_in[65]),.DI66(location_map_in[66]),.DI67(location_map_in[67]),.DI68(location_map_in[68]),.DI69(location_map_in[69]),
                     .DI70(location_map_in[70]),.DI71(location_map_in[71]),.DI72(location_map_in[72]),.DI73(location_map_in[73]),.DI74(location_map_in[74]),.DI75(location_map_in[75]),.DI76(location_map_in[76]),
                     .DI77(location_map_in[77]),.DI78(location_map_in[78]),.DI79(location_map_in[79]),.DI80(location_map_in[80]),.DI81(location_map_in[81]),.DI82(location_map_in[82]),.DI83(location_map_in[83]),
                     .DI84(location_map_in[84]),.DI85(location_map_in[85]),.DI86(location_map_in[86]),.DI87(location_map_in[87]),.DI88(location_map_in[88]),.DI89(location_map_in[89]),.DI90(location_map_in[90]),
                     .DI91(location_map_in[91]),.DI92(location_map_in[92]),.DI93(location_map_in[93]),.DI94(location_map_in[94]),.DI95(location_map_in[95]),.DI96(location_map_in[96]),.DI97(location_map_in[97]),
                     .DI98(location_map_in[98]),.DI99(location_map_in[99]),.DI100(location_map_in[100]),.DI101(location_map_in[101]),.DI102(location_map_in[102]),.DI103(location_map_in[103]),
                     .DI104(location_map_in[104]),.DI105(location_map_in[105]),.DI106(location_map_in[106]),.DI107(location_map_in[107]),.DI108(location_map_in[108]),.DI109(location_map_in[109]),
                     .DI110(location_map_in[110]),.DI111(location_map_in[111]),.DI112(location_map_in[112]),.DI113(location_map_in[113]),.DI114(location_map_in[114]),.DI115(location_map_in[115]),
                     .DI116(location_map_in[116]),.DI117(location_map_in[117]),.DI118(location_map_in[118]),.DI119(location_map_in[119]),.DI120(location_map_in[120]),.DI121(location_map_in[121]),
                     .DI122(location_map_in[122]),.DI123(location_map_in[123]),.DI124(location_map_in[124]),.DI125(location_map_in[125]),.DI126(location_map_in[126]),.DI127(location_map_in[127]),
                     .WEB(location_map_WEB),.CK(clk),.CS(1'b1),.OE(1'b1));

weight_map weight_map2(.A0(weight_map_addr[0]),.A1(weight_map_addr[1]),.A2(weight_map_addr[2]),.A3(weight_map_addr[3]),.A4(weight_map_addr[4]),.A5(weight_map_addr[5]),.A6(weight_map_addr[6]),
				   .DO0(weight_map_out[0]),.DO1(weight_map_out[1]),.DO2(weight_map_out[2]),.DO3(weight_map_out[3]),.DO4(weight_map_out[4]),.DO5(weight_map_out[5]),.DO6(weight_map_out[6]),
                   .DO7(weight_map_out[7]),.DO8(weight_map_out[8]),.DO9(weight_map_out[9]),.DO10(weight_map_out[10]),.DO11(weight_map_out[11]),.DO12(weight_map_out[12]),.DO13(weight_map_out[13]),.DO14(weight_map_out[14]),.DO15(weight_map_out[15]),
                   .DO16(weight_map_out[16]),.DO17(weight_map_out[17]),.DO18(weight_map_out[18]),.DO19(weight_map_out[19]),.DO20(weight_map_out[20]),.DO21(weight_map_out[21]),.DO22(weight_map_out[22]),.DO23(weight_map_out[23]),
                   .DO24(weight_map_out[24]),.DO25(weight_map_out[25]),.DO26(weight_map_out[26]),.DO27(weight_map_out[27]),.DO28(weight_map_out[28]),.DO29(weight_map_out[29]),.DO30(weight_map_out[30]),.DO31(weight_map_out[31]),
                   .DO32(weight_map_out[32]),.DO33(weight_map_out[33]),.DO34(weight_map_out[34]),.DO35(weight_map_out[35]),.DO36(weight_map_out[36]),.DO37(weight_map_out[37]),.DO38(weight_map_out[38]),.DO39(weight_map_out[39]),
                   .DO40(weight_map_out[40]),.DO41(weight_map_out[41]),.DO42(weight_map_out[42]),.DO43(weight_map_out[43]),.DO44(weight_map_out[44]),.DO45(weight_map_out[45]),.DO46(weight_map_out[46]),.DO47(weight_map_out[47]),
                   .DO48(weight_map_out[48]),.DO49(weight_map_out[49]),.DO50(weight_map_out[50]),.DO51(weight_map_out[51]),.DO52(weight_map_out[52]),.DO53(weight_map_out[53]),.DO54(weight_map_out[54]),.DO55(weight_map_out[55]),
                   .DO56(weight_map_out[56]),.DO57(weight_map_out[57]),.DO58(weight_map_out[58]),.DO59(weight_map_out[59]),.DO60(weight_map_out[60]),.DO61(weight_map_out[61]),.DO62(weight_map_out[62]),.DO63(weight_map_out[63]),
                   .DO64(weight_map_out[64]),.DO65(weight_map_out[65]),.DO66(weight_map_out[66]),.DO67(weight_map_out[67]),.DO68(weight_map_out[68]),.DO69(weight_map_out[69]),.DO70(weight_map_out[70]),.DO71(weight_map_out[71]),
                   .DO72(weight_map_out[72]),.DO73(weight_map_out[73]),.DO74(weight_map_out[74]),.DO75(weight_map_out[75]),.DO76(weight_map_out[76]),.DO77(weight_map_out[77]),.DO78(weight_map_out[78]),.DO79(weight_map_out[79]),
                   .DO80(weight_map_out[80]),.DO81(weight_map_out[81]),.DO82(weight_map_out[82]),.DO83(weight_map_out[83]),.DO84(weight_map_out[84]),.DO85(weight_map_out[85]),.DO86(weight_map_out[86]),.DO87(weight_map_out[87]),
                   .DO88(weight_map_out[88]),.DO89(weight_map_out[89]),.DO90(weight_map_out[90]),.DO91(weight_map_out[91]),.DO92(weight_map_out[92]),.DO93(weight_map_out[93]),.DO94(weight_map_out[94]),.DO95(weight_map_out[95]),
                   .DO96(weight_map_out[96]),.DO97(weight_map_out[97]),.DO98(weight_map_out[98]),.DO99(weight_map_out[99]),.DO100(weight_map_out[100]),.DO101(weight_map_out[101]),.DO102(weight_map_out[102]),.DO103(weight_map_out[103]),
                   .DO104(weight_map_out[104]),.DO105(weight_map_out[105]),.DO106(weight_map_out[106]),.DO107(weight_map_out[107]),.DO108(weight_map_out[108]),.DO109(weight_map_out[109]),.DO110(weight_map_out[110]),
                   .DO111(weight_map_out[111]),.DO112(weight_map_out[112]),.DO113(weight_map_out[113]),.DO114(weight_map_out[114]),.DO115(weight_map_out[115]),.DO116(weight_map_out[116]),.DO117(weight_map_out[117]),
                   .DO118(weight_map_out[118]),.DO119(weight_map_out[119]),.DO120(weight_map_out[120]),.DO121(weight_map_out[121]),.DO122(weight_map_out[122]),.DO123(weight_map_out[123]),.DO124(weight_map_out[124]),
                   .DO125(weight_map_out[125]),.DO126(weight_map_out[126]),.DO127(weight_map_out[127]),
				   .DI0(weight_map_in[0]),.DI1(weight_map_in[1]),.DI2(weight_map_in[2]),.DI3(weight_map_in[3]),.DI4(weight_map_in[4]),
                   .DI5(weight_map_in[5]),.DI6(weight_map_in[6]),.DI7(weight_map_in[7]),.DI8(weight_map_in[8]),.DI9(weight_map_in[9]),.DI10(weight_map_in[10]),.DI11(weight_map_in[11]),.DI12(weight_map_in[12]),.DI13(weight_map_in[13]),.DI14(weight_map_in[14]),
                   .DI15(weight_map_in[15]),.DI16(weight_map_in[16]),.DI17(weight_map_in[17]),.DI18(weight_map_in[18]),.DI19(weight_map_in[19]),.DI20(weight_map_in[20]),.DI21(weight_map_in[21]),.DI22(weight_map_in[22]),
                   .DI23(weight_map_in[23]),.DI24(weight_map_in[24]),.DI25(weight_map_in[25]),.DI26(weight_map_in[26]),.DI27(weight_map_in[27]),.DI28(weight_map_in[28]),.DI29(weight_map_in[29]),.DI30(weight_map_in[30]),
                   .DI31(weight_map_in[31]),.DI32(weight_map_in[32]),.DI33(weight_map_in[33]),.DI34(weight_map_in[34]),.DI35(weight_map_in[35]),.DI36(weight_map_in[36]),.DI37(weight_map_in[37]),.DI38(weight_map_in[38]),
                   .DI39(weight_map_in[39]),.DI40(weight_map_in[40]),.DI41(weight_map_in[41]),.DI42(weight_map_in[42]),.DI43(weight_map_in[43]),.DI44(weight_map_in[44]),.DI45(weight_map_in[45]),.DI46(weight_map_in[46]),
                   .DI47(weight_map_in[47]),.DI48(weight_map_in[48]),.DI49(weight_map_in[49]),.DI50(weight_map_in[50]),.DI51(weight_map_in[51]),.DI52(weight_map_in[52]),.DI53(weight_map_in[53]),.DI54(weight_map_in[54]),
                   .DI55(weight_map_in[55]),.DI56(weight_map_in[56]),.DI57(weight_map_in[57]),.DI58(weight_map_in[58]),.DI59(weight_map_in[59]),.DI60(weight_map_in[60]),.DI61(weight_map_in[61]),.DI62(weight_map_in[62]),
                   .DI63(weight_map_in[63]),.DI64(weight_map_in[64]),.DI65(weight_map_in[65]),.DI66(weight_map_in[66]),.DI67(weight_map_in[67]),.DI68(weight_map_in[68]),.DI69(weight_map_in[69]),.DI70(weight_map_in[70]),
                   .DI71(weight_map_in[71]),.DI72(weight_map_in[72]),.DI73(weight_map_in[73]),.DI74(weight_map_in[74]),.DI75(weight_map_in[75]),.DI76(weight_map_in[76]),.DI77(weight_map_in[77]),.DI78(weight_map_in[78]),
                   .DI79(weight_map_in[79]),.DI80(weight_map_in[80]),.DI81(weight_map_in[81]),.DI82(weight_map_in[82]),.DI83(weight_map_in[83]),.DI84(weight_map_in[84]),.DI85(weight_map_in[85]),.DI86(weight_map_in[86]),
                   .DI87(weight_map_in[87]),.DI88(weight_map_in[88]),.DI89(weight_map_in[89]),.DI90(weight_map_in[90]),.DI91(weight_map_in[91]),.DI92(weight_map_in[92]),.DI93(weight_map_in[93]),.DI94(weight_map_in[94]),
                   .DI95(weight_map_in[95]),.DI96(weight_map_in[96]),.DI97(weight_map_in[97]),.DI98(weight_map_in[98]),.DI99(weight_map_in[99]),.DI100(weight_map_in[100]),.DI101(weight_map_in[101]),.DI102(weight_map_in[102]),
                   .DI103(weight_map_in[103]),.DI104(weight_map_in[104]),.DI105(weight_map_in[105]),.DI106(weight_map_in[106]),.DI107(weight_map_in[107]),.DI108(weight_map_in[108]),.DI109(weight_map_in[109]),
                   .DI110(weight_map_in[110]),.DI111(weight_map_in[111]),.DI112(weight_map_in[112]),.DI113(weight_map_in[113]),.DI114(weight_map_in[114]),.DI115(weight_map_in[115]),.DI116(weight_map_in[116]),
                   .DI117(weight_map_in[117]),.DI118(weight_map_in[118]),.DI119(weight_map_in[119]),.DI120(weight_map_in[120]),.DI121(weight_map_in[121]),.DI122(weight_map_in[122]),.DI123(weight_map_in[123]),
                   .DI124(weight_map_in[124]),.DI125(weight_map_in[125]),.DI126(weight_map_in[126]),.DI127(weight_map_in[127]),.CK(clk),.WEB(weight_map_WEB),.OE(1'b1), .CS(1'b1));

//=====================================//
//            output register          //
//=====================================//
reg [13:0] cost_comb;
reg busy_comb;
always @(posedge clk or negedge rst_n) begin
	if(!rst_n)begin
		cost <= 0;
		busy <= 0;
	end
	else begin
		cost <= cost_comb;
		busy <= busy_comb;
	end
end
always @(*) begin
	if(cur_state == IDLE)begin
		if(weight_ready_dff == 0)begin
			busy_comb = 0;
			cost_comb = 0;
		end
		else begin
			busy_comb = 1;
			cost_comb = 0;
		end
	end
	else if(cur_state == INPUT_DRAM_ADDR)begin
		// if(nxt_state == DRAM_IN_WEIGHT)begin
		// 	busy_comb = 1;
		// end
		if(in_valid)begin
			busy_comb = 0;
		end
		else begin
			busy_comb = 1;
		end
		cost_comb = 0;
		// else if(weight_ready_dff)begin
		// 	busy_comb = 1;
		// end
	end
	else if(cur_state == DRAM_IN_WEIGHT)begin
		cost_comb = 0;
		if(in_valid)begin
			busy_comb = 0;
		end
		else begin
			busy_comb = 1;
		end
	end
	else if(cur_state == OUT)begin
		if(bvalid_m_inf)begin
			busy_comb = 0;
			cost_comb = cost_dff;
		end
		else begin
			busy_comb = 1;
			cost_comb = 0;
		end
	end
	else begin
		busy_comb = 1;
		cost_comb = 0;
	end
end
always @(*) begin
	if(cur_state == DRAM_IN_WEIGHT)begin
		weight_ready = 1;
	end
	else if(cur_state == OUT)begin
		weight_ready = 0;
	end
	else begin
		weight_ready = weight_ready_dff;
	end
end
//=====================================//
//              counter                //
//=====================================//
always @(posedge clk or negedge rst_n) begin
	if(!rst_n)begin
		net_count_dff <= 0;
		big_counter <= 0;
	end
	else begin
		// if(cur_state == INPUT_DRAM_ADDR || cur_state == IDLE)begin
		// 	if(in_valid)begin
		// 		big_counter <= big_counter + 1;
		// 		net_count_dff <= net_count_dff;
		// 		if(big_counter[0] == 1)begin
		// 			net_count_dff <= net_count_dff + 1;
		// 		end
		// 	end
		// end
		if(in_valid)begin
			big_counter <= big_counter + 1;
			net_count_dff <= net_count_dff;
			if(big_counter[0] == 1)begin
				net_count_dff <= net_count_dff + 1;
			end
		end
		else if(cur_state == OUT)begin
			big_counter <= 0;
			net_count_dff <= 0;
		end
		else begin
			big_counter <= big_counter;
			net_count_dff <= net_count_dff;
		end
	end
end
//=====================================//
//          input  register            //
//=====================================//
always @(posedge clk or negedge rst_n) begin
	if(!rst_n)begin
		frame_id_dff <= 0;
		for(i = 0; i < 15; i = i + 1)begin
			net_id_dff[i] <= 0;
			source_x_dff[i] <= 0;
			source_y_dff[i] <= 0;
			sink_x_dff[i] <= 0;
			sink_y_dff[i] <= 0;
		end
		
	end
	else begin
		frame_id_dff <= frame_id_comb;
		for(i = 0; i < 15; i = i + 1)begin
			net_id_dff[i] <= net_id_comb[i];
			source_x_dff[i] <= source_x_comb[i];
			source_y_dff[i] <= source_y_comb[i];
			sink_x_dff[i] <= sink_x_comb[i];
			sink_y_dff[i] <= sink_y_comb[i];
		end
		
	end
end
//================================================//
//              Filling map register              //
//================================================//
always @(posedge clk or negedge rst_n) begin
	if(!rst_n)begin
		for(i = 0; i < 64; i = i + 1)begin
			for(j = 0; j < 64; j = j + 1)begin
				Fill_map_dff[i][j] <= 0;
			end
		end
	end
	else begin
		for(i = 0; i < 64; i = i + 1)begin
			for(j = 0 ; j < 64; j = j + 1)begin
				Fill_map_dff[i][j] <= Fill_map_comb[i][j];
			end
		end
	end
end
//================================================//
//              input logic                       //
//================================================//
// always @(*) begin
// 	if(cur_state == INPUT_DRAM_ADDR || cur_state == IDLE)begin
// 		frame_id_comb = frame_id_dff;
// 		for(i = 0; i < 15;i = i + 1)begin
// 			net_id_comb[i] = net_id_dff[i];
// 			source_x_comb[i] = source_x_dff[i];
// 			source_y_comb[i] = source_y_dff[i];
// 			sink_x_comb[i] = sink_x_dff[i];
// 			sink_y_comb[i] = sink_y_dff[i];
// 		end
		
// 		if(in_valid)begin
// 			frame_id_comb = frame_id;
// 			case(net_count_dff)
// 				0:net_id_comb[0] = net_id;
// 				1:net_id_comb[1] = net_id;
// 				2:net_id_comb[2] = net_id;
// 				3:net_id_comb[3] = net_id;
// 				4:net_id_comb[4] = net_id;
// 				5:net_id_comb[5] = net_id;
// 				6:net_id_comb[6] = net_id;
// 				7:net_id_comb[7] = net_id;
// 				8:net_id_comb[8] = net_id;
// 				9:net_id_comb[9] = net_id;
// 				10:net_id_comb[10] = net_id;
// 				11:net_id_comb[11] = net_id;
// 				12:net_id_comb[12] = net_id;
// 				13:net_id_comb[13] = net_id;
// 				14:net_id_comb[14] = net_id;
// 			endcase
// 			case(big_counter)
// 				0:begin source_x_comb[0] = loc_x; source_y_comb[0] = loc_y; end
// 				1:begin sink_x_comb[0] = loc_x; sink_y_comb[0] = loc_y; end
// 				2:begin source_x_comb[1] = loc_x; source_y_comb[1] = loc_y; end
// 				3:begin sink_x_comb[1] = loc_x; sink_y_comb[1] = loc_y; end
// 				4:begin source_x_comb[2] = loc_x; source_y_comb[2] = loc_y; end
// 				5:begin sink_x_comb[2] = loc_x; sink_y_comb[2] = loc_y; end
// 				6:begin source_x_comb[3] = loc_x; source_y_comb[3] = loc_y; end
// 				7:begin sink_x_comb[3] = loc_x; sink_y_comb[3] = loc_y; end
// 				8:begin source_x_comb[4] = loc_x; source_y_comb[4] = loc_y; end
// 				9:begin sink_x_comb[4] = loc_x; sink_y_comb[4] = loc_y; end
// 				10:begin source_x_comb[5] = loc_x; source_y_comb[5] = loc_y; end
// 				11:begin sink_x_comb[5] = loc_x;sink_y_comb[5] = loc_y; end
// 				12:begin source_x_comb[6] = loc_x; source_y_comb[6] = loc_y; end
// 				13:begin sink_x_comb[6] = loc_x;sink_y_comb[6] = loc_y; end
// 				14:begin source_x_comb[7] = loc_x; source_y_comb[7] = loc_y; end
// 				15:begin sink_x_comb[7] = loc_x;sink_y_comb[7] = loc_y; end
// 				16:begin source_x_comb[8] = loc_x; source_y_comb[8] = loc_y; end
// 				17:begin sink_x_comb[8] = loc_x;sink_y_comb[8] = loc_y; end
// 				18:begin source_x_comb[9] = loc_x; source_y_comb[9] = loc_y; end
// 				19:begin sink_x_comb[9] = loc_x;sink_y_comb[9] = loc_y; end
// 				20:begin source_x_comb[10] = loc_x; source_y_comb[10] = loc_y; end
// 				21:begin sink_x_comb[10] = loc_x;sink_y_comb[10] = loc_y; end
// 				22:begin source_x_comb[11] = loc_x; source_y_comb[11] = loc_y; end
// 				23:begin sink_x_comb[11] = loc_x;sink_y_comb[11] = loc_y; end
// 				24:begin source_x_comb[12] = loc_x; source_y_comb[12] = loc_y; end
// 				25:begin sink_x_comb[12] = loc_x;sink_y_comb[12] = loc_y; end
// 				26:begin source_x_comb[13] = loc_x; source_y_comb[13] = loc_y; end
// 				27:begin sink_x_comb[13] = loc_x;sink_y_comb[13] = loc_y; end
// 				28:begin source_x_comb[14] = loc_x; source_y_comb[14] = loc_y; end
// 				29:begin sink_x_comb[14] = loc_x;sink_y_comb[14] = loc_y; end
// 			endcase
// 		end
		
// 	end
// 	else begin
// 		frame_id_comb = frame_id_dff;
// 		for(i = 0; i < 15;i = i + 1)begin
// 			net_id_comb[i] = net_id_dff[i];
// 			source_x_comb[i] = source_x_dff[i];
// 			source_y_comb[i] = source_y_dff[i];
// 			sink_x_comb[i] = sink_x_dff[i];
// 			sink_y_comb[i] = sink_y_dff[i];
// 		end
		
// 	end
// end
always @(*) begin
	if(in_valid)begin
		frame_id_comb = frame_id_dff;
		for(i = 0; i < 15;i = i + 1)begin
			net_id_comb[i] = net_id_dff[i];
			source_x_comb[i] = source_x_dff[i];
			source_y_comb[i] = source_y_dff[i];
			sink_x_comb[i] = sink_x_dff[i];
			sink_y_comb[i] = sink_y_dff[i];
		end
		frame_id_comb = frame_id;
		case(net_count_dff)
			0:net_id_comb[0] = net_id;
			1:net_id_comb[1] = net_id;
			2:net_id_comb[2] = net_id;
			3:net_id_comb[3] = net_id;
			4:net_id_comb[4] = net_id;
			5:net_id_comb[5] = net_id;
			6:net_id_comb[6] = net_id;
			7:net_id_comb[7] = net_id;
			8:net_id_comb[8] = net_id;
			9:net_id_comb[9] = net_id;
			10:net_id_comb[10] = net_id;
			11:net_id_comb[11] = net_id;
			12:net_id_comb[12] = net_id;
			13:net_id_comb[13] = net_id;
			14:net_id_comb[14] = net_id;
		endcase
		case(big_counter)
			0:begin source_x_comb[0] = loc_x; source_y_comb[0] = loc_y; end
			1:begin sink_x_comb[0] = loc_x; sink_y_comb[0] = loc_y; end
			2:begin source_x_comb[1] = loc_x; source_y_comb[1] = loc_y; end
			3:begin sink_x_comb[1] = loc_x; sink_y_comb[1] = loc_y; end
			4:begin source_x_comb[2] = loc_x; source_y_comb[2] = loc_y; end
			5:begin sink_x_comb[2] = loc_x; sink_y_comb[2] = loc_y; end
			6:begin source_x_comb[3] = loc_x; source_y_comb[3] = loc_y; end
			7:begin sink_x_comb[3] = loc_x; sink_y_comb[3] = loc_y; end
			8:begin source_x_comb[4] = loc_x; source_y_comb[4] = loc_y; end
			9:begin sink_x_comb[4] = loc_x; sink_y_comb[4] = loc_y; end
			10:begin source_x_comb[5] = loc_x; source_y_comb[5] = loc_y; end
			11:begin sink_x_comb[5] = loc_x;sink_y_comb[5] = loc_y; end
			12:begin source_x_comb[6] = loc_x; source_y_comb[6] = loc_y; end
			13:begin sink_x_comb[6] = loc_x;sink_y_comb[6] = loc_y; end
			14:begin source_x_comb[7] = loc_x; source_y_comb[7] = loc_y; end
			15:begin sink_x_comb[7] = loc_x;sink_y_comb[7] = loc_y; end
			16:begin source_x_comb[8] = loc_x; source_y_comb[8] = loc_y; end
			17:begin sink_x_comb[8] = loc_x;sink_y_comb[8] = loc_y; end
			18:begin source_x_comb[9] = loc_x; source_y_comb[9] = loc_y; end
			19:begin sink_x_comb[9] = loc_x;sink_y_comb[9] = loc_y; end
			20:begin source_x_comb[10] = loc_x; source_y_comb[10] = loc_y; end
			21:begin sink_x_comb[10] = loc_x;sink_y_comb[10] = loc_y; end
			22:begin source_x_comb[11] = loc_x; source_y_comb[11] = loc_y; end
			23:begin sink_x_comb[11] = loc_x;sink_y_comb[11] = loc_y; end
			24:begin source_x_comb[12] = loc_x; source_y_comb[12] = loc_y; end
			25:begin sink_x_comb[12] = loc_x;sink_y_comb[12] = loc_y; end
			26:begin source_x_comb[13] = loc_x; source_y_comb[13] = loc_y; end
			27:begin sink_x_comb[13] = loc_x;sink_y_comb[13] = loc_y; end
			28:begin source_x_comb[14] = loc_x; source_y_comb[14] = loc_y; end
			29:begin sink_x_comb[14] = loc_x;sink_y_comb[14] = loc_y; end
		endcase
	end
	else begin
		frame_id_comb = frame_id_dff;
		for(i = 0; i < 15;i = i + 1)begin
			net_id_comb[i] = net_id_dff[i];
			source_x_comb[i] = source_x_dff[i];
			source_y_comb[i] = source_y_dff[i];
			sink_x_comb[i] = sink_x_dff[i];
			sink_y_comb[i] = sink_y_dff[i];
		end
	end
end
//=====================================//
//               FSM                   //
//=====================================//
always @(posedge clk or negedge rst_n) begin
	if(!rst_n)begin
		cur_state <= 0;
		cur_state_delay <= 0;
		weight_ready_dff <= 0;
	end
	else begin
		cur_state <= nxt_state;
		cur_state_delay <= cur_state;
		weight_ready_dff <= weight_ready;
	end
end

always @(*) begin
	if(cur_state == IDLE)begin
		nxt_state = IDLE;
		if(in_valid || weight_ready_dff)begin
			nxt_state = INPUT_DRAM_ADDR;
		end
	end
	else if(cur_state == INPUT_DRAM_ADDR)begin
		if(weight_ready_dff == 0 && arready_m_inf)begin
			nxt_state = DRAM_IN_WEIGHT;
		end
		else if(weight_ready_dff == 1 && arready_m_inf)begin
			nxt_state = DRAM_IN_MAP;
		end
		else begin
			nxt_state = INPUT_DRAM_ADDR;
		end
	end
	else if(cur_state == DRAM_IN_WEIGHT)begin
		if(rlast_m_inf)begin
			nxt_state = IDLE;
		end
		else begin
			nxt_state = DRAM_IN_WEIGHT;
		end
	end
	else if(cur_state == DRAM_IN_MAP)begin
		if(rlast_m_inf)begin
			nxt_state = INIT;
		end
		else begin
			nxt_state = DRAM_IN_MAP;
		end
	end
	else if(cur_state == INIT)begin
		nxt_state = FILL;
	end
	else if(cur_state == FILL)begin
		if(Fill_map_dff[target_y][target_x][1] == 1)begin
			nxt_state = RETRACE_SRAM_R;
		end
		else begin
			nxt_state = FILL;
		end
	end
	else if(cur_state == RETRACE_SRAM_R)begin
		nxt_state = RETRACE_SRAM_W;
		// if(Fill_map_dff[source_y][source_x][1] == 0)begin
		// 	if(counter_15 == net_count_dff)begin
		// 		nxt_state = DRAM_OUT_ADDR;
		// 	end
		// 	else begin
		// 		nxt_state = CLEAR_MAP;
		// 	end
		// end
	end
	else if(cur_state == RETRACE_SRAM_W)begin
		if(nxt_x_dff == source_x && nxt_y_dff == source_y)begin//this should have chance to eliminate
			if(counter_15 == net_count_dff)begin
				nxt_state = DRAM_OUT_ADDR;
			end
			else begin
				nxt_state = CLEAR_MAP;
			end
		end
		else begin
			nxt_state = RETRACE_SRAM_R;
		end
		//nxt_state = RETRACE_SRAM_R;
	end
	else if(cur_state == CLEAR_MAP)begin
		nxt_state = INIT;
	end
	else if(cur_state == DRAM_OUT_ADDR)begin
		if(awready_m_inf)begin
			nxt_state = DRAM_OUT;
		end
		else begin
			nxt_state = DRAM_OUT_ADDR;
		end
	end
	else if(cur_state == DRAM_OUT)begin
		if(counter_128 == 127)begin
			nxt_state = OUT;
		end
		else begin
			nxt_state = DRAM_OUT;
		end
	end
	//OUT
	else begin
		if(bvalid_m_inf)begin
			nxt_state = IDLE;
		end
		else begin
			nxt_state = OUT;
		end
	end

end
//=====================================================//
//                  DRAM read address                  //
//=====================================================//
reg arvalid_m_inf_comb;
// always @(posedge clk or negedge rst_n) begin
// 	if(!rst_n)begin
// 		arvalid_m_inf <= 0;
// 	end
// 	else begin
// 		arvalid_m_inf <= arvalid_m_inf_comb;
// 	end
// end
always @(*) begin
	if(cur_state == INPUT_DRAM_ADDR)begin
		if(big_counter == 0)begin
			arvalid_m_inf = 0;
		end
		else begin
			arvalid_m_inf = 1;
		end
		if(weight_ready_dff == 0)begin
			araddr_m_inf = 32'h00020000 + frame_id_dff * 64 * 32;
		end
		else begin
			araddr_m_inf = 32'h00010000 + frame_id_dff * 64 * 32;
		end

	end
	else begin
		arvalid_m_inf = 0;
		araddr_m_inf = 0;
	end
end
//======================================================//
//                 DRAM write address                   //
//======================================================//
always @(*) begin
	if(cur_state == DRAM_OUT_ADDR)begin
		awvalid_m_inf = 1;
		awaddr_m_inf = 32'h00010000 + frame_id_dff * 64 * 32;
	end
	else begin
		awvalid_m_inf = 0;
		awaddr_m_inf = 0;
	end
end
//======================================================//
//              DRAM read & SRAM write                  //
//======================================================//

always @(posedge clk or negedge rst_n) begin
	if(!rst_n)begin
		counter_128 <= 0;
	end
	else begin
		if(cur_state == DRAM_IN_WEIGHT || cur_state == DRAM_IN_MAP)begin
			if(rvalid_m_inf)begin
				counter_128 <= counter_128 + 1;
			end
			else begin
				counter_128 <= 0;
			end
		end
		else if(cur_state == DRAM_OUT)begin
			if(wready_m_inf)begin
				counter_128 <= counter_128 + 1;
			end
			else begin
				counter_128 <= counter_128;
			end
		end
		else begin
			counter_128 <= 0;
		end
	end
end
always @(posedge clk or negedge rst_n) begin
	if(!rst_n)begin
		counter_15 <= 0;
	end
	else begin
		if(cur_state == INIT)begin
			counter_15 <= counter_15 + 1;
		end
		else if(cur_state == IDLE)begin
			counter_15 <= 0;
		end
		else begin
			counter_15 <= counter_15;
		end
	end
end

always @(posedge clk or negedge rst_n) begin
	if(!rst_n)begin
		weight_map_addr_dff <= 0;
		location_map_addr1_dff <= 0;
		target_dff <= 0;
	end
	else begin
		weight_map_addr_dff <= weight_map_addr;
		location_map_addr1_dff <= location_map_addr1;
		target_dff <= target_comb;
	end
end

always @(*) begin
	if(cur_state == INIT )begin
		case(counter_15)
			0:begin target_x = sink_x_dff[0]; target_y = sink_y_dff[0]; source_x = source_x_dff[0]; source_y = source_y_dff[0];end
			1:begin target_x = sink_x_dff[1]; target_y = sink_y_dff[1]; source_x = source_x_dff[1]; source_y = source_y_dff[1];end
			2:begin target_x = sink_x_dff[2]; target_y = sink_y_dff[2]; source_x = source_x_dff[2]; source_y = source_y_dff[2];end
			3:begin target_x = sink_x_dff[3]; target_y = sink_y_dff[3]; source_x = source_x_dff[3]; source_y = source_y_dff[3];end
			4:begin target_x = sink_x_dff[4]; target_y = sink_y_dff[4]; source_x = source_x_dff[4]; source_y = source_y_dff[4];end
			5:begin target_x = sink_x_dff[5]; target_y = sink_y_dff[5]; source_x = source_x_dff[5]; source_y = source_y_dff[5];end
			6:begin target_x = sink_x_dff[6]; target_y = sink_y_dff[6]; source_x = source_x_dff[6]; source_y = source_y_dff[6];end
			7:begin target_x = sink_x_dff[7]; target_y = sink_y_dff[7]; source_x = source_x_dff[7]; source_y = source_y_dff[7];end
			8:begin target_x = sink_x_dff[8]; target_y = sink_y_dff[8]; source_x = source_x_dff[8]; source_y = source_y_dff[8];end
			9:begin target_x = sink_x_dff[9]; target_y = sink_y_dff[9]; source_x = source_x_dff[9]; source_y = source_y_dff[9];end
			10:begin target_x = sink_x_dff[10]; target_y = sink_y_dff[10]; source_x = source_x_dff[10]; source_y = source_y_dff[10];end
			11:begin target_x = sink_x_dff[11]; target_y = sink_y_dff[11]; source_x = source_x_dff[11]; source_y = source_y_dff[11];end
			12:begin target_x = sink_x_dff[12]; target_y = sink_y_dff[12]; source_x = source_x_dff[12]; source_y = source_y_dff[12];end
			13:begin target_x = sink_x_dff[13]; target_y = sink_y_dff[13]; source_x = source_x_dff[13]; source_y = source_y_dff[13];end
			14:begin target_x = sink_x_dff[14]; target_y = sink_y_dff[14]; source_x = source_x_dff[14]; source_y = source_y_dff[14];end
			default:begin target_x = sink_x_dff[0]; target_y = sink_y_dff[0]; source_x = source_x_dff[0]; source_y = source_y_dff[0];end
		endcase
	end
	else if(cur_state == FILL || cur_state == RETRACE_SRAM_R || cur_state == RETRACE_SRAM_W)begin
		case(counter_15)
			1:begin target_x = sink_x_dff[0]; target_y = sink_y_dff[0]; source_x = source_x_dff[0]; source_y = source_y_dff[0];end
			2:begin target_x = sink_x_dff[1]; target_y = sink_y_dff[1]; source_x = source_x_dff[1]; source_y = source_y_dff[1];end
			3:begin target_x = sink_x_dff[2]; target_y = sink_y_dff[2]; source_x = source_x_dff[2]; source_y = source_y_dff[2];end
			4:begin target_x = sink_x_dff[3]; target_y = sink_y_dff[3]; source_x = source_x_dff[3]; source_y = source_y_dff[3];end
			5:begin target_x = sink_x_dff[4]; target_y = sink_y_dff[4]; source_x = source_x_dff[4]; source_y = source_y_dff[4];end
			6:begin target_x = sink_x_dff[5]; target_y = sink_y_dff[5]; source_x = source_x_dff[5]; source_y = source_y_dff[5];end
			7:begin target_x = sink_x_dff[6]; target_y = sink_y_dff[6]; source_x = source_x_dff[6]; source_y = source_y_dff[6];end
			8:begin target_x = sink_x_dff[7]; target_y = sink_y_dff[7]; source_x = source_x_dff[7]; source_y = source_y_dff[7];end
			9:begin target_x = sink_x_dff[8]; target_y = sink_y_dff[8]; source_x = source_x_dff[8]; source_y = source_y_dff[8];end
			10:begin target_x = sink_x_dff[9]; target_y = sink_y_dff[9]; source_x = source_x_dff[9]; source_y = source_y_dff[9];end
			11:begin target_x = sink_x_dff[10]; target_y = sink_y_dff[10]; source_x = source_x_dff[10]; source_y = source_y_dff[10];end
			12:begin target_x = sink_x_dff[11]; target_y = sink_y_dff[11]; source_x = source_x_dff[11]; source_y = source_y_dff[11];end
			13:begin target_x = sink_x_dff[12]; target_y = sink_y_dff[12]; source_x = source_x_dff[12]; source_y = source_y_dff[12];end
			14:begin target_x = sink_x_dff[13]; target_y = sink_y_dff[13]; source_x = source_x_dff[13]; source_y = source_y_dff[13];end
			15:begin target_x = sink_x_dff[14]; target_y = sink_y_dff[14]; source_x = source_x_dff[14]; source_y = source_y_dff[14];end
			default:begin target_x = sink_x_dff[0]; target_y = sink_y_dff[0]; source_x = source_x_dff[0]; source_y = source_y_dff[0];end
		endcase
	end
	else begin
		target_x = 0;
		target_y = 0;
		source_x = 0;
		source_y = 0;
	end

end
always @(*) begin
	if(cur_state == RETRACE_SRAM_R)begin
		case(counter_15)
			1:target_comb = net_id_dff[0];
			2:target_comb = net_id_dff[1];
			3:target_comb = net_id_dff[2];
			4:target_comb = net_id_dff[3];
			5:target_comb = net_id_dff[4];
			6:target_comb = net_id_dff[5];
			7:target_comb = net_id_dff[6];
			8:target_comb = net_id_dff[7];
			9:target_comb = net_id_dff[8];
			10:target_comb = net_id_dff[9];
			11:target_comb = net_id_dff[10];
			12:target_comb = net_id_dff[11];
			13:target_comb = net_id_dff[12];
			14:target_comb = net_id_dff[13];
			15:target_comb = net_id_dff[14];
			default:target_comb = 0;
		endcase
	end
	else begin
		target_comb = 0;
	end
end
always @(*) begin
	if(cur_state == DRAM_IN_WEIGHT)begin
		rready_m_inf = 1;
		weight_map_addr = counter_128;
		weight_map_WEB = 1;
		weight_map_in = 0;
		location_map_WEB = 1;
		location_map_addr1 = counter_128;
		location_map_in = 0;
		if(rvalid_m_inf)begin
			weight_map_WEB = 0;
			weight_map_in = rdata_m_inf;
		end
	end
	else if(cur_state == DRAM_IN_MAP) begin
		rready_m_inf = 1;
		location_map_WEB = 1;
		location_map_addr1 = counter_128;
		location_map_in = 0;
		weight_map_addr = counter_128;
		weight_map_WEB = 1;
		weight_map_in = 0;
		if(rvalid_m_inf)begin
			location_map_WEB = 0;
			location_map_in = rdata_m_inf;
		end
		
	end
	else if(cur_state == RETRACE_SRAM_R )begin
		rready_m_inf = 0;
		location_map_WEB = 1;
		weight_map_WEB = 1;
		weight_map_in = 0;
		location_map_in = 0;
		if(cur_x_dff > 31)begin
			weight_map_addr = {cur_y_dff,1'b1};
			location_map_addr1 = {cur_y_dff,1'b1};
		end
		else begin
			weight_map_addr = {cur_y_dff,1'b0};
			location_map_addr1 = {cur_y_dff,1'b0};
		end
	end
	else if(cur_state == RETRACE_SRAM_W)begin
		rready_m_inf = 0;
		location_map_WEB = 0;
		weight_map_WEB = 1;
		weight_map_in = 0;
		location_map_addr1 = location_map_addr1_dff;
		weight_map_addr = weight_map_addr_dff;
		for(i = 0; i < 32 ;i = i + 1)begin
			if(i == cur_x_dff[4:0])begin
				location_map_in[i * 4 +: 4] = target_dff;
			end
			else begin
				location_map_in[i * 4 +: 4] = location_map_out[i * 4 +: 4]; 
			end
		end
		
	end
	else if(cur_state == DRAM_OUT)begin
		rready_m_inf = 0;
		location_map_addr1 = 0;
		location_map_WEB = 1;
		weight_map_addr = counter_128;
		weight_map_WEB = 1;
		location_map_in = 0;
		weight_map_in = 0;
		if(wready_m_inf)begin
			location_map_addr1 = counter_128 + 1;
		end
	end
	else begin
		rready_m_inf = 0;
		location_map_addr1 = counter_128;
		location_map_WEB = 1;
		weight_map_addr = counter_128;
		weight_map_WEB = 1;
		location_map_in = 0;
		weight_map_in = 0;
	end
end
//=========================================================//
//                DRAM write and SRAM read                 //
//=========================================================//
always @(*) begin
	if(cur_state == DRAM_OUT)begin
		wdata_m_inf = location_map_out;
		wvalid_m_inf = 1;
		bready_m_inf = 1;
		if(counter_128 == 127)begin
			wlast_m_inf = 1;
		end
		else begin
			wlast_m_inf = 0;
		end
	end
	else if(cur_state == OUT)begin
		wdata_m_inf = 0;
		wvalid_m_inf = 0;
		bready_m_inf = 1;
		wlast_m_inf = 0;
	end
	else begin
		bready_m_inf = 0;
		wdata_m_inf = 0;
		wvalid_m_inf = 0;
		wlast_m_inf = 0;
	end
end
//=========================================================//
//         Filling map logic  & Retrace logic              //
//=========================================================//

always @(posedge clk or negedge rst_n) begin
	if(!rst_n)begin
		counter_4 <= 0;
		cost_dff <= 0;
		weight_map_out_dff <= 0;
	end
	else begin
		if(cur_state == IDLE)begin
			counter_4 <= 0;
			weight_map_out_dff <= 0;
			cost_dff <= 0;
		end
		else if(cur_state == FILL)begin
			cost_dff <= cost_dff;
			weight_map_out_dff <= 0;
			if(nxt_state == RETRACE_SRAM_R)begin
				counter_4 <= counter_4 - 2;
			end
			else begin
				counter_4 <= counter_4 + 1;
			end
		end
		else if(cur_state == RETRACE_SRAM_R)begin
			counter_4 <= counter_4 - 1;
			cost_dff <= cost_dff + weight_map_out_dff;
			weight_map_out_dff <= 0;
		end
		else if(cur_state == RETRACE_SRAM_W)begin
			counter_4 <= counter_4;
			cost_dff <= cost_dff;
			if((cur_x_dff == target_x && cur_y_dff == target_y) || (cur_x_dff == source_x && cur_y_dff == source_y))begin
				weight_map_out_dff <= 0;
			end
			else begin
				weight_map_out_dff <= weight_map_out[cur_x_dff[4:0] * 4 +: 4];
			end
		end
		else if(cur_state == DRAM_OUT_ADDR || cur_state == CLEAR_MAP)begin
			cost_dff <= cost_dff + weight_map_out_dff;
			counter_4 <= 0;
			weight_map_out_dff <= 0;
		end
		else begin
			cost_dff <= cost_dff;
			weight_map_out_dff <= 0;
			counter_4 <= 0;
		end
	end
end
always @(*) begin
	if(cur_state == FILL || cur_state == RETRACE_SRAM_R)begin
		case(counter_4)
			0:cur_flag = 0;
			1:cur_flag = 0;
			2:cur_flag = 1;
			3:cur_flag = 1;
		endcase
	end
	else begin
		cur_flag = 0;
	end
end
always @(posedge clk or negedge rst_n) begin
	if(!rst_n)begin
		cur_x_dff <= 0;
		cur_y_dff <= 0;
		nxt_x_dff <= 0;
		nxt_y_dff <= 0;
	end
	else begin
		cur_x_dff <= cur_x_comb;
		cur_y_dff <= cur_y_comb;
		nxt_x_dff <= nxt_x_comb;
		nxt_y_dff <= nxt_y_comb;
	end
end
always @(*) begin
	if(cur_state == DRAM_IN_MAP)begin
		cur_x_comb = 0;
		cur_y_comb = 0;
		nxt_x_comb = 0;
		nxt_y_comb = 0;
		for(k = 0; k < 64; k = k + 1)begin
			for(h = 0; h < 64 ; h = h + 1)begin
				Fill_map_comb[k][h] = Fill_map_dff[k][h];
			end
		end
		if(rvalid_m_inf)begin//critical path
			if(counter_128[0] == 0)begin
				for(i = 0; i < 32; i = i + 1)begin
					if(rdata_m_inf[i*4 +: 4] != 0)begin
						Fill_map_comb[counter_128[6:1]][i] = 1;
					end
					else begin
						Fill_map_comb[counter_128[6:1]][i] = 0;
					end
				end
			end
			else begin
				for(i = 0; i < 32; i = i + 1)begin
					if(rdata_m_inf[i*4 +: 4] != 0)begin
						Fill_map_comb[counter_128[6:1]][i + 32] = 1;
					end
					else begin
						Fill_map_comb[counter_128[6:1]][i + 32] = 0;
					end
				end
			end
			// for(i = 32; i < 64; i = i + 1)begin
			// 	Fill_map_comb[63][i] = {1'b0, |rdata_m_inf[(i - 32) * 4 +: 4]};
			// end
			// for(i = 0; i < 63; i = i + 1)begin
			// 	for(j = 0; j < 32;j = j + 1)begin
			// 		Fill_map_comb[i][j] = Fill_map_dff[i][j + 32];
			// 	end
			// end
			// for(i = 0; i < 63; i = i + 1)begin
			// 	for(j = 32; j < 64; j = j + 1)begin
			// 		Fill_map_comb[i][j] = Fill_map_dff[i + 1][j - 32];
			// 	end
			// end
			// for(i = 0; i < 32; i = i + 1)begin
			// 	Fill_map_comb[63][i] = Fill_map_dff[63][i + 32];
			// end
		end
	end
	else if(cur_state == INIT)begin
		// for(i = 0; i < 64; i = i + 1)begin
		// 	for(j = 0; j < 64 ; j = j + 1)begin
		// 		Fill_map_comb[i][j] = Fill_map_dff[i][j];
		// 	end
		// end
		cur_x_comb = target_x;
		cur_y_comb = target_y;
		nxt_x_comb = target_x;
		nxt_y_comb = target_y;
		// case(counter_15)
		// 	0 :begin Fill_map_comb[source_y_dff[0]][source_x_dff[0]] = 3; Fill_map_comb[sink_y_dff[0]][sink_x_dff[0]] = 0;cur_x_comb = sink_x_dff[0]; cur_y_comb = sink_y_dff[0]; end
		// 	1 :begin Fill_map_comb[source_y_dff[1]][source_x_dff[1]] = 3; Fill_map_comb[sink_y_dff[1]][sink_x_dff[1]] = 0;cur_x_comb = sink_x_dff[1]; cur_y_comb = sink_y_dff[1]; end
		// 	2 :begin Fill_map_comb[source_y_dff[2]][source_x_dff[2]] = 3; Fill_map_comb[sink_y_dff[2]][sink_x_dff[2]] = 0;cur_x_comb = sink_x_dff[2]; cur_y_comb = sink_y_dff[2]; end
		// 	3 :begin Fill_map_comb[source_y_dff[3]][source_x_dff[3]] = 3; Fill_map_comb[sink_y_dff[3]][sink_x_dff[3]] = 0;cur_x_comb = sink_x_dff[3]; cur_y_comb = sink_y_dff[3]; end
		// 	4 :begin Fill_map_comb[source_y_dff[4]][source_x_dff[4]] = 3; Fill_map_comb[sink_y_dff[4]][sink_x_dff[4]] = 0;cur_x_comb = sink_x_dff[4]; cur_y_comb = sink_y_dff[4]; end
		// 	5 :begin Fill_map_comb[source_y_dff[5]][source_x_dff[5]] = 3; Fill_map_comb[sink_y_dff[5]][sink_x_dff[5]] = 0;cur_x_comb = sink_x_dff[5]; cur_y_comb = sink_y_dff[5]; end
		// 	6 :begin Fill_map_comb[source_y_dff[6]][source_x_dff[6]] = 3; Fill_map_comb[sink_y_dff[6]][sink_x_dff[6]] = 0;cur_x_comb = sink_x_dff[6]; cur_y_comb = sink_y_dff[6]; end
		// 	7 :begin Fill_map_comb[source_y_dff[7]][source_x_dff[7]] = 3; Fill_map_comb[sink_y_dff[7]][sink_x_dff[7]] = 0;cur_x_comb = sink_x_dff[7]; cur_y_comb = sink_y_dff[7]; end
		// 	8 :begin Fill_map_comb[source_y_dff[8]][source_x_dff[8]] = 3; Fill_map_comb[sink_y_dff[8]][sink_x_dff[8]] = 0;cur_x_comb = sink_x_dff[8]; cur_y_comb = sink_y_dff[8]; end
		// 	9 :begin Fill_map_comb[source_y_dff[9]][source_x_dff[9]] = 3; Fill_map_comb[sink_y_dff[9]][sink_x_dff[9]] = 0;cur_x_comb = sink_x_dff[9]; cur_y_comb = sink_y_dff[9]; end
		// 	10:begin Fill_map_comb[source_y_dff[10]][source_x_dff[10]] = 3; Fill_map_comb[sink_y_dff[10]][sink_x_dff[10]] = 0;cur_x_comb = sink_x_dff[10];cur_y_comb = sink_y_dff[10]; end
		// 	11:begin Fill_map_comb[source_y_dff[11]][source_x_dff[11]] = 3; Fill_map_comb[sink_y_dff[11]][sink_x_dff[11]] = 0;cur_x_comb = sink_x_dff[11];cur_y_comb = sink_y_dff[11]; end
		// 	12:begin Fill_map_comb[source_y_dff[12]][source_x_dff[12]] = 3; Fill_map_comb[sink_y_dff[12]][sink_x_dff[12]] = 0;cur_x_comb = sink_x_dff[12];cur_y_comb = sink_y_dff[12]; end
		// 	13:begin Fill_map_comb[source_y_dff[13]][source_x_dff[13]] = 3; Fill_map_comb[sink_y_dff[13]][sink_x_dff[13]] = 0;cur_x_comb = sink_x_dff[13];cur_y_comb = sink_y_dff[13]; end
		// 	14:begin Fill_map_comb[source_y_dff[14]][source_x_dff[14]] = 3; Fill_map_comb[sink_y_dff[14]][sink_x_dff[14]] = 0;cur_x_comb = sink_x_dff[14];cur_y_comb = sink_y_dff[14]; end
		// endcase
		for(i = 2; i < 62; i = i + 1)begin
			for(j = 2; j < 62 ; j = j + 1)begin
				if(i == source_y && j == source_x)begin
					Fill_map_comb[i][j] = 3;
				end
				else if(i == target_y && j == target_x)begin
					Fill_map_comb[i][j] = 0;
				end
				else begin
					Fill_map_comb[i][j] = Fill_map_dff[i][j];
				end
			end
		end
		for(i = 0; i < 2; i = i + 1)begin
			for(j = 0; j < 64; j = j + 1)begin
				Fill_map_comb[i][j] = Fill_map_dff[i][j];
			end
		end
		for(i = 62; i < 64; i = i + 1)begin
			for(j = 0; j < 64; j = j + 1)begin
				Fill_map_comb[i][j] = Fill_map_dff[i][j];
			end
		end
		for(i = 2 ; i < 62; i = i + 1)begin
			for(j = 0; j < 2; j = j + 1)begin
				Fill_map_comb[i][j] = Fill_map_dff[i][j];
			end
		end
		for(i = 2; i < 62; i = i + 1)begin
			for(j = 62; j < 64; j = j + 1)begin
				Fill_map_comb[i][j] = Fill_map_dff[i][j];
			end
		end

	end
	else if(cur_state == FILL)begin
		cur_x_comb = cur_x_dff;
		cur_y_comb = cur_y_dff;
		nxt_x_comb = nxt_x_dff;
		nxt_y_comb = nxt_y_dff;
		for(i = 0; i < 64; i = i + 1)begin
			for(j = 0 ; j < 64; j = j + 1)begin
				Fill_map_comb[i][j] = Fill_map_dff[i][j];
			end
		end
		for(i = 0; i < 64; i = i + 1)begin
			for(j = 0 ; j < 64; j = j + 1)begin
				if(Fill_map_dff[i][j][1])begin
					if(i == 0 && j == 0)begin
						if(Fill_map_dff[0][1] == 0)begin Fill_map_comb[0][1] = {1'b1, cur_flag};end
						if(Fill_map_dff[1][0] == 0)begin Fill_map_comb[1][0] = {1'b1, cur_flag};end
					end
					else if(i == 0 && j == 63)begin
						if(Fill_map_dff[0][62] == 0)begin Fill_map_comb[0][62] = {1'b1, cur_flag};end
						if(Fill_map_dff[1][63] == 0)begin Fill_map_comb[1][63] = {1'b1, cur_flag};end
					end
					else if(i == 63 && j == 0)begin
						if(Fill_map_dff[62][0] == 0)begin Fill_map_comb[62][0] = {1'b1, cur_flag};end
						if(Fill_map_dff[63][1] == 0)begin Fill_map_comb[63][1] = {1'b1, cur_flag};end
					end
					else if(i == 63 && j == 63)begin
						if(Fill_map_dff[62][63] == 0)begin Fill_map_comb[62][63] = {1'b1, cur_flag};end
						if(Fill_map_dff[63][62] == 0)begin Fill_map_comb[63][62] = {1'b1, cur_flag};end
					end
					else if(i == 0)begin
						if(Fill_map_dff[1][j] == 0)begin Fill_map_comb[1][j] = {1'b1 ,cur_flag};end
						if(Fill_map_dff[0][j + 1] == 0)begin Fill_map_comb[0][j + 1] = {1'b1 ,cur_flag};end
						if(Fill_map_dff[0][j - 1] == 0)begin Fill_map_comb[0][j - 1] = {1'b1 ,cur_flag};end
					end
					else if(j == 0)begin
						if(Fill_map_dff[i + 1][0] == 0)begin Fill_map_comb[i + 1][0] = {1'b1 ,cur_flag};end
						if(Fill_map_dff[i - 1][0] == 0)begin Fill_map_comb[i - 1][0] = {1'b1 ,cur_flag};end
						if(Fill_map_dff[i][1] == 0)begin Fill_map_comb[i][1] = {1'b1 ,cur_flag};end
					end
					else if(i == 63)begin
						if(Fill_map_dff[62][j] == 0)begin Fill_map_comb[62][j] = {1'b1 ,cur_flag};end
						if(Fill_map_dff[63][j + 1] == 0)begin Fill_map_comb[63][j + 1] = {1'b1 ,cur_flag};end
						if(Fill_map_dff[63][j - 1] == 0)begin Fill_map_comb[63][j - 1] = {1'b1 ,cur_flag};end
					end
					else if(j == 63)begin
						if(Fill_map_dff[i + 1][63] == 0)begin Fill_map_comb[i + 1][63] = {1'b1 ,cur_flag};end
						if(Fill_map_dff[i - 1][63] == 0)begin Fill_map_comb[i - 1][63] = {1'b1 ,cur_flag};end
						if(Fill_map_dff[i][62] == 0)begin Fill_map_comb[i][62] = {1'b1 ,cur_flag};end
					end
					else begin
						if(Fill_map_dff[i + 1][j] == 0)begin Fill_map_comb[i + 1][j] = {1'b1, cur_flag};end
						if(Fill_map_dff[i - 1][j] == 0)begin Fill_map_comb[i - 1][j] = {1'b1, cur_flag};end
						if(Fill_map_dff[i][j + 1] == 0)begin Fill_map_comb[i][j + 1] = {1'b1, cur_flag};end
						if(Fill_map_dff[i][j - 1] == 0)begin Fill_map_comb[i][j - 1] = {1'b1,cur_flag};end
					end
				end
			end
		end
	end
	else if(cur_state == RETRACE_SRAM_R)begin
		for(i = 0; i < 64; i = i + 1)begin
			for(j = 0 ; j < 64; j = j + 1)begin
				Fill_map_comb[i][j] = Fill_map_dff[i][j];
			end
		end
		cur_x_comb = cur_x_dff;
		cur_y_comb = cur_y_dff;
		nxt_x_comb = nxt_x_dff;
		nxt_y_comb = nxt_y_dff;
		Fill_map_comb[nxt_y_dff][nxt_x_dff] = 1;
		if(Fill_map_dff[cur_y_dff + 1][cur_x_dff] == {1'b1, cur_flag} && cur_y_dff != 63 )begin 
			nxt_y_comb = cur_y_dff + 1 ; 
			//Fill_map_comb[cur_y_dff + 1][cur_x_dff] = 1;
		end
		else if(Fill_map_dff[cur_y_dff - 1][cur_x_dff] == {1'b1, cur_flag} && cur_y_dff != 0)begin 
			nxt_y_comb = cur_y_dff - 1 ;
			//Fill_map_comb[cur_y_dff - 1][cur_x_dff] = 1;	
		end
		else if(Fill_map_dff[cur_y_dff][cur_x_dff + 1] == {1'b1, cur_flag} && cur_x_dff != 63)begin 
			nxt_x_comb = cur_x_dff + 1;
			//Fill_map_comb[cur_y_dff][cur_x_dff + 1] = 1;	
		end
		else begin
			nxt_x_comb = cur_x_dff - 1;
			//Fill_map_comb[cur_y_dff][cur_x_dff - 1] = 1;
		end
	end
	else if(cur_state == RETRACE_SRAM_W)begin
		for(i = 0; i < 64; i = i + 1)begin
			for(j = 0 ; j < 64; j = j + 1)begin
				Fill_map_comb[i][j] = Fill_map_dff[i][j];
			end
		end
		cur_x_comb = nxt_x_dff;
		cur_y_comb = nxt_y_dff;
		nxt_x_comb = nxt_x_dff;
		nxt_y_comb = nxt_y_dff;
		//Fill_map_comb[nxt_y_dff][nxt_x_dff] = 1;
	end
	else if(cur_state == CLEAR_MAP)begin
		cur_x_comb = 0;
		cur_y_comb = 0;
		nxt_x_comb = 0;
		nxt_y_comb = 0;
		for(i = 0; i < 64; i = i + 1)begin
			for(j = 0; j < 64; j = j + 1)begin
				if(Fill_map_dff[i][j][1] == 1'b1)begin
					Fill_map_comb[i][j] = 0;
				end
				else begin
					Fill_map_comb[i][j] = Fill_map_dff[i][j];
				end
			end
		end
	end
	else begin
		cur_x_comb = 0;
		cur_y_comb = 0;
		nxt_x_comb = 0;
		nxt_y_comb = 0;
		for(i = 0; i < 64; i = i + 1)begin
			for(j = 0; j < 64 ; j = j + 1)begin
				Fill_map_comb[i][j] = Fill_map_dff[i][j];
			end
		end
	end
end
// task show_map;
// 	$display("target_x = %d target_y = %d", target_x, target_y);
// 	$display("source_x = %d source_y = %d", source_x, source_y);
// 	for(i = 0; i < 64; i = i + 1)begin
// 		for(j = 0; j < 64; j = j + 1)begin
// 			if(Fill_map_dff[i][j] != 1)begin
// 				$write("\033[m");
// 				$write("%d ", Fill_map_dff[i][j]);
// 			end
// 			else begin
// 				$write("\033[0;32;32m");
// 				$write("%d ", Fill_map_dff[i][j]);
// 			end
// 		end
// 		$write("\n");
// 	end
// 	$write("************************************************************************************************************\n");
// 	$write("************************************************************************************************************\n");
// endtask
endmodule
