//############################################################################
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//   (C) Copyright Laboratory System Integration and Silicon Implementation
//   All Right Reserved
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
//   2023 ICLAB Fall Course
//   Lab03      : BRIDGE
//   Author     : Ting-Yu Chang
//                
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
//   File Name   : BRIDGE_encrypted.v
//   Module Name : BRIDGE
//   Release version : v1.0 (Release Date: Sep-2023)
//
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//############################################################################
function automatic [6:0] CRC7;  // Return 7-bit result
    input [39:0] data;  // 40-bit data input
    reg [6:0] crc;
    integer i;
    reg data_in, data_out;
    parameter polynomial = 7'h9;  // x^7 + x^3 + 1

    begin
        crc = 7'd0;
        for (i = 0; i < 40; i = i + 1) begin
            data_in = data[39-i];
            data_out = crc[6];
            crc = crc << 1;  // Shift the CRC
            if (data_in ^ data_out) begin
                crc = crc ^ polynomial;
            end
        end
        CRC7 = crc;
    end
endfunction
function automatic [15:0] CRC16_CCITT;
    input [63:0] data;
	reg [15:0] crc;
	integer i;
	reg data_in, data_out;
	parameter polynomial = 16'h1021;
	
	begin
		crc = 16'd0;
		for(i = 0;i < 64; i = i + 1)begin
			data_in = data[63 - i];
			data_out = crc[15];
			crc = crc << 1;
			if(data_in ^ data_out)begin
				crc = crc ^ polynomial;
			end
		end
		CRC16_CCITT = crc;
	end
	
	
endfunction
module BRIDGE(
    // Input Signals
    clk,
    rst_n,
    in_valid,
    direction,
    addr_dram,
    addr_sd,
    // Output Signals
    out_valid,
    out_data,
    // DRAM Signals
    AR_VALID, AR_ADDR, R_READY, AW_VALID, AW_ADDR, W_VALID, W_DATA, B_READY,
	AR_READY, R_VALID, R_RESP, R_DATA, AW_READY, W_READY, B_VALID, B_RESP,
    // SD Signals
    MISO,
    MOSI
);

// Input Signals
input clk, rst_n;
input in_valid;
input direction;
input [12:0] addr_dram;
input [15:0] addr_sd;

// Output Signals
output reg out_valid;
output reg [7:0] out_data;

// DRAM Signals
// write address channel
output reg [31:0] AW_ADDR;
output reg AW_VALID;
input AW_READY;
// write data channel
output reg W_VALID;
output reg [63:0] W_DATA;
input W_READY;
// write response channel
input B_VALID;
input [1:0] B_RESP;
output reg B_READY;
// read address channel
output reg [31:0] AR_ADDR;
output reg AR_VALID;
input AR_READY;
// read data channel
input [63:0] R_DATA;
input R_VALID;
input [1:0] R_RESP;
output reg R_READY;

// SD Signals
input MISO;
output reg MOSI;

//==============================================//
//       parameter & integer declaration        //
//==============================================//
parameter IDLE = 5'd0;
parameter DRAread = 5'd1;
parameter SDcommand = 5'd2;
parameter Wait_reponse_1 = 5'd3;
parameter SDread = 5'd4;
parameter SDwrite = 5'd5;
parameter DRwrite = 5'd6; 
parameter Wait_reponse_2 = 5'd7;
parameter DRread = 5'd8;
parameter DRAWrite = 5'd9;
parameter Wait = 5'd10;
parameter Bready = 5'd11;
parameter Output = 5'd12;
parameter Busy = 5'd13;

integer i;
//==============================================//
//           reg & wire declaration             //
//==============================================//
//                 input reg                    //
//==============================================//
reg direction_DFF, in_valid_DFF;
reg [12:0] addr_dram_DFF;
reg [15:0] addr_sd_DFF;
always@(posedge clk or negedge rst_n)begin
	if(!rst_n)begin
		in_valid_DFF <= 0;
		direction_DFF <= 0;
		addr_dram_DFF <= 0;
		addr_sd_DFF <= 0;
	end
	else begin
		if(in_valid == 1)begin
			in_valid_DFF <= in_valid;
			direction_DFF <= direction;
			addr_dram_DFF <= addr_dram;
			addr_sd_DFF <= addr_sd;
		end
		else begin
			in_valid_DFF <= 0;
			direction_DFF <= direction_DFF;
			addr_dram_DFF <= addr_dram_DFF;
			addr_sd_DFF <= addr_sd_DFF;
		end
	end
