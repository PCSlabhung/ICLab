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

//================================================================
// wire & registers 
//================================================================
logic [7:0] golden_DRAM [((65536+8*256)-1):(65536+0)];  // 256 box

//real CYCLE = `CYCLE_TIME;
real CYCLE = 2.7; 
integer i, j;
logic [1:0] current_action, current_size;
logic [2:0] current_type;
logic [3:0] current_month;
logic [4:0] current_date;
logic [7:0] current_box;
logic [11:0] current_ing[1:4];
logic [63:0] dram_data, final_dram_data;
logic [11:0] black_tea, green_tea, milk, pineapple_juice;
logic [3:0] month;
logic [4:0] date;
logic [9:0] size;
logic [9:0] black_tea_size, green_tea_size, milk_size, pineapple_juice_size;
logic [11:0] black_tea_remain, green_tea_remain, milk_remain, pineapple_juice_remain;
logic [11:0] black_tea_supply, green_tea_supply, milk_supply, pineapple_juice_supply;
logic [1:0] golden_error_msg;
logic golden_complete;

//================================================================
// class random
//================================================================
class random_act;
    randc Action act_id;
    constraint range{
        act_id inside{Make_drink, Supply, Check_Valid_Date};
    }
endclass

class random_type;
    randc Bev_Type bev_type;
    constraint range{
        bev_type inside{Black_Tea, Milk_Tea, Extra_Milk_Tea, Green_Tea, Green_Milk_Tea, Pineapple_Juice, Super_Pineapple_Tea, Super_Pineapple_Milk_Tea};
    }
endclass

class random_size;
    randc Bev_Size bev_size;
    constraint range{
        bev_size inside{L, M, S};
    }
endclass

class random_month;
    randc Month m;
    constraint range{
        m inside{[1:12]};
    }
endclass

class random_date;
    randc Date d_31;
    randc Date d_30;
    randc Date d_28;
    constraint range{
        d_31 inside{[1:31]};
        d_30 inside{[1:30]};
        d_28 inside{[1:28]};
    }
endclass

class random_box;
    randc logic [7:0] box_id;
    constraint range{
        box_id inside{[0:255]};
    }
endclass

class random_ing;
    randc ING ing_1;
    randc ING ing_2;
    randc ING ing_3;
    randc ING ing_4;
    constraint range{
        ing_1 inside{[0:4095]};
        ing_2 inside{[0:4095]};
        ing_3 inside{[0:4095]};
        ing_4 inside{[0:4095]};
    }
endclass

class random_delay;
    randc logic [2:0] delay;
    constraint range{
        delay inside{[0:3]};
    }
endclass

class random_delay_between_valid;
    randc logic [2:0] delay_between_valid;
    constraint range{
        delay_between_valid inside{[0:3]};
    }
endclass

random_act act_rand = new();
random_type  type_rand = new();
random_size size_rand = new();
random_month month_rand = new();
random_date date_rand = new();
random_ing ing_rand = new();
random_box box_rand = new();
random_delay delay_rand = new();
random_delay_between_valid delay_between_valid_rand = new();

//================================================================
// initial
//================================================================
initial $readmemh(DRAM_p_r, golden_DRAM);

initial begin
    reset_task;
    for (i = 0; i < 8800; i = i+1) begin
        input_task;
        cal_ans_task;
        wait_task;
        check_ans_task;
        $display("PASS PATTERN NO.%4d", i);
    end
    YOU_PASS_TASK;
end

task reset_task; begin
    inf.rst_n = 1'b1;
    inf.sel_action_valid = 1'b0;
    inf.type_valid = 1'b0;
    inf.size_valid = 1'b0;
    inf.date_valid = 1'b0;
    inf.box_no_valid = 1'b0;
    inf.box_sup_valid = 1'b0;
    inf.D = 'bx;
	
	force clk = 0;
	#CYCLE; inf.rst_n = 0;
	#(CYCLE*5); inf.rst_n = 1;
	
	#CYCLE; release clk;
end endtask

