`ifdef RTL
	`define CYCLE_TIME_clk1 14.1
	`define CYCLE_TIME_clk2 3.9
	`define CYCLE_TIME_clk3 4.1
`endif
`ifdef GATE
	`define CYCLE_TIME_clk1 14.1
	`define CYCLE_TIME_clk2 3.9
	`define CYCLE_TIME_clk3 20.7
`endif

module PATTERN(
	clk1,
	clk2,
	clk3,
	rst_n,
	in_valid,
	seed,
	out_valid,
	rand_num
);

output reg clk1, clk2, clk3;
output reg rst_n;
output reg in_valid;
output reg [31:0] seed;

input out_valid;
input [31:0] rand_num;


//================================================================
// parameters & integer
//================================================================
real	CYCLE_clk1 = `CYCLE_TIME_clk1;
real	CYCLE_clk2 = `CYCLE_TIME_clk2;
real	CYCLE_clk3 = `CYCLE_TIME_clk3;
integer total_latency;
integer i, j, latency, t, i_pat;
//================================================================
// wire & registers 
//================================================================
reg [31:0]golden_answer;

//================================================================
// clock
//================================================================

always #(CYCLE_clk1/2.0) clk1 = ~clk1;
always #(CYCLE_clk2/2.0) clk2 = ~clk2;
always #(CYCLE_clk3/2.0) clk3 = ~clk3;

//================================================================
// initial
//================================================================
initial begin
	reset_task;
	repeat(2) @(negedge clk1);
	for(i_pat = 0; i_pat < 1000; i_pat = i_pat + 1) begin
		input_task;
    	latency = 0;
		check_ans_task;
		$display ("             \033[0;%2dmPass Pattern NO. %d\033[m         ", 31+(i_pat%7), i_pat);
        repeat(1) @(negedge clk1);
	end
	YOU_PASS_TASK;
end


//================================================================
// task
//================================================================

task input_task; begin
	in_valid = 1'b1;
	seed = $urandom(1);
	golden_answer = seed;
	@(negedge clk1);

	in_valid = 1'b0;
	seed = 'bx;
	@(negedge clk1);

end endtask

task wait_out_valid_task; begin
    while(out_valid !== 1'b1) begin
        latency = latency + 1;
        if(latency == 2000) begin
            YOU_FAIL_TASK;
            $display("*************************************************************************");
            $display("                           fail pattern: %d                           ", i_pat);
            $display("             The execution latency is limited in 2000 cycle              ");
            $display("*************************************************************************");
            $finish;
        end

        @(negedge clk3);
    end
    total_latency = total_latency + latency;
end
endtask

task check_ans_task; begin
	for(i = 0; i < 256; i = i + 1) begin
		wait_out_valid_task;
		golden_answer = golden_answer ^ (golden_answer << 13);
		golden_answer = golden_answer ^ (golden_answer >> 17);
		golden_answer = golden_answer ^ (golden_answer << 5);
		if(rand_num !== golden_answer) begin
			YOU_FAIL_TASK;
			$display("*************************************************************************");
			$display("                           fail pattern: %d - %d                         ", i_pat, i);
			$display("                               Wrong Answer                              ");
			$display("*************************************************************************");
			$display("golden_answer = %h\n", golden_answer);
			$display("your answer = %h\n", rand_num);
			$finish;
		end

		@(negedge clk3);
	end



end endtask


task reset_task; begin
    rst_n = 1'b1;
    in_valid = 1'b0;
    seed = 'dx;

    force clk1 = 0;
    force clk2 = 0;
    force clk3 = 0;

    #(10); rst_n = 0;
    #(200); rst_n = 1;

    // check output reset
    if(out_valid !== 1'b0 || rand_num !== 1'b0) begin
        YOU_FAIL_TASK;
        $display("************************************************************");    
        $display("*  Output signal should be 0 after initial RESET           *");
        $display("************************************************************");
        repeat(2) #CYCLE_clk3;
        $finish;
    end

	release clk1;
	release clk2;
	release clk3;
end
endtask

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


task YOU_PASS_TASK; begin
    $display("*************************************************************************");
    $display("*                         Congratulations!                              *");
    $display("*                Your execution cycles = %5d cycles          *", total_latency);
    $display("*                Your clock period = %.1f ns          *", CYCLE_clk3);
    $display("*                Total Latency = %.1f ns          *", total_latency*CYCLE_clk3);
    $display("*************************************************************************");
    $finish;
end endtask


endmodule
