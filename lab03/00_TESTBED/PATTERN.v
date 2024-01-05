`ifdef RTL
    `define CYCLE_TIME 40.0
`endif
`ifdef GATE
    `define CYCLE_TIME 40.0
`endif

`include "../00_TESTBED/pseudo_DRAM.v"
`include "../00_TESTBED/pseudo_SD.v"

module PATTERN(
    // Input Signals
    clk,
    rst_n,
    in_valid,
    direction,
    addr_dram,
    addr_sd,
    // Output Signals
    out_valid,
    out_data,
    // DRAM Signals
    AR_VALID, AR_ADDR, R_READY, AW_VALID, AW_ADDR, W_VALID, W_DATA, B_READY,
	AR_READY, R_VALID, R_RESP, R_DATA, AW_READY, W_READY, B_VALID, B_RESP,
    // SD Signals
    MISO,
    MOSI
);

/* Input for design */
output reg        clk, rst_n;
output reg        in_valid;
output reg        direction;
output reg [12:0] addr_dram;
output reg [15:0] addr_sd;

/* Output for pattern */
input        out_valid;
input  [7:0] out_data; 

// DRAM Signals
// write address channel
input [31:0] AW_ADDR;
input AW_VALID;
output AW_READY;
// write data channel
input W_VALID;
input [63:0] W_DATA;
output W_READY;
// write response channel
output B_VALID;
output [1:0] B_RESP;
input B_READY;
// read address channel
input [31:0] AR_ADDR;
input AR_VALID;
output AR_READY;
// read data channel
output [63:0] R_DATA;
output R_VALID;
output [1:0] R_RESP;
input R_READY;

// SD Signals
output MISO;
input MOSI;

