/*
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
NYCU Institute of Electronic
2023 Autumn IC Design Laboratory 
Lab09: SystemVerilog Design and Verification 
File Name   : PATTERN.sv
Module Name : PATTERN
Release version : v1.0 (Release Date: Nov-2023)
Author : Jui-Huang Tsai (erictsai.10@nycu.edu.tw)
//   (C) Copyright Laboratory System Integration and Silicon Implementation
//   All Right Reserved
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
*/

`include "Usertype_BEV.sv"

program automatic PATTERN(input clk, INF.PATTERN inf);
import usertype::*;

//================================================================
// parameters & integer
//================================================================
parameter DRAM_p_r = "../00_TESTBED/DRAM/dram.dat";
`define GREEN "\033[0;32;32m"
`define BLUE "\033[0;32;34m"
`define WHITE "\033[1;37m"
//================================================================
// wire & registers 
//================================================================
//logic [7:0] golden_DRAM [((65536+8*256)-1):(65536+0)];  
logic [7:0] golden_DRAM [65536:((65536 + 8 * 256) - 1)];
int t, latency, total_latency;
int i, patnum;
Action r;
Bev_Size beverage_size;
Bev_Type beverage_type;
logic[3:0] month;
logic[4:0] day;
logic[7:0] box_id;
logic[11:0] volume;
logic[11:0] box_sup_array [0:3];
logic[1:0] golden_Err_mssg;
//================================================================
// class random
//================================================================

/**
 * Class representing a random action.
 */
class random_act;
    randc Action act_id;
    constraint range{
        act_id inside{Make_drink, Supply, Check_Valid_Date};
    }
endclass

/**
 * Class representing a random box from 0 to 31.
 */
class random_box;
    randc logic [7:0] box_id;
    constraint range{
        box_id inside{[0:255]};
    }
endclass
/**
 *
 *class representing a random beverage
 */
class random_beverage;
	randc Bev_Type beverage;
	constraint range{
		beverage inside{
			Black_Tea,      	        
			Milk_Tea,	            
		    Extra_Milk_Tea,          
		    Green_Tea, 	            
		    Green_Milk_Tea,          
		    Pineapple_Juice,         
		    Super_Pineapple_Tea,     
		    Super_Pineapple_Milk_Tea
		};
	}
endclass
/**
 *
 *class representing a random beverage size
 */
 class random_beverage_size;
	randc Bev_Size beverage_size;
	constraint range{
		beverage_size inside{L,M,S};
	}
endclass

/**
 *
 *class representing month
 */
 class random_Month;
	randc logic [3:0] month ;
	constraint range{
		 month inside{[1:12]};
	}
endclass
/**
 *
 *class representing date
 */
 class random_day;
	randc logic [4:0] day;
	logic [3:0] month;
	function  new(logic[3:0] seed);
		this.month = seed;
	endfunction
	constraint range{
		if(this.month == 2)
		 	day inside{[1:28]};
		else if(this.month == 1 || this.month == 3 || this.month == 5 || this.month == 7 || this.month == 8 || this.month == 10 || this.month == 12)
			day inside{[1:31]};
		else
			day inside{[1:30]};
	}
endclass
/**
 *
 *class representing drink volume
 */
 class random_volume;
	randc logic [11:0] volume;
	constraint range{
		volume inside{[0:4095]};
	}
endclass
//================================================================
// initial
//================================================================

initial $readmemh(DRAM_p_r, golden_DRAM);
logic [1:0] pre_r = r;
random_act R_act = new();
random_beverage R_beverage_type = new();
random_beverage_size R_beverage_size = new();
random_Month R_random_month = new();
random_box R_random_boxid = new();	
random_volume R_random_volume = new();
random_day R_random_day;
int make_latency;

