`ifdef RTL
    `define CYCLE_TIME 10.0
`endif
`ifdef GATE
    `define CYCLE_TIME 10.0
`endif

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


output reg clk, rst_n, in_valid, out_mode;
output reg [2:0] in_weight;

input out_valid, out_code;

real CYCLE = `CYCLE_TIME;
always #(CYCLE/2.0) clk = ~clk;
integer i, a, b, c, f_in, f_out, pat_conut;
integer latency, total_latency;
integer t;
initial begin
	f_in = $fopen("../00_TESTBED/input.txt", "r");
	f_out = $fopen("../00_TESTBED/output.txt", "r");
	reset_task;
	for(pat_conut = 0; pat_conut < 1000; pat_conut = pat_conut + 1) begin
		input_task;
		wait_out_valid_task;
        check_ans_task;
		$display("   pass  %d  pattern  ",pat_conut+1);
	end
	YOU_PASS_task;
	$finish;
end

always@* begin
	if(in_valid && out_valid) begin
        $display("************************************************************");  
        $display("                          FAIL!                             ");    
        $display("*  The out_valid cannot overlap with in_valid              *");
        $display("************************************************************");
		$finish;			
	end	
end
task reset_task; begin 
    rst_n = 'b1;
    in_valid = 'b0;
	in_weight = 'bx;
	out_mode = 'bx;
    total_latency = 0;

    force clk = 0;

    #CYCLE; rst_n = 0; 
    #CYCLE; rst_n = 1;
    
    if(out_valid !== 1'b0 || out_code !== 'b0) begin //out!==0
        $display("************************************************************");  
        $display("                          FAIL!                              ");    
        $display("*  Output signal should be 0 after initial RESET  at %8t   *",$time);
        $display("************************************************************");
        repeat(2) #CYCLE;
        $finish;
    end
	#CYCLE; release clk;
end endtask

logic[2:0] weight[0:7];
logic mode_in;
task input_task; begin
    a = $fscanf(f_in, "%d ", weight[0]);
	a = $fscanf(f_in, "%d ", weight[1]);
	a = $fscanf(f_in, "%d ", weight[2]);
	a = $fscanf(f_in, "%d ", weight[3]);
	a = $fscanf(f_in, "%d ", weight[4]);
	a = $fscanf(f_in, "%d ", weight[5]);
	a = $fscanf(f_in, "%d ", weight[6]);
	a = $fscanf(f_in, "%d ", weight[7]);
	a = $fscanf(f_in, "%d ", mode_in);
    t = $urandom_range(1, 4);
	repeat(t) @(negedge clk);
	in_valid = 1'b1;
	out_mode = mode_in;	
	in_weight = weight[0];
	@(negedge clk);
	out_mode = 'bx;
	in_weight = weight[1];
	@(negedge clk);	
	in_weight = weight[2];
	@(negedge clk);	
	in_weight = weight[3];
	@(negedge clk);		
	in_weight = weight[4];
	@(negedge clk);
	in_weight = weight[5];
	@(negedge clk);
	in_weight = weight[6];
	@(negedge clk);
	in_weight = weight[7];
	@(negedge clk);
    in_valid = 1'b0;	
	out_mode = 'bx;	
	in_weight = 'bx;
end endtask 

task wait_out_valid_task; begin
    latency = 0;
    while(out_valid !== 1'b1) begin
	latency = latency + 1;
      if( latency == 2000) begin
          $display("********************************************************");     
          $display("                          FAIL!                              ");
          $display("*  The execution latency are over 2000 cycles  at %8t   *",$time);//over max
          $display("********************************************************");
	    repeat(2)@(negedge clk);
	    //$finish;
      end
     @(negedge clk);
   end
   total_latency = total_latency + latency;
end endtask
logic[5:0] length;
logic golden;
task check_ans_task; begin
	a = $fscanf(f_out, "%d", length);
	while(out_valid === 1)begin
		for(i = 0; i < length; i = i + 1) begin	
			a = $fscanf(f_out, "%b", golden);
			if(out_code !== golden)begin
				$display ("------------------------------------------------------------------------------------------------------------------------------------------");
				$display ("                                                                      FAIL!                                                               ");
				$display ("                                                                 Golden bit :    %b                                                       ",golden[i]); 
				$display ("                                                                 Your bit :      %b                                                       ",out_code);
				$display ("------------------------------------------------------------------------------------------------------------------------------------------");
				@(negedge clk);
				$finish;		
			end
			else begin		                                                                               
				@(negedge clk);
			end
		end
		
	end	
end endtask

task YOU_PASS_task; begin
	$display ("----------------------------------------------------------------------------------------------------------------------");
    $display ("                                                  Congratulations!                                                                       ");
    $display ("                                           You have passed all patterns!                                                                 ");
    $display ("                                           Your execution cycles = %5d cycles                                                            ", total_latency);
    $display ("                                           Your clock period = %.1f ns                                                               ", CYCLE);
    $display ("                                           Total Latency = %.1f ns                                                               ", total_latency*CYCLE);
    $display ("----------------------------------------------------------------------------------------------------------------------");     
    repeat(2)@(negedge clk);
    $finish;
end endtask



endmodule