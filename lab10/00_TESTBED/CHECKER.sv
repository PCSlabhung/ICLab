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


/*
1. Each case of Beverage_Type should be select at least 100 times.
*/


covergroup Spec1 @(posedge clk iff(inf.type_valid));
    option.per_instance = 1;
    option.at_least = 100;
    btype:coverpoint bev_info.bev_type{
        bins b_bev_type [] = {[Black_Tea:Super_Pineapple_Milk_Tea]};
    }
endgroup

Spec1 s1 = new();
/*
2.	Each case of Bererage_Size should be select at least 100 times.
*/
always_ff @(posedge clk )begin
	if(inf.size_valid)begin
		bev_info.bev_size = inf.D.d_size[0];
	end
end
covergroup Spec2 @(posedge clk iff(inf.size_valid));
	option.per_instance = 1;
	option.at_least = 100;
	bsize: coverpoint bev_info.bev_size{
		bins b_bev_size[] = {[L:S]};
	}
endgroup

Spec2 s2 = new();
/*
3.	Create a cross bin for the SPEC1 and SPEC2. Each combination should be selected at least 100 times. 
(Black Tea, Milk Tea, Extra Milk Tea, Green Tea, Green Milk Tea, Pineapple Juice, Super Pineapple Tea, Super Pineapple Tea) x (L, M, S)
*/
covergroup Spec1_2_3 @(posedge clk iff(inf.size_valid));
	btype_1:coverpoint bev_info.bev_type{
        bins b_bev_type [] = {[Black_Tea:Super_Pineapple_Milk_Tea]};
    }
	bsize_1: coverpoint inf.D.d_size[0]{
		bins b_bev_size []= {[L:S]};
	}
	cross btype_1, bsize_1{
		option.at_least = 100;
	}
endgroup

Spec1_2_3 s3 = new();

/*
4.	Output signal inf.err_msg should be No_Err, No_Exp, No_Ing and Ing_OF, each at least 20 times. (Sample the value when inf.out_valid is high)
*/
covergroup Spec4 @(posedge clk iff(inf.out_valid));
	option.per_instance = 1;
	option.at_least = 20;
	Err:coverpoint inf.err_msg{
		bins Err_msg[] = {[No_Err : Ing_OF]};
	}
endgroup
Spec4 s4 = new();
/*
5.	Create the transitions bin for the inf.D.act[0] signal from [0:2] to [0:2]. Each transition should be hit at least 200 times. (sample the value at posedge clk iff inf.sel_action_valid)
*/
covergroup Spec5 @(posedge clk iff(inf.sel_action_valid));
	option.per_instance = 1;
	option.at_least = 200;
	Sel:coverpoint inf.D.d_act[0]{
		bins Act[] = ([0:2] => [0:2]);
	}
endgroup
Spec5 s5 = new();
/*
6.	Create a covergroup for material of supply action with auto_bin_max = 32, and each bin have to hit at least one time.
*/
logic [11:0] supply;
always_ff@(posedge clk)begin
	if(inf.box_sup_valid)begin
		supply = inf.D.d_ing[0];
	end
end
covergroup Spec6 @(posedge clk iff (inf.box_sup_valid));
	option.per_instance = 1;
	option.goal = 1;
	Material:coverpoint supply{
		option.auto_bin_max = 32;
	}
endgroup
Spec6 s6 = new();
/*
    Create instances of Spec1, Spec2, Spec3, Spec4, Spec5, and Spec6
*/
// Spec1_2_3 cov_inst_1_2_3 = new();

/*
    Asseration
*/

/*
    If you need, you can declare some FSM, logic, flag, and etc. here.
*/

/*
    1. All outputs signals (including BEV.sv and bridge.sv) should be zero after reset.
*/
always @ (negedge inf.rst_n)begin
	#1;
	assert_1: assert(
		(inf.C_out_valid === 0) && ( inf.C_data_r === 0) &&  
		(inf.AR_VALID === 0) && (inf.AR_ADDR === 0) && (inf.R_READY === 0) &&  
		(inf.AW_VALID === 0) &&  (inf.AW_ADDR === 0) && (inf.W_VALID  === 0) && (inf.W_DATA === 0) && (inf.B_READY === 0) &&
		(inf.out_valid === 0) && (inf.err_msg === 0) && (inf.complete === 0) &&
        (inf.C_addr === 0) && (inf.C_data_w === 0) && (inf.C_in_valid === 0) && (inf.C_r_wb === 0) 
	)
	else begin
		$display("=========================================");
		$display("     Assertion 1 is violated        ");
		$display("=========================================");
		$fatal;
	end
end