task input_task; begin
    if (i == 0) begin
        @(negedge clk);
    end
    else begin
        j = delay_rand.randomize();
        repeat(delay_rand.delay) @(negedge clk);
    end

    // action
    inf.sel_action_valid = 1'b1;
    j = act_rand.randomize();
    current_action = act_rand.act_id;
    inf.D = current_action;
    @(negedge clk);

    inf.sel_action_valid = 1'b0;
    inf.D = 'bx;

    j = delay_between_valid_rand.randomize();
    repeat(delay_between_valid_rand.delay_between_valid) @(negedge clk);

    if (current_action == Make_drink) begin
        // type
        inf.type_valid = 1'b1;
        j = type_rand.randomize();
        current_type = type_rand.bev_type;
        inf.D = current_type;
        @(negedge clk);

        inf.type_valid = 1'b0;
        inf.D = 'bx;

        j = delay_between_valid_rand.randomize();
        repeat(delay_between_valid_rand.delay_between_valid) @(negedge clk);

        // size
        inf.size_valid = 1'b1;
        j = size_rand.randomize();
        current_size = size_rand.bev_size;
        inf.D = current_size;
        @(negedge clk);

        inf.size_valid = 1'b0;
        inf.D = 'bx;

        j = delay_between_valid_rand.randomize();
        repeat(delay_between_valid_rand.delay_between_valid) @(negedge clk);
    end
    
    // date
    inf.date_valid = 1'b1;
    j = month_rand.randomize();
    j = date_rand.randomize();
    current_month = month_rand.m;
    case (current_month)
        1, 3, 5, 7, 8, 10, 12: current_date = date_rand.d_31;
        4, 6, 9, 11: current_date = date_rand.d_30;
        2: current_date = date_rand.d_28;
    endcase
    inf.D = {current_month, current_date};
    @(negedge clk);

    inf.date_valid = 1'b0;
    inf.D = 'bx;

    j = delay_between_valid_rand.randomize();
    repeat(delay_between_valid_rand.delay_between_valid) @(negedge clk);

    // box
    inf.box_no_valid = 1'b1;
    j = box_rand.randomize();
    current_box = box_rand.box_id;
    inf.D = current_box;
    @(negedge clk);

    inf.box_no_valid = 1'b0;
    inf.D = 'bx;

    if (current_action == Supply) begin
        j = delay_between_valid_rand.randomize();
        repeat(delay_between_valid_rand.delay_between_valid) @(negedge clk);
        j = ing_rand.randomize();

        // supply black tea
        inf.box_sup_valid = 1'b1;
        current_ing[1] = ing_rand.ing_1;
        inf.D = current_ing[1];
        @(negedge clk);

        inf.box_sup_valid = 1'b0;
        inf.D = 'bx;

        j = delay_between_valid_rand.randomize();
        repeat(delay_between_valid_rand.delay_between_valid) @(negedge clk);

        // supply green tea
        inf.box_sup_valid = 1'b1;
        current_ing[2] = ing_rand.ing_2;
        inf.D = current_ing[2];
        @(negedge clk);

        inf.box_sup_valid = 1'b0;
        inf.D = 'bx;

        j = delay_between_valid_rand.randomize();
        repeat(delay_between_valid_rand.delay_between_valid) @(negedge clk);

        // supply milk
        inf.box_sup_valid = 1'b1;
        current_ing[3] = ing_rand.ing_3;
        inf.D = current_ing[3];
        @(negedge clk);

        inf.box_sup_valid = 1'b0;
        inf.D = 'bx;

        j = delay_between_valid_rand.randomize();
        repeat(delay_between_valid_rand.delay_between_valid) @(negedge clk);

        // supply pineapple juice
        inf.box_sup_valid = 1'b1;
        current_ing[4] = ing_rand.ing_4;
        inf.D = current_ing[4];
        @(negedge clk);

        inf.box_sup_valid = 1'b0;
        inf.D = 'bx;
    end
end endtask

