module bridge(input clk, INF.bridge_inf inf);

//================================================================
// logic 
//================================================================

//================================================================
// state 
//================================================================
typedef enum logic [2:0]{
	IDLE = 3'd0,
	DRAM_addr = 3'd1,
	DRAM_read = 3'd2,
	DRAM_write = 3'd3,
	DRAM_response = 3'd4,
	OUTPUT = 3'd5
}state;
state cur_state, nxt_state;
logic [16:0] addr;
logic [63:0] data;
logic read_or_write;
//================================================================
//  FSM register
//================================================================
always_ff@(posedge clk or negedge inf.rst_n)begin
	if(!inf.rst_n)begin
		cur_state <= IDLE;
	end
	else begin
		cur_state <= nxt_state;
	end
end

//================================================================
//  FSM
//================================================================
always_comb begin
	if(cur_state == IDLE)begin
		if(inf.C_in_valid)begin
			nxt_state = DRAM_addr;
		end
		else begin
			nxt_state = IDLE;
		end
	end
	else if(cur_state == DRAM_addr)begin
		if(read_or_write == 1'b1)begin
			if(inf.AR_READY)begin
				nxt_state = DRAM_read;
			end
			else begin
				nxt_state = DRAM_addr;
			end
		end
		else begin
			if(inf.AW_READY)begin
				nxt_state = DRAM_write;
			end
			else begin
				nxt_state = DRAM_addr;
			end
		end
	end
	else if(cur_state == DRAM_read)begin
		if(inf.R_VALID)begin
			nxt_state = OUTPUT;
		end
		else begin
			nxt_state = DRAM_read;
		end
	end
	else if(cur_state == DRAM_write)begin
		if(inf.W_READY)begin
			nxt_state = DRAM_response;
		end
		else begin
			nxt_state = DRAM_write;
		end
	end
	else if(cur_state == DRAM_response)begin
		if(inf.B_VALID && inf.B_RESP == 0)begin
			nxt_state = OUTPUT;
		end
		else begin
			nxt_state = DRAM_response;
		end
	end
	//cur_state == OUTPUT
	else begin
		nxt_state = IDLE;
	end
end

//==================================================================
//  data & address & read_or_write register
//==================================================================
always_ff@(posedge clk or negedge inf.rst_n)begin
	if(!inf.rst_n)begin
		addr <= 0;
		data <= 0;
		read_or_write <= 0;
	end
	else begin
		if(cur_state == IDLE)begin
			if(inf.C_in_valid)begin
				addr <= inf.C_addr*8 + 65536;
				data <= inf.C_data_w;
				read_or_write <= inf.C_r_wb;
			end
			else begin
				addr <= addr;
				data <= data;
				read_or_write <= read_or_write;
			end
		end
		else if(cur_state == DRAM_read)begin
			if(inf.R_VALID)begin
				addr <= addr;
				read_or_write <= read_or_write;
				data <= inf.R_DATA;
			end
			else begin
				addr <= addr;
				read_or_write <= read_or_write;
				data <= data;
			end
		end
		else begin
			addr <= addr;
			data <= data;
			read_or_write <= read_or_write;
		end
	end
end    
//====================================================================
//  AXI AR_VALID & AR_ADDR & AW_VALID AW_ADDR
//====================================================================
always_comb begin
	if(cur_state == DRAM_addr)begin
		if(read_or_write == 1'b1)begin
			inf.AR_VALID = 1'b1;
			inf.AR_ADDR = addr;
			inf.AW_VALID = 1'b0;
			inf.AW_ADDR = addr;
		end
		else begin
			inf.AR_VALID = 1'b0;
			inf.AR_ADDR = addr;
			inf.AW_VALID = 1'b1;
			inf.AW_ADDR = addr;
		end
	end
	else begin
		inf.AR_ADDR = addr;
		inf.AR_VALID = 1'b0;
		inf.AW_ADDR = addr;
		inf.AW_VALID = 1'b0;
	end
end                     
//=====================================================================
//   AXI R_READY & data
//=====================================================================
always_comb begin
	if(cur_state == DRAM_read)begin
		inf.R_READY = 1'b1;
	end
	else begin
		inf.R_READY = 1'b0;
	end
end    
//=====================================================================
//  AXI W_VALID W_DATA
//=====================================================================
always_comb begin
	if(cur_state == DRAM_write)begin
		inf.W_VALID = 1'b1;
		inf.W_DATA = data;
	end
	else begin
		inf.W_VALID = 1'b0;
		inf.W_DATA = data;
	end
end                   
//=====================================================================
//  AXI B_READY
//=====================================================================
always_comb begin
	if(cur_state == DRAM_response)begin
		inf.B_READY = 1'b1;
	end
	else begin
		inf.B_READY = 1'b0;
	end
end
//=====================================================================
//  C_out_valid & C_data_r
//=====================================================================
always_comb begin
	if(cur_state == OUTPUT)begin
		inf.C_out_valid = 1'b1;
		inf.C_data_r = data;
	end
	else begin
		inf.C_out_valid = 1'b0;
		inf.C_data_r = data;
	end
end
endmodule