/*
    2.	Latency should be less than 1000 cycles for each operation.
*/
logic [2:0] cur_state, nxt_state;
logic [1:0] act, counter;
int latency;
always_ff@(posedge clk)begin
	if(cur_state == 4)begin
		latency = latency + 1;
	end
	else begin
		latency = 0;
	end
end
always_ff@(posedge clk)begin
	if(inf.sel_action_valid)begin
		act = inf.D.d_act[0];
	end
end
always_ff@(posedge clk or negedge inf.rst_n)begin
	if(!inf.rst_n)begin
		cur_state = 0;
		counter = 0;
	end
	else begin
		if(inf.box_sup_valid)begin
			counter = counter + 1;
		end
		else begin
			counter = counter;
		end
		cur_state = nxt_state;
	end
end
always_comb begin
	if(cur_state == 0)begin
		nxt_state = 0;
		if(inf.sel_action_valid)begin
			if(inf.D.d_act[0] == 0)begin
				nxt_state = 1;
			end
			else if(inf.D.d_act[0] == 1)begin
				nxt_state = 2;
			end
			else begin
				nxt_state = 3;
			end
		end
	end
	else if(cur_state == 1 || cur_state == 3)begin
		if(inf.box_no_valid)begin
			nxt_state = 4;
		end
	end
	else if(cur_state == 2)begin
		if(inf.box_sup_valid && counter === 3)begin
			nxt_state = 4;
		end
	end
	else begin
		if(inf.out_valid)begin
			nxt_state = 0;
		end
	end
end

always @(posedge clk)
	if(cur_state == 4)
		assert (latency <= 1000) 
		else begin
			$display("******************************************");
			$display("   Assertion 2 is violated   ");
			$display("******************************************");
			$fatal;
		end
//=================================================
//  3.
//=================================================
always @(posedge inf.complete)begin
	assert (inf.err_msg === 0) 
	else begin
		$display("========================================");
		$display("   Assertion 3 is violated  ");
		$display("========================================");
		$fatal;
	end
end
/*
    4. Next input valid will be valid 1-4 cycles after previous input valid fall.
*/
property ass_1;
	@(posedge clk) (inf.sel_action_valid === 1)|->  ##[1:4] (inf.type_valid === 1 || inf.date_valid === 1);
endproperty
property ass_2;
	@(posedge clk) (inf.type_valid === 1)|-> ##[1:4] (inf.size_valid === 1);
endproperty
property ass_3;
	@(posedge clk) (inf.type_valid === 1)|-> ##[1:4] (inf.size_valid === 1);
endproperty
property ass_4;
	@(posedge clk) (inf.size_valid === 1)|-> ##[1:4] (inf.date_valid === 1);
endproperty
property ass_5;
	@(posedge clk) (inf.date_valid === 1)|->##[1:4] (inf.box_no_valid === 1);
endproperty
property ass_6;
	@(posedge clk) (inf.box_no_valid === 1)|->##[1:4] (inf.box_sup_valid === 1);
endproperty
property ass_7;
	@(posedge clk) (inf.box_sup_valid === 1 && counter != 3)|->##[1:4] (inf.box_sup_valid === 1);
endproperty
always @(posedge clk)begin
	assert_4_1:assert property (ass_1) else begin 
		$display("========================================");
		$display("   Assertion 4 is violated  ");
		$display("========================================");
		$fatal;
	end
	assert_4_2:assert property (ass_2) else begin  
		$display("========================================");
		$display("   Assertion 4 is violated  ");
		$display("========================================");
		$fatal;
	end
	assert_4_3:assert property (ass_3)else begin
		$display("========================================");
		$display("   Assertion 4 is violated  ");
		$display("========================================");
		$fatal;
	end
	assert_4_4:assert property (ass_4)else begin
		$display("========================================");
		$display("   Assertion 4 is violated  ");
		$display("========================================");
		$fatal;
	end
	assert_4_5:assert property (ass_5)else begin
		$display("========================================");
		$display("   Assertion 4 is violated  ");
		$display("========================================");
		$fatal;
	end
	if(cur_state == 2 || cur_state == 4)begin
		assert_4_6:assert property (ass_6) else begin
			$display("========================================");
			$display("   Assertion 4 is violated  ");
			$display("========================================");
			$fatal;
		end
		assert_4_7:assert property (ass_7) else begin 
			$display("========================================");
			$display("   Assertion 4 is violated  ");
			$display("========================================");
			$fatal;
		end
	end
end

