//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
//   2023 ICLAB Fall Course
//   Lab06      : PATTERN
//   Author     : Ian Lai
//                
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

`ifdef RTL
    `define CYCLE_TIME 20.0
`endif
`ifdef GATE
    `define CYCLE_TIME 9.5
`endif

/*
The PATTERN.v will read 3 files: 
    mode.txt
    weight.txt (contains PAT_NUM)
    answer.txt
*/
/*
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
link the file in 01_RTL and 03_GATE: 
    ln -s ../00_TESTBED/mode.txt mode.txt
    ln -s ../00_TESTBED/weight.txt weight.txt
    ln -s ../00_TESTBED/answer.txt answer.txt
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
*/

module PATTERN(
    // Output signals
    clk,
	rst_n,
	in_valid,
    in_weight, 
	out_mode,
    // Input signals
    out_valid, 
	out_code
);

// ========================================
// Input & Output
// ========================================
output reg clk, rst_n, in_valid, out_mode;
output reg [2:0] in_weight;

input out_valid, out_code;

// ========================================
// Parameter
// ========================================
// clock generate
real CYCLE = `CYCLE_TIME;
always #(CYCLE/2.0) clk = ~clk;

// parameters and integers
integer weight_file, mode_file, answer_file;
integer latency, total_latency;
integer PAT_NUM, i_pat;
integer i;
integer golden_len;

reg [2:0] weight[7:0];
reg mode;
reg [31:0] golden_answer;
reg [31:0] present_out;

//================================================================
// design
//================================================================
initial begin
    weight_file = $fopen("../00_TESTBED/weight.txt", "r");
    mode_file = $fopen("../00_TESTBED/mode.txt", "r");
    answer_file = $fopen("../00_TESTBED/answer.txt", "r");

    reset_task;

    total_latency = 0;
    $fscanf(weight_file, "%d", PAT_NUM);
    
    for(i_pat=1; i_pat<=PAT_NUM; i_pat++) begin
        @(negedge clk);
        input_task;
        wait_out_valid_task;
        check_ans_task;
        $display ("             \033[0;%2dmPass Pattern NO. %d\033[m         ", 31+(i_pat%7), i_pat);
        repeat($urandom_range(1, 3)) @(negedge clk);
    end

    $fclose(weight_file);
    $fclose(mode_file);
    $fclose(answer_file);
    YOU_PASS_TASK;
    $finish;
end

always@(*)begin
	if(in_valid && out_valid)begin
        YOU_FAIL_TASK;
        $display("************************************************************");     
        $display("*          The out_valid cannot overlap with in_valid       *");
        $display("************************************************************");
		$finish;			
	end	
end

task reset_task; begin
    rst_n = 1'b1;
    in_valid = 1'b0;
    in_weight = 'dx;
    out_mode = 'dx;

    force clk = 0;

    #(CYCLE*2); rst_n = 0;
    #(CYCLE*2); rst_n = 1;

    // check output reset
    if(out_valid !== 1'b0 || out_code !== 1'b0) begin
        YOU_FAIL_TASK;
        $display("************************************************************");    
        $display("*  Output signal should be 0 after initial RESET           *");
        $display("************************************************************");
        repeat(2) #CYCLE;
        $finish;
    end

    #CYCLE; release clk;
end
endtask

task input_task; begin
    in_valid = 1'b1;
    $fscanf(mode_file, "%d", mode);
    $fscanf(weight_file, "%d", weight[0]);
    out_mode = mode;
    in_weight = weight[0];

    for(i=1;i<8;i++) begin
        @(negedge clk);
        $fscanf(weight_file, "%d", weight[i]);
        in_weight = weight[i];
        out_mode = 'dx;
    end

    @(negedge clk);
    in_valid = 1'b0;
    in_weight = 'dx;
end
endtask

task wait_out_valid_task; begin
    latency = 0;
    while(out_valid !== 1'b1) begin
        latency = latency + 1;
        if(latency == 2000) begin
            YOU_FAIL_TASK;
            $display("*************************************************************************");
            $display("                           fail pattern: %d                           ", i_pat);
            $display("             The execution latency is limited in 1000 cycle              ");
            $display("*************************************************************************");
            $finish;
        end

        @(negedge clk);
    end
    total_latency = total_latency + latency;
end
endtask

task check_ans_task; begin
    $fscanf(answer_file, "%d", golden_len);
    $fscanf(answer_file, "%b", golden_answer);

    present_out = 'd0;
    for(i=0;i<golden_len;i++) begin
        if(out_valid === 1'b0) begin
            YOU_FAIL_TASK;
            $display("*************************************************************************");
            $display("                           fail pattern: %d                           ", i_pat);
            $display("                               Wrong Answer                              ");
            $display("*************************************************************************");
            $display("golden_answer length = %d\n", golden_len); 
            $display("your answer length = %d\n", i+1);
            $finish;
        end

        present_out = present_out << 1;
        present_out[0] = out_code;
        @(negedge clk);
    end

    // check answer
    if(present_out !== golden_answer || out_valid === 1'b1) begin
        YOU_FAIL_TASK;
        $display("*************************************************************************");
        $display("                           fail pattern: %d                           ", i_pat);
        $display("                               Wrong Answer                              ");
        $display("*************************************************************************");
        $display("golden_answer = %b\n", golden_answer); 
        $display("your answer = %b\n", present_out);
        $finish;
    end
end
endtask


task YOU_PASS_TASK; begin
    $display("        \033[0;34m------------");
    $display("        | ┏┓ ┏┓ ┏┓ |");
    $display("        | ┗┛ ┗┛ ┗┛ |");
    $display("        | ┏┓ ┏┓ ┏┓ |");
    $display("        \033[0;34m| ┗┛ ┗┛ ┗┛ |\033[0;32m＼O/");
    $display("        \033[0;34m| ┏┓ ┏┓ ┏┓ |\033[0;32m //");
    $display("        \033[0;34m| ┗┛ ┗┛ ┗┛ |\033[0;32mノ)");
    $display("        \033[0;34m| ┏┓ ┏┓ ┏┓ |");
    $display("        | ┗┛ ┗┛ ┗┛ |");
    $display("        | ┏┓ ┏┓ ┏┓ |");
    $display("        | ┗┛ ┗┛ ┗┛ |");
    $display("        | ┏┓ ┏┓ ┏┓ |");
    $display("        | ┗┛ ┗┛ ┗┛ |");
    $display("        \033[m----------------------------               ");
    $display("        --                        --       |\__||  ");
    $display("        --  Congratulations !!    --      / O.O  | ");
    $display("        --                        --    /_____   | ");
    $display("        --  \033[0;32mSimulation PASS!!\033[m     --   /^ ^ ^ \\  |");
    $display("        --                        --  |^ ^ ^ ^ |w| ");
    $display("        ----------------------------   \\m___m__|_|");
    $display("*************************************************************************");
    $display("*                Your execution cycles = %5d cycles          *", total_latency);
    $display("*                Your clock period = %.1f ns          *", CYCLE);
    $display("*                Total Latency = %.1f ns          *", total_latency*CYCLE);
    $display("*************************************************************************");
end endtask

task YOU_FAIL_TASK; begin
    $display("\n");
    $display("\n");
    $display("        ----------------------------               ");
    $display("        --                        --       |\__||  ");
    $display("        --  OOPS!!                --      / X,X  | ");
    $display("        --                        --    /_____   | ");
    $display("        --  \033[0;31mSimulation FAIL!!\033[m   --   /^ ^ ^ \\  |");
    $display("        --                        --  |^ ^ ^ ^ |w| ");
    $display("        ----------------------------   \\m___m__|_|");
    $display("\n");
end endtask

endmodule

// Black   "\033[0;30m"
// Red     "\033[0;31m"  
// Green   "\033[0;32m"  
// Yellow  "\033[0;33m"  
// Blue    "\033[0;34m"  
// Purple  "\033[0;35m"  
// Cyan    "\033[0;36m"  
// White   "\033[0;37m"  