real CYCLE = `CYCLE_TIME;
always #(CYCLE / 2.0) clk = ~clk;

integer pat_read;
integer PAT_NUM;
integer total_latency, latency;
integer i_pat,t;

initial begin
    pat_read = $fopen("../00_TESTBED/Input.txt", "r");
    reset_signal_task;

    i_pat = 0;
    total_latency = 0;
    $fscanf(pat_read, "%d", PAT_NUM);
    for (i_pat = 1; i_pat <= PAT_NUM; i_pat = i_pat + 1) begin
        input_task;
        wait_out_valid_task;
        check_ans_task;
        total_latency = total_latency + latency;
        $display("PASS PATTERN NO.%4d", i_pat);
    end
    $fclose(pat_read);

    $writememh("../00_TESTBED/DRAM_final.dat", u_DRAM.DRAM);
    $writememh("../00_TESTBED/SD_final.dat", u_SD.SD);
    YOU_PASS_task;
end

//////////////////////////////////////////////////////////////////////
// Write your own task here
//////////////////////////////////////////////////////////////////////
//                                   reset task SPEC MAIN-1 
/////////////////////////////////////////////////////////////////////
task reset_signal_task;begin
	rst_n = 'b1;
	in_valid = 'b0;
	direction = 'bX;
	addr_dram = 'bX;
	addr_sd = 'bX;
	
	total_latency = 0;
	
	force clk = 0;
	
	#CYCLE; rst_n = 1;
	#CYCLE; rst_n = 0;
	#CYCLE;
	if(out_valid !== 0 || out_data !== 0 || AW_ADDR !== 0 || AW_VALID !== 0 || W_DATA !== 0 || 
		W_VALID !== 0 || B_READY !== 0 || AR_ADDR !== 0 || AR_VALID !== 0 || R_READY !== 0 || MOSI !== 1 )begin
		
		$display("************************************************************");  
        $display("                          FAIL!                             *");    
        $display("*                  SPEC MAIN-1 FAIL                         *");
        $display("************************************************************");
        repeat(2) #CYCLE;
        $finish;
	end
	#CYCLE; rst_n = 'b1;
	#CYCLE; release clk;
end endtask
///////////////////////////////////////////////////////////////////////
//                                 input task                        //
///////////////////////////////////////////////////////////////////////
reg        direction_r;
reg [12:0] addr_dram_r;
reg [15:0] addr_sd_r;
integer a;
task input_task;begin
	t = $urandom_range(2,4);
	repeat(t)@(negedge clk);
	in_valid = 'b1;
	a = $fscanf(pat_read , "%d", direction_r);
	a = $fscanf(pat_read , "%d", addr_dram_r);
	a = $fscanf(pat_read , "%d", addr_sd_r);
	direction = direction_r;
	addr_dram = addr_dram_r;
	addr_sd = addr_sd_r;
	@(negedge clk);
	in_valid = 'b0;
	direction = 'bX;
	addr_dram = 'bX;
	addr_sd = 'bX;
end endtask
///////////////////////////////////////////////////////////////////////////
///                               wait_out_valid_task    
//                                 SPEC MAIN-3                
///////////////////////////////////////////////////////////////////////////
task wait_out_valid_task;begin
	latency = 0;
	while(out_valid !== 1'b1)begin
		latency = latency + 1;
		if(latency > 10000)begin
			$display("********************************************************");     
			$display("                          FAIL!                        *");
			$display("*                     SPEC MAIN-3 FAIL                 *");
			$display("********************************************************");
			repeat(2)@(negedge clk);
			$finish;
		end
		@(negedge clk);
	end

end endtask
/////////////////////////////////////////////////////////////////////////
//                                  check_ans_task
//                                  SPEC MAIN-5
//                                  SPEC MAIN-4
//                                  SPEC MAIN-2
//                                  SPEC MAIN-6
/////////////////////////////////////////////////////////////////////////
always@(negedge clk)begin
	if(out_valid === 0)begin
		if(out_data !== 0)begin
			$display("********************************************************");     
			$display("                          FAIL!                        *");
			$display("*                     SPEC MAIN-2 FAIL                 *");
			$display("********************************************************");
			repeat(2)@(negedge clk);
			$finish;
		end
	end
end
reg [63:0] golden_out_data;
reg [63:0] golden_out_data_SD, golden_out_data_DRAM;
assign golden_out_data_SD = u_SD.SD[addr_sd_r];
assign golden_out_data_DRAM = u_DRAM.DRAM[addr_dram_r];
task check_ans_task;begin
	if(direction_r === 0)begin
		golden_out_data = u_DRAM.DRAM[addr_dram_r];
		if(u_SD.SD[addr_sd_r] !== u_DRAM.DRAM[addr_dram_r] )begin
			$display("********************************************************");     
			$display("                          FAIL!                        *");
			$display("*                     SPEC MAIN-6 FAIL                 *");
			$display("                      DRAM to SD wrong                 *");
			$display("********************************************************");
			repeat(9)@(negedge clk);
			$finish;
		end
		if(out_data !== golden_out_data[63:56])begin
			$display("********************************************************");     
			$display("                        1 FAIL!                        *");
			$display("*                     SPEC MAIN-5 FAIL                 *");
			$display("********************************************************");
			repeat(9)@(negedge clk);
			$finish;
		end
		
		@(negedge clk);
		if(out_valid !== 1 )begin
			$display("********************************************************");     
			$display("                        2 FAIL!                        *");
			$display("*                     SPEC MAIN-4 FAIL                 *");
			$display("********************************************************");
			repeat(9)@(negedge clk);
			$finish;
		end
		if(out_data !== golden_out_data[55:48])begin
			$display("********************************************************");     
			$display("                        3 FAIL!                        *");
			$display("*                     SPEC MAIN-5 FAIL                 *");
			$display("********************************************************");
			repeat(9)@(negedge clk);
			$finish;
		end
		
		@(negedge  clk);
		
		if(out_valid !== 1 )begin
			$display("********************************************************");     
			$display("                        4 FAIL!                        *");
			$display("*                     SPEC MAIN-4 FAIL                 *");
			$display("********************************************************");
			repeat(9)@(negedge clk);
			$finish;
		end
		if(out_data !== golden_out_data[47:40])begin
			$display("********************************************************");     
			$display("                        5 FAIL!                        *");
			$display("*                     SPEC MAIN-5 FAIL                 *");
			$display("********************************************************");
			repeat(9)@(negedge clk);
			$finish;
		end
		
		@(negedge clk);
		
		if(out_valid !== 1 )begin
			$display("********************************************************");     
			$display("                        6 FAIL!                        *");
			$display("*                     SPEC MAIN-4 FAIL                 *");
			$display("********************************************************");
			repeat(9)@(negedge clk);
			$finish;
		end
		if(out_data !== golden_out_data[39:32])begin
			$display("********************************************************");     
			$display("                        7 FAIL!                        *");
			$display("*                     SPEC MAIN-5 FAIL                 *");
			$display("********************************************************");
			repeat(9)@(negedge clk);
			$finish;
		end
		
		@(negedge clk);
		
		if(out_valid !== 1 )begin
			$display("********************************************************");     
			$display("                        8 FAIL!                        *");
			$display("*                     SPEC MAIN-4 FAIL                 *");
			$display("********************************************************");
			repeat(9)@(negedge clk);
			$finish;
		end
		if(out_data !== golden_out_data[31:24])begin
			$display("********************************************************");     
			$display("                        9 FAIL!                        *");
			$display("*                     SPEC MAIN-5 FAIL                 *");
			$display("********************************************************");
			repeat(9)@(negedge clk);
			$finish;
		end
		
		@(negedge clk);
		
		if(out_valid !== 1 )begin
			$display("********************************************************");     
			$display("                       10 FAIL!                        *");
			$display("*                     SPEC MAIN-4 FAIL                 *");
			$display("********************************************************");
			repeat(9)@(negedge clk);
			$finish;
		end
		if(out_data !== golden_out_data[23:16])begin
			$display("********************************************************");     
			$display("                          FAIL!                        *");
			$display("*                     SPEC MAIN-5 FAIL                 *");
			$display("********************************************************");
			repeat(9)@(negedge clk);
			$finish;
		end
		
		@(negedge clk);
		
		if(out_valid !== 1 )begin
			$display("********************************************************");     
			$display("                          FAIL!                        *");
			$display("*                     SPEC MAIN-4 FAIL                 *");
			$display("********************************************************");
			repeat(9)@(negedge clk);
			$finish;
		end
		if(out_data !== golden_out_data[15:8])begin
			$display("********************************************************");     
			$display("                          FAIL!                        *");
			$display("*                     SPEC MAIN-5 FAIL                 *");
			$display("********************************************************");
			repeat(9)@(negedge clk);
			$finish;
		end
		
		@(negedge clk);
		
		if(out_valid !== 1 )begin
			$display("********************************************************");     
			$display("                          FAIL!                        *");
			$display("*                     SPEC MAIN-4 FAIL                 *");
			$display("********************************************************");
			repeat(9)@(negedge clk);
			$finish;
		end
		if(out_data !== golden_out_data[7:0])begin
			$display("********************************************************");     
			$display("                          FAIL!                        *");
			$display("*                     SPEC MAIN-5 FAIL                 *");
			$display("********************************************************");
			repeat(9)@(negedge clk);
			$finish;
		end
		
		@(negedge clk);
		
		if(out_valid === 1)begin
			$display("********************************************************");     
			$display("                          FAIL!                        *");
			$display("*                     SPEC MAIN-4 FAIL                 *");
			$display("********************************************************");
			repeat(9)@(negedge clk);
			$finish;
		end
		if(out_data !== 0)begin
			$display("********************************************************");     
			$display("                          FAIL!                        *");
			$display("*                     SPEC MAIN-2 FAIL                 *");
			$display("********************************************************");
			repeat(9)@(negedge clk);
			$finish;
		end
	end
	else begin
		golden_out_data = u_SD.SD[addr_sd_r];
		if(u_DRAM.DRAM[addr_dram_r] !== u_SD.SD[addr_sd_r])begin
			$display("********************************************************");     
			$display("*                         FAIL!                        *");
			$display("*                     SPEC MAIN-6 FAIL                 *");
			$display("*                     SD to DRAM wrong                 *");
			$display("********************************************************");
			repeat(9)@(negedge clk);
			$finish;
		end
		if(out_data !== golden_out_data[63:56])begin
			$display("********************************************************");     
			$display("                          FAIL!                        *");
			$display("*                     SPEC MAIN-5 FAIL                 *");
			$display("********************************************************");
			repeat(9)@(negedge clk);
			$finish;
		end
		
		@(negedge clk);
		if(out_valid !== 1 )begin
			$display("********************************************************");     
			$display("                          FAIL!                        *");
			$display("*                     SPEC MAIN-4 FAIL                 *");
			$display("********************************************************");
			repeat(9)@(negedge clk);
			$finish;
		end
		if(out_data !== golden_out_data[55:48])begin
			$display("********************************************************");     
			$display("                          FAIL!                        *");
			$display("*                     SPEC MAIN-5 FAIL                 *");
			$display("********************************************************");
			repeat(9)@(negedge clk);
			$finish;
		end
		
		@(negedge  clk);
		
		if(out_valid !== 1 )begin
			$display("********************************************************");     
			$display("                          FAIL!                        *");
			$display("*                     SPEC MAIN-4 FAIL                 *");
			$display("********************************************************");
			repeat(9)@(negedge clk);
			$finish;
		end
		if(out_data !== golden_out_data[47:40])begin
			$display("********************************************************");     
			$display("                          FAIL!                        *");
			$display("*                     SPEC MAIN-5 FAIL                 *");
			$display("********************************************************");
			repeat(9)@(negedge clk);
			$finish;
		end
		
		@(negedge clk);
		
		if(out_valid !== 1 )begin
			$display("********************************************************");     
			$display("                          FAIL!                        *");
			$display("*                     SPEC MAIN-4 FAIL                 *");
			$display("********************************************************");
			repeat(9)@(negedge clk);
			$finish;
		end
		if(out_data !== golden_out_data[39:32])begin
			$display("********************************************************");     
			$display("                          FAIL!                        *");
			$display("*                     SPEC MAIN-5 FAIL                 *");
			$display("********************************************************");
			repeat(9)@(negedge clk);
			$finish;
		end
		
		@(negedge clk);
		
		if(out_valid !== 1 )begin
			$display("********************************************************");     
			$display("                          FAIL!                        *");
			$display("*                     SPEC MAIN-4 FAIL                 *");
			$display("********************************************************");
			repeat(9)@(negedge clk);
			$finish;
		end
		if(out_data !== golden_out_data[31:24])begin
			$display("********************************************************");     
			$display("                          FAIL!                        *");
			$display("*                     SPEC MAIN-5 FAIL                 *");
			$display("********************************************************");
			repeat(9)@(negedge clk);
			$finish;
		end
		
		@(negedge clk);
		
		if(out_valid !== 1 )begin
			$display("********************************************************");     
			$display("                          FAIL!                        *");
			$display("*                     SPEC MAIN-4 FAIL                 *");
			$display("********************************************************");
			repeat(9)@(negedge clk);
			$finish;
		end
		if(out_data !== golden_out_data[23:16])begin
			$display("********************************************************");     
			$display("                          FAIL!                        *");
			$display("*                     SPEC MAIN-5 FAIL                 *");
			$display("********************************************************");
			repeat(9)@(negedge clk);
			$finish;
		end
		
		@(negedge clk);
		
		if(out_valid !== 1 )begin
			$display("********************************************************");     
			$display("                          FAIL!                        *");
			$display("*                     SPEC MAIN-4 FAIL                 *");
			$display("********************************************************");
			repeat(9)@(negedge clk);
			$finish;
		end
		if(out_data !== golden_out_data[15:8])begin
			$display("********************************************************");     
			$display("                          FAIL!                        *");
			$display("*                     SPEC MAIN-5 FAIL                 *");
			$display("********************************************************");
			repeat(9)@(negedge clk);
			$finish;
		end
		
		@(negedge clk);
		
		if(out_valid !== 1 )begin
			$display("********************************************************");     
			$display("                          FAIL!                        *");
			$display("*                     SPEC MAIN-4 FAIL                 *");
			$display("********************************************************");
			repeat(9)@(negedge clk);
			$finish;
		end
		if(out_data !== golden_out_data[7:0])begin
			$display("********************************************************");     
			$display("                          FAIL!                        *");
			$display("*                     SPEC MAIN-5 FAIL                 *");
			$display("********************************************************");
			repeat(9)@(negedge clk);
			$finish;
		end
		
		@(negedge clk);
		
		if(out_valid === 1)begin
			$display("********************************************************");     
			$display("                          FAIL!                        *");
			$display("*                     SPEC MAIN-4 FAIL                 *");
			$display("********************************************************");
			repeat(9)@(negedge clk);
			$finish;
		end
		if(out_data !== 0)begin
			$display("********************************************************");     
			$display("                          FAIL!                        *");
			$display("*                     SPEC MAIN-2 FAIL                 *");
			$display("********************************************************");
			repeat(9)@(negedge clk);
			$finish;
		end
	end

end endtask
//////////////////////////////////////////////////////////////////////

task YOU_PASS_task; begin
    $display("*************************************************************************");
    $display("*                         Congratulations!                              *");
    $display("*                Your execution cycles = %5d cycles          *", total_latency);
    $display("*                Your clock period = %.1f ns          *", CYCLE);
    $display("*                Total Latency = %.1f ns          *", total_latency*CYCLE);
    $display("*************************************************************************");
    $finish;
end endtask

task YOU_FAIL_task; begin
    $display("*                              FAIL!                                    *");
    $display("*                    Error message from PATTERN.v                       *");
end endtask

pseudo_DRAM u_DRAM (
    .clk(clk),
    .rst_n(rst_n),
    // write address channel
    .AW_ADDR(AW_ADDR),
    .AW_VALID(AW_VALID),
    .AW_READY(AW_READY),
    // write data channel
    .W_VALID(W_VALID),
    .W_DATA(W_DATA),
    .W_READY(W_READY),
    // write response channel
    .B_VALID(B_VALID),
    .B_RESP(B_RESP),
    .B_READY(B_READY),
    // read address channel
    .AR_ADDR(AR_ADDR),
    .AR_VALID(AR_VALID),
    .AR_READY(AR_READY),
    // read data channel
    .R_DATA(R_DATA),
    .R_VALID(R_VALID),
    .R_RESP(R_RESP),
    .R_READY(R_READY)
);

pseudo_SD u_SD (
    .clk(clk),
    .MOSI(MOSI),
    .MISO(MISO)
);

endmodule