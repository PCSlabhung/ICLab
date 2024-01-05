module BEV(input clk, INF.BEV_inf inf);
import usertype::*;
// This file contains the definition of several state machines used in the BEV (Beverage) System RTL design.
// The state machines are defined using SystemVerilog enumerated types.
// The state machines are:
// - state_t: used to represent the overall state of the BEV system
//
// Each enumerated type defines a set of named states that the corresponding process can be in.
logic [1:0] counter_4;
logic make_drink_true;
Error_Msg Err_msg;
logic Complete;
Bev_Bal Bev_input;
Action act;
logic [7:0] box_no;
logic [63:0] data, data_dff;
logic [12:0] Ing_sum[0:3];
logic busy, busy_dff;
int i,j;
parameter Black_Tea      	       = 3'h0;
parameter Milk_Tea	               = 3'h1;
parameter Extra_Milk_Tea           = 3'h2;
parameter Green_Tea 	           = 3'h3;
parameter Green_Milk_Tea           = 3'h4;
parameter Pineapple_Juice          = 3'h5;
parameter Super_Pineapple_Tea      = 3'h6;
parameter Super_Pineapple_Milk_Tea = 3'h7;
parameter Large = 2'd0;
parameter Medium = 2'd1;
parameter Small = 2'd3;


//=========================================================================
//  FSM
//=========================================================================
typedef enum logic[2:0]{
	IDLE,
	DRAM_out,
	DRAM_read,
	Calculate_minus,
	Calculate,
	DRAM_out_2,
	OUT
} state_s;
state_s cur_state, nxt_state;
always_ff@(posedge clk or negedge inf.rst_n)begin
	if(!inf.rst_n)begin
		busy_dff <= 0;
	end
	else begin
		busy_dff <= busy;
	end
end
always_comb begin
	if(cur_state == DRAM_out_2)begin
		busy = 1;
	end
	else if(inf.C_out_valid)begin
		busy = 0;
	end
	else begin
		busy = busy_dff;
	end
end
always_ff@(posedge clk or negedge inf.rst_n)begin
	if(!inf.rst_n)begin
		cur_state <= IDLE;
	end
	else begin
		cur_state <= nxt_state;
	end
end
always_comb begin
	if(cur_state == IDLE)begin
		nxt_state = IDLE;
		if(act == Make_drink || act == Check_Valid_Date)begin
			if(inf.box_no_valid)begin
				nxt_state = DRAM_out;
			end
		end
		else begin
			if(inf.box_sup_valid && counter_4 == 3)begin
				nxt_state = DRAM_out;
			end
		end
	end
	else if(cur_state == DRAM_out)begin
		if(busy_dff == 0)begin
			nxt_state = DRAM_read;
		end
		else begin
			nxt_state = DRAM_out;
		end
	end
	else if(cur_state == DRAM_read)begin
		nxt_state = DRAM_read;
		if(inf.C_out_valid)begin
			if(act == Supply)begin
				nxt_state = Calculate;
			end
			else begin
				nxt_state = Calculate_minus;
			end
		end
	end
	else if(cur_state == Calculate_minus)begin
		if(Err_msg == No_Exp || Err_msg == No_Ing || act == Check_Valid_Date)begin
			nxt_state = OUT;
		end
		else begin
			nxt_state = Calculate;
		end
	end
	else if(cur_state == Calculate)begin
		if(act == Make_drink)begin
			nxt_state = DRAM_out_2;
		end
		else if(act == Check_Valid_Date)begin
			nxt_state = OUT;
		end
		else begin
			nxt_state = DRAM_out_2;
		end
	end
	else if(cur_state == DRAM_out_2)begin
		nxt_state = OUT;
	end
	else begin
		nxt_state = IDLE;
	end
