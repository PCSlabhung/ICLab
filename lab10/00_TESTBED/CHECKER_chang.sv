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
    Action act;
    ING ing;
    Bev_Type bev_type;
    Bev_Size bev_size;
endclass

class RESULT;
    Error_Msg err_msg;
endclass

BEV bev_info = new();
RESULT result_info = new();

always_ff @(posedge clk) begin
    if (inf.type_valid) begin
        bev_info.bev_type = inf.D.d_type[0];
    end
    if (inf.size_valid) begin
        bev_info.bev_size = inf.D.d_size[0];
    end
    if (inf.sel_action_valid) begin
        bev_info.act = inf.D.d_act[0];
    end
    if (inf.box_sup_valid) begin
        bev_info.ing = inf.D.d_ing[0];
    end
    if (inf.out_valid) begin
        result_info.err_msg = inf.err_msg;
    end
end

/*
1. Each case of Beverage_Type should be select at least 100 times.
*/

covergroup Spec1 @(posedge clk iff inf.type_valid);
    option.per_instance = 1;
    option.at_least = 100;
    btype:coverpoint bev_info.bev_type{
        bins b_bev_type [] = {[Black_Tea:Super_Pineapple_Milk_Tea]};
    }
endgroup

/*
2.	Each case of Bererage_Size should be select at least 100 times.
*/

covergroup Spec2 @(posedge clk iff inf.size_valid);
    option.per_instance = 1;
    option.at_least = 100;
    bsize:coverpoint bev_info.bev_size{
        bins b_bev_size [] = {L,M,S};
    }
endgroup

/*
3.	Create a cross bin for the SPEC1 and SPEC2. Each combination should be selected at least 100 times. 
(Black Tea, Milk Tea, Extra Milk Tea, Green Tea, Green Milk Tea, Pineapple Juice, Super Pineapple Tea, Super Pineapple Tea) x (L, M, S)
*/

covergroup Spec3 @(posedge clk);
    option.per_instance = 1;
    option.at_least = 100;
    bctype:coverpoint bev_info.bev_type {
        bins b_bev_type [] = {[Black_Tea:Super_Pineapple_Milk_Tea]};
    }
    bcsize:coverpoint bev_info.bev_size {
        bins b_bev_size [] = {L,M,S};
    }
    cross bctype, bcsize iff inf.size_valid; 
endgroup

/*
4.	Output signal inf.err_msg should be No_Err, No_Exp, No_Ing and Ing_OF, each at least 20 times. (Sample the value when inf.out_valid is high)
*/

covergroup Spec4 @(posedge clk iff inf.out_valid);
    option.per_instance = 1;
    option.at_least = 20;
    emsg:coverpoint result_info.err_msg{
        bins r_err_msg [] = {No_Err, No_Exp, No_Ing, Ing_OF};
    }
endgroup

/*
5.	Create the transitions bin for the inf.D.act[0] signal from [0:2] to [0:2]. Each transition should be hit at least 200 times. (sample the value at posedge clk iff inf.sel_action_valid)
*/

covergroup Spec5 @(posedge clk iff inf.sel_action_valid);
    option.per_instance = 1;
    option.at_least = 200;
    statet:coverpoint bev_info.act{
        bins b_act [] = ([Make_drink:Check_Valid_Date] => [Make_drink:Check_Valid_Date]);
    }
endgroup

/*
6.	Create a covergroup for material of supply action with auto_bin_max = 32, and each bin have to hit at least one time.
*/

covergroup Spec6 @(posedge clk iff inf.box_sup_valid);
    option.per_instance = 1;
    option.at_least = 1;
    option.auto_bin_max = 32;
    bsupply:coverpoint bev_info.ing;
endgroup

/*
    Create instances of Spec1, Spec2, Spec3, Spec4, Spec5, and Spec6
*/
// Spec1_2_3 cov_inst_1_2_3 = new();
Spec1 cov_inst_1 = new();
Spec2 cov_inst_2 = new();
Spec3 cov_inst_3 = new();
Spec4 cov_inst_4 = new();
Spec5 cov_inst_5 = new();
Spec6 cov_inst_6 = new();

/*
    Asseration
*/

/*
    If you need, you can declare some FSM, logic, flag, and etc. here.
*/

typedef enum logic [2:0]{
    START,
    IDLE,
    INPUT,
    WAIT,
    OUTPUT
} state_t;

state_t current_state, next_state;
Action a_act;
logic [2:0] sup_cnt;
logic [9:0] wait_cnt;
logic overlap;
logic cal_valid;
logic [4:0] date;
logic shadow_valid;
logic [2:0] interval_cnt, idle_cnt;
logic [1:0] cinvalid_cnt;
logic err_complete;

