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

///                   input      /////
reg [47:0] input_data;
reg MOSI_delay;
reg [87:0] read_data;
reg [63:0] write_data;
////         FSM      ///
parameter IDLE = 4'd0;
parameter Input = 4'd1;
parameter reponse_1 = 4'd2;
parameter read = 4'd3;
parameter write = 4'd4;
parameter reponse_2 = 4'd5;
parameter stop = 4'd6;
parameter busy = 4'd7;
parameter stalk = 4'd8;

reg [10:0] counter, counter_reg, counter_2, counter_2_reg;
reg [2:0] cur_state, next_state;
reg [15:0] for_CRC16;
reg [7:0] reponse_2_data;
reg MOSI_reg;
integer a;

initial $readmemh(SD_p_r, SD);
initial cur_state = 0;
initial counter_reg = 0;

assign reponse_2_data = 8'b0000_0101;
always@(posedge clk)begin
	cur_state <= next_state;
	counter_reg <= counter;
	MOSI_delay <= MOSI;
	counter_2_reg <= counter_2;
	MOSI_reg <= MOSI;
end
always@(*)begin
	case(cur_state)
		IDLE:begin
			MISO = 1;
			counter = 0;
			if(MOSI_reg == 0)begin
				input_data[47] = 0;
				next_state = Input;
			end
			else begin
				next_state = IDLE;
			end
		end
		Input:begin
			MISO = 1;
			counter = counter_reg + 1;
			counter_2 = 0;
			input_data[46 - counter_reg ] = MOSI_reg;
			if(counter_reg >= 46)begin
				next_state = reponse_1;
				counter = 0;
			end
			else begin
				next_state = Input;
			end
		end
		reponse_1:begin
			integer a;
			input_format_check;
			counter = 0;
			counter_2 = counter_2_reg + 1;
			if(counter_2_reg >= 7)begin
				MISO = 0;
				
				if(input_data[45:40] == 17)begin
					next_state = read;
				end
				else begin
					next_state = stop;
				end
			end
			else begin
				MISO = 0;
				next_state = reponse_1;
			end
		end
		stop:begin
			MISO = 1;
			counter = counter_reg + 1;
			counter_2 = 0;
			if(MOSI_reg == 0)begin
				counter = counter_reg - 7;
				next_state = write;
			end
			else begin
				next_state = stop;
			end
		end
		read:begin
			counter = counter_reg + 1;
			for_CRC16 = CRC16_CCITT(.data(SD[input_data[39:8]]));
			read_data = {8'b1111_1110 , SD[input_data[39:8]], CRC16_CCITT(.data(SD[input_data[39:8]]))};
			MISO = read_data[87 - counter_reg];
			if(counter_reg >= 87)begin
				MISO = read_data[0];
				next_state = IDLE;
			end
			else begin
				MISO = read_data[87 - counter_reg];
				next_state = read;
			end
			
		end
		write:begin
			if(counter_reg  % 8 !== 0 || counter_reg  === 0)begin
				time_mod_eight;
			end
			else begin	
				counter_2 = counter_2_reg + 1;
				if(counter_2_reg >= 79)begin
					counter = 0;
					for_CRC16[0] = MOSI_reg;
					next_state = reponse_2;
					if(for_CRC16 !== CRC16_CCITT(.data(write_data)))begin
						check_CRC16;
					end
					SD[input_data[39:8]] = write_data;
				end
				else begin
					next_state = write;
					if(counter_2_reg < 64 )begin
						write_data[63 - counter_2_reg] = MOSI_reg;
					end
					else begin
						for_CRC16[79 - counter_2_reg] = MOSI_reg;
					end
				end
			end
			
			
		end
		reponse_2:begin
			counter = counter_reg + 1;
			counter_2 = 0;
			if(counter_reg >= 7)begin
				MISO = reponse_2_data[0];
				next_state = IDLE;
			end
			else begin
				MISO = reponse_2_data[7 - counter_reg];
				next_state = reponse_2;
			end
		end
		busy:begin
			MISO = 0;
			counter = 0;
			counter_2 = counter_2_reg + 1;
			if(counter_2_reg >= 8)begin
				next_state = IDLE;
			end
			else begin
				next_state = IDLE;
			end
		end 
		default:begin
			counter = 0;
			counter_2 = 0;
			next_state = IDLE;
		end
		
	
	endcase
end

///                       input register                    /////
// always@(posedge clk)begin
	// integer i;
	// if(cur_state == Input)begin
		// input_data[0] <= MOSI_delay;
		// for(i = 0; i < 47;i++)begin
			// input_data[i + 1] <= input_data[i];
		// end
	// end
	// else begin
		// for(i = 0; i <= 47;i++)begin
			// input_data[i] <= input_data[i];
		// end
	// end
	
// end
//////////////////////////////////////////////////////////////////////
// Write your own task here
//////////////////////////////////////////////////////////////////////
//                      SPEC  SD-1 
//                      SPEC  SD-2
//                      SPEC  SD-3
reg [6:0] CRC_7;
task input_format_check; begin
	integer i;
	if(input_data[47] !== 0)begin
		$display("*                              FAIL!                                    *");
		$display("*                        first bit should be 0                          *");
		$display("*                             SPEC SD-1 FAIL                            *");
		YOU_FAIL_task;
		repeat(9)@(negedge clk);
		$finish;
	end
	
	if(input_data[46] !== 1)begin
		$display("*                              FAIL!                                    *");
		$display("*                        second bit should be one                       *");
		$display("*                             SPEC SD-1 FAIL                            *");
		YOU_FAIL_task;
		repeat(9)@(negedge clk);
		$finish;
	end
	
	if(input_data[45:40] !== 24 && input_data[45:40] !== 17)begin
		$display("*                              FAIL!                                    *");
		$display("*                        command should be 24 or 17                     *");
		$display("*                             SPEC SD-1 FAIL                            *");
		YOU_FAIL_task;
		repeat(9)@(negedge clk);
		$finish;
	end
	if(input_data[39:8] > 65535 || input_data[39:8] < 0)begin
		$display("*                              FAIL!                                    *");
		$display("*                     SD address  out of bound                          *");
		$display("*                             SPEC SD-2 FAIL                            *");
		YOU_FAIL_task;
		repeat(9)@(negedge clk);
		$finish;
	end
	if(input_data[7:1] !== CRC7(.data(input_data[47:8])))begin
		$display("*                              FAIL!                                    *");
		$display("*                           CRC_7 wrong                                 *");
		$display("*                             SPEC SD-3 FAIL                            *");
		YOU_FAIL_task;
		repeat(9)@(negedge clk);
		$finish;
	end	
	if(input_data[0] !== 1)begin
		$display("*                              FAIL!                                    *");
		$display("*                        last bit should be 0                           *");
		$display("*                             SPEC SD-1 FAIL                            *");
		YOU_FAIL_task;
		repeat(9)@(negedge clk);
		$finish;
	end
	
end endtask
//              SPEC SD-4                  //
task check_CRC16;begin
	$display("*                              FAIL!                                    *");
	$display("*                       input violate  CRC16                            *");
	$display("*                             SPEC SD-4                                 *");
	YOU_FAIL_task;
	repeat(9)@(negedge clk);
	$finish;
end endtask 

//              SPEC SD-5                  //
task time_mod_eight;begin
	$display("*                              FAIL!                                    *");
	$display("*                        CYCLE time must 0 8 16 ...                     *");
	$display("*                        yout CYCLE time =  %d                          *", counter_reg);
	$display("*                             SPEC SD-5 FAIL                            *");
	YOU_FAIL_task;
	repeat(9)@(negedge clk);
	$finish;
end endtask
//////////////////////////////////////////////////////////////////////




task YOU_FAIL_task; begin
    $display("*                              FAIL!                                    *");
    $display("*                 Error message from pseudo_SD.v                        *");
end endtask

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

endmodule