end
//=========================================================================
//  bridge signal
//=========================================================================
always_comb begin
	if(cur_state == DRAM_out)begin
		inf.C_data_w = 0;
		inf.C_addr = box_no;
		inf.C_r_wb = 1;
		if(busy_dff == 0)begin
			inf.C_in_valid = 1;
		end
		else begin
			inf.C_in_valid = 0;
		end
	end
	else if(cur_state == DRAM_out_2)begin
		inf.C_data_w = data_dff;
		inf.C_addr = box_no;
		inf.C_in_valid = 1;
		inf.C_r_wb = 0;
	end
	else begin
		inf.C_data_w = 0;
		inf.C_addr = box_no;
		inf.C_in_valid = 0;
		inf.C_r_wb = 0;
	end
end
//=========================================================================
// data & Err_msg & Complete & make_drink_true
//=========================================================================
logic Complete_dff;
Error_Msg Err_msg_dff;
always_ff@(posedge clk or negedge inf.rst_n)begin
	if(!inf.rst_n)begin
		data_dff <= 0;
		Err_msg_dff <= 0;
		Complete_dff <= 0;
	end
	else begin
		data_dff <= data;
		Complete_dff <= Complete;
		Err_msg_dff <= Err_msg;
	end
end
always_comb begin
	if(cur_state == DRAM_read)begin
		data = inf.C_data_r;
		Err_msg = No_Err;
		Complete = 1;
	end
	else if(cur_state == Calculate_minus)begin
		data = data_dff;
		if(data_dff[39:32] < Bev_input.M || (data_dff[39:32] == Bev_input.M && data_dff[7:0] < Bev_input.D))begin
			Err_msg = No_Exp;
			Complete = 0;
		end
		else begin
			Complete = 1;
			Err_msg = No_Err;
			if(act == Make_drink)begin
				case(Bev_input.milk[2:0])
					Black_Tea:begin
						if(Bev_input.pineapple_juice[1:0] == Large)begin
							if(data_dff[63:52] < 960)begin
								Complete = 0;
								Err_msg = No_Ing;
							end
						end
						else if(Bev_input.pineapple_juice[1:0] == Medium)begin
							if(data_dff[63:52] < 720)begin
								Complete = 0;
								Err_msg = No_Ing;
							end
						end
						else begin
							if(data_dff[63:52] < 480)begin
								Complete = 0;
								Err_msg = No_Ing;
							end
						end
					end
					Milk_Tea:begin
						if(Bev_input.pineapple_juice[1:0] == Large)begin
							if(data_dff[63:52] < 720 || data_dff[31:20] < 240)begin
								Complete = 0;
								Err_msg = No_Ing;
							end
						end
						else if(Bev_input.pineapple_juice[1:0] == Medium)begin
							if(data_dff[63:52] < 540 || data_dff[31:20] < 180)begin
								Complete = 0;
								Err_msg = No_Ing;
							end
						end
						else begin
							if(data_dff[63:52] < 360 || data_dff[31:20] < 120)begin
								Complete = 0;
								Err_msg = No_Ing;
							end
						end
					end
					Extra_Milk_Tea:begin
						if(Bev_input.pineapple_juice[1:0] == Large)begin
							if(data_dff[63:52] < 480 || data_dff[31:20] < 480)begin
								Complete = 0;
								Err_msg = No_Ing;
							end
						end
						else if(Bev_input.pineapple_juice[1:0] == Medium)begin
							if(data_dff[63:52] < 360 || data_dff[31:20] < 360)begin
								Complete = 0;
								Err_msg = No_Ing;
							end
						end
						else begin
							if(data_dff[63:52] < 240 || data_dff[31:20] < 240)begin
								Complete = 0;
								Err_msg = No_Ing;
							end
						end
					end
					Green_Tea:begin
						if(Bev_input.pineapple_juice[1:0] == Large)begin
							if(data_dff[51:40] < 960)begin
								Complete = 0;
								Err_msg = No_Ing;
							end
						end
						else if(Bev_input.pineapple_juice[1:0] == Medium)begin
							if(data_dff[51:40] < 720)begin
								Complete = 0;
								Err_msg = No_Ing;
							end
						end
						else begin
							if(data_dff[51:40] < 480)begin
								Complete = 0;
								Err_msg = No_Ing;
							end
						end
					end
					Green_Milk_Tea:begin
						if(Bev_input.pineapple_juice[1:0] == Large)begin
							if(data_dff[51:40] < 480 || data_dff[31:20] < 480)begin
								Complete = 0;
								Err_msg = No_Ing;
							end
						end
						else if(Bev_input.pineapple_juice[1:0] == Medium)begin
							if(data_dff[51:40] < 360 || data_dff[31:20] < 360)begin
								Complete = 0;
								Err_msg = No_Ing;
							end
						end
						else begin
							if(data_dff[51:40] < 240 || data_dff[31:20] < 240)begin
								Complete = 0;
								Err_msg = No_Ing;
							end
							
						end
					end
					Pineapple_Juice:begin
						if(Bev_input.pineapple_juice[1:0] == Large)begin
							if(data_dff[19:8] < 960)begin
								Complete = 0;
								Err_msg = No_Ing;
							end
						end
						else if(Bev_input.pineapple_juice[1:0] == Medium)begin
							if(data_dff[19:8] < 720)begin
								Complete = 0;
								Err_msg = No_Ing;
							end
						end
						else begin
							if(data_dff[19:8] < 480)begin
								Complete = 0;
								Err_msg = No_Ing;
							end
						end
					end
					Super_Pineapple_Tea:begin
						if(Bev_input.pineapple_juice[1:0] == Large)begin
							if(data_dff[19:8] < 480 || data_dff[63:52] < 480)begin
								Complete = 0;
								Err_msg = No_Ing;
							end
						end
						else if(Bev_input.pineapple_juice[1:0] == Medium)begin
							if(data_dff[19:8] < 360 || data_dff[63:52] < 360)begin
								Complete = 0;
								Err_msg = No_Ing;
							end
						end
						else begin
							if(data_dff[19:8] < 240 || data_dff[63:52] < 240)begin
								Complete = 0;
								Err_msg = No_Ing;
							end
						end
					end
					Super_Pineapple_Milk_Tea:begin
						if(Bev_input.pineapple_juice[1:0] == Large)begin
							if(data_dff[19:8] < 240 || data_dff[63:52] < 480 || data_dff[31:20] < 240)begin
								Complete = 0;
								Err_msg = No_Ing;
							end
						end
						else if(Bev_input.pineapple_juice[1:0] == Medium)begin
							if(data_dff[19:8] < 180 || data_dff[63:52] < 360 || data_dff[31:20] < 180)begin
								Complete = 0;
								Err_msg = No_Ing;
							end
						end
						else begin
							if(data_dff[19:8] < 120 || data_dff[63:52] < 240 || data_dff[31:20] < 120)begin
								Complete = 0;
								Err_msg = No_Ing;
							end
						end
					end
				endcase
			end
		end
	end
	else if(cur_state == Calculate)begin
		Err_msg = No_Err;
		data = data_dff;
		Complete = 1;
		if(act == Make_drink)begin
			case(Bev_input.milk[2:0])
				Black_Tea:begin
					if(Bev_input.pineapple_juice[1:0] == Large)begin
						data[63:52] = data_dff[63:52] - 960;
					end
					else if(Bev_input.pineapple_juice[1:0] == Medium)begin
						data[63:52] = data_dff[63:52] - 720;
					end
					else begin
						data[63:52] = data_dff[63:52] - 480;
					end
				end
				Milk_Tea:begin
					if(Bev_input.pineapple_juice[1:0] == Large)begin
						data[63:52] = data_dff[63:52] - 720;
						data[31:20] = data_dff[31:20] - 240;
					end
					else if(Bev_input.pineapple_juice[1:0] == Medium)begin
						data[63:52] = data_dff[63:52] - 540;
						data[31:20] = data_dff[31:20] - 180;
					end
					else begin
						data[63:52] = data_dff[63:52] - 360;
						data[31:20] = data_dff[31:20] - 120;
					end
				end
				Extra_Milk_Tea:begin
					if(Bev_input.pineapple_juice[1:0] == Large)begin
						data[63:52] = data_dff[63:52] - 480;
						data[31:20] = data_dff[31:20] - 480;
					end
					else if(Bev_input.pineapple_juice[1:0] == Medium)begin
						data[63:52] = data_dff[63:52] - 360;
						data[31:20] = data_dff[31:20] - 360;
					end
					else begin
						data[63:52] = data_dff[63:52] - 240;
						data[31:20] = data_dff[31:20] - 240;
					end
				end
				Green_Tea:begin
					if(Bev_input.pineapple_juice[1:0] == Large)begin
						data[51:40] = data_dff[51:40] - 960;
					end
					else if(Bev_input.pineapple_juice[1:0] == Medium)begin
						data[51:40] = data_dff[51:40] - 720;
					end
					else begin
						data[51:40] = data_dff[51:40] - 480;
					end
				end
				Green_Milk_Tea:begin
					if(Bev_input.pineapple_juice[1:0] == Large)begin
						data[51:40] = data_dff[51:40] - 480;
						data[31:20] = data_dff[31:20] - 480;
					end
					else if(Bev_input.pineapple_juice[1:0] == Medium)begin
						data[31:20] = data_dff[31:20] - 360;
						data[51:40] = data_dff[51:40] - 360;
					end
					else begin
						data[31:20] = data_dff[31:20] - 240;
						data[51:40] = data_dff[51:40] - 240;
					end
				end
				Pineapple_Juice:begin
					if(Bev_input.pineapple_juice[1:0] == Large)begin
						data[19:8] = data_dff[19:8] - 960;	
					end
					else if(Bev_input.pineapple_juice[1:0] == Medium)begin
						data[19:8] = data_dff[19:8] - 720;
					end
					else begin
						data[19:8] = data_dff[19:8] - 480;
					end
				end
				Super_Pineapple_Tea:begin
					if(Bev_input.pineapple_juice[1:0] == Large)begin
						data[19:8] = data_dff[19:8] - 480;
						data[63:52] = data_dff[63:52] - 480;
					end
					else if(Bev_input.pineapple_juice[1:0] == Medium)begin
						data[19:8] = data_dff[19:8] - 360;
						data[63:52] = data_dff[63:52] - 360;
					end
					else begin
						data[19:8] = data_dff[19:8] - 240;
						data[63:52] = data_dff[63:52] - 240;
					end
				end
				Super_Pineapple_Milk_Tea:begin
					if(Bev_input.pineapple_juice[1:0] == Large)begin
						data[19:8] = data_dff[19:8] - 240;
						data[63:52] = data_dff[63:52] - 480;
						data[31:20] = data_dff[31:20] - 240;
					end
					else if(Bev_input.pineapple_juice[1:0] == Medium)begin
						data[19:8] = data_dff[19:8] - 180;
						data[63:52] = data_dff[63:52] - 360;
						data[31:20] = data_dff[31:20] - 180;
					end
					else begin
						data[19:8] = data_dff[19:8] - 120;
						data[63:52] = data_dff[63:52] - 240;
						data[31:20] = data_dff[31:20] - 120;
					end
				end
			endcase
		end
		//supply
		else begin
			data[39:32] = Bev_input.M;
			data[7:0] = Bev_input.D;
			if(Ing_sum[0][12] == 0)begin
				data[63:52] = Ing_sum[0];
			end
			else begin
				data[63:52] = 4095;
				Err_msg = Ing_OF;
				Complete = 0;
			end
			if(Ing_sum[1][12] == 0)begin
				data[51:40] = Ing_sum[1];
			end
			else begin
				data[51:40] = 4095;
				Err_msg = Ing_OF;
				Complete = 0;
			end
			if(Ing_sum[2][12] == 0)begin
				data[31:20] = Ing_sum[2];
			end	
			else begin
				data[31:20] = 4095;
				Err_msg = Ing_OF;
				Complete = 0;
			end
			if(Ing_sum[3][12] == 0)begin
				data[19:8] = Ing_sum[3];
			end
			else begin
				data[19:8] = 4095;
				Err_msg = Ing_OF;
				Complete = 0;
			end
		end
	end
	else begin
		Err_msg = Err_msg_dff;
		Complete = Complete_dff;
		data = data_dff;
	end
