/*
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
NYCU Institute of Electronic
2023 Autumn IC Design Laboratory 
Lab10: SystemVerilog Coverage & Assertion
File Name   : CHECKER.sv
Module Name : CHECKER
Release version : v1.0 (Release Date: Nov-2023)
Author : Jui-Huang Tsai (erictsai.10@nycu.edu.tw)
//   (C) Copyright Laboratory System Integration and Silicon Implementation
//   All Right Reserved
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
*/

`include "Usertype_BEV.sv"
module Checker(input clk, INF.CHECKER inf);
import usertype::*;

/*
    Coverage Part
*/

/*
class BEV;
    Bev_Type bev_type;
    Bev_Size bev_size;
endclass

BEV bev_info = new();

always_ff @(posedge clk) begin
    if (inf.type_valid) begin
        bev_info.bev_type = inf.D.d_type[0];
    end
end
*/
//sample
Order_Info bev;
// assign bev.Bev_Type_O = inf.D.d_type[0];
// assign bev.Bev_Size_O = inf.D.d_size[0];
assign bev.Bev_Type_O = (inf.type_valid)? inf.D.d_type[0]: bev.Bev_Type_O;
assign bev.Bev_Size_O = (inf.size_valid)? inf.D.d_size[0]: bev.Bev_Size_O;

Error_Msg err_msg;
assign err_msg = inf.err_msg;

ING ing[4];
logic [1:0] cnt;
initial begin
	cnt = 0;
	@(negedge clk);
	while(1) begin
		if (inf.box_sup_valid) cnt = cnt + 1;
		@(negedge clk);
	end
end
always_comb begin
	if (cnt == 0) ing[0] = inf.D.d_ing[0];
	if (cnt == 1) ing[1] = inf.D.d_ing[0];
	if (cnt == 2) ing[2] = inf.D.d_ing[0];
	if (cnt == 3) ing[3] = inf.D.d_ing[0];
end

Action act;
assign act = inf.D.d_act[0];
/*
1. Each case of Beverage_Type should be select at least 100 times.
*/
covergroup Spec1 @(posedge clk);
	option.per_instance = 1;
	option.at_least = 100;
	bevtype: coverpoint bev.Bev_Type_O iff(inf.type_valid) {
		bins bev_type [] = {[Black_Tea:Super_Pineapple_Milk_Tea]};
	}
endgroup

/*
covergroup Spec1 @(posedge clk);
    option.per_instance = 1;
    option.at_least = 100;
    btype:coverpoint bev_info.bev_type{
        bins b_bev_type [] = {[Black_Tea:Super_Pineapple_Milk_Tea]};
    }
endgroup
*/

/*
2.	Each case of Bererage_Size should be select at least 100 times.
*/
covergroup Spec2 @(posedge clk);
	option.per_instance = 1;
	option.at_least = 100;
	bevsize: coverpoint bev.Bev_Size_O iff(inf.size_valid) {
		bins bev_size [] = {[L:S]};
	}
endgroup
/*
3.	Create a cross bin for the SPEC1 and SPEC2. Each combination should be selected at least 100 times. 
(Black Tea, Milk Tea, Extra Milk Tea, Green Tea, Green Milk Tea, Pineapple Juice, Super Pineapple Tea, Super Pineapple Tea) x (L, M, S)
*/
covergroup Spec3 @(posedge clk);
	option.per_instance = 1;
	Bev_type: coverpoint bev.Bev_Type_O {
		option.at_least = 0;
	}
	Bev_size: coverpoint bev.Bev_Size_O {
		option.at_least = 0;
	}
	Size_Type_Comb: cross bev.Bev_Type_O, bev.Bev_Size_O iff(inf.size_valid){
		option.at_least = 100;
		//bins size_type_comb = binsof(Bev_size) intersect {[L:S]} && binsof(Bev_type) intersect {[Black_Tea:Super_Pineapple_Milk_Tea]};
	}
endgroup
/*
4.	Output signal inf.err_msg should be No_Err, No_Exp, No_Ing and Ing_OF, each at least 20 times. (Sample the value when inf.out_valid is high)
*/
covergroup Spec4 @(posedge clk);
	option.per_instance = 1;
	option.at_least = 20;
	Err: coverpoint err_msg iff (inf.out_valid) {
		bins err [] = {[No_Err:Ing_OF]};
	}
endgroup
/*
5.	Create the transitions bin for the inf.D.act[0] signal from [0:2] to [0:2]. Each transition should be hit at least 200 times. (sample the value at posedge clk iff inf.sel_action_valid)
*/
covergroup Spec5 @(posedge clk);
	option.per_instance = 1;
	option.at_least = 200;
	Action: coverpoint act iff(inf.sel_action_valid) {
		bins action_trans [] = ([Make_drink:Check_Valid_Date] => [Make_drink:Check_Valid_Date]);
	}
endgroup
/*
6.	Create a covergroup for material of supply action with auto_bin_max = 32, and each bin have to hit at least one time.
*/
covergroup Spec6 @(posedge clk);
	option.per_instance = 1;
	option.at_least = 1;
	Supply_material: coverpoint {ing[0], ing[1], ing[2], ing[3]} iff(cnt == 3) {
		option.auto_bin_max = 32;
	}
endgroup
/*
    Create instances of Spec1, Spec2, Spec3, Spec4, Spec5, and Spec6
*/
// Spec1_2_3 cov_inst_1_2_3 = new();
Spec1 spec1 = new();
Spec2 spec2 = new();
Spec3 spec3 = new();
Spec4 spec4 = new();
Spec5 spec5 = new();
Spec6 spec6 = new();

/*
    Asseration
*/

/*
    If you need, you can declare some FSM, logic, flag, and etc. here.
*/
logic [2:0] state;
logic [1:0] supply_cnt;
parameter st_make = 3'd1, st_idle = 3'd0, st_sup = 3'd2, st_date = 3'd3, st_last = 3'd4;
initial begin 
	state = st_last;
	supply_cnt = 0;
	@(negedge inf.rst_n);
	@(posedge inf.rst_n);
	while(1) begin
		@(negedge clk);
		case(state)
			st_last:
				if (inf.sel_action_valid)
					if (inf.D.d_act[0] == Make_drink) state = st_make;
					else if (inf.D.d_act[0] == Supply) state = st_sup;
					else state = st_date;
			st_make, st_date:
				if (inf.box_no_valid) state = st_last;
			st_sup:
				if (supply_cnt == 3 && inf.box_sup_valid) state = st_last;
			// st_last:
				// if (supply_cnt == 0 | inf.box_no_valid) state = st_idle;
		endcase
		if (inf.box_sup_valid) supply_cnt = supply_cnt + 1;
	end
end

logic cin, cout;
logic [1:0] cin_state;
parameter cin_idle = 2'b00, cin_wait = 2'b01, cin_out = 2'b10;
initial begin
	cin_state = cin_idle;
	cin = 0;
	cout = 0;
	@(negedge inf.rst_n);
	@(posedge inf.rst_n);
	while(1) begin
		cin = inf.C_in_valid;
		cout = inf.C_out_valid;
		case(cin_state)
			cin_idle: cin_state = (cin)? cin_wait: cin_state;
			cin_wait: cin_state = (cin)? cin_wait: (cout)? cin_idle: cin_out;
			cin_out: cin_state = (cout)? cin_idle: cin_out;
		endcase
		@(negedge clk);
	end
end
/*
    1. All outputs signals (including BEV.sv and bridge.sv) should be zero after reset.
*/
initial begin
	//as_reset: assert (property (Reset_BEV) && property (Reset_Bridge_BEV) && property (Reset_Bridge_DRAM));
	//@(negedge inf.rst_n);
	//@(posedge clk);
	#88
	as_reset: assert property(Reset)
	else begin
		$display("************************************************************");    
		$display("*              Output signal should be reseted             *");
		$display("*----------------------------------------------------------*");
		$display("*                          BEV                             *");
		$display("*         out_valid = %b, complete = %b, err_msg = %b         *", inf.out_valid, inf.complete, inf.out_valid);
		$display("*         C_in_valid = %b, C_data_w = %b, C_addr = %b, C_r_wb = %b         *", inf.C_in_valid, inf.C_data_w, inf.C_addr, inf.C_r_wb);
		$display("*----------------------------------------------------------*");
		$display("*                         Bridge                           *");
		$display("*               C_out_valid = %b, C_data_r = %b              *", inf.C_out_valid, inf.C_data_r);
		$display("*          AR_VALID = %b, AR_ADDR = %b, R_READY = %b          *", inf.AR_VALID, inf.AR_ADDR, inf.R_READY);
		$display("*                 AW_VALID = %b, AW_ADDR = %b                *", inf.AW_VALID, inf.AW_ADDR);
		$display("*           W_VALID = %b, W_DATA = %b, B_READY = %b           *", inf.W_VALID, inf.W_DATA, inf.R_READY);
		$display("************************************************************");
		$display("Assertion 1 is violated");
		$fatal;
	end
end
// property Reset;
	// @(posedge clk) ((property (Reset_BEV)) && (property (Reset_Bridge_BEV)) && (property (Reset_Bridge_DRAM)));
// endproperty: Reset

property Reset;
	@(negedge clk) !inf.rst_n |=> (inf.out_valid =='b0 && inf.complete =='b0 && inf.err_msg =='b0 && inf.C_in_valid =='b0 && inf.C_addr =='b0 && inf.C_r_wb =='b0 && inf.AR_VALID =='b0 && inf.AR_ADDR =='b0 && inf.R_READY =='b0 && inf.AW_VALID =='b0 && inf.AW_ADDR =='b0 && inf.W_VALID =='b0 && inf.W_DATA ==0 && inf.B_READY =='b0 && inf.C_out_valid =='b0 && inf.C_data_r =='b0 && inf.C_data_w =='b0);
endproperty: Reset

// property Reset_BEV;
	// #system_clock !inf.rst_n ##2 (!(inf.out_valid | inf.complete | inf.err_msg | inf.C_in_valid) && (inf.C_data_w==0));
// endproperty: Reset_BEV

// property Reset_Bridge_DRAM;
	// #system_clock !inf.rst_n ##2 !(inf.AR_VALID | inf.AR_ADDR | inf.R_READY | inf.AW_VALID | inf.AW_ADDR | inf.W_VALID | inf.W_DATA | inf.B_READY);
// endproperty: Reset_Bridge_DRAM

// property Reset_Bridge_BEV;
	// #system_clock !inf.rst_n ##2 !(inf.C_out_valid | inf.C_data);
// endproperty: Reset_Bridge_BEV
	
/*
    2.	Latency should be less than 1000 cycles for each operation.
*/
integer latency = 0;
integer total_latency = 0;
initial begin
	@(negedge inf.rst_n);
	@(posedge inf.rst_n);
	while(1) begin
		while (inf.sel_action_valid !== 1) begin
			latency = 0;
			@(negedge clk);
		end
		while (inf.out_valid !== 1) begin
			latency = latency+1;
			@(negedge clk);
		end
		total_latency = total_latency + latency;
	end
end

always@(negedge clk) begin
	as_lat: assert (latency < 1000)
	else begin
		$display("************************************************************");    
		$display("*                   Execution cycle >= 1000                *");
		$display("************************************************************");
		$display("Assertion 2 is violated");
		$fatal;
	end
end
/*
    3. If out_valid does not pull up, complete should be 0.
*/
always@(negedge clk) begin
	as_errmsg_complete: assert property 
		(@(negedge clk) inf.complete == 1 |-> inf.err_msg == No_Err)
	else begin
		$display("************************************************************");    
		$display("*    complete signal should be zero while out_valid = 0    *");
		$display("************************************************************");
		$display("Assertion 3 is violated");
		$fatal;
	end
end

/*
    4. Next input valid will be valid 1-4 cycles after previous input valid fall.
*/
logic valid;
//assign valid = (inf.sel_action_valid | inf.size_valid | inf.type_valid | inf.date_valid | inf.box_no_valid | inf.box_sup_valid)? 1: 0;
initial begin
	valid = 0;
	@(negedge inf.rst_n);
	@(posedge inf.rst_n);
	while(1) begin
		@(negedge clk);
		if (inf.sel_action_valid | inf.size_valid | inf.type_valid | inf.date_valid | inf.box_no_valid | inf.box_sup_valid)
			valid = 1;
		else valid = 0;
	end
end
always@(negedge clk) begin
	if (state != st_last) begin
		//$display("state = %d", state);
		as_next_input: assert property
			(@(negedge clk) valid == 1 |-> ##[1:4] valid == 1) //begin
				//$display("state = %d", state);
			//end
			//(next_input)
		else begin
			$display("*****************************************************************************");    
			$display("* Next input valid will be valid 1-4 cycles after previous input valid fail *");
			$display("*****************************************************************************");
			$display("Assertion 4 is violated");
			$fatal;
		end
	end
end

// property next_input;
	// @(negedge clk) valid == 1 |-> ##[1:4] valid == 1;
// endproperty: next_input
/*
    5. All input valid signals won't overlap with each other. 
*/
always@(negedge clk) begin
	as_input_overlap: assert property (input_overlap)
	else begin
		$display("*****************************************************************************");    
		$display("*                            input valid overlap                            *");
		$display("*      sel_action_valid = %b,   type_valid = %b, size_valid = %b               *", inf.sel_action_valid, inf.type_valid, inf.size_valid);
		$display("*            date_valid = %b, box_no_valid = %b, box_sup_valid = %b            *", inf.date_valid, inf.box_no_valid, inf.box_sup_valid);
		$display("*****************************************************************************");
		$display("Assertion 5 is violated");
		$fatal;
	end
end

logic [5:0] input_seq;
initial begin
	input_seq = 0;
	@(negedge inf.rst_n);
	@(posedge inf.rst_n);
	while(1) begin
		input_seq = {inf.sel_action_valid, inf.type_valid, inf.size_valid, inf.date_valid, inf.box_no_valid, inf.box_sup_valid};
		@(negedge clk);
	end
end

property input_overlap;
	@(negedge clk) 1'b1 ##1 ($onehot(input_seq) || input_seq==0);
endproperty: input_overlap
/*
    6. Out_valid can only be high for exactly one cycle.
*/
always@(negedge clk) begin
	as_outvalid_one: assert property 
		(@(negedge clk) $rose(inf.out_valid) |=> $fell(inf.out_valid))
	else begin
		$display("*****************************************************************************");    
		$display("*                  out_valid pull high more than 1 cycle                    *");
		$display("*****************************************************************************");
		$display("Assertion 6 is violated");
		$fatal;
	end
end


/*
    7. Next operation will be valid 1-4 cycles after out_valid fall.
*/

always@(negedge clk) begin
	
	as_next_pat_delay: assert property
		(@(negedge clk) $rose(inf.out_valid) ##1 $fell(inf.out_valid) |-> ##[1:4] inf.sel_action_valid)
	else begin
		$display("*****************************************************************************");    
		$display("*       Next operation will be valid 1-4 cycles after out_valid fall        *");
		$display("*****************************************************************************");
		$display("Assertion 7 is violated");
		$fatal;
	end
end
/*
    8. The input date from pattern should adhere to the real calendar. (ex: 2/29, 3/0, 4/31, 13/1 are illegal cases)
*/
Month month;
Day day;
initial begin
	month = 1;
	day = 1;
	@(negedge inf.rst_n);
	@(posedge inf.rst_n);
	while(1) begin
		month = (inf.date_valid)? inf.D.d_date[0][8:5]: month;
		day = (inf.date_valid)? inf.D.d_date[0][4:0]: day;
		@(negedge clk);
	end
end

always@(negedge clk) begin
	as_real_date: assert ((month == 2 && day > 0 && day < 29) 
						|| ((month == 4 || month == 6 || month == 9 || month == 11) && (day > 0 && day < 31))
						|| ((month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12)
						&& (day > 0 && day < 32)))
	else begin
		$display("*****************************************************************************");    
		$display("*                             invalid date                                  *");
		$display("*                          month = %2d, day = %2d                             *", month, day);
		$display("*****************************************************************************");
		$display("Assertion 8 is violated");
		$fatal;
	end
end
/*
    9. C_in_valid can only be high for one cycle and can't be pulled high again before C_out_valid
*/
always@(negedge clk) begin
	if (cin_state == cin_wait) begin
		as_cin_1: assert property
			(@(negedge clk) cin |=> !cin)
		else begin
			$display("*****************************************************************************");    
			$display("*                 C_in_valid can only be high for one cycle                 *");
			$display("*****************************************************************************");
			$display("Assertion 9 is violated");
			$fatal;
		end
	end
	else if (cin_state == cin_out) begin
		as_cin_2: assert (cin == 0)
		else begin
			$display("*****************************************************************************");    
			$display("*         C_in_valid can't be pulled high again before C_out_valid          *");
			$display("*****************************************************************************");
			$display("Assertion 9 is violated");
			$fatal;
		end
	end
end

endmodule
