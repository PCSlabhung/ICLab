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

/*
1. Each case of Beverage_Type should be select at least 100 times.
*/

covergroup Spec1 @(posedge clk && inf.type_valid);
    coverpoint inf.D.d_type[0]{
endgroup

/*
2.	Each case of Bererage_Size should be select at least 100 times.
*/
covergroup Spec2 @(posedge clk && inf.size_valid);
    coverpoint inf.D.d_size[0]{
		option.at_least = 100;
		bins b1 = {S};
		bins b2 = {M};
		bins b3 = {L};
	}
endgroup
/*
3.	Create a cross bin for the SPEC1 and SPEC2. Each combination should be selected at least 100 times. 
(Black Tea, Milk Tea, Extra Milk Tea, Green Tea, Green Milk Tea, Pineapple Juice, Super Pineapple Tea, Super Pineapple Tea) x (L, M, S)
*/
	if(inf.type_valid) begin
		btype <= inf.D.d_type[0];
	end
	else begin
		btype <= btype;
	end
end
covergroup Spec3 @(posedge clk && inf.size_valid);
    cp1: coverpoint inf.D.d_size[0]{
		bins b1 = {S};
		bins b2 = {M};
		bins b3 = {L};
	}
		bins b1 = {Black_Tea};
		bins b2 = {Milk_Tea};
		bins b3 = {Extra_Milk_Tea};
		bins b4 = {Green_Tea};
		bins b5 = {Green_Milk_Tea};
		bins b6 = {Pineapple_Juice};
		bins b7 = {Super_Pineapple_Tea};
		bins b8 = {Super_Pineapple_Milk_Tea};
	}
		bins b8 = {M, Extra_Milk_Tea};
		bins b9 = {L, Extra_Milk_Tea};
		bins b11 = {M, Green_Tea};
		bins b12 = {L, Green_Tea};
		bins b14 = {M, Green_Milk_Tea};
		bins b15 = {L, Green_Milk_Tea};
		bins b17 = {M, Super_Pineapple_Tea};
		bins b18 = {L, Super_Pineapple_Milk_Tea};
		bins b20 = {L, Super_Pineapple_Tea};
		bins b21 = {S, Super_Pineapple_Milk_Tea};
		bins b23 = {S, Super_Pineapple_Tea};
		bins b24 = {M, Super_Pineapple_Milk_Tea};
endgroup
/*
4.	Output signal inf.err_msg should be No_Err, No_Exp, No_Ing and Ing_OF, each at least 20 times. (Sample the value when inf.out_valid is high)
*/
covergroup Spec4 @(posedge clk && inf.out_valid);
    coverpoint inf.err_msg{
		option.at_least = 20;
		bins b1 = {No_Err};
		bins b2 = {No_Exp};
		bins b3 = {No_Ing};
	}
endgroup
/*
5.	Create the transitions bin for the inf.D.act[0] signal from [0:2] to [0:2]. Each transition should be hit at least 200 times. (sample the value at posedge clk iff inf.sel_action_valid)
*/
covergroup Spec5 @(posedge clk iff inf.sel_action_valid);
    coverpoint inf.D.d_act[0]{
		option.at_least = 200;
		bins b[] = (0, 1, 2 => 0, 1, 2);
	}
endgroup
/*
6.	Create a covergroup for material of supply action with auto_bin_max = 32, and each bin have to hit at least one time.
*/
covergroup Spec6 @(posedge clk && inf.box_sup_valid);
    coverpoint inf.D.d_ing[0]{
		option.at_least = 1;
		option.auto_bin_max = 32;
	}
endgroup
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
always_ff@(posedge clk or negedge inf.rst_n) begin
/*
    1. All outputs signals (including BEV.sv and bridge.sv) should be zero after reset.
*/
always@(negedge inf.rst_n) begin
	#1;
	assert_1 : assert((inf.out_valid===0)&&(inf.err_msg===No_Err)&&(inf.complete===0)&&(inf.C_out_valid===0)&&(inf.C_data_r===0)&&
	else begin
		$display("           Assertion 1 is violated        ");
		$fatal; 
	end
end
/*
    2.	Latency should be less than 1000 cycles for each operation.
*/
assert_2_1: assert property(@(posedge clk)(act===Make_drink && inf.box_no_valid===1)|-> ##[1:1000](inf.out_valid===1))  
	else begin
		$display("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$");
		$display("           Assertion 2 is violated        ");
		$display("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$");
		$fatal; 
	end
	else begin
		$display("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$");
		$display("           Assertion 2 is violated        ");
		$display("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$");
		$fatal; 
	end
	else begin
		$display("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$");
		$display("           Assertion 2 is violated        ");
		$display("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$");
		$fatal; 
	end
/*
    3. If action is completed (complete=1), err_msg should be 2’b0 (no_err).
*/
always@(posedge inf.complete) begin
		$display("           Assertion 3 is violated        ");
		$display("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$");
		$fatal; 
/*
    4. Next input valid will be valid 1-4 cycles after previous input valid fall.
*/
assert_4_1: assert property(@(posedge clk)(inf.sel_action_valid===1)|-> ##[1:4](inf.date_valid===1 || inf.type_valid===1))  
	else begin
		$display("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$");
		$display("           Assertion 4 is violated        ");
		$display("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$");
		$fatal; 
	end
	else begin
		$display("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$");
		$display("           Assertion 4 is violated        ");
		$display("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$");
		$fatal; 
	end
	else begin
		$display("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$");
		$display("           Assertion 4 is violated        ");
		$display("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$");
		$fatal; 
	end
	else begin
		$display("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$");
		$display("           Assertion 4 is violated        ");
		$display("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$");
		$fatal; 
	end
	else begin
		$display("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$");
		$display("           Assertion 4 is violated        ");
		$display("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$");
		$fatal; 
	end
	else begin
		$display("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$");
		$display("           Assertion 4 is violated        ");
		$display("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$");
		$fatal; 
	end
/*
    5. All input valid signals won't overlap with each other. 
*/
		$display("           Assertion 5 is violated        ");
		$display("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$");
		$fatal; 

/*
    6. Out_valid can only be high for exactly one cycle.
*/
assert_6: assert property(@(posedge clk)(inf.out_valid===1) |=> (inf.out_valid===0))
	else
	begin
		$display("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$");
		$display("           Assertion 6 is violated        ");
		$display("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$");
		$fatal; 
	end
/*
    7. Next operation will be valid 1-4 cycles after out_valid fall.
*/
assert_7: assert property(@(posedge clk)(inf.out_valid===1)|-> ##[1:4](inf.sel_action_valid===1))  
	else begin
		$display("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$");
		$display("           Assertion 7 is violated        ");
		$display("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$");
		$fatal; 
	end
/*
    8. The input date from pattern should adhere to the real calendar. (ex: 2/29, 3/0, 4/31, 13/1 are illegal cases)
*/
		$display("           Assertion 8 is violated        ");
		$display("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$");
		$fatal; 

/*
    9. C_in_valid can only be high for one cycle and can't be pulled high again before C_out_valid
*/
assert_9_1: assert property(@(posedge clk)(inf.C_in_valid===1) |=> (inf.C_in_valid===0))
	else
	begin
		$display("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$");
		$display("           Assertion 9 is violated        ");
		$display("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$");
		$fatal; 
	end
	else
	begin
		$display("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$");
		$display("           Assertion 9 is violated        ");
		$display("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$");
		$fatal; 
	end
endmodule