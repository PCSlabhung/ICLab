module CLK_1_MODULE (
    clk,
    rst_n,
    in_valid,
    seed_in,
    out_idle,
    out_valid,
    seed_out,

    clk1_handshake_flag1,
    clk1_handshake_flag2,
    clk1_handshake_flag3,
    clk1_handshake_flag4
);

input clk;
input rst_n;
input in_valid;
input [31:0] seed_in;
input out_idle;
output reg out_valid;
output reg [31:0] seed_out;

reg [31:0] seed_dff;
// You can change the input / output of the custom flag ports
input clk1_handshake_flag1;
input clk1_handshake_flag2;
output clk1_handshake_flag3;
output clk1_handshake_flag4;

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
        seed_dff <= 0;
        out_valid <= 0;
    end
    else begin
        if(in_valid)begin
            seed_dff <= seed_in;
            out_valid <= 1;
        end
        else begin
            seed_dff <= seed_dff;
            out_valid <= 0;
        end
    end
end
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
        seed_out <= 0;
    end
    else begin
        if(out_idle)begin
            seed_out <= seed_dff;
        end
        else begin
            seed_out <= seed_out;
        end
    end
end

endmodule

module CLK_2_MODULE (
    clk,
    rst_n,
    in_valid,
    fifo_full,
    seed,
    out_valid,
    rand_num,
    busy,

    handshake_clk2_flag1,
    handshake_clk2_flag2,
    handshake_clk2_flag3,
    handshake_clk2_flag4,

    clk2_fifo_flag1,
    clk2_fifo_flag2,
    clk2_fifo_flag3,
    clk2_fifo_flag4
);

input clk;
input rst_n;
input in_valid;
input fifo_full;
input [31:0] seed;
output reg out_valid;
output reg [31:0] rand_num;
output reg busy;

// You can change the input / output of the custom flag ports
input handshake_clk2_flag1;
input handshake_clk2_flag2;
output handshake_clk2_flag3;
output handshake_clk2_flag4;

input clk2_fifo_flag1;
input clk2_fifo_flag2;
output clk2_fifo_flag3;
output clk2_fifo_flag4;

reg [31:0] seed_dff;
reg [31:0] num1, num2, rand_num_comb;
reg [31:0] input_seed;
always@(posedge clk or negedge rst_n)begin
	if(!rst_n)begin
		input_seed <= 0;
	end
	else begin
		if(in_valid)
			input_seed <= seed;
		else
			input_seed <= input_seed;
	end
end
//=========================================================//
//             parameter  &    FSM                         //
//=========================================================//
parameter IDLE = 2'd0;
parameter Calculate = 2'd1;
parameter Full = 2'd3;
reg [1:0] cur_state;
reg [1:0] nxt_state;
reg [8:0] counter_comb, counter_dff;
reg [31:0] seed_dff_d1;
reg [8:0] counter_dff_d1;
reg in_valid_dff;
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
        cur_state <= 0;
        in_valid_dff <= 0;
        counter_dff <= 0;
    end
    else begin
        cur_state <= nxt_state;
        in_valid_dff <= in_valid;
        counter_dff <= counter_comb;
    end
end
always @(*) begin
    if(cur_state == IDLE)begin
        busy = 0;
        counter_comb = 0;
        out_valid = 0;
        if(in_valid_dff == 1)begin
            nxt_state = Calculate;
        end
        else begin
            nxt_state = IDLE;
        end
    end
    else if(cur_state == Calculate)begin // here might fail functional test
        busy = 1;
        if(fifo_full)begin
            counter_comb = counter_dff_d1;
            nxt_state = Full;
			out_valid = 0;
        end
        else begin
            if(counter_dff == 256)begin
                counter_comb = 0;
                nxt_state = IDLE;
				out_valid = 0;
            end
            else begin
                counter_comb = counter_dff + 1;
                nxt_state = Calculate;
                out_valid = 1;
            end
        end
    end
    else begin
        busy = 1;
		out_valid = 0;
        counter_comb = counter_dff;
        if(counter_dff == 256)begin // here might fail funtional test
            nxt_state = IDLE;
            counter_comb = 0;
        end
        else begin
            if(fifo_full)begin
                nxt_state = Full;
            end
            else begin
                nxt_state = Calculate;
            end
        end
    end
end
//========================================//
//             input register             //
//========================================//

always@(posedge clk or negedge rst_n)begin
	if(!rst_n)begin
		seed_dff_d1 <= 0;
		counter_dff_d1 <= 0;
	end
	else begin
		seed_dff_d1 <= seed_dff;
		counter_dff_d1 <= counter_dff;
	end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
        seed_dff <= 0;
    end
    else begin
        if(cur_state == IDLE)begin
            if(in_valid_dff == 1)begin
                seed_dff <= input_seed;
            end
            else begin
                seed_dff <= seed_dff;
            end
        end
        else if(cur_state == Calculate)begin
            if(fifo_full == 1)begin
                seed_dff <= seed_dff_d1;
            end
            else begin
                seed_dff <= rand_num;
            end
        end
        else begin
            seed_dff <= seed_dff;
        end
    end
end
//=======================================================================//
//                          combination circuit                          //
//=======================================================================//
assign num1 = seed_dff ^ (seed_dff << 13);
assign num2 = num1 ^ (num1 >> 17);
//assign rand_num_comb = num2 ^ (num2 << 5);
assign rand_num = num2 ^ (num2 << 5);
endmodule

module CLK_3_MODULE (
    clk,
    rst_n,
    fifo_empty,
    fifo_rdata,
    fifo_rinc,
    out_valid,
    rand_num,

    fifo_clk3_flag1,
    fifo_clk3_flag2,
    fifo_clk3_flag3,
    fifo_clk3_flag4
);

input clk;
input rst_n;
input fifo_empty;
input [31:0] fifo_rdata;
output reg fifo_rinc;
output reg out_valid;
output reg [31:0] rand_num;
reg fifo_empty_dff, fifo_empty_dff_d1;
// You can change the input / output of the custom flag ports
input fifo_clk3_flag1;
input fifo_clk3_flag2;
output fifo_clk3_flag3;
output fifo_clk3_flag4;
/* always @(posedge clk or negedge rst_n) begin // mind combinational loop of rinc and rempty
    if(!rst_n)begin
		fifo_rinc <= 0;
	end
	else begin
		if(fifo_empty)begin
			fifo_rinc <= 0;
		end
		else begin
			fifo_rinc <= 1;
		end
	end
end */
always@(*)begin
	if(fifo_empty)begin
		fifo_rinc = 0;
	end
	else begin
		fifo_rinc = 1;
	end
end 
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
        fifo_empty_dff <= 1;
        fifo_empty_dff_d1 <= 1;
    end
    else begin
        fifo_empty_dff <= fifo_empty;
        fifo_empty_dff_d1 <= fifo_empty_dff;
    end
end
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
        out_valid <= 0;
        rand_num <= 0;
    end
    else begin
        if(fifo_empty_dff)begin
            out_valid <= 0;
            rand_num <= 0;
        end
        else begin
            out_valid <= 1;
            rand_num <= fifo_rdata;
        end
    end
end

endmodule