always_ff @(negedge clk or negedge inf.rst_n) begin
    if (!inf.rst_n) begin
        current_state <= START;
        sup_cnt <= 0;
        wait_cnt <= 0;
        interval_cnt <= 0;
        idle_cnt <= 0;
        cinvalid_cnt <= 0;
    end
    else begin
        if (inf.sel_action_valid == 1) begin
            a_act <= inf.D.d_act[0];
            current_state <= INPUT;
        end
        if (a_act == Make_drink) begin
            if (inf.box_no_valid == 1) current_state <= WAIT;
        end
        else if (a_act == Supply) begin
            if (inf.box_sup_valid == 1) sup_cnt <= sup_cnt + 1;
            if (sup_cnt == 3 && inf.box_sup_valid == 1) begin
                current_state <= WAIT;
                sup_cnt <= 0;
            end
        end
        else if (a_act == Check_Valid_Date) begin
            if (inf.box_no_valid == 1) current_state <= WAIT;
        end
        if (inf.out_valid == 1) begin
            current_state <= OUTPUT;
        end
        if (current_state == OUTPUT && inf.out_valid == 0) begin
            current_state <= IDLE;
        end
        if (current_state == WAIT) begin
            wait_cnt <= wait_cnt + 1;
        end
        else wait_cnt <= 0;
        if (current_state == INPUT) begin
            if (shadow_valid == 0) interval_cnt <= interval_cnt + 1;
            else interval_cnt <= 0;
        end
        else interval_cnt <= 0;
        if (current_state == IDLE) idle_cnt <= idle_cnt + 1;
        else idle_cnt <= 0;
        if (inf.C_in_valid) cinvalid_cnt <= cinvalid_cnt + 1;
        if (inf.C_out_valid) cinvalid_cnt <= 0;
    end
end

/*
    1. All outputs signals (including BEV.sv and bridge.sv) should be zero after reset.
*/
property p_reset;
    @(posedge clk) (inf.rst_n === 0) |=> (inf.out_valid === 0 && inf.err_msg === 0 && inf.complete === 0
                                        && inf.C_addr === 0 && inf.C_data_w === 0 && inf.C_in_valid === 0
                                        && inf.C_r_wb === 0 && inf.C_out_valid === 0 && inf.C_data_r === 0
                                        && inf.AR_VALID === 0 && inf.AR_ADDR === 0 && inf.R_READY === 0
                                        && inf.AW_VALID === 0 && inf.AW_ADDR === 0 && inf.W_VALID === 0
                                        && inf.W_DATA === 0 && inf.B_READY === 0);
endproperty
assert property (p_reset) else $fatal(0, "Assertion 1 is violated"); // fail statement must be written afterwards

/*
    2.	Latency should be less than 1000 cycles for each operation.
*/
always @(*) begin
    assert (wait_cnt < 1000) else $fatal(0, "Assertion 2 is violated");
end

/*
    3. If complete = 1, err_msg = 0
*/
property p_errmsg;
    @(negedge clk) (inf.complete === 1) |-> (inf.err_msg === No_Err);
endproperty
assert property (p_errmsg) else $fatal(0, "Assertion 3 is violated");

/*
    4. Next input valid will be valid 1-4 cycles after previous input valid fall.
*/
always @(*) begin
    shadow_valid = inf.sel_action_valid || inf.type_valid || inf.size_valid || inf.date_valid || inf.box_no_valid || inf.box_sup_valid;
    assert (interval_cnt < 4) else $fatal(0, "Assertion 4 is violated");
end
// property p_interval;
//     @(negedge clk) (shadow_valid ##[1:4] shadow_valid);
// endproperty
// assert property (p_interval) else $fatal(0, "Assertion 4 is violated");

/*
    5. All input valid signals won't overlap with each other. 
*/
always @(*) begin
    if ((inf.sel_action_valid && inf.type_valid) || (inf.sel_action_valid && inf.size_valid)
        || (inf.sel_action_valid && inf.date_valid) || (inf.sel_action_valid && inf.box_no_valid)
        || (inf.sel_action_valid && inf.box_sup_valid)
        || (inf.type_valid && inf.size_valid) || (inf.type_valid && inf.date_valid)
        || (inf.type_valid && inf.box_no_valid) || (inf.type_valid && inf.box_sup_valid)
        || (inf.size_valid && inf.date_valid) || (inf.size_valid && inf.box_no_valid)
        || (inf.size_valid && inf.box_sup_valid)
        || (inf.date_valid && inf.box_no_valid) || (inf.date_valid && inf.box_sup_valid)
        || (inf.box_no_valid && inf.box_sup_valid)) begin
        overlap = 1;
    end
    else overlap = 0;
    assert (overlap == 0) else $fatal(0, "Assertion 5 is violated");
end

/*
    6. Out_valid can only be high for exactly one cycle.
*/
property p_outvalid;
    @(negedge clk) (inf.out_valid === 1) |=> (inf.out_valid === 0);
endproperty
assert property (p_outvalid) else $fatal(0, "Assertion 6 is violated");

/*
    7. Next operation will be valid 1-4 cycles after out_valid fall.
*/
always @(*) begin
    assert (idle_cnt <= 4) else $fatal(0, "Assertion 7 is violated");
end

/*
    8. The input date from pattern should adhere to the real calendar. (ex: 2/29, 3/0, 4/31, 13/1 are illegal cases)
*/
always @(*) begin
    date = inf.D.d_date[0][4:0];
    cal_valid = 1;
    if (inf.date_valid) begin
        case (inf.D.d_date[0][8:5])
            1, 3, 5, 7, 8, 10, 12: begin
                if (date > 31 || date < 1) cal_valid = 0;
            end
            2: begin
                if (date > 28 || date < 1) cal_valid = 0;
            end
            4, 6, 9, 11: begin
                if (date > 30 || date < 1) cal_valid = 0;
            end
            default: cal_valid = 0;
        endcase
    end
    assert (cal_valid == 1) else $fatal(0, "Assertion 8 is violated");
end

/*
    9. C_in_valid can only be high for one cycle and can't be pulled high again before C_out_valid
*/
always @(*) begin
    assert (cinvalid_cnt <= 1) else $fatal(0, "Assertion 9 is violated");
end

endmodule