end
always_ff@(posedge clk or negedge inf.rst_n)begin
	if(!inf.rst_n)begin
		counter_4 <= 0;
	end
	else begin
		if(inf.box_sup_valid)begin
			counter_4 <= counter_4 + 1;
		end
	end
end
// always_ff@(posedge clk or negedge inf.rst_n) begin
	// if(!inf.rst_n)begin
		// Ing_sum[0] <= 0;
		// Ing_sum[1] <= 0;
		// Ing_sum[2] <= 0;
		// Ing_sum[3] <= 0;
	// end
	// else begin
		// Ing_sum[0] <= Bev_input.black_tea       + data_dff[63:52];
		// Ing_sum[1] <= Bev_input.green_tea       + data_dff[51:40];
		// Ing_sum[2] <= Bev_input.milk      	   + data_dff[31:20];
		// Ing_sum[3] <= Bev_input.pineapple_juice + data_dff[19:8];
	// end
// end
always_comb begin
	Ing_sum[0] = Bev_input.black_tea       + data_dff[63:52];
	Ing_sum[1] = Bev_input.green_tea       + data_dff[51:40];
	Ing_sum[2] = Bev_input.milk      	   + data_dff[31:20];
	Ing_sum[3] = Bev_input.pineapple_juice + data_dff[19:8];
