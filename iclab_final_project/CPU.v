//############################################################################
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//   (C) Copyright Laboratory System Integration and Silicon Implementation
//   All Right Reserved
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
//   ICLAB 2021 Final Project: Customized ISA Processor 
//   Author              : Hsi-Hao Huang
//
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
//   File Name   : CPU.v
//   Module Name : CPU.v
//   Release version : V1.0 (Release Date: 2021-May)
//
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//############################################################################
// remote controll
module CPU(

				clk,
			  rst_n,
  
		   IO_stall,

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
       bready_m_inf,
                    
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
       rready_m_inf 

);
// Input port
input  wire clk, rst_n;
// Output port
output reg  IO_stall;

parameter ID_WIDTH = 4 , ADDR_WIDTH = 32, DATA_WIDTH = 16, DRAM_NUMBER=2, WRIT_NUMBER=1;

// AXI Interface wire connecttion for pseudo DRAM read/write
/* Hint:
  your AXI-4 interface could be designed as convertor in submodule(which used reg for output signal),
  therefore I declared output of AXI as wire in CPU
*/



// axi write address channel 
output  wire [WRIT_NUMBER * ID_WIDTH-1:0]        awid_m_inf;
output  wire [WRIT_NUMBER * ADDR_WIDTH-1:0]    awaddr_m_inf;
output  wire [WRIT_NUMBER * 3 -1:0]            awsize_m_inf;
output  wire [WRIT_NUMBER * 2 -1:0]           awburst_m_inf;
output  wire [WRIT_NUMBER * 7 -1:0]             awlen_m_inf;
output  wire [WRIT_NUMBER-1:0]                awvalid_m_inf;
input   wire [WRIT_NUMBER-1:0]                awready_m_inf;
// axi write data channel 
output  wire [WRIT_NUMBER * DATA_WIDTH-1:0]     wdata_m_inf;
output  wire [WRIT_NUMBER-1:0]                  wlast_m_inf;
output  wire [WRIT_NUMBER-1:0]                 wvalid_m_inf;
input   wire [WRIT_NUMBER-1:0]                 wready_m_inf;
// axi write response channel
input   wire [WRIT_NUMBER * ID_WIDTH-1:0]         bid_m_inf;
input   wire [WRIT_NUMBER * 2 -1:0]             bresp_m_inf;
input   wire [WRIT_NUMBER-1:0]             	   bvalid_m_inf;
output  wire [WRIT_NUMBER-1:0]                 bready_m_inf;
// -----------------------------
// axi read address channel 
output  wire [DRAM_NUMBER * ID_WIDTH-1:0]       arid_m_inf;
output  wire [DRAM_NUMBER * ADDR_WIDTH-1:0]   araddr_m_inf;
output  wire [DRAM_NUMBER * 7 -1:0]            arlen_m_inf;
output  wire [DRAM_NUMBER * 3 -1:0]           arsize_m_inf;
output  wire [DRAM_NUMBER * 2 -1:0]          arburst_m_inf;
output  wire [DRAM_NUMBER-1:0]               arvalid_m_inf;
input   wire [DRAM_NUMBER-1:0]               arready_m_inf;
// -----------------------------
// axi read data channel 
input   wire [DRAM_NUMBER * ID_WIDTH-1:0]         rid_m_inf;
input   wire [DRAM_NUMBER * DATA_WIDTH-1:0]     rdata_m_inf;
input   wire [DRAM_NUMBER * 2 -1:0]             rresp_m_inf;
input   wire [DRAM_NUMBER-1:0]                  rlast_m_inf;
input   wire [DRAM_NUMBER-1:0]                 rvalid_m_inf;
output  wire [DRAM_NUMBER-1:0]                 rready_m_inf;
// -----------------------------

//
//
// 
/* Register in each core:
  There are sixteen registers in your CPU. You should not change the name of those registers.
  TA will check the value in each register when your core is not busy.
  If you change the name of registers below, you must get the fail in this lab.
*/

reg signed [15:0] core_r0 , core_r1 , core_r2 , core_r3 ;
reg signed [15:0] core_r4 , core_r5 , core_r6 , core_r7 ;
reg signed [15:0] core_r8 , core_r9 , core_r10, core_r11;
reg signed [15:0] core_r12, core_r13, core_r14, core_r15;

//###########################################
//
// Wrtie down your design below
//
//###########################################
parameter Init =       4'd0;
parameter Inst_Fetch = 4'd1;
parameter Hit =        4'd2;
parameter Exe =        4'd3;
parameter Jump =       4'd4;
parameter Data_Find =  4'd5;
parameter Data_DRAM =  4'd6;
parameter Inst_DRAM =  4'd7;
parameter mult =       4'd8;
parameter Data_Hit  =  4'd9;

int i, j;
genvar  a, b;
//####################################################
//               reg & wire
//####################################################



//         for sram                          
//---------------------------
reg [15:0] sram_out_data;
reg [15:0] sram_in_data;
reg [7:0] sram_addr;
reg sram_w_r;

//      for DRAM dealer
//-------------------------
reg Data_DRAM_out_valid, Data_DRAM_out_valid_sram, Data_DRAM_in_valid, one_for_w_zero_for_r, one_for_w_zero_for_r_dff;
reg Inst_DRAM_out_valid, Inst_DRAM_out_valid_sram, Inst_DRAM_in_valid;
reg [11:0] Data_DRAM_addr;
reg [11:0] Inst_DRAM_addr;
reg signed [15:0] data_write; 
reg signed [15:0] DRAM_out_data;
reg [15:0] Inst_from_DRAM;

//         for FSM                            
//-------------------------------
reg [3:0] cur_state, next_state;
reg hit, hit_dff;
reg data_hit, data_hit_dff;
reg Inst_init, Data_init;

//    instruction
//-----------------------------
reg [15:0] instruction;
reg [3:0] opcode;
reg [3:0] rs, rt, rd;
reg signed [4:0] immediate;
reg [12:0] JUMP;
reg compout;
//      PC & inst DRAM addr
//-----------------------------
reg signed [11:0] My_Inst_DRAM_addr, My_Inst_DRAM_addr_dff;
reg [6:0] PC, PC_dff, counter_128; // concate with 0 in the front
reg [3:0] save_Inst_hit_addr, save_Inst_hit_addr_dff;