initial begin
	reset_task;
	total_latency = 0;
	latency = 0;
	for(patnum = 0; patnum < 2000; patnum = patnum + 1)begin
		r = 0;
		input_makedrink_task;
		calculate_task;
		wait_out_valid_task;
		check_ans_task;
		$display("\033[0;32;32m pass pattern \033[0;32;34m %d", patnum);
		make_latency = patnum;
	end
	pre_r = r;
	for(patnum = 2000; patnum < 2200; patnum = patnum + 1)begin
		r = 1;
		input_supply_task;
		calculate_task;
		wait_out_valid_task;
		check_ans_task;
		$display("\033[0;32;32m pass pattern \033[0;32;34m %d", patnum);
	end
	for(patnum = 2200; patnum < 2600; patnum = patnum + 1)begin
		r = ((patnum + 1) % 2);
		if(r == 0)begin
			input_makedrink_task;
		end
		else if(r == 1)begin
			input_supply_task;
		end
		else begin
			input_check_task;
		end
		calculate_task;
		wait_out_valid_task;
		check_ans_task;
		$display("\033[0;32;32m pass pattern \033[0;32;34m %d", patnum );
	end
	for(patnum = 2600; patnum < 3000; patnum = patnum + 1)begin
		r = (patnum  % 2);
		r = (r == 0) ? 2 : 1;
		if(r == 0)begin
			if(patnum < 2920)begin
				
			end
			input_makedrink_task;
		end
		else if(r == 1)begin
			input_supply_task;
		end
		else begin
			input_check_task;
		end
		calculate_task;
		wait_out_valid_task;
		check_ans_task;
		$display("\033[0;32;32m pass pattern \033[0;32;34m %d", patnum );
	end
	for(patnum = 3000; patnum < 3200; patnum = patnum + 1)begin
		r = 2;
		if(r == 0)begin
			input_makedrink_task;
		end
		else if(r == 1)begin
			input_supply_task;
		end
		else begin
			input_check_task;
		end
		calculate_task;
		wait_out_valid_task;
		check_ans_task;
		$display("\033[0;32;32m pass pattern \033[0;32;34m %d", patnum );
	end
	for(patnum = 3200; patnum < 3600;patnum = patnum + 1)begin
		r = patnum % 2;
		r = (r == 0) ? 2 : 0;
		if(r == 0)begin
			input_makedrink_task;
		end
		else if(r == 1)begin
			input_supply_task;
		end
		else begin
			input_check_task;
		end
		calculate_task;
		wait_out_valid_task;
		check_ans_task;
		$display("\033[0;32;32m pass pattern \033[0;32;34m %d", patnum );
	end
	// for(patnum = 0; patnum < 1730; patnum = patnum + 1)begin
		// R_act.randomize();
		// r = R_act.act_id;
		// if(pre_r == 0)
			// r = $urandom_range(1,2);
		// else 
			// r = $urandom_range(0,2);
		// if(r == 0)begin
			// input_makedrink_task;
		// end
		// else if(r == 1)begin
			// input_supply_task;
		// end
		// else begin
			// input_check_task;
		// end
		// calculate_task;
		// wait_out_valid_task;
		// check_ans_task;
		// $display("\033[0;32;32m pass pattern \033[0;32;34m %d", patnum + make_latency + 1);
		// pre_r = r;
	// end
	$display(`WHITE);
	$display("================================================================");
	$display("                Congratulations  !!                             ");
	$display("                total_latency = %d                              ", total_latency);
	$display("================================================================");
	$finish;
end
//================================================================
// reset task                                                     
//================================================================

task reset_task;
	inf.rst_n = 1'b0;
	inf.sel_action_valid = 'b0;
	inf.type_valid = 'b0;
	inf.size_valid = 'b0;
	inf.date_valid = 'b0;
	inf.box_no_valid = 'b0;
	inf.box_sup_valid = 'b0;
	inf.D = 'bX;
	#12 inf.rst_n = 1'b0;
	#12 inf.rst_n = 1'b1;
	// if(inf.out_valid !== 0 || inf.err_msg !== 0 || inf.complete !== 0)begin
		// $display("======================================================");
		// $display("               output should be reset                 ");
		// $display("======================================================");
		// $finish;
	// end
	inf.sel_action_valid = 'b0;
	inf.type_valid = 'b0;
	inf.size_valid = 'b0;
	inf.date_valid = 'b0;
	inf.box_no_valid = 'b0;
	inf.box_sup_valid = 'b0;
	inf.D = 'bX;
endtask
//=================================================================
//  input make drink task                                                     
//=================================================================

task input_makedrink_task;
	// R_beverage_type.randomize();
	// beverage_type = R_beverage_type.beverage;
	// R_beverage_size.randomize();
	// beverage_size = R_beverage_size.beverage_size;
	
	if(patnum < 300)begin
		beverage_type = Black_Tea;
		if(patnum < 100)
			beverage_size = L;
		else if(patnum < 200)
			beverage_size = M;
		else begin
			beverage_size = S;
		end
	end
	else if(patnum < 600)begin
		beverage_type = Milk_Tea;
		if(patnum < 400)begin
			beverage_size = L;
		end
		else if(patnum < 500)
			beverage_size = M;
		else 
			beverage_size = S;
	end
	else if(patnum < 900)begin
		beverage_type = Extra_Milk_Tea;
		if(patnum < 700) begin
			beverage_size = L;
		end
		else if(patnum < 800)
			beverage_size = M;
		else 
			beverage_size = S;
	end
	else if(patnum < 1200)begin
		beverage_type = Green_Tea;
		if(patnum < 1000) begin
			beverage_size = L;
		end
		else if(patnum < 1100)
			beverage_size = M;
		else 
			beverage_size = S;
	end
	else if(patnum < 1500)begin
		beverage_type = Green_Milk_Tea;
		if(patnum < 1300) begin
			beverage_size = L;
		end
		else if(patnum < 1400)
			beverage_size = M;
		else 
			beverage_size = S;
	end
	else if(patnum < 1800)begin
		beverage_type = Pineapple_Juice;
		if(patnum < 1600) begin
			beverage_size = L;
		end
		else if(patnum < 1700)
			beverage_size = M;
		else 
			beverage_size = S;
	end
	else if(patnum < 2000)begin
		beverage_type = Super_Pineapple_Tea;
		if(patnum < 1900)begin
			beverage_size = L;
		end
		else 
			beverage_size = M;
	end
	else if(patnum < 2600)begin
		if(patnum <= 2399)begin
			beverage_type = Super_Pineapple_Tea;
			beverage_size = S;
		end
		else begin
			beverage_type = Super_Pineapple_Milk_Tea;
			beverage_size = L;
		end
	end
	else begin
		if(patnum <= 3400)begin
			beverage_type = Super_Pineapple_Milk_Tea;
			beverage_size = M;
		end
		else begin
			beverage_type = Super_Pineapple_Milk_Tea;
			beverage_size = S;
		end
	end
	R_random_month.randomize();
	month = R_random_month.month;
	R_random_day = new(month);
	R_random_day.randomize();
	day = R_random_day.day;
	R_random_boxid.randomize();
	box_id = R_random_boxid.box_id;
	t = $urandom_range(1,3);
	repeat (t) @ (negedge clk);
	inf.sel_action_valid = 1;
	inf.D = {10'b0, r};

	@ (negedge clk);
	inf.sel_action_valid = 0;
	inf.D = 'bX;
	t = $urandom_range(0,2);
	repeat (t) @ (negedge clk);
	inf.type_valid = 1;
	inf.D = {9'b0, beverage_type};
	@ (negedge clk);
	inf.type_valid = 0;
	inf.D = 'bX;
	
	t = $urandom_range(0,2);
	repeat (t) @ (negedge clk);
	inf.size_valid = 1;
	inf.D = {10'b0, beverage_size};
	@ (negedge clk);
	inf.size_valid = 0;
	inf.D = 'bX;
	
	t = $urandom_range(0,2);
	repeat (t) @ (negedge clk);
	inf.date_valid = 1;
	inf.D = {3'b0, month, day};
	@ (negedge clk);
	inf.date_valid = 0;
	inf.D = 'bX;

	t = $urandom_range(0,2);
	repeat (t) @ (negedge clk);
	inf.box_no_valid = 1;
	inf.D = {7'b0, box_id};
	@ (negedge clk);
	inf.box_no_valid = 0;
	inf.D = 'bX;
endtask
//==================================================================
//      input supply task       
//==================================================================

task input_supply_task;

	R_random_month.randomize();
	month = R_random_month.month;
	R_random_day = new(month);
	R_random_day.randomize();
	day = R_random_day.day;
	R_random_boxid.randomize();
	box_id = R_random_boxid.box_id;

	t = $urandom_range(1,3);
	repeat (t) @ (negedge clk);
	inf.sel_action_valid = 1;
	inf.D = {10'b0, r};
	@ (negedge clk);
	inf.sel_action_valid = 0;
	inf.D = 'bX;

	t = $urandom_range(0,2);
	repeat (t) @ (negedge clk);
	inf.date_valid = 1;
	inf.D = {3'b0, month, day};
	@ (negedge clk);
	inf.date_valid = 0;
	inf.D = 'bX;

	t = $urandom_range(0,2);
	repeat (t) @ (negedge clk);
	inf.box_no_valid = 1;
	inf.D = {4'b0, box_id};
	@(negedge clk);
	inf.box_no_valid = 0;
	inf.D = 'bX;
	
	for(i = 0; i < 4; i = i + 1)begin
		t = $urandom_range(0,2);
		R_random_volume.randomize();
		volume = R_random_volume.volume;
		repeat (t) @ (negedge clk);
		inf.box_sup_valid = 1;
		inf.D = volume;
		box_sup_array[i] = volume;
		@(negedge clk);
		inf.box_sup_valid = 0;
		inf.D = 'bX;
	end
endtask
//===========================================================
//   input check task
//===========================================================
task input_check_task;
	R_random_month.randomize();
	month = R_random_month.month;
	R_random_day = new(month);
	R_random_day.randomize();
	day = R_random_day.day;
	R_random_boxid.randomize();
	box_id = R_random_boxid.box_id;

	t = $urandom_range(1,3);
	repeat (t) @ (negedge clk);
	inf.sel_action_valid = 1;
	inf.D = {10'b0, r};
	@ (negedge clk);
	inf.sel_action_valid = 0;
	inf.D = 'bX;

	t = $urandom_range(0,2);
	repeat (t) @ (negedge clk);
	inf.date_valid = 1;
	inf.D = {3'b0, month, day};
	@ (negedge clk);
	inf.date_valid = 0;
	inf.D = 'bX;

	t = $urandom_range(0,2);
	repeat (t) @ (negedge clk);
	inf.box_no_valid = 1;
	inf.D = {4'b0, box_id};
	@(negedge clk);
	inf.box_no_valid = 0;
	inf.D = 'bX;
endtask
//======================================================
//  calculate task
//======================================================

logic [11:0] black_tea, green_tea, pinapple, milk; 
logic [4:0] dram_day;
logic [3:0] dram_month;
logic [11:0] golden_volume;
logic golden_complete;
int sum;
task calculate_task;
	if(r == 0)begin
		black_tea = {golden_DRAM[65536 + 8 * box_id + 7], golden_DRAM[65536 + 8 * box_id + 6][7:4]};
		milk = {golden_DRAM[65536 + 8 * box_id + 3], golden_DRAM[65536 + 8 * box_id  + 2][7:4]} ;
		pinapple = {golden_DRAM[65536 + 8 * box_id + 2][3:0], golden_DRAM[65536 + 8 * box_id + 1]};
		green_tea = {golden_DRAM[65536 + 8 * box_id + 6][3:0], golden_DRAM[65536 + 8 * box_id + 5]};
		dram_month = golden_DRAM[65536 + 8 * box_id + 4];
		dram_day = golden_DRAM[65536 + 8 * box_id ];
		golden_complete = 1;
		case(beverage_type)
			Black_Tea:begin
				if(golden_DRAM[65536 + 8 * box_id + 4] < month || ( golden_DRAM[65536 + 8 * box_id + 4] == month && golden_DRAM[65536 + 8 * box_id] < day))begin
					golden_Err_mssg = 2'b01;
					golden_complete = 0;
				end
				else begin
					if(beverage_size == L)begin
						if(black_tea < 960)begin
							golden_Err_mssg = 2'b10;
							golden_complete = 0;
						end
						else begin
							golden_volume = black_tea;
							golden_volume = golden_volume - 960;
							golden_DRAM[65536 + 8 * box_id + 6][7:4] = golden_volume[3:0];
							golden_DRAM[65536 + 8 * box_id + 7] = golden_volume[11:4];
							golden_Err_mssg = 0;
						end
					end	
					else if(beverage_size == M)begin
						if(black_tea < 720)begin
							golden_complete = 0;
							golden_Err_mssg = 2'b10;
						end
						else begin
							golden_volume = black_tea;
							golden_volume = golden_volume - 720;
							golden_DRAM[65536 + 8 * box_id + 6][7:4] = golden_volume[3:0];
							golden_DRAM[65536 + 8 * box_id + 7] = golden_volume[11:4];
							golden_Err_mssg = 0;
						end
					end
					else begin
						if(black_tea < 480)begin
							golden_Err_mssg = 2'b10;
							golden_complete = 0;
						end
						else begin
							golden_volume = black_tea;
							golden_volume = golden_volume - 480;
							golden_DRAM[65536 + 8 * box_id + 6][7:4] = golden_volume[3:0];
							golden_DRAM[65536 + 8 * box_id + 7] = golden_volume[11:4];
							golden_Err_mssg = 0;
						end
					end
				end
			end	
			Milk_Tea:begin
				if(golden_DRAM[65536 + 8 * box_id + 4] < month || ( golden_DRAM[65536 + 8 * box_id + 4] == month && golden_DRAM[65536 + 8 * box_id] < day))begin
					golden_complete = 0;
					golden_Err_mssg = 2'b01; 
				end
				else begin
					if(beverage_size == L)begin
						if(black_tea < 720 || milk < 240)begin
							golden_Err_mssg = 2'b10;
							golden_complete = 0;
						end
						else begin
							golden_volume = black_tea;
							golden_volume = golden_volume - 720;
							golden_DRAM[65536 + 8 * box_id + 6][7:4] = golden_volume[3:0];
							golden_DRAM[65536 + 8 * box_id + 7] = golden_volume[11:4];
							golden_volume = milk;
							golden_volume = golden_volume - 240;
							golden_DRAM[65536 + 8 * box_id + 2][7:4] = golden_volume[3:0];
							golden_DRAM[65536 + 8 * box_id + 3] = golden_volume[11:4];
							golden_Err_mssg = 0;
						end
					end	
					else if(beverage_size == M)begin
						if(black_tea < 540 || milk < 180 )begin
							golden_Err_mssg = 2'b10;
							golden_complete = 0;
						end
						else begin
							golden_volume = black_tea;
							golden_volume = golden_volume - 540;
							golden_DRAM[65536 + 8 * box_id + 6][7:4] = golden_volume[3:0];
							golden_DRAM[65536 + 8 * box_id + 7] = golden_volume[11:4];
							golden_volume = milk;
							golden_volume = golden_volume - 180;
							golden_DRAM[65536 + 8 * box_id + 2][7:4] = golden_volume[3:0];
							golden_DRAM[65536 + 8 * box_id + 3] = golden_volume[11:4];
							golden_Err_mssg = 0;
						end
					end
					else begin
						if(black_tea < 360 || milk < 120)begin
							golden_Err_mssg = 2'b10;
							golden_complete = 0;
						end
						else begin
							golden_volume = black_tea;
							golden_volume = golden_volume - 360;
							golden_DRAM[65536 + 8 * box_id + 6][7:4] = golden_volume[3:0];
							golden_DRAM[65536 + 8 * box_id + 7] = golden_volume[11:4];
							golden_volume = milk;
							golden_volume = golden_volume - 120;
							golden_DRAM[65536 + 8 * box_id + 2][7:4] = golden_volume[3:0];
							golden_DRAM[65536 + 8 * box_id + 3] = golden_volume[11:4];
							golden_Err_mssg = 0;
						end
					end
				end
			end
			Extra_Milk_Tea:begin
				if(golden_DRAM[65536 + 8 * box_id + 4] < month || ( golden_DRAM[65536 + 8 * box_id + 4] == month && golden_DRAM[65536 + 8 * box_id] < day))begin
					golden_complete = 0;
					golden_Err_mssg = 2'b01; 
				end
				else begin
					if(beverage_size == L)begin
						if(black_tea < 480 || milk < 480)begin
							golden_Err_mssg = 2'b10;
							golden_complete = 0;
						end
						else begin
							golden_volume = black_tea;
							golden_volume = golden_volume - 480;
							golden_DRAM[65536 + 8 * box_id + 6][7:4] = golden_volume[3:0];
							golden_DRAM[65536 + 8 * box_id + 7] = golden_volume[11:4];
							golden_volume = milk;
							golden_volume = golden_volume - 480;
							golden_DRAM[65536 + 8 * box_id + 2][7:4] = golden_volume[3:0];
							golden_DRAM[65536 + 8 * box_id + 3] = golden_volume[11:4];
							golden_Err_mssg = 0;
						end
					end	
					else if(beverage_size == M)begin
						if(black_tea < 360 || milk < 360 )begin
							golden_Err_mssg = 2'b10;
							golden_complete = 0;
						end
						else begin
							golden_volume = black_tea;
							golden_volume = golden_volume - 360;
							golden_DRAM[65536 + 8 * box_id + 6][7:4] = golden_volume[3:0];
							golden_DRAM[65536 + 8 * box_id + 7] = golden_volume[11:4];
							golden_volume = milk;
							golden_volume = golden_volume - 360;
							golden_DRAM[65536 + 8 * box_id + 2][7:4] = golden_volume[3:0];
							golden_DRAM[65536 + 8 * box_id + 3] = golden_volume[11:4];
							golden_Err_mssg = 0;
						end
					end
					else begin
						if(black_tea < 240 || milk < 240)begin
							golden_Err_mssg = 2'b10;
							golden_complete = 0;
						end
						else begin
							golden_volume = black_tea;
							golden_volume = golden_volume - 240;
							golden_DRAM[65536 + 8 * box_id + 6][7:4] = golden_volume[3:0];
							golden_DRAM[65536 + 8 * box_id + 7] = golden_volume[11:4];
							golden_volume = milk;
							golden_volume = golden_volume - 240;
							golden_DRAM[65536 + 8 * box_id + 2][7:4] = golden_volume[3:0];
							golden_DRAM[65536 + 8 * box_id + 3] = golden_volume[11:4];
							golden_Err_mssg = 0;
						end
					end
				end
			end
			Green_Tea:begin
				if(golden_DRAM[65536 + 8 * box_id + 4] < month || ( golden_DRAM[65536 + 8 * box_id + 4] == month && golden_DRAM[65536 + 8 * box_id] < day))begin
					golden_Err_mssg = 2'b01; 
					golden_complete = 0;
				end
				else begin
					if(beverage_size == L)begin
						if(green_tea < 960 )begin
							golden_Err_mssg = 2'b10;
							golden_complete = 0;
						end
						else begin
							golden_volume = green_tea;
							golden_volume = golden_volume - 960;
							golden_DRAM[65536 + 8 * box_id + 5] = golden_volume[7:0];
							golden_DRAM[65536 + 8 * box_id + 6][3:0] = golden_volume[11:8];
							golden_Err_mssg = 0;
						end
					end	
					else if(beverage_size == M)begin
						if(green_tea < 720 )begin
							golden_Err_mssg = 2'b10;
							golden_complete = 0;
						end
						else begin
							golden_volume =green_tea;
							golden_volume = golden_volume - 720;
							golden_DRAM[65536 + 8 * box_id + 5] = golden_volume[7:0];
							golden_DRAM[65536 + 8 * box_id + 6][3:0] = golden_volume[11:8];
							golden_Err_mssg = 0;
						end
					end
					else begin
						if(green_tea < 480)begin
							golden_Err_mssg = 2'b10;
							golden_complete = 0;
						end
						else begin
							golden_volume = green_tea;
							golden_volume = golden_volume - 480;
							golden_DRAM[65536 + 8 * box_id + 5] = golden_volume[7:0];
							golden_DRAM[65536 + 8 * box_id + 6][3:0] = golden_volume[11:8];
							golden_Err_mssg = 0;
						end
					end
				end
			end
			Green_Milk_Tea:begin
				if(golden_DRAM[65536 + 8 * box_id + 4] < month || ( golden_DRAM[65536 + 8 * box_id + 4] == month && golden_DRAM[65536 + 8 * box_id] < day))begin
					golden_Err_mssg = 2'b01; 
					golden_complete = 0;
				end
				else begin
					if(beverage_size == L)begin
						if(green_tea < 480 || milk < 480 )begin
							golden_Err_mssg = 2'b10;
							golden_complete = 0;
						end
						else begin
							golden_volume = green_tea;
							golden_volume = golden_volume - 480;
							golden_DRAM[65536 + 8 * box_id + 5] = golden_volume[7:0];
							golden_DRAM[65536 + 8 * box_id + 6][3:0] = golden_volume[11:8];
							golden_volume = milk;
							golden_volume = golden_volume - 480;
							golden_DRAM[65536 + 8 * box_id + 2][7:4] = golden_volume[3:0];
							golden_DRAM[65536 + 8 * box_id + 3] = golden_volume[11:4];
							golden_Err_mssg = 0;
						end
					end	
					else if(beverage_size == M)begin
						if(green_tea < 360 || milk < 360)begin
							golden_Err_mssg = 2'b10;
							golden_complete = 0;
						end
						else begin
							golden_volume = green_tea;
							golden_volume = golden_volume - 360;
							golden_DRAM[65536 + 8 * box_id + 5] = golden_volume[7:0];
							golden_DRAM[65536 + 8 * box_id + 6][3:0] = golden_volume[11:8];
							golden_volume = milk;
							golden_volume = golden_volume - 360;
							golden_DRAM[65536 + 8 * box_id + 2][7:4] = golden_volume[3:0];
							golden_DRAM[65536 + 8 * box_id + 3] = golden_volume[11:4];
							golden_Err_mssg = 0;
						end
					end
					else begin
						if(green_tea < 240 || milk < 240)begin
							golden_Err_mssg = 2'b10;
							golden_complete = 0;
						end
						else begin
							golden_volume = green_tea;
							golden_volume = golden_volume - 240;
							golden_DRAM[65536 + 8 * box_id + 5] = golden_volume[7:0];
							golden_DRAM[65536 + 8 * box_id + 6][3:0] = golden_volume[11:8];
							golden_volume = milk;
							golden_volume = golden_volume - 240;
							golden_DRAM[65536 + 8 * box_id + 2][7:4] = golden_volume[3:0];
							golden_DRAM[65536 + 8 * box_id + 3] = golden_volume[11:4];
							golden_Err_mssg = 0;
						end
					end
				end
			end
			Pineapple_Juice:begin
				if(golden_DRAM[65536 + 8 * box_id + 4] < month || ( golden_DRAM[65536 + 8 * box_id + 4] == month && golden_DRAM[65536 + 8 * box_id] < day))begin
					golden_complete = 0;
					golden_Err_mssg = 2'b01; 
				end
				else begin
					if(beverage_size == L)begin
						if(pinapple < 960 )begin
							golden_complete = 0;
							golden_Err_mssg = 2'b10;
						end
						else begin
							golden_volume = pinapple;
							golden_volume = golden_volume - 960;
							golden_DRAM[65536 + 8 * box_id + 1] = golden_volume[7:0];
							golden_DRAM[65536 + 8 * box_id + 2][3:0] = golden_volume[11:8];
							golden_Err_mssg = 0;
						end
					end	
					else if(beverage_size == M)begin
						if(pinapple < 720 )begin
							golden_complete = 0;
							golden_Err_mssg = 2'b10;
						end
						else begin
							golden_volume = pinapple;
							golden_volume = golden_volume - 720;
							golden_DRAM[65536 + 8 * box_id + 1] = golden_volume[7:0];
							golden_DRAM[65536 + 8 * box_id + 2][3:0] = golden_volume[11:8];
							golden_Err_mssg = 0;
						end
					end
					else begin
						if(pinapple < 480)begin
							golden_complete = 0;
							golden_Err_mssg = 2'b10;
						end
						else begin
							golden_volume = pinapple;
							golden_volume = golden_volume - 480;
							golden_DRAM[65536 + 8 * box_id + 1] = golden_volume[7:0];
							golden_DRAM[65536 + 8 * box_id + 2][3:0] = golden_volume[11:8];
							golden_Err_mssg = 0;
						end
					end
				end
			end
			Super_Pineapple_Tea:begin
				if(golden_DRAM[65536 + 8 * box_id + 4] < month || ( golden_DRAM[65536 + 8 * box_id + 4] == month && golden_DRAM[65536 + 8 * box_id] < day))begin
					golden_complete = 0;
					golden_Err_mssg = 2'b01; 
				end
				else begin
					if(beverage_size == L)begin
						if(pinapple < 480 || black_tea < 480 )begin
							golden_complete = 0;
							golden_Err_mssg = 2'b10;
						end
						else begin
							golden_volume = pinapple;
							golden_volume = golden_volume - 480;
							golden_DRAM[65536 + 8 * box_id + 1] = golden_volume[7:0];
							golden_DRAM[65536 + 8 * box_id + 2][3:0] = golden_volume[11:8];
							golden_volume = black_tea;
							golden_volume = golden_volume - 480;
							golden_DRAM[65536 + 8 * box_id + 6][7:4] = golden_volume[3:0];
							golden_DRAM[65536 + 8 * box_id + 7] = golden_volume[11:4];
							golden_Err_mssg = 0;
						end
					end	
					else if(beverage_size == M)begin
						if(pinapple < 360 || black_tea < 360 )begin
							golden_Err_mssg = 2'b10;
							golden_complete = 0;
						end
						else begin
							golden_volume = pinapple;
							golden_volume = golden_volume - 360;
							golden_DRAM[65536 + 8 * box_id + 1] = golden_volume[7:0];
							golden_DRAM[65536 + 8 * box_id + 2][3:0] = golden_volume[11:8];
							golden_volume = black_tea;
							golden_volume = golden_volume - 360;
							golden_DRAM[65536 + 8 * box_id + 6][7:4] = golden_volume[3:0];
							golden_DRAM[65536 + 8 * box_id + 7] = golden_volume[11:4];
							golden_Err_mssg = 0;
						end
					end
					else begin
						if(pinapple < 240 || black_tea < 240)begin
							golden_Err_mssg = 2'b10;
							golden_complete = 0;
						end
						else begin
							golden_volume = pinapple;
							golden_volume = golden_volume - 240;
							golden_DRAM[65536 + 8 * box_id + 1] = golden_volume[7:0];
							golden_DRAM[65536 + 8 * box_id + 2][3:0] = golden_volume[11:8];
							golden_volume = black_tea;
							golden_volume = golden_volume - 240;
							golden_DRAM[65536 + 8 * box_id + 6][7:4] = golden_volume[3:0];
							golden_DRAM[65536 + 8 * box_id + 7] = golden_volume[11:4];
							golden_Err_mssg = 0;
						end
					end
				end
			end
			Super_Pineapple_Milk_Tea:begin
				if(golden_DRAM[65536 + 8 * box_id + 4] < month || ( golden_DRAM[65536 + 8 * box_id + 4] == month && golden_DRAM[65536 + 8 * box_id] < day))begin
					golden_complete = 0;
					golden_Err_mssg = 2'b01; 
				end
				else begin
					if(beverage_size == L)begin
						if(pinapple < 240 || black_tea < 480 || milk < 240)begin
							golden_Err_mssg = 2'b10;
							golden_complete = 0;
						end
						else begin
							golden_volume = pinapple;
							golden_volume = golden_volume - 240;
							golden_DRAM[65536 + 8 * box_id + 1] = golden_volume[7:0];
							golden_DRAM[65536 + 8 * box_id + 2][3:0] = golden_volume[11:8];
							golden_volume = black_tea;
							golden_volume = golden_volume - 480;
							golden_DRAM[65536 + 8 * box_id + 6][7:4] = golden_volume[3:0];
							golden_DRAM[65536 + 8 * box_id + 7] = golden_volume[11:4];
							golden_volume = milk;
							golden_volume = golden_volume - 240;
							golden_DRAM[65536 + 8 * box_id + 2][7:4] = golden_volume[3:0];
							golden_DRAM[65536 + 8 * box_id + 3] = golden_volume[11:4];
							golden_Err_mssg = 0;
						end
					end	
					else if(beverage_size == M)begin
						if(pinapple < 180 || black_tea < 360 || milk < 180 )begin
							golden_Err_mssg = 2'b10;
							golden_complete = 0;
						end
						else begin
							golden_volume = pinapple;
							golden_volume = golden_volume - 180;
							golden_DRAM[65536 + 8 * box_id + 1] = golden_volume[7:0];
							golden_DRAM[65536 + 8 * box_id + 2][3:0] = golden_volume[11:8];
							golden_volume = black_tea;
							golden_volume = golden_volume - 360;
							golden_DRAM[65536 + 8 * box_id + 6][7:4] = golden_volume[3:0];
							golden_DRAM[65536 + 8 * box_id + 7] = golden_volume[11:4];
							golden_volume = milk;
							golden_volume = golden_volume - 180;
							golden_DRAM[65536 + 8 * box_id + 2][7:4] = golden_volume[3:0];
							golden_DRAM[65536 + 8 * box_id + 3] = golden_volume[11:4];
							golden_Err_mssg = 0;
						end
					end
					else begin
						if(pinapple < 120 || black_tea < 240 || milk < 120 )begin
							golden_Err_mssg = 2'b10;
							golden_complete = 0;
						end
						else begin
							golden_volume = pinapple;
							golden_volume = golden_volume - 120;
							golden_DRAM[65536 + 8 * box_id + 1] = golden_volume[7:0];
							golden_DRAM[65536 + 8 * box_id + 2][3:0] = golden_volume[11:8];
							golden_volume = black_tea;
							golden_volume = golden_volume - 240;
							golden_DRAM[65536 + 8 * box_id + 6][7:4] = golden_volume[3:0];
							golden_DRAM[65536 + 8 * box_id + 7] = golden_volume[11:4];
							golden_volume = milk;
							golden_volume = golden_volume - 120;
							golden_DRAM[65536 + 8 * box_id + 2][7:4] = golden_volume[3:0];
							golden_DRAM[65536 + 8 * box_id + 3] = golden_volume[11:4];
							golden_Err_mssg = 0;
						end
					end
				end
			end
		endcase
	
	end
	else if(r == 1)begin
		black_tea 	= {golden_DRAM[65536 + 8 * box_id + 7], golden_DRAM[65536 + 8 * box_id + 6][7:4]};
		milk 		= {golden_DRAM[65536 + 8 * box_id + 3], golden_DRAM[65536 + 8 * box_id  + 2][7:4]} ;
		pinapple 	= {golden_DRAM[65536 + 8 * box_id + 2][3:0], golden_DRAM[65536 + 8 * box_id + 1]};
		green_tea 	= {golden_DRAM[65536 + 8 * box_id + 6][3:0], golden_DRAM[65536 + 8 * box_id + 5]};
		dram_month 	= golden_DRAM[65536 + 8 * box_id + 4];
		dram_day 	= golden_DRAM[65536 + 8 * box_id ];
		golden_complete = 1;
		golden_Err_mssg = 0;
		golden_volume = black_tea + box_sup_array[0];
		golden_DRAM[65536 + 8 * box_id + 7] = golden_volume[11:4];
		golden_DRAM[65536 + 8 * box_id + 6][7:4] = golden_volume[3:0];
		
		golden_volume = green_tea + box_sup_array[1];
		golden_DRAM[65536 + 8 * box_id + 6][3:0] = golden_volume[11:8];
		golden_DRAM[65536 + 8 * box_id + 5] = golden_volume[7:0];
		
		golden_volume = milk + box_sup_array[2];
		golden_DRAM[65536 + 8 * box_id + 3] = golden_volume[11:4];
		golden_DRAM[65536 + 8 * box_id + 2][7:4] = golden_volume[3:0];
		
		golden_volume = pinapple + box_sup_array[3];
		golden_DRAM[65536 + 8 * box_id + 2][3:0] = golden_volume[11:8];
		golden_DRAM[65536 + 8 * box_id + 1] = golden_volume[7:0];
		
		golden_DRAM[65536 + 8 * box_id] = day;
		golden_DRAM[65536 + 8 * box_id + 4] = month;
		sum = box_sup_array[0] + black_tea;
		if(sum > 4095 )begin
			golden_complete = 0;
			golden_Err_mssg = 2'b11;
			golden_volume = 4095;
			golden_DRAM[65536 + 8 * box_id + 7] = golden_volume[11:4];
			golden_DRAM[65536 + 8 * box_id + 6][7:4] = golden_volume[3:0];
		end
		sum = box_sup_array[1] + green_tea;
		if(sum > 4095)begin
			golden_complete = 0;
			golden_Err_mssg = 2'b11;
			golden_volume = 4095;
			golden_DRAM[65536 + 8 * box_id + 6][3:0] = golden_volume[11:8];
			golden_DRAM[65536 + 8 * box_id + 5] = golden_volume[7:0];
		end
		sum = box_sup_array[2] + milk;
		if(sum > 4095)begin
			golden_complete = 0;
			golden_Err_mssg = 2'b11;
			golden_volume = 4095;
			golden_DRAM[65536 + 8 * box_id + 3] = golden_volume[11:4];
			golden_DRAM[65536 + 8 * box_id + 2][7:4] = golden_volume[3:0];
		end
		sum = box_sup_array[3] + pinapple;
		if(sum > 4095)begin
			golden_complete = 0;
			golden_Err_mssg = 2'b11;
			golden_volume = 4095;
			golden_DRAM[65536 + 8 * box_id + 2][3:0] = golden_volume[11:8];
			golden_DRAM[65536 + 8 * box_id + 1] = golden_volume[7:0];
		end
	end
	else begin
		black_tea = {golden_DRAM[65536 + 8 * box_id + 7], golden_DRAM[65536 + 8 * box_id + 6][7:4]};
		milk = {golden_DRAM[65536 + 8 * box_id + 3], golden_DRAM[65536 + 8 * box_id  + 2][7:4]} ;
		pinapple = {golden_DRAM[65536 + 8 * box_id + 2][3:0], golden_DRAM[65536 + 8 * box_id + 1]};
		green_tea = {golden_DRAM[65536 + 8 * box_id + 6][3:0], golden_DRAM[65536 + 8 * box_id + 5]};
		dram_month = golden_DRAM[65536 + 8 * box_id + 4];
		dram_day = golden_DRAM[65536 + 8 * box_id ];
		golden_complete = 1;
		golden_Err_mssg = 0;
		if(golden_DRAM[65536 + 8 * box_id + 4] < month || ( golden_DRAM[65536 + 8 * box_id + 4] == month && golden_DRAM[65536 + 8 * box_id] < day))begin
			golden_Err_mssg = 2'b01;
			golden_complete = 0;
		end
	end
endtask
//======================================================
//  wait out valid task
//======================================================

task wait_out_valid_task;
	while(inf.out_valid !== 1)begin
		latency = latency + 1;
		if(latency > 1000)begin
			$display("==========================================================");
			$display("            execution latency over 1000                   ");
			$display("                   action = %d                            ", r);
			$display("                   wrong answer                           ");
			$display("==========================================================");
			$finish;
		end
		@(negedge clk);
	end
endtask
//=========================================================
//  check ans task 
//=========================================================
task check_ans_task;
	if(inf.complete !== golden_complete)begin
		$display(`WHITE);
		$display("==========================================================");
		$display("                    Wrong Answer                          ");
		$display("==========================================================");
		$display("            golden complete  = %d  your complete = %d     ", golden_complete, inf.complete);
		$display("                   action = %d                            ", r);
		$display("==========================================================");
		$display("==========================================================");
		$display("            golden Err_msg   = %d  your Err_msg = %d      ", golden_Err_mssg, inf.err_msg);
		$display("                   action = %d                            ", r);
		$display("==========================================================");
		$finish;
	end
	if(inf.err_msg !== golden_Err_mssg)begin
		
		$display(`WHITE);
		$display("==========================================================");
		$display("                    Wrong Answer                          ");
		$display("==========================================================");
		$display("            golden Err_msg   = %d  your Err_msg = %d      ", golden_Err_mssg, inf.err_msg);
		$display("                   action = %d                            ", r);
		$display("==========================================================");
		$finish;
	end
	@(negedge clk);
	total_latency = total_latency + latency;
	latency = 0;
	
endtask
endprogram