end
//==============================================//
//                 for FSM                      //
//==============================================// 
reg [4:0] cur_state, next_state; 
reg [7:0] counter_SD_command, counter_SD_command_DFF;
//==============================================//
//                  for MISO MOSI               //
//==============================================//
reg [7:0] MISO_reg;
reg [47:0] command_reg, command_comb;
reg [79:0] SD_data_reg;
reg [87:0] MOSI_reg, MOSI_comb;
//==============================================//
//                  input data from DRAM        //
//==============================================//
reg [63:0] DRAM_data, DRAM_data_comb;

//==============================================//
//                  for output                  //
//==============================================//
reg out_valid_comb;
reg [7:0] out_data_comb;
reg [31:0] AW_ADDR_comb;
reg AW_VALID_comb;
reg W_VALID_comb;
reg [63:0] W_DATA_comb;
reg B_READY_comb;
reg [31:0] AR_ADDR_comb;
reg AR_VALID_comb;
reg R_READY_comb;
always@(posedge clk or negedge rst_n)begin
	if(!rst_n)begin
		out_valid <= 0;
		out_data <= 0;
		AW_ADDR <= 0;
		AW_VALID <= 0;
		W_VALID <= 0;
		W_DATA <= 0;
		B_READY <= 0;
		AR_ADDR <= 0;
		AR_VALID <= 0;
		R_READY <= 0;
	end
	else begin
		out_data <= out_data_comb;
		out_valid <= out_valid_comb;
		AW_ADDR <= AW_ADDR_comb;
		AW_VALID <= AW_VALID_comb;
		W_VALID <= W_VALID_comb;
		W_DATA <= W_DATA_comb;
		B_READY <= B_READY_comb;
		AR_ADDR <= AR_ADDR_comb;
		AR_VALID <= AR_VALID_comb;
		R_READY <= R_READY_comb;
	end
end
//==============================================//
//                  design                      //
//==============================================//
//                  counter                     //
always@(posedge clk or negedge rst_n)begin
	if(!rst_n)begin
		counter_SD_command_DFF <= 0;
	end
	else begin
		counter_SD_command_DFF <= counter_SD_command;
	end
end
//==============================================//
//                  FSM                         //
//==============================================//
always@(posedge clk or negedge rst_n)begin
	if(!rst_n)begin
		cur_state <= 0;
	end
	else begin
		cur_state <= next_state;
	end