task cal_ans_task; begin
    dram_data[7:0] = golden_DRAM[current_box * 8 + 65536];
    dram_data[15:8] = golden_DRAM[current_box * 8 + 1 + 65536];
    dram_data[23:16] = golden_DRAM[current_box * 8 + 2 + 65536];
    dram_data[31:24] = golden_DRAM[current_box * 8 + 3 + 65536];
    dram_data[39:32] = golden_DRAM[current_box * 8 + 4 + 65536];
    dram_data[47:40] = golden_DRAM[current_box * 8 + 5 + 65536];
    dram_data[55:48] = golden_DRAM[current_box * 8 + 6 + 65536];
    dram_data[63:56] = golden_DRAM[current_box * 8 + 7 + 65536];

    black_tea = dram_data[63:52];
    green_tea = dram_data[51:40];
    month = dram_data[35:32];
    milk = dram_data[31:20];
    pineapple_juice = dram_data[19:8];
    date = dram_data[4:0];

    black_tea_size = 0;
    green_tea_size = 0;
    milk_size = 0;
    pineapple_juice_size = 0;
    golden_complete = 1'b1;
    golden_error_msg = 2'b00;
    black_tea_remain = 0;
    green_tea_remain = 0;
    milk_remain = 0;
    pineapple_juice_remain = 0;
    black_tea_supply = 0;
    green_tea_supply = 0;
    milk_supply = 0;
    pineapple_juice_supply = 0;
    case (current_action)
        Make_drink: begin
            case (current_type)
                Black_Tea: begin
                    case (current_size)
                        L: black_tea_size = 960;
                        M: black_tea_size = 720;
                        S: black_tea_size = 480;
                    endcase
                end
                Milk_Tea: begin
                    case (current_size)
                        L: begin
                            black_tea_size = 720;
                            milk_size = 240;
                        end
                        M: begin
                            black_tea_size = 540;
                            milk_size = 180;
                        end
                        S: begin
                            black_tea_size = 360;
                            milk_size = 120;
                        end
                    endcase
                end
                Extra_Milk_Tea: begin
                    case (current_size)
                        L: begin
                            black_tea_size = 480;
                            milk_size = 480;
                        end
                        M: begin
                            black_tea_size = 360;
                            milk_size = 360;
                        end
                        S: begin
                            black_tea_size = 240;
                            milk_size = 240;
                        end
                    endcase
                end
                Green_Tea: begin
                    case (current_size)
                        L: green_tea_size = 960;
                        M: green_tea_size = 720;
                        S: green_tea_size = 480;
                    endcase
                end
                Green_Milk_Tea: begin
                    case (current_size)
                        L: begin
                            green_tea_size = 480;
                            milk_size = 480;
                        end
                        M: begin
                            green_tea_size = 360;
                            milk_size = 360;
                        end
                        S: begin
                            green_tea_size = 240;
                            milk_size = 240;
                        end
                    endcase
                end
                Pineapple_Juice: begin
                    case (current_size)
                        L: pineapple_juice_size = 960;
                        M: pineapple_juice_size = 720;
                        S: pineapple_juice_size = 480;
                    endcase
                end
                Super_Pineapple_Tea: begin
                    case (current_size)
                        L: begin
                            black_tea_size = 480;
                            pineapple_juice_size = 480;
                        end
                        M: begin
                            black_tea_size = 360;
                            pineapple_juice_size = 360;
                        end
                        S: begin
                            black_tea_size = 240;
                            pineapple_juice_size = 240;
                        end
                    endcase
                end
                Super_Pineapple_Milk_Tea: begin
                    case (current_size)
                        L: begin
                            black_tea_size = 480;
                            milk_size = 240;
                            pineapple_juice_size = 240;
                        end
                        M: begin
                            black_tea_size = 360;
                            milk_size = 180;
                            pineapple_juice_size = 180;
                        end
                        S: begin
                            black_tea_size = 240;
                            milk_size = 120;
                            pineapple_juice_size = 120;
                        end
                    endcase
                end
            endcase
            if (current_month > month || (current_month == month && current_date > date)) begin
                golden_error_msg = 2'b01;
                golden_complete = 1'b0;
            end
            else if (black_tea_size > black_tea || green_tea_size > green_tea || milk_size > milk || pineapple_juice_size > pineapple_juice) begin
                golden_error_msg = 2'b10;
                golden_complete = 1'b0;
            end
            else begin
                black_tea_remain = black_tea - black_tea_size;
                green_tea_remain = green_tea - green_tea_size;
                milk_remain = milk - milk_size;
                pineapple_juice_remain = pineapple_juice - pineapple_juice_size;
                golden_DRAM[current_box * 8 + 7 + 65536] = {black_tea_remain[11:4]};
                golden_DRAM[current_box * 8 + 6 + 65536] = {black_tea_remain[3:0], green_tea_remain[11:8]};
                golden_DRAM[current_box * 8 + 5 + 65536] = {green_tea_remain[7:0]};
                golden_DRAM[current_box * 8 + 4 + 65536] = {4'd0, month};
                golden_DRAM[current_box * 8 + 3 + 65536] = {milk_remain[11:4]};
                golden_DRAM[current_box * 8 + 2 + 65536] = {milk_remain[3:0], pineapple_juice_remain[11:8]};
                golden_DRAM[current_box * 8 + 1 + 65536] = {pineapple_juice_remain[7:0]};
                golden_DRAM[current_box * 8 + 65536] = {3'd0, date};
            end
        end
        Supply: begin
            if (current_ing[1] + black_tea > 4095) begin
                golden_error_msg = 2'b11;
                golden_complete = 1'b0;
                black_tea_supply = 4095;
            end
            else black_tea_supply = current_ing[1] + black_tea;

            if (current_ing[2] + green_tea > 4095) begin
                golden_error_msg = 2'b11;
                golden_complete = 1'b0;
                green_tea_supply = 4095;
            end
            else green_tea_supply = current_ing[2] + green_tea;

            if (current_ing[3] + milk > 4095) begin
                golden_error_msg = 2'b11;
                golden_complete = 1'b0;
                milk_supply = 4095;
            end
            else milk_supply = current_ing[3] + milk;

            if (current_ing[4] + pineapple_juice > 4095) begin
                golden_error_msg = 2'b11;
                golden_complete = 1'b0;
                pineapple_juice_supply = 4095;
            end
            else pineapple_juice_supply = current_ing[4] + pineapple_juice;

            golden_DRAM[current_box * 8 + 7 + 65536] = {black_tea_supply[11:4]};
            golden_DRAM[current_box * 8 + 6 + 65536] = {black_tea_supply[3:0], green_tea_supply[11:8]};
            golden_DRAM[current_box * 8 + 5 + 65536] = {green_tea_supply[7:0]};
            golden_DRAM[current_box * 8 + 4 + 65536] = {4'd0, current_month};
            golden_DRAM[current_box * 8 + 3 + 65536] = {milk_supply[11:4]};
            golden_DRAM[current_box * 8 + 2 + 65536] = {milk_supply[3:0], pineapple_juice_supply[11:8]};
            golden_DRAM[current_box * 8 + 1 + 65536] = {pineapple_juice_supply[7:0]};
            golden_DRAM[current_box * 8 + 65536] = {3'd0, current_date};
        end
        Check_Valid_Date: begin
            if (current_month > month || (current_month == month && current_date > date)) begin
                golden_error_msg = 2'b01;
                golden_complete = 1'b0;
            end
        end
    endcase
end endtask

task wait_task; begin
    while (inf.out_valid !== 1'b1) begin
        @(negedge clk);
    end
end endtask

task check_ans_task; begin
    if (inf.out_valid !== 1'b0) begin
        if (inf.err_msg !== golden_error_msg || inf.complete !== golden_complete) begin
            $display("*********************************************************************");
            $display("*                         Wrong Answer                              *");
            $display("*********************************************************************");
            $finish;
        end
    end
    @(negedge clk);
end endtask

task YOU_PASS_TASK; begin
    $display("*************************************************************************");
    $display("*                         Congratulations                               *");
    $display("*************************************************************************");
    $finish;
end endtask

endprogram