/*
    5. All input valid signals won't overlap with each other. 
*/
logic [2:0] check_overlap;
assign check_overlap = inf.sel_action_valid + inf.type_valid + inf.date_valid + inf.size_valid + inf.box_no_valid + inf.box_sup_valid ;
always @(posedge inf.sel_action_valid or posedge inf.type_valid or posedge inf.size_valid or posedge inf.date_valid or posedge inf.box_no_valid)begin
	assert (check_overlap < 2) else begin 
		$display("++++++++++++++++++++++++++++++++++++++++");
		$display("    Assertion 5 is violated  ");
		$display("++++++++++++++++++++++++++++++++++++++++");
		$fatal;
	end
end
/*
    6. Out_valid can only be high for exactly one cycle.
*/
property out_valid_high;
	@(posedge clk) (inf.out_valid === 1) |=> (inf.out_valid === 0);
endproperty

always @(posedge clk)begin
	assert property (out_valid_high) else begin
		$display("----------------------------------------");
		$display("    Assertion 6 is violated  ");
		$display("----------------------------------------");
		$fatal;
	end
end
/*
    7. Next operation will be valid 1-4 cycles after out_valid fall.
*/
property next_op;
	@(posedge clk) (inf.out_valid === 1) |-> ##[1:4] (inf.sel_action_valid === 1); 
endproperty
always @(posedge clk)begin
	assert property (next_op) else begin 
		$display("7777777777777777777777777777777777777777");
		$display("    Assertion 7 is violated  ");
		$display("7777777777777777777777777777777777777777");
		$fatal;
	end
end

/*
    8. The input date from pattern should adhere to the real calendar. (ex: 2/29, 3/0, 4/31, 13/1 are illegal cases)
*/
always @(posedge clk)begin
	if(inf.date_valid)begin
		assert (inf.D.d_date[0].M < 13 && inf.D.d_date[0].M > 0)
		else begin
			$display("8888888888888888888888888888888888888888");
			$display("    Assertion 8 is violated  ");
			$display("8888888888888888888888888888888888888888");
			$fatal;
		end
		if(inf.D.d_date[0].M === 2)begin
			assert (inf.D.d_date[0].D > 0 && inf.D.d_date[0].D < 29)
			else begin
				$display("8888888888888888888888888888888888888888");
				$display("    Assertion 8 is violated  ");
				$display("8888888888888888888888888888888888888888");
				$fatal;
			end
		end
		else if(inf.D.d_date[0].M === 1 || inf.D.d_date[0].M === 3 || inf.D.d_date[0].M === 5 || inf.D.d_date[0].M === 7 || inf.D.d_date[0].M === 8 || inf.D.d_date[0].M === 10 || inf.D.d_date[0].M === 12)begin
			assert (inf.D.d_date[0].D > 0 && inf.D.d_date[0].D < 32)
			else begin
				$display("8888888888888888888888888888888888888888");
				$display("    Assertion 8 is violated  ");
				$display("8888888888888888888888888888888888888888");
				$fatal;
			end
		end
		else begin
			assert (inf.D.d_date[0].D > 0 && inf.D.d_date[0].D < 31)
			else begin
				$display("8888888888888888888888888888888888888888");
				$display("    Assertion 8 is violated  ");
				$display("8888888888888888888888888888888888888888");
				$fatal;
			end
		end
	end
end
/*
    9. C_in_valid can only be high for one cycle and can't be pulled high again before C_out_valid
*/
logic C_curstate;
always_ff@(posedge clk or negedge inf.rst_n)begin
	if(!inf.rst_n)begin
		C_curstate = 0;
	end
	else begin
		if(inf.C_in_valid === 1)begin
			C_curstate = 1;
		end
		else if(inf.C_out_valid === 1)begin
			C_curstate = 0;
		end
		else begin
			C_curstate = C_curstate;
		end
	end
end

property C_one_cycle;
	@(posedge clk) (inf.C_in_valid === 1) |=> (inf.C_in_valid === 0);
endproperty
property C_catch;
	@(posedge clk) (cur_state === 1) |-> (inf.C_in_valid === 0);
endproperty
always @(posedge clk)begin
	assert property (C_one_cycle ) else begin
		$display("9999999999999999999999999999999999999999");
		$display("    Assertion 9 is violated  ");
		$display("9999999999999999999999999999999999999999");
		$fatal;
	end
	// if(C_curstate === 1)begin
		// assert(inf.C_in_valid === 0)
		// else begin
			// $fatal("======================== Assertion 9 is violated =============================");
		// end
	// end
	assert property (C_catch ) else begin
		$display("9999999999999999999999999999999999999999");
		$display("    Assertion 9 is violated  ");
		$display("9999999999999999999999999999999999999999");
		$fatal;
	end
end
endmodule
