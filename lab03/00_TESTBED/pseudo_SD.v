//############################################################################
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//   (C) Copyright Laboratory System Integration and Silicon Implementation
//   All Right Reserved
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
//   2023 ICLAB Fall Course
//   Lab03      : BRIDGE
//   Author     : Ting-Yu Chang
//                
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
//   File Name   : pseudo_SD.v
//   Module Name : pseudo_SD
//   Release version : v1.0 (Release Date: Sep-2023)
//
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//############################################################################

module pseudo_SD (
    clk,
    MOSI,
    MISO
);

input clk;
input MOSI;
output reg MISO;

parameter SD_p_r = "../00_TESTBED/SD_init.dat";

reg [63:0] SD [0:65535];
reg [87:0] read_data;
reg [79:0] write_data;
reg [7:0] start_token;
integer i,pat_read, pat_num, rand_num, counter;

reg [47:0] command;
initial begin
	$readmemh(SD_p_r, SD);
	pat_read = $fopen("../00_TESTBED/Input.txt","r");
	$fscanf(pat_read,"%d",pat_num);
	$display("%d", pat_num);
	for(i = 0; i < pat_num;i = i + 1)begin
		MISO = 1;
		counter = 0;
		SDcommand;
		reponse_1;
		if(command[45:40] === 17)begin
			stalk;
			SDread;
			
		end
		else begin
			wait_1to32;
			SDwrite;
			reponse_2;
			busy;
		end
		MISO = 1;
	end

end
function automatic [6:0] CRC7;  // Return 7-bit result
    input [39:0] data;  // 40-bit data input
    reg [6:0] crc;
    integer i;
    reg data_in, data_out;
    parameter polynomial = 7'h9;  // x^7 + x^3 + 1

    begin
        crc = 7'd0;
        for (i = 0; i < 40; i = i + 1) begin
            data_in = data[39-i];
            data_out = crc[6];
            crc = crc << 1;  // Shift the CRC
            if (data_in ^ data_out) begin
                crc = crc ^ polynomial;
            end
        end
        CRC7 = crc;
    end
endfunction

function automatic [15:0] CRC16_CCITT;
    input [63:0] data;
	reg [15:0] crc;
	integer i;
	reg data_in, data_out;
	parameter polynomial = 16'h1021;
	
	begin
		crc = 16'd0;
		for(i = 0;i < 64; i = i + 1)begin
			data_in = data[63 - i];
			data_out = crc[15];
			crc = crc << 1;
			if(data_in ^ data_out)begin
				crc = crc ^ polynomial;
			end
		end
		CRC16_CCITT = crc;
	end
	
	
endfunction

task stalk;
	MISO = 1;
	rand_num = $urandom_range(1,32);
	repeat(rand_num * 8)@(posedge clk);
endtask
task wait_1to32;
	MISO = 1;
	start_token = 0;
	while(start_token !== 8'b1111_1110)begin
		@(posedge clk);
		start_token[7] = start_token[6];
		start_token[6] = start_token[5];
		start_token[5] = start_token[4];
		start_token[4] = start_token[3];
		start_token[3] = start_token[2];
		start_token[2] = start_token[1];
		start_token[1] = start_token[0];
		start_token[0] = MOSI;
		counter = counter + 1;
	end
	if((counter - 8) % 8 != 0 || (counter - 8) === 0)begin
		$display("************************************************************");  
        $display("                          FAIL!                            *");    
        $display("*                      SPEC SD-5 FAIL                      *");
		$display("             stalk cycles should be multiple of 8          *");
        $display("************************************************************");
		you_fuck_up;
	end
	
endtask
task SDcommand; begin
	read_data = 0;
	MISO = 1;
	while(MOSI !== 0)begin
		@(posedge clk);
	end
	command[47] = MOSI;
	for(i = 46;i >= 0;i = i - 1)begin
		@(posedge clk);
		command[i] = MOSI;
		
	end
	if(command[47] !== 0)begin
		$display("************************************************************");  
        $display("                          FAIL!                            *");    
        $display("*                      SPEC SD-1 FAIL                      *");
		$display("                 first bit should be zero                  *");
        $display("************************************************************");
		you_fuck_up;
	end
	if(command[46] !== 1)begin
		$display("************************************************************");  
        $display("                          FAIL!                            *");    
        $display("*                      SPEC SD-1 FAIL                      *");
		$display("                second bit should be zero                  *");
        $display("************************************************************");
		you_fuck_up;
	end
	if(command[45:40] !== 17 && command[45:40] !== 24)begin
		$display("************************************************************");  
        $display("                          FAIL!                            *");    
        $display("*                      SPEC SD-1 FAIL                      *");
		$display("                command should be 24 or 17                 *");
        $display("************************************************************");
		you_fuck_up;
	end
	if(command[39:8] > 65535)begin
		$display("************************************************************");  
        $display("                          FAIL!                            *");    
        $display("*                      SPEC SD-2 FAIL                      *");
		$display("                    address out of bound                   *");
        $display("************************************************************");
		you_fuck_up;
	end
	if(command[7:1] !== CRC7(.data(command[47:8])))begin
		$display("************************************************************");  
        $display("                          FAIL!                            *");    
        $display("*                      SPEC SD-3 FAIL                      *");
		$display("                        CRC 7 wrong                        *");
        $display("************************************************************");
		you_fuck_up;
	end
	if(command[0] !== 1)begin
		$display("************************************************************");  
        $display("                          FAIL!                            *");    
        $display("*                      SPEC SD-1 FAIL                      *");
		$display("                last bit should be zero                    *");
        $display("************************************************************");
		you_fuck_up;
	end
end endtask
task reponse_1;begin
	rand_num = $urandom_range(0,8);
	repeat(rand_num * 8)@(posedge clk);
	
	for(i = 0; i <= 7; i = i + 1)begin
		MISO = 0;
		@(posedge clk);
	end
end endtask 

task SDread;begin
	read_data = {8'hFE, SD[command[39:8]], CRC16_CCITT(.data(SD[command[39:8]]))};
	MISO = read_data[87];
	for(i = 86;i >= 0;i = i - 1)begin
		@(posedge clk);
		MISO = read_data[i];
	end
	@(posedge clk);
end endtask
task SDwrite;begin
	MISO = 1;
	for(i = 79;i >= 0; i = i - 1)begin
		@(posedge clk);
		write_data[i] = MOSI;
	end
	if(write_data[15:0] !== CRC16_CCITT(.data(write_data[79:16])))begin
		$display("************************************************************");  
        $display("                          FAIL!                            *");    
        $display("*                      SPEC SD-4 FAIL                      *");
		$display("                        CRC16 wrong                        *");
        $display("************************************************************");
		you_fuck_up;
	end
end endtask
reg [7:0] reponse;
assign reponse = 8'b0000_0101;
task reponse_2;
	for(i = 7; i >= 0;i = i - 1)begin
		MISO = reponse[i];
		@(posedge clk);
	end
endtask
task busy;
	MISO = 0;
	rand_num = $urandom_range(0 , 32);
	repeat(rand_num * 8)@( posedge clk);
	SD[command[39:8]] = write_data[79:16];
	MISO = 1;
	
endtask
task you_fuck_up;
	$display("************************************************************");  
    $display("                          FAIL!                            *");    
    $display("*                   You fuck up in SD                      *");
    $display("************************************************************");
	repeat(9)@(posedge clk);
	$finish;
endtask


endmodule