end
//=========================================================================
//    input register 
//     milk store type and pineapple_juice store size in make drink task 
//=========================================================================

always_ff@(posedge clk or negedge inf.rst_n)begin
	if(!inf.rst_n)begin
		Bev_input.black_tea <= 0;
		Bev_input.green_tea <= 0;
		Bev_input.milk <= 0;
		Bev_input.pineapple_juice <= 0;
		Bev_input.M <= 0;
		Bev_input.D <= 0;
		box_no <= 0;
		act <= Make_drink;
	end
	else begin
		if(inf.sel_action_valid)begin
			act <= inf.D.d_act[0];
		end
		if(inf.date_valid)begin
			Bev_input.M <= inf.D.d_date[0].M;
			Bev_input.D <= inf.D.d_date[0].D;
		end
		if(inf.box_no_valid)begin
			box_no <= inf.D.d_box_no[0];
		end
		if(inf.box_sup_valid || inf.type_valid || inf.size_valid)begin
			Bev_input.pineapple_juice <= inf.D.d_ing[0];
			Bev_input.milk <= Bev_input.pineapple_juice;
			Bev_input.green_tea <= Bev_input.milk;
			Bev_input.black_tea <= Bev_input.green_tea;
		end
	end
end
//==================================================================
//  output register
//==================================================================
always_ff@(posedge clk or negedge inf.rst_n)begin
	if(!inf.rst_n)begin
		inf.out_valid <= 0;
		inf.complete <= 0;
		inf.err_msg <= No_Err;
	end
	else begin
		if(cur_state == OUT)begin
			inf.out_valid <= 1;
			inf.complete <= Complete_dff;
			inf.err_msg <= Err_msg_dff;
		end
		else begin
			inf.out_valid <= 0;
			inf.complete <= 0;
			inf.err_msg <= No_Err;
		end
	end
end
endmodule