//    Exe & data DRAM addr
//------------------------------
reg signed [15:0] add_out, sub_out, mult_out, load_out, store_out;
reg [3:0] save_Data_hit_addr, save_Data_hit_addr_dff;
reg signed [11:0] My_Data_DRAM_addr, My_Data_DRAM_addr_dff;
reg Data_DRAM_in_valid_dff;
reg signed [11:0] Data_addr_cal;
reg signed [15:0] load_out_dff;
reg signed [15:0] rs_data, rt_data;
reg signed [15:0] Exe_out;
//===================================================
SRAM_16X256 my_cache(.A0(sram_addr[0]), .A1(sram_addr[1]), .A2(sram_addr[2]), .A3(sram_addr[3]), 
                    .A4(sram_addr[4]), .A5(sram_addr[5]), .A6(sram_addr[6]), .A7(sram_addr[7]),
                    .DO0(sram_out_data[0]), .DO1(sram_out_data[1]), .DO2(sram_out_data[2]), 
                    .DO3(sram_out_data[3]), .DO4(sram_out_data[4]), .DO5(sram_out_data[5]),
                    .DO6(sram_out_data[6]), .DO7(sram_out_data[7]), .DO8(sram_out_data[8]),
                    .DO9(sram_out_data[9]), .DO10(sram_out_data[10]), .DO11(sram_out_data[11]), 
                    .DO12(sram_out_data[12]), .DO13(sram_out_data[13]), .DO14(sram_out_data[14]),
                    .DO15(sram_out_data[15]), 
                    .DI0(sram_in_data[0]), .DI1(sram_in_data[1]), .DI2(sram_in_data[2]), 
                    .DI3(sram_in_data[3]), .DI4(sram_in_data[4]), .DI5(sram_in_data[5]), 
                    .DI6(sram_in_data[6]), .DI7(sram_in_data[7]), .DI8(sram_in_data[8]),
                    .DI9(sram_in_data[9]), .DI10(sram_in_data[10]), .DI11(sram_in_data[11]),
                    .DI12(sram_in_data[12]), .DI13(sram_in_data[13]), .DI14(sram_in_data[14]), 
                    .DI15(sram_in_data[15]),
                    .CK(clk), .WEB(sram_w_r), .OE(1'b1), .CS(1'b1));

//==================================================//
//              DRAM dealer                         //
//==================================================//
Data_DRAM_dealer my_data_DRAM_dealer(
    .clk(clk), .rst_n(rst_n), .in_valid(Data_DRAM_in_valid_dff), .out_valid(Data_DRAM_out_valid), .out_valid_sram(Data_DRAM_out_valid_sram), 
    .one_for_w_zero_for_r(one_for_w_zero_for_r),
    .Data_DRAM_addr(Data_DRAM_addr), .data_write(data_write), .out_data(DRAM_out_data),
      .awid_m_inf(awid_m_inf),
      .awaddr_m_inf(awaddr_m_inf),
      .awsize_m_inf(awsize_m_inf),
      .awburst_m_inf(awburst_m_inf),
      .awlen_m_inf(awlen_m_inf),
      .awvalid_m_inf(awvalid_m_inf),
      .awready_m_inf(awready_m_inf),
                    
      .wdata_m_inf(wdata_m_inf),
      .wlast_m_inf(wlast_m_inf),
      .wvalid_m_inf(wvalid_m_inf),
      .wready_m_inf(wready_m_inf),
                    
      .bid_m_inf(bid_m_inf),
      .bresp_m_inf(bresp_m_inf),
      .bvalid_m_inf(bvalid_m_inf),
      .bready_m_inf(bready_m_inf),
                    
      .arid_m_inf(arid_m_inf[ID_WIDTH-1:0]),
      .araddr_m_inf(araddr_m_inf[ADDR_WIDTH-1:0]),
      .arlen_m_inf(arlen_m_inf[6:0]),
      .arsize_m_inf(arsize_m_inf[2:0]),
      .arburst_m_inf(arburst_m_inf[1:0]),
      .arvalid_m_inf(arvalid_m_inf[0]),
      .arready_m_inf(arready_m_inf[0]),

      .rid_m_inf(rid_m_inf[ID_WIDTH-1:0]),
      .rdata_m_inf(rdata_m_inf[DATA_WIDTH-1:0]),
      .rresp_m_inf(rready_m_inf[1:0]),
      .rlast_m_inf(rlast_m_inf[0]),
      .rvalid_m_inf(rvalid_m_inf[0]),
      .rready_m_inf(rready_m_inf[0]) 
);
Inst_DRAM_dealer my_Inst_DRAM_dealer(
        .clk(clk),
        .rst_n(rst_n),
        .in_valid(Inst_DRAM_in_valid),
        .Inst_DRAM_addr(Inst_DRAM_addr),
        .out_valid(Inst_DRAM_out_valid),
        .out_valid_sram(Inst_DRAM_out_valid_sram),
        .out_inst(Inst_from_DRAM),
                    
        .arid_m_inf(arid_m_inf[2*ID_WIDTH-1:ID_WIDTH]),
       .araddr_m_inf(araddr_m_inf[2*ADDR_WIDTH-1:ADDR_WIDTH]),
       .arlen_m_inf(arlen_m_inf[13:7]),
       .arsize_m_inf(arsize_m_inf[5:3]),
      .arburst_m_inf(arburst_m_inf[3:2]),
      .arvalid_m_inf(arvalid_m_inf[1]),             
      .arready_m_inf(arready_m_inf[1]),

        .rid_m_inf(rid_m_inf[2*ID_WIDTH-1:ID_WIDTH]),
        .rdata_m_inf(rdata_m_inf[2*DATA_WIDTH-1:DATA_WIDTH]),
        .rresp_m_inf(rresp_m_inf[3:2]),
        .rlast_m_inf(rlast_m_inf[1]),
       .rvalid_m_inf(rvalid_m_inf[1]),
       .rready_m_inf(rready_m_inf[1]) 

);
//==============================================//
//            DRAM dealer control               //
//              cache filling                   //
//==============================================//
always @(posedge clk or negedge rst_n) begin
  if(!rst_n)begin
    one_for_w_zero_for_r_dff <= 0;
    
  end
  else begin
    one_for_w_zero_for_r_dff <= one_for_w_zero_for_r;
  end
end
always @(posedge clk or negedge rst_n) begin
  if(!rst_n)begin
    counter_128 <= 0;
  end
  else begin
    if(cur_state == Inst_DRAM)begin
      if(Inst_DRAM_out_valid_sram)
        counter_128 <= counter_128 + 1;
      else
        counter_128 <= counter_128;
    end
    else if(cur_state == Data_DRAM)begin
      if(Data_DRAM_out_valid_sram)
        counter_128 <= counter_128 + 1;
      else
        counter_128 <= counter_128;
    end
    else 
      counter_128 <= 0;
    
  end
end
always @(posedge clk or negedge rst_n) begin
  if(!rst_n)begin
    My_Data_DRAM_addr_dff <= 0;
  end
  else begin
    My_Data_DRAM_addr_dff <= My_Data_DRAM_addr;
  end
end
always @(*) begin
  if(cur_state == Inst_Fetch)begin
    if(Inst_init == 0 || hit_dff == 0)begin
      Inst_DRAM_in_valid = 1;
    end
    else begin
      Inst_DRAM_in_valid = 0;
    end
  end
  else begin
    Inst_DRAM_in_valid = 0;
  end
end
always @(posedge clk or negedge rst_n) begin
  if(!rst_n)begin
    Data_DRAM_in_valid_dff <= 0;
  end
  else begin
    Data_DRAM_in_valid_dff <= Data_DRAM_in_valid;
  end