end
always@(*)begin
	counter_SD_command = 0;
	if(cur_state == IDLE)begin
		if(in_valid_DFF == 1)begin
			if(direction_DFF == 0)begin
				next_state = DRAread;
			end
			else begin
				next_state = SDcommand;
			end
		end
		else begin
			next_state = IDLE;
		end
	end
	else if(cur_state == DRAread)begin
		if(AR_READY == 1 && AR_VALID == 1)begin
			next_state = DRread;
		end
		else begin
			next_state = DRAread;
		end
	end
	else if(cur_state == DRread)begin
		if(R_READY == 1 && R_VALID == 1 && R_RESP == 0)begin
			next_state = SDcommand;
			counter_SD_command = 0;
		end
		else begin
			next_state = DRread;
		end
	end
	else if(cur_state == SDcommand)begin
		counter_SD_command = counter_SD_command_DFF + 1;
		if(counter_SD_command_DFF >= 47)begin
			next_state = Wait_reponse_1;
		end
		else begin
			next_state = SDcommand;
		end
	end
	else if(cur_state == Wait_reponse_1)begin
		if(MISO_reg[7:0] == 0)begin
			next_state = Wait;
			counter_SD_command = 0;
		end
		else begin
			next_state = Wait_reponse_1;
		end
	end
	else if(cur_state == Wait)begin
		counter_SD_command = counter_SD_command_DFF + 1;
		if(direction_DFF == 0)begin
			if(counter_SD_command_DFF >= 13)begin
				counter_SD_command = 0;
				next_state = SDwrite;
			end
			else begin
				next_state = Wait;
			end
		end
		else begin
			if(MISO == 0)begin
				counter_SD_command = 0;
				next_state = SDread;
			end
			else begin
				next_state = Wait;
			end
		end
	end
	else if(cur_state == SDread)begin
		counter_SD_command = counter_SD_command_DFF + 1;
		if(counter_SD_command_DFF >= 80)begin//79
			next_state = DRAWrite;
		end
		else begin
			next_state = SDread;
		end
	end
	else if(cur_state == DRAWrite)begin
		if(AW_VALID == 1 && AW_READY == 1)begin
			next_state = DRwrite;
		end
		else begin
			next_state = DRAWrite;
		end
	end
	else if(cur_state == DRwrite)begin
		if(W_VALID == 1 && W_READY == 1)begin
			next_state = Bready;
		end
		else begin
			next_state = DRwrite;
		end
	end
	else if(cur_state == Bready)begin
		if(B_READY == 1 && B_RESP == 0 && B_VALID == 1)begin
			next_state = Output;
			counter_SD_command = 0;
		end
		else begin
			next_state = Bready;
		end
	end
	else if(cur_state == SDwrite)begin
		counter_SD_command = counter_SD_command_DFF + 1;
		if(counter_SD_command_DFF >= 87)begin
			next_state = Wait_reponse_2;
		end
		else begin
			next_state = SDwrite;
		end
	end
	else if(cur_state == Wait_reponse_2)begin
		if(MISO_reg[7:0] == 8'b00000101)begin
			counter_SD_command = 0;
			next_state = Busy;
		end
		else begin
			next_state = Wait_reponse_2;
		end
	end
	else if(cur_state == Busy)begin
		if(MISO_reg[0] == 1)begin
			counter_SD_command = 0;
			next_state = Output;
		end
		else begin
			next_state = Busy;
		end
	end
	//Output state
	else begin
		counter_SD_command = counter_SD_command_DFF + 1;
		if(counter_SD_command_DFF >= 7)begin
			next_state = IDLE;
		end
		else begin
			next_state = Output;
		end
	end
end
//===================================//
//                 MISO              //
//===================================//
/*
reg [7:0] MISO_reg;
reg [47:0] command_reg, command_comb;
reg [79:0] SD_data_reg;
reg [87:0] MOSI_reg, MOSI_comb;*/
//==========================================//
//             wait reponse_1 & reponse_2   //
//==========================================//
always@(posedge clk or negedge rst_n)begin
	if(!rst_n)begin
		MISO_reg <= 1;
	end
	else begin
		if(cur_state == Wait_reponse_1 || cur_state == Wait_reponse_2 || cur_state == Wait || cur_state == Busy)begin
			MISO_reg[0] <= MISO;
			for(i = 0; i < 7; i = i + 1)begin
				MISO_reg[i + 1] <= MISO_reg[i];
			end
		end
		else begin
			MISO_reg <= MISO_reg;
		end
		
	end
end
//====================================//
//          SDread                    //
//====================================//
always@(posedge clk or negedge rst_n)begin
	if(!rst_n)begin
		SD_data_reg <= 0;
	end
	else begin
		if(next_state == SDread)begin
			SD_data_reg[0] <= MISO;
			for(i = 0; i < 79 ;i = i + 1)begin
				SD_data_reg[i + 1] <= SD_data_reg[i];
			end
		end
		else begin
			SD_data_reg <= SD_data_reg;
		end
	end
	
end
//==================================//
//              MOSI                //
//             SDcommand            //
//             SDwrite              //
//==================================//
always@(posedge clk or negedge rst_n)begin
	if(!rst_n)begin
		MOSI <= 1;
		MOSI_reg <= 0;
		command_reg <= 0;
	end
	else begin
		if(cur_state == SDwrite)begin
			MOSI <= MOSI_reg[87];
			for(i = 87;i > 0; i = i - 1)begin
				MOSI_reg[i] <= MOSI_reg[i - 1];
			end
			MOSI_reg[0] <= MOSI_reg[0];
			command_reg <= command_comb;
		end
		else if(cur_state == SDcommand)begin
			MOSI <= command_reg[47];
			for(i = 47; i > 0;i = i - 1)begin
				command_reg[i] <= command_reg[i - 1];
			end
			command_reg[0] <= command_reg[0];
			MOSI_reg <= MOSI_comb;
		end
		else begin
			command_reg <= command_comb;
			MOSI_reg <= MOSI_comb;
			MOSI <= 1;
		end
	end
end
//======================================//
//        read DRAM address             //
//======================================//
always@(*)begin
	if(cur_state == DRAread)begin
		AR_ADDR_comb = addr_dram_DFF;
		AR_VALID_comb = 1;
	end
	else begin
		AR_ADDR_comb = 0;
		AR_VALID_comb = 0;
	end
end
//=====================================//
//         read DRAM data              //
//=====================================//
always@(posedge clk or negedge rst_n)begin
	if(!rst_n)begin
		DRAM_data <= 0;
	end
	else begin
		DRAM_data <= DRAM_data_comb;
	end
end
always@(*)begin
	if(cur_state == DRread)begin
		R_READY_comb = 1;
		DRAM_data_comb = R_DATA;
	end
	else begin
		DRAM_data_comb = DRAM_data;
		R_READY_comb = 0;
	end
end
//=====================================//
//          SDcommand                  //
//=====================================//
reg [31:0] addr_sd_32;
assign addr_sd_32 = addr_sd_DFF;
reg [6:0] temp;
assign temp = CRC7(.data({2'b01 , 6'd24 , addr_sd_32}));
always@(*)begin
	if(cur_state != SDcommand)begin
		if(direction_DFF == 0)begin
			command_comb = {2'b01 , 6'd24 , addr_sd_32, temp, 1'b1 };
		end
		else begin
			command_comb = {2'b01, 6'd17, addr_sd_32, CRC7(.data({2'b01, 6'd17, addr_sd_32})), 1'b1};
		end
	end
	else begin
		command_comb = command_reg;
	end
end
//====================================//
//        DRAM address write          //
//====================================//
always@(*)begin
	if(cur_state == DRAWrite)begin
		AW_ADDR_comb = addr_dram_DFF;
		AW_VALID_comb = 1;
	end
	else begin
		AW_ADDR_comb = 0;
		AW_VALID_comb = 0;
	end
end
//====================================//
//      DRAM write data               //
//====================================//
always@(*)begin
	if(cur_state == DRwrite)begin
		W_DATA_comb = SD_data_reg[79:16];
		W_VALID_comb = 1;
	end
	else begin
		W_DATA_comb = 0;
		W_VALID_comb = 0;
	end
end
//====================================//
//           SDwrite                  //
//====================================//
always@(*)begin
	if(cur_state != SDwrite)begin
		MOSI_comb = {8'hFE, DRAM_data, CRC16_CCITT(.data(DRAM_data))};
	end
	else begin
		MOSI_comb = MOSI_reg;
	end
	
end
//====================================//
//        Bready                      //
//====================================//
always@(*)begin
	if(cur_state == Bready)begin
		B_READY_comb = 1;
	end
	else begin
		B_READY_comb = 0;
	end
end
//====================================//
//          output                    //
//====================================//
always@(*)begin
	if(cur_state == Output)begin
		out_valid_comb = 1;
		if(direction_DFF == 0)begin
			case(counter_SD_command_DFF)
				0:out_data_comb = DRAM_data[63:56];
				1:out_data_comb = DRAM_data[55:48];
				2:out_data_comb = DRAM_data[47:40];
				3:out_data_comb = DRAM_data[39:32];
				4:out_data_comb = DRAM_data[31:24];
				5:out_data_comb = DRAM_data[23:16];
				6:out_data_comb = DRAM_data[15:8];
				7:out_data_comb = DRAM_data[7:0];
				default:out_data_comb = 0;
			endcase
		end
		else begin
			case(counter_SD_command_DFF)
				0:out_data_comb = SD_data_reg[79:72];
				1:out_data_comb = SD_data_reg[71:64];
				2:out_data_comb = SD_data_reg[63:56];
				3:out_data_comb = SD_data_reg[55:48];
				4:out_data_comb = SD_data_reg[47:40];
				5:out_data_comb = SD_data_reg[39:32];
				6:out_data_comb = SD_data_reg[31:24];
				7:out_data_comb = SD_data_reg[23:16];
				default:out_data_comb = 0;
			endcase
		end
	end
	else begin
		out_valid_comb = 0;
		out_data_comb = 0;
	end
	
end
endmodule

//===============================================//
//              CRC function                     //
//===============================================//