end
always @(*) begin
  if(cur_state == Data_Find)begin
    if(data_hit == 0 || Data_init == 0 || one_for_w_zero_for_r)begin
      Data_DRAM_in_valid = 1;
    end
    else begin
      Data_DRAM_in_valid = 0;
    end
  end
  else begin
    Data_DRAM_in_valid = 0;
  end
end
always @(*) begin
  case(cur_state)
    Init:begin
      if(!Inst_init)begin
        sram_w_r = 0;
      end
      else begin
        sram_w_r = 1;
      end
    end
    Inst_DRAM:begin
      if(Inst_DRAM_out_valid_sram)begin
        sram_w_r = 0;
      end
      else begin
        sram_w_r = 1;
      end
    end
    Data_Find:begin
      sram_w_r = !(one_for_w_zero_for_r && data_hit);
    end
    Data_DRAM:begin
      if(Data_DRAM_out_valid_sram)begin
        sram_w_r = 0;
      end
      else begin
        sram_w_r = 1;
      end
    end
    default:sram_w_r = 1;
  endcase
end
always @(*) begin
  if(cur_state == Init)begin
    if(!Inst_init )begin
      sram_addr = {1'b0, PC_dff};
      //sram_w_r = 0;
    end
    else begin
      sram_addr = {1'b0, PC_dff};
      //sram_w_r = 1;
    end
  end
  else if(cur_state == Inst_DRAM)begin
    sram_addr = {1'b0,counter_128};
    // if(Inst_DRAM_out_valid_sram)
    //   sram_w_r = 0;
    // else
    //   sram_w_r = 1;
  end
  else if(cur_state == Data_Find)begin
    sram_addr = {1'b1, My_Data_DRAM_addr[7:1]};
   // sram_w_r = !(one_for_w_zero_for_r && data_hit);
  end
  else if(cur_state == Data_DRAM)begin
    sram_addr = {1'b1, counter_128};
    // if(Data_DRAM_out_valid_sram)begin
    //   sram_w_r = 0;
    // end
    // else begin
    //   sram_w_r = 1;
    // end
  end
  else begin
    sram_addr = {1'b0, PC_dff};
    //sram_w_r = 1;
  end
end

assign Inst_DRAM_addr = My_Inst_DRAM_addr_dff;
assign Data_DRAM_addr = My_Data_DRAM_addr_dff;
assign data_write = store_out;
always @(*) begin
  if(cur_state == Inst_DRAM)begin
    if(Inst_DRAM_out_valid_sram)begin
      sram_in_data = Inst_from_DRAM;
    end
    else begin
      sram_in_data = 0;
    end
  end
  else if(cur_state == Data_Find && one_for_w_zero_for_r)begin
    sram_in_data = store_out;
  end
  else if(cur_state == Data_DRAM)begin
    if(Data_DRAM_out_valid_sram)begin
      sram_in_data = DRAM_out_data;
    end
    else begin
      sram_in_data = 0;
    end
  end
  else begin
    sram_in_data = 0;
  end
end
//==============================================//
//              FSM                             //
//==============================================//
always @(posedge clk or negedge rst_n) begin
  if(!rst_n)begin
    cur_state <= 0;
  end
  else begin
    cur_state <= next_state;
  end
end
always @(*) begin
  if(cur_state == Init)begin
    next_state = Inst_Fetch;
  end
  else if(cur_state == Inst_Fetch)begin
    if(!Inst_init)begin
      next_state = Inst_DRAM;
    end
    else if(hit_dff)begin
      next_state = Hit;
    end
    else begin
      next_state = Inst_DRAM;
    end
  end
  else if(cur_state == Inst_DRAM)begin
    if(Inst_DRAM_out_valid)begin
      if(Inst_from_DRAM[15:13] == 3'b100 || Inst_from_DRAM[15:13] == 3'b101)begin
        next_state = Jump;
      end
      else if(Inst_from_DRAM[15:13] == 3'b010 || Inst_from_DRAM[15:13] == 3'b011)begin
        next_state = Data_Find;
      end
      else begin
        next_state = Exe;
      end
    end
    else begin
      next_state = Inst_DRAM;
    end
  end
  else if(cur_state == Hit)begin
    if(opcode[3:1] == 3'b100 || opcode[3:1] == 3'b101)begin
        next_state = Jump;
    end
    else if(opcode[3:1] == 3'b010 || opcode[3:1] == 3'b011)begin
      next_state = Data_Find;
    end
    else begin
      next_state = Exe;
    end
  end
  else if(cur_state == Exe)begin
    if(opcode[1:0] == 2'b11)begin
      next_state = mult;
    end
    else begin
      next_state = Init;
    end
  end
  else if(cur_state == mult)begin
    next_state = Init;
  end
  else if(cur_state == Data_Find)begin
    if(!Data_init)begin
      next_state = Data_DRAM;
    end
    else if(data_hit && one_for_w_zero_for_r == 0)begin
      next_state = Data_Hit;
    end
    else begin
      next_state = Data_DRAM;
    end
  end
  else if(cur_state == Jump)begin
    next_state = Init;
  end
  else if(cur_state == Data_Hit)begin
    next_state = Init;
  end
  else begin
    if(Data_DRAM_out_valid)
      next_state = Init;
    else
      next_state = Data_DRAM;
  end
end
//=============================================//
//          instruction fetch                  //
//=============================================//
always @(posedge clk or negedge rst_n) begin
  if(!rst_n)begin
    instruction <= 0;
    Inst_init <= 0;
  end
  else begin
    if(cur_state == Inst_Fetch)begin
      if(hit_dff)
        instruction <= sram_out_data;
      else
        instruction <= instruction;
      Inst_init <= Inst_init;
    end
    else if(cur_state == Inst_DRAM)begin
      Inst_init <= 1;
      if(Inst_DRAM_out_valid)begin
        instruction <= Inst_from_DRAM; 
      end
      else begin
        instruction <= instruction;
      end
    end
    else begin
      instruction <= instruction;
      Inst_init <= Inst_init;
    end
  end
end

always @(posedge clk or negedge rst_n) begin
  if(!rst_n)begin
    Data_init <= 0;
  end
  else begin
    if(cur_state == Data_Find && !one_for_w_zero_for_r)begin
      Data_init <= 1;
    end
    else begin
      Data_init <= Data_init;
    end
  end
end

assign opcode = {instruction[15:13], instruction[0]};
assign rs = instruction[12:9];
assign rt = instruction[8:5];
assign rd = instruction[4:1];
assign immediate = instruction[4:0];
assign JUMP = instruction[12:0];

//==============================================//
//            Inst DRAM & SRAM addr             //
//==============================================//
always @(posedge clk or negedge rst_n) begin
  if(!rst_n)begin
    My_Inst_DRAM_addr_dff <= 'h1000;
    PC_dff <= 0;
    hit_dff <= 0;
    save_Inst_hit_addr_dff <= 4'b0000;
  end
  else begin
    My_Inst_DRAM_addr_dff <= My_Inst_DRAM_addr;
    PC_dff <= PC;
    hit_dff <= hit; 
    save_Inst_hit_addr_dff <= save_Inst_hit_addr;
  end
end
always @(*) begin
  if(cur_state == Inst_DRAM)begin
    save_Inst_hit_addr = My_Inst_DRAM_addr_dff[11:8];
  end
  else begin
    save_Inst_hit_addr = save_Inst_hit_addr_dff;
  end
end
always @(*) begin
  if(cur_state == Exe || cur_state == Data_Find)begin
    My_Inst_DRAM_addr = My_Inst_DRAM_addr_dff + 2;
  end
  else if(cur_state == Jump)begin
    My_Inst_DRAM_addr = My_Inst_DRAM_addr_dff + 2 + 2 * immediate;
    if(opcode[1] == 0)begin
      if(rs_data != rt_data)begin
        My_Inst_DRAM_addr = My_Inst_DRAM_addr_dff + 2;
      end
    end
    else begin
      My_Inst_DRAM_addr = JUMP[11:0];
    end
  end
  else begin
    My_Inst_DRAM_addr = My_Inst_DRAM_addr_dff;
  end
end

assign PC = My_Inst_DRAM_addr[7:1];

always @(*) begin
  if(cur_state == Exe || cur_state == Data_Find )begin
    if(My_Inst_DRAM_addr_dff[7:1] == 127)begin
      hit = 0;
    end
    else begin
      hit = 1;
    end
  end
  else if(cur_state == Jump)begin
    if(My_Inst_DRAM_addr[11:8] != save_Inst_hit_addr_dff)begin
      hit = 0;
    end
    else begin
      hit = 1;
    end
  end
  else begin
    hit = hit_dff;
  end
end

//=================================================//
//                Exe Data_Find                    //
//=================================================//

// assign rs_data = core_dff[rs];
// assign rt_data = core_dff[rt];
always @(*) begin
  case(rs)
    4'd0:rs_data = core_r0;
    4'd1:rs_data = core_r1;
    4'd2:rs_data = core_r2;
    4'd3:rs_data = core_r3;
    4'd4:rs_data = core_r4;
    4'd5:rs_data = core_r5;
    4'd6:rs_data = core_r6;
    4'd7:rs_data = core_r7;
    4'd8:rs_data = core_r8;
    4'd9:rs_data = core_r9;
    4'd10:rs_data = core_r10;
    4'd11:rs_data = core_r11;
    4'd12:rs_data = core_r12;
    4'd13:rs_data = core_r13;
    4'd14:rs_data = core_r14;
    4'd15:rs_data = core_r15;
  endcase
end
always @(*) begin
  case(rt)
    4'd0:rt_data = core_r0;
    4'd1:rt_data = core_r1;
    4'd2:rt_data = core_r2;
    4'd3:rt_data = core_r3;
    4'd4:rt_data = core_r4;
    4'd5:rt_data = core_r5;
    4'd6:rt_data = core_r6;
    4'd7:rt_data = core_r7;
    4'd8:rt_data = core_r8;
    4'd9:rt_data = core_r9;
    4'd10:rt_data = core_r10;
    4'd11:rt_data = core_r11;
    4'd12:rt_data = core_r12;
    4'd13:rt_data = core_r13;
    4'd14:rt_data = core_r14;
    4'd15:rt_data = core_r15;
  endcase
end
assign add_out = rs_data + rt_data;
assign sub_out = rs_data - rt_data;
reg signed [31:0] IP_mult_out;
DW02_mult_2_stage #(16,16) M1(.A(rs_data), .B(rt_data), .TC(1'b1), .CLK(clk), .PRODUCT(IP_mult_out));
assign mult_out = IP_mult_out[15:0];
assign compout = (rs_data < rt_data) ? 1 : 0;
assign store_out = rt_data;
assign Data_addr_cal = (rs_data + immediate) * 2 + $signed('h1000);
assign My_Data_DRAM_addr = Data_addr_cal;
assign one_for_w_zero_for_r = (opcode[1] == 1) ? 1 : 0;

always @(*) begin
  if(cur_state == Data_Hit)begin
    load_out = sram_out_data;
  end
  else if(cur_state == Data_DRAM)begin
    if(Data_DRAM_out_valid)begin
      load_out = DRAM_out_data;
    end
    else begin
      load_out = 0;
    end
  end
  else begin
    load_out = 0;
  end
end

always @(*) begin
  case(opcode[1:0])
    2'b00:Exe_out = add_out;
    2'b01:Exe_out = sub_out;
    2'b10:Exe_out = compout;
    default:Exe_out = compout;
  endcase
end

always @(posedge clk or negedge rst_n) begin
  if(!rst_n)begin
    core_r0 <= 0;
  end
  else begin
    if(cur_state == Exe && rd == 0)begin
      core_r0 <= Exe_out;
    end
    else if(cur_state == mult && rd == 0)begin
      core_r0 <= mult_out;
    end
    else if((cur_state == Data_DRAM) && rt == 0 && !one_for_w_zero_for_r && Data_DRAM_out_valid)begin
      core_r0 <= load_out;
    end
    else if(cur_state == Data_Hit && rt == 0 && !one_for_w_zero_for_r )begin
      core_r0 <= load_out;
    end
    else begin
      core_r0 <= core_r0;
    end
  end
end

always @(posedge clk or negedge rst_n) begin
  if(!rst_n)begin
    core_r1 <= 0;
  end
  else begin
    if(cur_state == Exe && rd == 1)begin
      core_r1 <= Exe_out;
    end
    else if(cur_state == mult && rd == 1)begin
      core_r1 <= mult_out;
    end
    else if((cur_state == Data_DRAM ) && rt == 1 && !one_for_w_zero_for_r && Data_DRAM_out_valid)begin
      core_r1 <= load_out;
    end
    else if(cur_state == Data_Hit && rt == 1 && !one_for_w_zero_for_r )begin
      core_r1 <= load_out;
    end
    else begin
      core_r1 <= core_r1;
    end
  end
end

always @(posedge clk or negedge rst_n) begin
  if(!rst_n)begin
    core_r2 <= 0;
  end
  else begin
    if(cur_state == Exe && rd == 2)begin
      core_r2 <= Exe_out;
    end
    else if(cur_state == mult && rd == 2)begin
      core_r2 <= mult_out;
    end
    else if((cur_state == Data_DRAM ) && rt == 2 && !one_for_w_zero_for_r && Data_DRAM_out_valid)begin
      core_r2 <= load_out;
    end
    else if(cur_state == Data_Hit && rt == 2 && !one_for_w_zero_for_r )begin
      core_r2 <= load_out;
    end
    else begin
      core_r2 <= core_r2;
    end
  end
end

always @(posedge clk or negedge rst_n) begin
  if(!rst_n)begin
    core_r3 <= 0;
  end
  else begin
    if(cur_state == Exe && rd == 3)begin
      core_r3 <= Exe_out;
    end
    else if(cur_state == mult && rd == 3)begin
      core_r3 <= mult_out;
    end
    else if((cur_state == Data_DRAM ) && rt == 3 && !one_for_w_zero_for_r && Data_DRAM_out_valid)begin
      core_r3 <= load_out;
    end
    else if(cur_state == Data_Hit && rt == 3 && !one_for_w_zero_for_r )begin
      core_r3 <= load_out;
    end
    else begin
      core_r3 <= core_r3;
    end
  end
end

always @(posedge clk or negedge rst_n) begin
  if(!rst_n)begin
    core_r4 <= 0;
  end
  else begin
    if(cur_state == Exe && rd == 4)begin
      core_r4 <= Exe_out;
    end
    else if(cur_state == mult && rd == 4)begin
      core_r4 <= mult_out;
    end
    else if((cur_state == Data_DRAM ) && rt == 4 && !one_for_w_zero_for_r && Data_DRAM_out_valid)begin
      core_r4 <= load_out;
    end
    else if(cur_state == Data_Hit && rt == 4 && !one_for_w_zero_for_r )begin
      core_r4 <= load_out;
    end
    else begin
      core_r4 <= core_r4;
    end
  end
end

always @(posedge clk or negedge rst_n) begin
  if(!rst_n)begin
    core_r5 <= 0;
  end
  else begin
    if(cur_state == Exe && rd == 5)begin
      core_r5 <= Exe_out;
    end
    else if(cur_state == mult && rd == 5)begin
      core_r5 <= mult_out;
    end
    else if((cur_state == Data_DRAM ) && rt == 5 && !one_for_w_zero_for_r && Data_DRAM_out_valid)begin
      core_r5 <= load_out;
    end
    else if(cur_state == Data_Hit && rt == 5 && !one_for_w_zero_for_r )begin
      core_r5 <= load_out;
    end
    else begin
      core_r5 <= core_r5;
    end
  end
end

always @(posedge clk or negedge rst_n) begin
  if(!rst_n)begin
    core_r6 <= 0;
  end
  else begin
    if(cur_state == Exe && rd == 6)begin
      core_r6 <= Exe_out;
    end
    else if(cur_state == mult && rd == 6)begin
      core_r6 <= mult_out;
    end
    else if((cur_state == Data_DRAM ) && rt == 6 && !one_for_w_zero_for_r && Data_DRAM_out_valid)begin
      core_r6 <= load_out;
    end
    else if(cur_state == Data_Hit && rt == 6 && !one_for_w_zero_for_r )begin
      core_r6 <= load_out;
    end
    else begin
      core_r6 <= core_r6;
    end
  end
end

always @(posedge clk or negedge rst_n) begin
  if(!rst_n)begin
    core_r7 <= 0;
  end
  else begin
    if(cur_state == Exe && rd == 7)begin
      core_r7 <= Exe_out;
    end
    else if(cur_state == mult && rd == 7)begin
      core_r7 <= mult_out;
    end
    else if((cur_state == Data_DRAM ) && rt == 7 && !one_for_w_zero_for_r && Data_DRAM_out_valid)begin
      core_r7 <= load_out;
    end
    else if(cur_state == Data_Hit && rt == 7 && !one_for_w_zero_for_r )begin
      core_r7 <= load_out;
    end
    else begin
      core_r7 <= core_r7;
    end
  end
end

always @(posedge clk or negedge rst_n) begin
  if(!rst_n)begin
    core_r8 <= 0;
  end
  else begin
    if(cur_state == Exe && rd == 8)begin
      core_r8 <= Exe_out;
    end
    else if(cur_state == mult && rd == 8)begin
      core_r8 <= mult_out;
    end
    else if((cur_state == Data_DRAM || cur_state == Data_Hit) && rt == 8 && !one_for_w_zero_for_r && Data_DRAM_out_valid)begin
      core_r8 <= load_out;
    end
    else if(cur_state == Data_Hit && rt == 8 && !one_for_w_zero_for_r )begin
      core_r8 <= load_out;
    end
    else begin
      core_r8 <= core_r8;
    end
  end
end
always @(posedge clk or negedge rst_n) begin
  if(!rst_n)begin
    core_r9 <= 0;
  end
  else begin
    if(cur_state == Exe && rd == 9)begin
      core_r9 <= Exe_out;
    end
    else if(cur_state == mult && rd == 9)begin
      core_r9 <= mult_out;
    end
    else if((cur_state == Data_DRAM ) && rt == 9 && !one_for_w_zero_for_r && Data_DRAM_out_valid)begin
      core_r9 <= load_out;
    end
    else if(cur_state == Data_Hit && rt == 9 && !one_for_w_zero_for_r )begin
      core_r9 <= load_out;
    end
    else begin
      core_r9 <= core_r9;
    end
  end
end
always @(posedge clk or negedge rst_n) begin
  if(!rst_n)begin
    core_r10 <= 0;
  end
  else begin
    if(cur_state == Exe && rd == 10)begin
      core_r10 <= Exe_out;
    end
    else if(cur_state == mult && rd == 10)begin
      core_r10 <= mult_out;
    end
    else if((cur_state == Data_DRAM ) && rt == 10 && !one_for_w_zero_for_r && Data_DRAM_out_valid)begin
      core_r10 <= load_out;
    end
    else if(cur_state == Data_Hit && rt == 10 && !one_for_w_zero_for_r )begin
      core_r10 <= load_out;
    end
    else begin
      core_r10 <= core_r10;
    end
  end
end
always @(posedge clk or negedge rst_n) begin
  if(!rst_n)begin
    core_r11 <= 0;
  end
  else begin
    if(cur_state == Exe && rd == 11)begin
      core_r11 <= Exe_out;
    end
    else if(cur_state == mult && rd == 11)begin
      core_r11 <= mult_out;
    end
    else if((cur_state == Data_DRAM ) && rt == 11 && !one_for_w_zero_for_r && Data_DRAM_out_valid)begin
      core_r11 <= load_out;
    end
    else if(cur_state == Data_Hit && rt == 11 && !one_for_w_zero_for_r )begin
      core_r11 <= load_out;
    end
    else begin
      core_r11 <= core_r11;
    end
  end
end
always @(posedge clk or negedge rst_n) begin
  if(!rst_n)begin
    core_r12 <= 0;
  end
  else begin
    if(cur_state == Exe && rd == 12)begin
      core_r12 <= Exe_out;
    end
    else if(cur_state == mult && rd == 12)begin
      core_r12 <= mult_out;
    end
    else if((cur_state == Data_DRAM ) && rt == 12 && !one_for_w_zero_for_r && Data_DRAM_out_valid)begin
      core_r12 <= load_out;
    end
    else if(cur_state == Data_Hit && rt == 12 && !one_for_w_zero_for_r )begin
      core_r12 <= load_out;
    end
    else begin
      core_r12 <= core_r12;
    end
  end
end
always @(posedge clk or negedge rst_n) begin
  if(!rst_n)begin
    core_r13 <= 0;
  end
  else begin
    if(cur_state == Exe && rd == 13)begin
      core_r13 <= Exe_out;
    end
    else if(cur_state == mult && rd == 13)begin
      core_r13 <= mult_out;
    end
    else if((cur_state == Data_DRAM ) && rt == 13 && !one_for_w_zero_for_r && Data_DRAM_out_valid)begin
      core_r13 <= load_out;
    end
    else if(cur_state == Data_Hit && rt == 13 && !one_for_w_zero_for_r )begin
      core_r13 <= load_out;
    end
    else begin
      core_r13 <= core_r13;
    end
  end
end
always @(posedge clk or negedge rst_n) begin
  if(!rst_n)begin
    core_r14 <= 0;
  end
  else begin
    if(cur_state == Exe && rd == 14)begin
      core_r14 <= Exe_out;
    end
    else if(cur_state == mult && rd == 14)begin
      core_r14 <= mult_out;
    end
    else if((cur_state == Data_DRAM ) && rt == 14 && !one_for_w_zero_for_r && Data_DRAM_out_valid)begin
      core_r14 <= load_out;
    end
    else if(cur_state == Data_Hit && rt == 14 && !one_for_w_zero_for_r )begin
      core_r14 <= load_out;
    end
    else begin
      core_r14 <= core_r14;
    end
  end
end
always @(posedge clk or negedge rst_n) begin
  if(!rst_n)begin
    core_r15 <= 0;
  end
  else begin
    if(cur_state == Exe && rd == 15)begin
      core_r15 <= Exe_out;
    end
    else if(cur_state == mult && rd == 15)begin
      core_r15 <= mult_out;
    end
    else if(cur_state == Data_DRAM  && rt == 15 && !one_for_w_zero_for_r && Data_DRAM_out_valid)begin
      core_r15 <= load_out;
    end
    else if(cur_state == Data_Hit && rt == 15 && !one_for_w_zero_for_r )begin
      core_r15 <= load_out;
    end
    else begin
      core_r15 <= core_r15;
    end
  end
end
//=============================================//
//          Data DRAM addr                     //
//=============================================//
always @(posedge clk or negedge rst_n) begin
  if(!rst_n)begin
    save_Data_hit_addr_dff <= 0;
    data_hit_dff <= 0;
  end
  else begin
    data_hit_dff <= data_hit;
    save_Data_hit_addr_dff <= save_Data_hit_addr;
  end
end
always @(*) begin
  if(cur_state == Data_Find)begin
    if(Data_addr_cal[11:8] != save_Data_hit_addr_dff[3:0])begin
      data_hit = 0;
    end
    else begin
      data_hit = 1;
    end
  end
  else begin
    data_hit = data_hit_dff;
  end
end
always @(*) begin
  if(cur_state == Data_DRAM)begin
    if(!one_for_w_zero_for_r)
      save_Data_hit_addr = Data_addr_cal[11:8];
    else
      save_Data_hit_addr = save_Data_hit_addr_dff;
  end
  else begin
    save_Data_hit_addr = save_Data_hit_addr_dff;
  end
end
//====================================================//
//            IOstall                                 //
//====================================================//
always @(posedge clk or negedge rst_n) begin
  if(!rst_n)begin
    IO_stall <= 1;
  end
  else begin
    if(next_state == Init)begin
      IO_stall <= 0;
    end
    else begin
      IO_stall <= 1;
    end
  end
end
endmodule


module Inst_DRAM_dealer(
        clk,
        rst_n,
        in_valid,
        Inst_DRAM_addr,
        out_valid,
        out_valid_sram,
        out_inst,
                    
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
       rready_m_inf 

);
    input clk, rst_n, in_valid;
    input [11:0] Inst_DRAM_addr;
    output reg out_valid, out_valid_sram; // out_valid for instruction fetch in DRAM and used immediately
    //out_valid_sram for filling cache
    output reg [15:0] out_inst;
    parameter ID_WIDTH = 4 , ADDR_WIDTH = 32, DATA_WIDTH = 16, DRAM_NUMBER = 1;

    // -----------------------------
    // axi read address channel 
    output  reg [DRAM_NUMBER * ID_WIDTH-1:0]       arid_m_inf;
    output  reg [DRAM_NUMBER * ADDR_WIDTH-1:0]   araddr_m_inf;
    output  reg [DRAM_NUMBER * 7 -1:0]            arlen_m_inf;
    output  reg [DRAM_NUMBER * 3 -1:0]           arsize_m_inf;
    output  reg [DRAM_NUMBER * 2 -1:0]          arburst_m_inf;
    output  reg [DRAM_NUMBER-1:0]               arvalid_m_inf;
    input   reg [DRAM_NUMBER-1:0]               arready_m_inf;
    // -----------------------------
    // axi read data channel 
    input   reg [DRAM_NUMBER * ID_WIDTH-1:0]         rid_m_inf;
    input   reg [DRAM_NUMBER * DATA_WIDTH-1:0]     rdata_m_inf;
    input   reg [DRAM_NUMBER * 2 -1:0]             rresp_m_inf;
    input   reg [DRAM_NUMBER-1:0]                  rlast_m_inf;
    input   reg [DRAM_NUMBER-1:0]                 rvalid_m_inf;
    output  reg [DRAM_NUMBER-1:0]                 rready_m_inf;

    //axi signal setting
    assign arid_m_inf = 'd0;
    assign arlen_m_inf = 7'd127;
    assign arsize_m_inf = 3'b001;
    assign arburst_m_inf = 2'b01;
    //===================================================//
    //                  parameter                        //
    //===================================================//
    parameter IDLE =      2'd0;
    parameter DRAM_ADDR = 2'd1;
    parameter DRAM_DATA = 2'd2;
    parameter OUT =       2'd3;
    //===================================================//
    //                  reg declaration                  //
    //===================================================//
    reg [1:0] cur_state, next_state;
    reg [15:0] out_inst_dff; // for output the instruction needed immediately
    reg [6:0] counter_128; // for count the result and find the instruction needed immediately
    reg [11:0] Inst_DRAM_addr_dff;
    //===================================================//
    //            AXI signal contralled by FSM           //
    //===================================================//
    assign araddr_m_inf = (cur_state == DRAM_ADDR) ? {20'h0001 , Inst_DRAM_addr_dff[11:8] , 8'd0} : 0;
    assign arvalid_m_inf = (cur_state == DRAM_ADDR) ? 1 : 0;
    assign rready_m_inf =  (cur_state == DRAM_DATA) ? 1 : 0;

    //===================================================//
    //            save the instruction needed            //
    //===================================================//
    always @(posedge clk or negedge rst_n) begin
      if(!rst_n)begin
        out_inst_dff <= 0;
      end
      else begin
        if(rvalid_m_inf && counter_128 == Inst_DRAM_addr[7:1])begin // last bit of Inst_DRAM_addr should always be zero 
          out_inst_dff <= rdata_m_inf;                              // ex: counter_128 == 0 fetch XXX0 & XXX1 at the same time
        end
        else begin
          out_inst_dff <= out_inst_dff;
        end
      end
    end
    always @(posedge clk or negedge rst_n) begin
      if(!rst_n)begin
        Inst_DRAM_addr_dff <= 0;
      end
      else begin
        if(in_valid)begin
          Inst_DRAM_addr_dff <= Inst_DRAM_addr;
        end
        else begin
          Inst_DRAM_addr_dff <= Inst_DRAM_addr;
        end
      end
    end
    //===================================================//
    //                  counter                          //
    //===================================================//
    always @(posedge clk or negedge rst_n) begin
      if(!rst_n)begin
        counter_128 <= 0;
      end
      else begin
        if(rvalid_m_inf)begin
          counter_128 <= counter_128 + 1;
        end
        else begin
          counter_128 <= counter_128; // automatically go back to zero
        end
      end
    end
    //===================================================//
    //                    FSM                            //
    //===================================================//
  
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)begin
            cur_state <= 0;
        end
        else begin
            cur_state <= next_state;
        end
    end
  
    always @(*) begin
        if(cur_state == IDLE)begin
            if(in_valid)begin
              next_state = DRAM_ADDR;
            end          
            else begin
              next_state = IDLE;
            end
        end
        else if(cur_state == DRAM_ADDR)begin
          if(arready_m_inf)begin
            next_state = DRAM_DATA;
          end
          else begin
            next_state = DRAM_ADDR;
          end
        end 
        else if(cur_state == DRAM_DATA)begin
          if(rlast_m_inf)begin
            next_state = OUT;
          end
          else begin
            next_state = DRAM_DATA;
          end
        end
        else begin
            next_state = IDLE;
        end
    end
    //==============================================//
    //         filling cache & output data          //
    //==============================================//
    // always @(*) begin
    //   if(cur_state == DRAM_DATA)begin
    //     if(rvalid_m_inf)begin
    //       out_valid_sram = 1;
    //     end
    //     else begin
    //       out_valid_sram = 0;
    //     end
    //   end
    //   else begin
    //     out_valid_sram = 0;
    //   end
    // end
    always @(posedge clk or negedge rst_n) begin
      if(!rst_n)begin
        out_valid_sram <= 0;
      end
      else begin
        if(cur_state == DRAM_DATA)begin
          if(rvalid_m_inf)
            out_valid_sram <= 1;
          else
            out_valid_sram <= 0;
        end
        else 
          out_valid_sram <= 0;
      end
    end
    always @(posedge clk or negedge rst_n) begin
      if(!rst_n)begin
        out_inst <= 0;
        out_valid <= 0;
      end
      else begin
        if(cur_state == OUT)begin
          out_valid <= 1;
          out_inst <= out_inst_dff;
        end
        else if(cur_state == DRAM_DATA)begin
          if(rvalid_m_inf)
            out_inst <= rdata_m_inf;
          else
            out_inst <= 0;

          out_valid <= 0;
        end
        else begin
          out_inst <= 0;
          out_valid <= 0;
        end
      end
    end
    // always @(*) begin
    //   if(cur_state == OUT)begin
    //     out_valid = 1;
    //     out_inst = out_inst_dff;
    //   end
    //   else if(cur_state == DRAM_DATA)begin
    //     out_valid = 0;
    //     if(rvalid_m_inf)begin
    //       out_inst = rdata_m_inf;
    //     end
    //     else begin
    //       out_inst = 0;
    //     end
    //   end
    //   else begin
    //     out_valid = 0;
    //     out_inst = 0;
    //   end
    //end
endmodule
module Data_DRAM_dealer(
    clk, rst_n, in_valid, out_valid, out_valid_sram, one_for_w_zero_for_r,
    Data_DRAM_addr, data_write, out_data,
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
       bready_m_inf,
                    
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
       rready_m_inf 
);
    input clk, rst_n, in_valid, one_for_w_zero_for_r;
    input [11:0] Data_DRAM_addr ;
    input [15:0] data_write;
    output reg [15:0] out_data;
    output reg out_valid, out_valid_sram;

    parameter ID_WIDTH = 4 , ADDR_WIDTH = 32, DATA_WIDTH = 16, DRAM_NUMBER = 1, WRIT_NUMBER = 1;
    // axi write address channel 
    output  wire [WRIT_NUMBER * ID_WIDTH-1:0]        awid_m_inf;
    output  wire [WRIT_NUMBER * ADDR_WIDTH-1:0]    awaddr_m_inf;
    output  wire [WRIT_NUMBER * 3 -1:0]            awsize_m_inf;
    output  wire [WRIT_NUMBER * 2 -1:0]           awburst_m_inf;
    output  wire [WRIT_NUMBER * 7 -1:0]             awlen_m_inf;
    output  wire [WRIT_NUMBER-1:0]                awvalid_m_inf;
    input   wire [WRIT_NUMBER-1:0]                awready_m_inf;
    // axi write data channel 
    output  wire [WRIT_NUMBER * DATA_WIDTH-1:0]     wdata_m_inf;
    output  wire [WRIT_NUMBER-1:0]                  wlast_m_inf;
    output  wire [WRIT_NUMBER-1:0]                 wvalid_m_inf;
    input   wire [WRIT_NUMBER-1:0]                 wready_m_inf;
    // axi write response channel
    input   wire [WRIT_NUMBER * ID_WIDTH-1:0]         bid_m_inf;
    input   wire [WRIT_NUMBER * 2 -1:0]             bresp_m_inf;
    input   wire [WRIT_NUMBER-1:0]             	   bvalid_m_inf;
    output  wire [WRIT_NUMBER-1:0]                 bready_m_inf;
    // -----------------------------
    // axi read address channel 
    output  wire [DRAM_NUMBER * ID_WIDTH-1:0]       arid_m_inf;
    output  wire [DRAM_NUMBER * ADDR_WIDTH-1:0]   araddr_m_inf;
    output  wire [DRAM_NUMBER * 7 -1:0]            arlen_m_inf;
    output  wire [DRAM_NUMBER * 3 -1:0]           arsize_m_inf;
    output  wire [DRAM_NUMBER * 2 -1:0]          arburst_m_inf;
    output  wire [DRAM_NUMBER-1:0]               arvalid_m_inf;
    input   wire [DRAM_NUMBER-1:0]               arready_m_inf;
    // -----------------------------
    // axi read data channel 
    input   wire [DRAM_NUMBER * ID_WIDTH-1:0]         rid_m_inf;
    input   wire [DRAM_NUMBER * DATA_WIDTH-1:0]     rdata_m_inf;
    input   wire [DRAM_NUMBER * 2 -1:0]             rresp_m_inf;
    input   wire [DRAM_NUMBER-1:0]                  rlast_m_inf;
    input   wire [DRAM_NUMBER-1:0]                 rvalid_m_inf;
    output  wire [DRAM_NUMBER-1:0]                 rready_m_inf;

    // axi signal setting
    // write
    assign awid_m_inf = 'd0;
    assign awsize_m_inf = 3'b001;
    assign awburst_m_inf = 2'b01;
    assign awlen_m_inf = 7'd0;

    //read 
    assign arid_m_inf = 'd0;
    assign arsize_m_inf = 3'b001;
    assign arburst_m_inf = 2'b01;
    assign arlen_m_inf = 7'd127;

    //====================================//
    //            parameter               //
    //====================================//
    parameter IDLE =   3'd0;
    parameter R_ADDR = 3'd1;
    parameter R_DATA = 3'd2;
    parameter W_ADDR = 3'd3;
    parameter W_DATA = 3'd4;
    parameter WAIT   = 3'd5;
    parameter OUT =    3'd6;
    //====================================//
    //        reg declaration             //
    //====================================//
    reg [2:0] cur_state , next_state;
    reg one_for_w_zero_for_r_dff;
    reg [15:0] out_data_dff; // for data needed immediately
    reg [15:0] in_data_dff;
    reg [6:0] counter_128;
    reg [11:0] Data_DRAM_addr_dff;
    //====================================//
    //         input register             //
    //====================================//
    always @(posedge clk or negedge rst_n) begin
      if(!rst_n)begin
        one_for_w_zero_for_r_dff <= 0;
        in_data_dff <= 0;
        Data_DRAM_addr_dff <= 0;
      end
      else begin
        if(in_valid)begin
          in_data_dff <= data_write;
          one_for_w_zero_for_r_dff <= one_for_w_zero_for_r;
          Data_DRAM_addr_dff <= Data_DRAM_addr;
        end
        else begin
          in_data_dff <= in_data_dff;
          one_for_w_zero_for_r_dff <= one_for_w_zero_for_r_dff;
          Data_DRAM_addr_dff <= Data_DRAM_addr_dff;
        end
      end
    end
    
    //===================================//
    //            counter                //
    //===================================//
    always @(posedge clk or negedge rst_n) begin
      if(!rst_n)begin
        counter_128 <= 0;
      end
      else begin
        if(rvalid_m_inf)begin
          counter_128 <= counter_128 + 1;
        end
        else begin
          counter_128 <= counter_128; // automatically go back to zero
        end
      end
    end
    //====================================//
    //      for needed data reg           //
    //====================================//
    always @(posedge clk or negedge rst_n) begin
      if(!rst_n)begin
        out_data_dff <= 0;
      end
      else begin
        if(rvalid_m_inf)begin
          if(counter_128 == Data_DRAM_addr[7:1])begin
            out_data_dff <= rdata_m_inf;
          end
          else begin
            out_data_dff <= out_data_dff;
          end
        end
        else begin
          out_data_dff <= out_data_dff;
        end
      end
    end
    //====================================//
    //          AXI signal                //
    //====================================//
    assign arvalid_m_inf = (cur_state == R_ADDR) ? 1 : 0;
    assign rready_m_inf = (cur_state == R_DATA) ? 1 : 0;
    assign araddr_m_inf = (cur_state == R_ADDR) ? {20'h0001, Data_DRAM_addr_dff[11:8], 8'd0} : 0;
    
    assign awaddr_m_inf = (cur_state == W_ADDR) ? {20'h0001, Data_DRAM_addr_dff} : 0;
    assign awvalid_m_inf = (cur_state == W_ADDR) ? 1 : 0;
    assign wdata_m_inf = (cur_state == W_DATA) ? in_data_dff : 0;
    assign wlast_m_inf = (cur_state == W_DATA) ? 1 : 0;
    assign wvalid_m_inf = (cur_state == W_DATA) ? 1 : 0;

    assign bready_m_inf = (cur_state == WAIT) ? 1 : 0;
    //====================================//
    //            FSM                     //
    //====================================//
    always @(posedge clk or negedge rst_n) begin
      if(!rst_n)begin
        cur_state <= 0;
      end
      else begin
        cur_state <= next_state;
      end
    end
    always @(*) begin
      if(cur_state == IDLE)begin
        if(in_valid)begin
          if(one_for_w_zero_for_r)begin
            next_state = W_ADDR;
          end
          else begin
            next_state = R_ADDR;
          end
        end
        else begin
          next_state = IDLE;
        end
      end
      else if(cur_state == R_ADDR)begin
        if(arready_m_inf)begin
          next_state = R_DATA;
        end
        else begin
          next_state = R_ADDR;
        end
      end
      else if(cur_state == R_DATA)begin
        if(rlast_m_inf)begin
          next_state = OUT;
        end
        else begin
          next_state = R_DATA;
        end
      end
      else if(cur_state == W_ADDR)begin
        if(awready_m_inf)begin
          next_state = W_DATA;
        end
        else begin
          next_state = W_ADDR;
        end
      end
      else if(cur_state == W_DATA)begin
        if(wready_m_inf)begin
          next_state = WAIT;
        end
        else begin
          next_state = W_DATA;
        end
      end
      else if(cur_state == WAIT)begin
        if(bvalid_m_inf)begin
          next_state = OUT;
        end
        else begin
          next_state = WAIT;
        end
      end
      else begin
        next_state = IDLE;
      end
    end
  //===================================================//
  //             filling cache & out                   //
  //===================================================//
  // always @(*) begin
  //   if(cur_state == R_DATA)begin
  //     out_valid = 0;
  //     if(rvalid_m_inf)begin
  //       out_valid_sram = 1;
  //       out_data = rdata_m_inf;
  //     end
  //     else begin
  //       out_valid_sram = 0;
  //       out_data = 0;
  //     end
  //   end
  //   else if(cur_state == OUT)begin
  //     out_valid = 1;
  //     out_data = out_data_dff;
  //     out_valid_sram = 0;
  //   end
  //   else begin
  //     out_data = 0;
  //     out_valid_sram = 0;
  //     out_valid = 0;
  //   end
  // end
  always @(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
      out_valid_sram <= 0;
    end
    else begin
      case(cur_state)
        R_DATA:begin
          if(in_valid == 0)begin
            if(!one_for_w_zero_for_r_dff)begin
              if(rvalid_m_inf)begin
                out_valid_sram <= 1;
              end
              else begin
                out_valid_sram <= 0;
              end
            end
            else begin
              out_valid_sram <= 0;
            end
          end
          else begin
            out_valid_sram <= 0;
          end
        end
        OUT:begin
          out_valid_sram <= 0;
        end
        default:begin
          out_valid_sram <= 0;
        end
      endcase
    end
  end
  always @(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
      out_valid <= 0;
      //out_valid_sram <= 0;
      out_data <= 0;
    end
    else begin
      case(cur_state)
        R_DATA:begin 
          out_valid <= 0;
          if(rvalid_m_inf)begin
            out_data <= rdata_m_inf;
            //out_valid_sram <= 1;
          end
          else begin
            out_data <= 0;
            //out_valid_sram <= 0;
          end
        end
        OUT:begin
          out_valid <= 1;
          out_data <= out_data_dff;
          //out_valid_sram <= 0;
        end
        default:begin
          out_valid <= 0;
          //out_valid_sram <= 0;
          out_data <= 0;
        end
      endcase
    end
  end
endmodule

















