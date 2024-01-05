
//############################################################################
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//   (C) Copyright Laboratory System Integration and Silicon Implementation
//   All Right Reserved
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
//   ICLAB 2023 Fall
//   Lab04 Exercise		: Siamese Neural Network
//   Author     		: Hsien-Chi Peng (jhpeng2012@gmail.com)
//
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
//   File Name   : SNN.v
//   Module Name : SNN
//   Release version : V1.0 (Release Date: 2023-10)
//
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//############################################################################

// synopsys translate_off
`ifdef RTL
	`include "GATED_OR.v"
`else
	`include "Netlist/GATED_OR_SYN.v"
`endif
// synopsys translate_on

module SNN(
    //Input Port
    clk,
    rst_n,
    in_valid,
    cg_en,
    Img,
    Kernel,
	Weight,
    Opt,

    //Output Port
    out_valid,
    out
    );


//---------------------------------------------------------------------
//   PARAMETER
//---------------------------------------------------------------------

// IEEE floating point parameter
parameter inst_sig_width = 23;
parameter inst_exp_width = 8;
parameter inst_ieee_compliance = 0;
parameter inst_arch_type = 0;
parameter inst_arch = 0;
parameter inst_faithful_round = 0;



input rst_n, clk, in_valid, cg_en;
input [inst_sig_width+inst_exp_width:0] Img, Kernel, Weight;
input [1:0] Opt;

output reg	out_valid;
output reg [inst_sig_width+inst_exp_width:0] out;
integer i,j;
genvar  a,b;

reg [31:0] In_feature_map_1_comb [0:3][0:3];
reg [31:0] In_feature_map_2_comb [0:3][0:3];
reg [31:0] In_feature_map_1_reg  [0:3][0:3];
reg [31:0] In_feature_map_2_reg  [0:3][0:3];

reg [31:0] padding_map [0:5][0:5];

reg [1:0] Opt_reg, Opt_comb;
reg [31:0] Kernel_1_reg [0:2][0:2];
reg [31:0] Kernel_1_comb[0:2][0:2];
reg [31:0] Kernel_2_reg [0:2][0:2];
reg [31:0] Kernel_2_comb[0:2][0:2];
reg [31:0] Kernel_3_reg [0:2][0:2];
reg [31:0] Kernel_3_comb[0:2][0:2];
reg [31:0] In_weight_reg[0:1][0:1];
reg [31:0] In_weight_comb[0:1][0:1];

reg [31:0] Kernel_CNN[0:2][0:2];
reg [31:0] input_feature_map_comb [0:2][0:2];
reg [31:0] input_feature_map_dff  [0:2][0:2];
wire [31:0] CNN_out;

reg [31:0] Convolution_out1_reg  [0:3][0:3];
//reg [31:0] Convolution_out2_reg  [0:3][0:3];
reg [31:0] Convolution_out1_comb [0:3][0:3];
//reg [31:0] Convolution_out2_comb [0:3][0:3];

reg [31:0] CNN_adder_input;
reg [31:0] CNN_adder_input_reg;
wire [31:0] CNN_adder_output;

reg [31:0] for_max_1[0:1][0:1][0:1];
reg [31:0] Equalizer_in         [0:5][0:5];
reg [31:0] Equalizer_out        [0:3][0:3];
reg [31:0] Equalizer_out_div    [0:3][0:3];
reg [31:0] Equalizer_out_div_reg[0:3][0:3];
reg [31:0] Equalizer_out_reg    [0:3][0:3];
reg [31:0] Max_pool_in    [0:3][0:3];
wire [31:0] Max_pool_out   [0:1][0:1];
reg [31:0] fc_out    [0:3];
reg [31:0] fc_1_comb [0:3];
reg [31:0] fc_2_comb [0:3];
reg [31:0] fc_1_reg  [0:3];
reg [31:0] fc_2_reg  [0:3];

reg [31:0] Norm_input[0:3];
reg [31:0] Norm_output [0:3];
reg [31:0] Norm_1_reg[0:3];
reg [31:0] Norm_2_reg[0:3];
reg [31:0] Norm_1_comb[0:3];
reg [31:0] Norm_2_comb[0:3];
wire [31:0] max_1, max_2, max_true, min_1, min_2, min_true;
wire [31:0] no1, no2, no3, no4, de;

reg [31:0] ST_stage_in[0:3];
wire [31:0] expZ;
reg [31:0] expZ_reg;
wire [31:0] exp_neg_Z;
reg [31:0] exp_neg_Z_reg;
wire [31:0] exp_neg_Z_plus_1;
wire [31:0] sigmoid_out[0:3];
wire [31:0] tanh_de;
wire [31:0] tanh_no;

reg [31:0] div_in_de;
reg [31:0] div_in_no;
wire [31:0] ST_stage_out;
reg [31:0] encode_1_reg [0:3];
reg [31:0] encode_1_comb[0:3];
reg [31:0] encode_2_reg [0:3];
reg [31:0] encode_2_comb[0:3];

wire[31:0] L1_distance_in  [0:3];
reg [31:0] L1_distance_in_abs[0:3];
wire[31:0] L1_ditance_out;
reg [31:0] out_comb;
reg out_valid_comb;
//===========================================//
//              for FSM                      //
//===========================================//
parameter IDLE_Input = 1'd0;
parameter Calculation = 1'd1;
reg cur_state, nxt_state;
reg [6:0] counter, counter_reg;
//===========================================//
//                FSM                        //
//===========================================//
always@(posedge clk or negedge rst_n)begin
	if(!rst_n)begin
		cur_state <= 0;
		counter_reg <= 0;
	end
	else begin
		cur_state <= nxt_state;
		counter_reg <= counter;
	end
end

always@(*)begin
	if(cur_state == IDLE_Input)begin
		if(in_valid)begin
			counter = counter_reg + 1;
		end
		else begin
			counter = 0;
		end
		if(counter_reg == 8)begin
			nxt_state = Calculation;
		end
		else begin
			nxt_state = IDLE_Input;
		end
	end
	else begin
		counter = counter_reg + 1;
		if(out_valid == 1)begin
			counter = 0;
			nxt_state = IDLE_Input;
		end
		else begin
			nxt_state = Calculation;
		end
	end
end
always @(*) begin
	if(counter_reg == 123)begin
		out_comb = L1_ditance_out;
		out_valid_comb = 1;
	end
	else begin 
		out_comb = 0;
		out_valid_comb = 0;
	end
end
wire out_CG;
GATED_OR GATED_1(.CLOCK(clk), .SLEEP_CTRL((counter_reg != 123 && counter_reg != 124) & cg_en), .RST_N(rst_n), .CLOCK_GATED(out_CG));
always @(posedge out_CG or negedge rst_n) begin//03_pass
	if(!rst_n)begin
		out <= 0;
		out_valid <= 0;
	end
	else begin
		out <= out_comb;
		out_valid <= out_valid_comb;
	end
end
//==========================================//
//              input register              //
//==========================================//
wire In_kernel_map_CG;
reg in_valid_wake_up;
always @(posedge clk or negedge rst_n) begin
	if(!rst_n)begin
		in_valid_wake_up <= 0;
	end
	else begin
		if(in_valid || counter_reg == 0)begin
			in_valid_wake_up <= 0 ;
		end
		else begin
			in_valid_wake_up <= 1 ;
		end
	end
end
GATED_OR GATED_2(.CLOCK(clk), .SLEEP_CTRL((in_valid_wake_up) & cg_en), .RST_N(rst_n), .CLOCK_GATED(In_kernel_map_CG));
always @(posedge clk or negedge rst_n) begin//03_fail
	if(!rst_n)begin
		for(i = 0; i < 3;i = i + 1)begin
			for(j = 0; j < 3; j = j + 1)begin
				Kernel_1_reg[i][j] <= 0;
				Kernel_2_reg[i][j] <= 0;
				Kernel_3_reg[i][j] <= 0;
			end
		end
	end
	else begin
		for(i = 0; i < 3; i = i + 1)begin
			for(j = 0;j < 3;j = j + 1)begin
				Kernel_1_reg[i][j] <= Kernel_1_comb[i][j];
				Kernel_2_reg[i][j] <= Kernel_2_comb[i][j];
				Kernel_3_reg[i][j] <= Kernel_3_comb[i][j];
			end
		end
	end
end
wire In_feature_map_CG;
GATED_OR GATED_3(.CLOCK(clk), .SLEEP_CTRL((counter_reg > 95) & cg_en), .RST_N(rst_n), .CLOCK_GATED(In_feature_map_CG));
always @(posedge clk or negedge rst_n) begin
	if(!rst_n)begin
		for(i = 0; i < 4; i = i + 1)begin
			for(j = 0 ;j < 4; j = j + 1)begin
				In_feature_map_1_reg[i][j] <= 0;
			end
		end
		
	end
	else begin
		for(i = 0; i < 4; i = i + 1)begin
			for(j = 0 ;j < 4; j = j + 1)begin
				In_feature_map_1_reg[i][j] <= In_feature_map_1_comb[i][j];
			end
		end
	end
end
wire In_Opt_CG;
GATED_OR GATED_4(.CLOCK(clk), .SLEEP_CTRL((counter_reg != 0) & cg_en), .RST_N(rst_n), .CLOCK_GATED(In_Opt_CG));
always @(posedge clk or negedge rst_n) begin
	if(!rst_n)begin
		Opt_reg <= 0;
	end
	else begin
		Opt_reg <= Opt_comb;
	end
end
wire In_weight_CG;
GATED_OR GATED_5(.CLOCK(clk), .SLEEP_CTRL((counter_reg > 3) & cg_en), .RST_N(rst_n), .CLOCK_GATED(In_weight_CG));
always@(posedge clk or negedge rst_n)begin
	if(!rst_n)begin
		
		In_weight_reg[0][0] <= 0;
		In_weight_reg[0][1] <= 0;
		In_weight_reg[1][0] <= 0;
		In_weight_reg[1][1] <= 0;
	end
	else begin
		
		In_weight_reg[0][0] <= In_weight_comb[0][0];
		In_weight_reg[0][1] <= In_weight_comb[0][1];
		In_weight_reg[1][0] <= In_weight_comb[1][0];
		In_weight_reg[1][1] <= In_weight_comb[1][1];
	end
end
//================================================//
//                    input weight                //
//================================================//
always@(*)begin
	if(cur_state == IDLE_Input)begin
		In_weight_comb[0][0] = In_weight_reg[0][0];
		In_weight_comb[0][1] = In_weight_reg[0][1];
		In_weight_comb[1][0] = In_weight_reg[1][0];
		In_weight_comb[1][1] = In_weight_reg[1][1];
		Opt_comb = Opt_reg;
		if(in_valid)begin
			case(counter_reg)
				7'd0:begin 
					In_weight_comb[0][0] = Weight;
					Opt_comb = Opt;
				end
				7'd1:In_weight_comb[0][1] = Weight;
				7'd2:In_weight_comb[1][0] = Weight;
				7'd3:In_weight_comb[1][1] = Weight;
			endcase
		end
		else begin
			In_weight_comb[0][0] = In_weight_reg[0][0];
			In_weight_comb[0][1] = In_weight_reg[0][1];
			In_weight_comb[1][0] = In_weight_reg[1][0];
			In_weight_comb[1][1] = In_weight_reg[1][1];
			Opt_comb = Opt_reg;
		end
	end
	else begin
		Opt_comb = Opt_reg;
		In_weight_comb[0][0] = In_weight_reg[0][0];
		In_weight_comb[0][1] = In_weight_reg[0][1];
		In_weight_comb[1][0] = In_weight_reg[1][0];
		In_weight_comb[1][1] = In_weight_reg[1][1];
	end
end
//================================================//
//                     input kernel               //
//================================================//

always@(*)begin
	if(in_valid)begin
		for(i = 0; i < 3; i = i + 1)begin
			for(j = 0; j < 3; j = j + 1)begin
				Kernel_1_comb[i][j] = Kernel_1_reg[i][j];
				Kernel_2_comb[i][j] = Kernel_2_reg[i][j];
				Kernel_3_comb[i][j] = Kernel_3_reg[i][j];
			end
		end
	
		case(counter_reg)
			7'd0:Kernel_1_comb[0][0] = Kernel;
			7'd1:Kernel_1_comb[0][1] = Kernel;
			7'd2:Kernel_1_comb[0][2] = Kernel;

			7'd3:Kernel_1_comb[1][0] = Kernel;
			7'd4:Kernel_1_comb[1][1] = Kernel;
			7'd5:Kernel_1_comb[1][2] = Kernel;
			
			7'd6:Kernel_1_comb[2][0] = Kernel;
			7'd7:Kernel_1_comb[2][1] = Kernel;
			7'd8:Kernel_1_comb[2][2] = Kernel;

			7'd9:Kernel_2_comb[0][0] = Kernel;
			7'd10:Kernel_2_comb[0][1] = Kernel;
			7'd11:Kernel_2_comb[0][2] = Kernel;

			7'd12:Kernel_2_comb[1][0] = Kernel;
			7'd13:Kernel_2_comb[1][1] = Kernel;
			7'd14:Kernel_2_comb[1][2] = Kernel;
			
			7'd15:Kernel_2_comb[2][0] = Kernel;
			7'd16:Kernel_2_comb[2][1] = Kernel;
			7'd17:Kernel_2_comb[2][2] = Kernel;

			7'd18:Kernel_3_comb[0][0] = Kernel;
			7'd19:Kernel_3_comb[0][1] = Kernel;
			7'd20:Kernel_3_comb[0][2] = Kernel;

			7'd21:Kernel_3_comb[1][0] = Kernel;
			7'd22:Kernel_3_comb[1][1] = Kernel;
			7'd23:Kernel_3_comb[1][2] = Kernel;
			
			7'd24:Kernel_3_comb[2][0] = Kernel;
			7'd25:Kernel_3_comb[2][1] = Kernel;
			7'd26:Kernel_3_comb[2][2] = Kernel;
		endcase
		
	end
	else begin
		for(i = 0; i < 3; i = i + 1)begin
			for(j = 0; j < 3; j = j + 1)begin
				Kernel_1_comb[i][j] = Kernel_1_reg[i][j];
				Kernel_2_comb[i][j] = Kernel_2_reg[i][j];
				Kernel_3_comb[i][j] = Kernel_3_reg[i][j];
			end
		end
	end
end



always @(*) begin
	if(counter_reg <= 95)begin
		if(in_valid)begin
			for(i = 0; i < 4; i = i + 1)begin
				for(j = 0 ;j < 4; j = j + 1)begin
					In_feature_map_1_comb[i][j] = In_feature_map_1_reg[i][j];
				end
			end
			case(counter_reg)
				0 , 16 , 32 , 48 , 64 , 80: In_feature_map_1_comb[0][0] = Img;
				1 , 17 , 33 , 49 , 65 , 81: In_feature_map_1_comb[0][1] = Img;
				2 , 18 , 34 , 50 , 66 , 82: In_feature_map_1_comb[0][2] = Img;
				3 , 19 , 35 , 51 , 67 , 83: In_feature_map_1_comb[0][3] = Img;
				
				4 , 20 , 36 , 52 , 68 , 84: In_feature_map_1_comb[1][0] = Img;
				5 , 21 , 37 , 53 , 69 , 85: In_feature_map_1_comb[1][1] = Img;
				6 , 22 , 38 , 54 , 70 , 86: In_feature_map_1_comb[1][2] = Img;
				7 , 23 , 39 , 55 , 71 , 87: In_feature_map_1_comb[1][3] = Img;
				
				8 , 24 , 40 , 56 , 72 , 88: In_feature_map_1_comb[2][0] = Img;
				9 , 25 , 41 , 57 , 73 , 89: In_feature_map_1_comb[2][1] = Img;
				10, 26 , 42 , 58 , 74 , 90:In_feature_map_1_comb[2][2] = Img;
				11, 27 , 43 , 59 , 75 , 91:In_feature_map_1_comb[2][3] = Img;
				
				12, 28 , 44 , 60 , 76 , 92:In_feature_map_1_comb[3][0] = Img;
				13, 29 , 45 , 61 , 77 , 93:In_feature_map_1_comb[3][1] = Img;
				14, 30 , 46 , 62 , 78 , 94:In_feature_map_1_comb[3][2] = Img;
				15, 31 , 47 , 63 , 79 , 95:In_feature_map_1_comb[3][3] = Img;
			endcase
		end
		else begin
			for(i = 0; i < 4; i = i + 1)begin
				for(j = 0 ;j < 4; j = j + 1)begin
					In_feature_map_1_comb[i][j] = In_feature_map_1_reg[i][j];
				end
			end
		end
	end
	else begin
		for(i = 0; i < 4; i = i + 1)begin
				for(j = 0 ;j < 4; j = j + 1)begin
					In_feature_map_1_comb[i][j] = In_feature_map_1_reg[i][j];
				end
			end
	end
end
//======================================//
//                 padding              //
//======================================//

always @(*) begin
	for(i = 0; i < 6; i = i + 1)begin
			for(j = 0 ; j < 6; j = j + 1)begin
				if(i == 0 && j > 0 && j < 5)begin
					padding_map[i][j] = In_feature_map_1_reg[0][j - 1] & ({32{~Opt_reg[0]}});
				end
				else if(i == 5 && j > 0 && j < 5)begin
					padding_map[i][j] = In_feature_map_1_reg[3][j - 1] & ({32{~Opt_reg[0]}});
				end
				else if(j == 0 && i > 0 && i < 5)begin
					padding_map[i][j] = In_feature_map_1_reg[i -1][0] & ({32{~Opt_reg[0]}});
				end
				else if(j == 5 && i > 0 && i < 5)begin
					padding_map[i][j] = In_feature_map_1_reg[i - 1][3] & ({32{~Opt_reg[0]}});
				end
				else if(i >= 1 && i <= 4 && j >= 1 && j <= 4)begin
					padding_map[i][j] = In_feature_map_1_reg[i - 1][j - 1] ;
				end
			end
		end
	padding_map[0][0] = In_feature_map_1_reg[0][0] & ({32{~Opt_reg[0]}});
	padding_map[0][5] = In_feature_map_1_reg[0][3] & ({32{~Opt_reg[0]}});
	padding_map[5][0] = In_feature_map_1_reg[3][0] & ({32{~Opt_reg[0]}});
	padding_map[5][5] = In_feature_map_1_reg[3][3] & ({32{~Opt_reg[0]}});
end
//======================================//
//                CNN                   //
//======================================//

always @(*) begin
    case(counter_reg)
        9 , 25, 41 , 57 , 73, 89:begin
            input_feature_map_comb[0][0] = padding_map[0][0];
            input_feature_map_comb[0][1] = padding_map[0][1];
            input_feature_map_comb[0][2] = padding_map[0][2];
            input_feature_map_comb[1][0] = padding_map[1][0];
            input_feature_map_comb[1][1] = padding_map[1][1];
            input_feature_map_comb[1][2] = padding_map[1][2];
            input_feature_map_comb[2][0] = padding_map[2][0];
            input_feature_map_comb[2][1] = padding_map[2][1];
            input_feature_map_comb[2][2] = padding_map[2][2];
        end
        10 , 26 , 42 , 58 , 74, 90:begin
            input_feature_map_comb[0][0] = padding_map[0][1];
            input_feature_map_comb[0][1] = padding_map[0][2];
            input_feature_map_comb[0][2] = padding_map[0][3];
            input_feature_map_comb[1][0] = padding_map[1][1];
            input_feature_map_comb[1][1] = padding_map[1][2];
            input_feature_map_comb[1][2] = padding_map[1][3];
            input_feature_map_comb[2][0] = padding_map[2][1];
            input_feature_map_comb[2][1] = padding_map[2][2];
            input_feature_map_comb[2][2] = padding_map[2][3]; 
        end
        11 , 27 , 43 , 59 , 75 , 91:begin
            input_feature_map_comb[0][0] = padding_map[0][2];
            input_feature_map_comb[0][1] = padding_map[0][3];
            input_feature_map_comb[0][2] = padding_map[0][4];
            input_feature_map_comb[1][0] = padding_map[1][2];
            input_feature_map_comb[1][1] = padding_map[1][3];
            input_feature_map_comb[1][2] = padding_map[1][4];
            input_feature_map_comb[2][0] = padding_map[2][2];
            input_feature_map_comb[2][1] = padding_map[2][3];
            input_feature_map_comb[2][2] = padding_map[2][4]; 
        end
        12 , 28 , 44 , 60 , 76 , 92:begin
            input_feature_map_comb[0][0] = padding_map[0][3];
            input_feature_map_comb[0][1] = padding_map[0][4];
            input_feature_map_comb[0][2] = padding_map[0][5];
            input_feature_map_comb[1][0] = padding_map[1][3];
            input_feature_map_comb[1][1] = padding_map[1][4];
            input_feature_map_comb[1][2] = padding_map[1][5];
            input_feature_map_comb[2][0] = padding_map[2][3];
            input_feature_map_comb[2][1] = padding_map[2][4];
            input_feature_map_comb[2][2] = padding_map[2][5];
        end
        13 , 29 , 45 , 61 , 77 , 93:begin
            input_feature_map_comb[0][0] = padding_map[1][0];
            input_feature_map_comb[0][1] = padding_map[1][1];
            input_feature_map_comb[0][2] = padding_map[1][2];
            input_feature_map_comb[1][0] = padding_map[2][0];
            input_feature_map_comb[1][1] = padding_map[2][1];
            input_feature_map_comb[1][2] = padding_map[2][2];
            input_feature_map_comb[2][0] = padding_map[3][0];
            input_feature_map_comb[2][1] = padding_map[3][1];
            input_feature_map_comb[2][2] = padding_map[3][2];      
        end
        14 , 30 , 46 , 62 , 78 , 94:begin
            input_feature_map_comb[0][0] = padding_map[1][1];
            input_feature_map_comb[0][1] = padding_map[1][2];
            input_feature_map_comb[0][2] = padding_map[1][3];
            input_feature_map_comb[1][0] = padding_map[2][1];
            input_feature_map_comb[1][1] = padding_map[2][2];
            input_feature_map_comb[1][2] = padding_map[2][3];
            input_feature_map_comb[2][0] = padding_map[3][1];
            input_feature_map_comb[2][1] = padding_map[3][2];
            input_feature_map_comb[2][2] = padding_map[3][3];
        end
        15 , 31 , 47 , 63 , 79 , 95:begin
            input_feature_map_comb[0][0] = padding_map[1][2];
            input_feature_map_comb[0][1] = padding_map[1][3];
            input_feature_map_comb[0][2] = padding_map[1][4];
            input_feature_map_comb[1][0] = padding_map[2][2];
            input_feature_map_comb[1][1] = padding_map[2][3];
            input_feature_map_comb[1][2] = padding_map[2][4];
            input_feature_map_comb[2][0] = padding_map[3][2];
            input_feature_map_comb[2][1] = padding_map[3][3];
            input_feature_map_comb[2][2] = padding_map[3][4];
        end
        16 , 32 , 48 , 64 , 80 , 96:begin
            input_feature_map_comb[0][0] = padding_map[1][3];
            input_feature_map_comb[0][1] = padding_map[1][4];
            input_feature_map_comb[0][2] = padding_map[1][5];
            input_feature_map_comb[1][0] = padding_map[2][3];
            input_feature_map_comb[1][1] = padding_map[2][4];
            input_feature_map_comb[1][2] = padding_map[2][5];
            input_feature_map_comb[2][0] = padding_map[3][3];
            input_feature_map_comb[2][1] = padding_map[3][4];
            input_feature_map_comb[2][2] = padding_map[3][5];
        end
        17 , 33 , 49 , 65 , 81 , 97:begin
            input_feature_map_comb[0][0] = padding_map[2][0];
            input_feature_map_comb[0][1] = padding_map[2][1];
            input_feature_map_comb[0][2] = padding_map[2][2];
            input_feature_map_comb[1][0] = padding_map[3][0];
            input_feature_map_comb[1][1] = padding_map[3][1];
            input_feature_map_comb[1][2] = padding_map[3][2];
            input_feature_map_comb[2][0] = padding_map[4][0];
            input_feature_map_comb[2][1] = padding_map[4][1];
            input_feature_map_comb[2][2] = padding_map[4][2];
        end
        18 , 34 , 50 , 66 , 82 , 98:begin
            input_feature_map_comb[0][0] = padding_map[2][1];
            input_feature_map_comb[0][1] = padding_map[2][2];
            input_feature_map_comb[0][2] = padding_map[2][3];
            input_feature_map_comb[1][0] = padding_map[3][1];
            input_feature_map_comb[1][1] = padding_map[3][2];
            input_feature_map_comb[1][2] = padding_map[3][3];
            input_feature_map_comb[2][0] = padding_map[4][1];
            input_feature_map_comb[2][1] = padding_map[4][2];
            input_feature_map_comb[2][2] = padding_map[4][3];
        end
        19 , 35 , 51 , 67 , 83 , 99:begin
            input_feature_map_comb[0][0] = padding_map[2][2];
            input_feature_map_comb[0][1] = padding_map[2][3];
            input_feature_map_comb[0][2] = padding_map[2][4];
            input_feature_map_comb[1][0] = padding_map[3][2];
            input_feature_map_comb[1][1] = padding_map[3][3];
            input_feature_map_comb[1][2] = padding_map[3][4];
            input_feature_map_comb[2][0] = padding_map[4][2];
            input_feature_map_comb[2][1] = padding_map[4][3];
            input_feature_map_comb[2][2] = padding_map[4][4];
        end
        20 , 36 , 52 , 68 , 84 , 100:begin
            input_feature_map_comb[0][0] = padding_map[2][3];
            input_feature_map_comb[0][1] = padding_map[2][4];
            input_feature_map_comb[0][2] = padding_map[2][5];
            input_feature_map_comb[1][0] = padding_map[3][3];
            input_feature_map_comb[1][1] = padding_map[3][4];
            input_feature_map_comb[1][2] = padding_map[3][5];
            input_feature_map_comb[2][0] = padding_map[4][3];
            input_feature_map_comb[2][1] = padding_map[4][4];
            input_feature_map_comb[2][2] = padding_map[4][5];
        end
        21 , 37 , 53 , 69 , 85 , 101:begin
            input_feature_map_comb[0][0] = padding_map[3][0];
            input_feature_map_comb[0][1] = padding_map[3][1];
            input_feature_map_comb[0][2] = padding_map[3][2];
            input_feature_map_comb[1][0] = padding_map[4][0];
            input_feature_map_comb[1][1] = padding_map[4][1];
            input_feature_map_comb[1][2] = padding_map[4][2];
            input_feature_map_comb[2][0] = padding_map[5][0];
            input_feature_map_comb[2][1] = padding_map[5][1];
            input_feature_map_comb[2][2] = padding_map[5][2];
        end
        22, 38 , 54 , 70 , 86 , 102:begin
            input_feature_map_comb[0][0] = padding_map[3][1];
            input_feature_map_comb[0][1] = padding_map[3][2];
            input_feature_map_comb[0][2] = padding_map[3][3];
            input_feature_map_comb[1][0] = padding_map[4][1];
            input_feature_map_comb[1][1] = padding_map[4][2];
            input_feature_map_comb[1][2] = padding_map[4][3];
            input_feature_map_comb[2][0] = padding_map[5][1];
            input_feature_map_comb[2][1] = padding_map[5][2];
            input_feature_map_comb[2][2] = padding_map[5][3];
        end
        23 , 39 , 55 , 71 , 87 , 103:begin
            input_feature_map_comb[0][0] = padding_map[3][2];
            input_feature_map_comb[0][1] = padding_map[3][3];
            input_feature_map_comb[0][2] = padding_map[3][4];
            input_feature_map_comb[1][0] = padding_map[4][2];
            input_feature_map_comb[1][1] = padding_map[4][3];
            input_feature_map_comb[1][2] = padding_map[4][4];
            input_feature_map_comb[2][0] = padding_map[5][2];
            input_feature_map_comb[2][1] = padding_map[5][3];
            input_feature_map_comb[2][2] = padding_map[5][4];
        end
        24 , 40 , 56 , 72 , 88 , 104:begin
            input_feature_map_comb[0][0] = padding_map[3][3];
            input_feature_map_comb[0][1] = padding_map[3][4];
            input_feature_map_comb[0][2] = padding_map[3][5];
            input_feature_map_comb[1][0] = padding_map[4][3];
            input_feature_map_comb[1][1] = padding_map[4][4];
            input_feature_map_comb[1][2] = padding_map[4][5];
            input_feature_map_comb[2][0] = padding_map[5][3];
            input_feature_map_comb[2][1] = padding_map[5][4];
            input_feature_map_comb[2][2] = padding_map[5][5];
        end
        default:begin
            input_feature_map_comb[0][0] = input_feature_map_dff[0][0];// for power spreading// for JG
            input_feature_map_comb[0][1] = input_feature_map_dff[0][1];
            input_feature_map_comb[0][2] = input_feature_map_dff[0][2];
            input_feature_map_comb[1][0] = input_feature_map_dff[1][0];
            input_feature_map_comb[1][1] = input_feature_map_dff[1][1];
            input_feature_map_comb[1][2] = input_feature_map_dff[1][2];
            input_feature_map_comb[2][0] = input_feature_map_dff[2][0];
            input_feature_map_comb[2][1] = input_feature_map_dff[2][1];
            input_feature_map_comb[2][2] = input_feature_map_dff[2][2];
        end
    endcase
end

wire input_feature_map_CG;
GATED_OR GATED_6(.CLOCK(clk), .SLEEP_CTRL((counter_reg < 9 || counter_reg > 104) & cg_en), .RST_N(rst_n), .CLOCK_GATED(input_feature_map_CG));
always @(posedge input_feature_map_CG or negedge rst_n) begin
	if(!rst_n)begin
		for(i = 0; i < 3; i = i + 1)begin
			for(j = 0; j < 3; j = j + 1)begin
				input_feature_map_dff[i][j] <= 0;
			end
		end
	end
	else begin
		for(i = 0; i < 3; i = i + 1)begin
			for(j = 0; j < 3; j = j + 1)begin
				input_feature_map_dff[i][j] <= input_feature_map_comb[i][j];
			end
		end
	end
end
reg [31:0] Kernel_CNN_comb[0:2][0:2];

always@(*)begin
	if(counter_reg < 9)begin// for JG
		for(i = 0; i < 3; i = i + 1)begin
			for(j = 0;j < 3; j = j + 1)begin
				Kernel_CNN_comb[i][j] = Kernel_CNN[i][j];
			end
		end
	end
	else if(counter_reg <= 24 || (counter_reg >= 57 && counter_reg <= 72))begin
		for(i = 0; i < 3; i = i + 1)begin
			for(j = 0;j < 3; j = j + 1)begin
				Kernel_CNN_comb[i][j] = Kernel_1_reg[i][j];
			end
		end
	end
	else if(counter_reg <= 40 || (counter_reg >= 73 && counter_reg <= 88))begin
		for(i = 0; i < 3; i = i + 1)begin
			for(j = 0;j < 3; j = j + 1)begin
				Kernel_CNN_comb[i][j] = Kernel_2_reg[i][j];
			end
		end
	end
	else begin
		for(i = 0; i < 3; i = i + 1)begin
			for(j = 0;j < 3; j = j + 1)begin
				Kernel_CNN_comb[i][j] = Kernel_3_reg[i][j];
			end
		end
	end
end
wire CNN_kernel_map_CG;
GATED_OR GATED_7(.CLOCK(clk), .SLEEP_CTRL((counter_reg != 9 && counter_reg != 25 && counter_reg != 41 && counter_reg != 57 && counter_reg != 73 && counter_reg != 89) & cg_en), .RST_N(rst_n), .CLOCK_GATED(CNN_kernel_map_CG));
always @(posedge CNN_kernel_map_CG or negedge rst_n) begin
	if(!rst_n)begin
		for(i = 0; i < 3; i = i + 1)begin
			for(j = 0; j < 3; j = j + 1)begin
				Kernel_CNN[i][j] <= 0;
			end
		end
	end
	else begin
		for(i = 0; i < 3; i = i + 1)begin
			for(j = 0; j < 3; j = j + 1)begin
				Kernel_CNN[i][j] <= Kernel_CNN_comb[i][j];
			end
		end
	end
end
//=============================================//
//                CNN module call              //
//=============================================//
wire CNN_CG;

GATED_OR GATED_9(.CLOCK(clk), .SLEEP_CTRL((counter_reg < 10 || counter_reg > 105) & cg_en), .RST_N(rst_n), .CLOCK_GATED(CNN_CG));
CNN C1(.Image1(input_feature_map_dff[0][0]), .filter1(Kernel_CNN[0][0]),
		.Image2(input_feature_map_dff[0][1]), .filter2(Kernel_CNN[0][1]),
		.Image3(input_feature_map_dff[0][2]), .filter3(Kernel_CNN[0][2]),
		.Image4(input_feature_map_dff[1][0]), .filter4(Kernel_CNN[1][0]),
		.Image5(input_feature_map_dff[1][1]), .filter5(Kernel_CNN[1][1]),
		.Image6(input_feature_map_dff[1][2]), .filter6(Kernel_CNN[1][2]),
		.Image7(input_feature_map_dff[2][0]), .filter7(Kernel_CNN[2][0]),
		.Image8(input_feature_map_dff[2][1]), .filter8(Kernel_CNN[2][1]),
		.Image9(input_feature_map_dff[2][2]), .filter9(Kernel_CNN[2][2]),
		.clk(CNN_CG), .rst_n(rst_n), .out(CNN_out)
);
//=================================================//
//             convolution outcome DFF             //
//=================================================//
wire conv_CG;
GATED_OR GATED_10(.CLOCK(clk), .SLEEP_CTRL(((counter_reg < 11 || (counter_reg > 106 && counter_reg != 124))) & cg_en), .RST_N(rst_n), .CLOCK_GATED(conv_CG));
always@(posedge clk or negedge rst_n)begin//timing violation//03_fail
	if(!rst_n)begin
		for(i = 0; i < 4; i = i + 1)begin
			for(j = 0; j < 4; j = j + 1)begin
				Convolution_out1_reg[i][j] <= 0;
				//Convolution_out2_reg[i][j] <= 0;
			end
		end
	end
	else begin
		for(i = 0; i < 4; i = i + 1)begin
			for(j = 0 ; j < 4 ; j = j + 1)begin
				Convolution_out1_reg[i][j] <= Convolution_out1_comb[i][j];
				//Convolution_out2_reg[i][j] <= Convolution_out2_comb[i][j];
			end
		end
	end
end
//==========================================================//
//                convolution adder & mux                   //
//==========================================================//
always @(*) begin
	CNN_adder_input = CNN_adder_input_reg;
	case(counter_reg)
		10 , 26 , 42, 58, 74, 90 : CNN_adder_input = Convolution_out1_reg[0][0];
		11 , 27 , 43, 59, 75, 91 : CNN_adder_input = Convolution_out1_reg[0][1];
		12 , 28 , 44, 60, 76, 92 : CNN_adder_input = Convolution_out1_reg[0][2];
		13 , 29 , 45, 61, 77, 93 : CNN_adder_input = Convolution_out1_reg[0][3];
		14 , 30 , 46, 62, 78, 94 : CNN_adder_input = Convolution_out1_reg[1][0];
		15 , 31 , 47, 63, 79, 95 : CNN_adder_input = Convolution_out1_reg[1][1];
		16 , 32 , 48, 64, 80, 96 : CNN_adder_input = Convolution_out1_reg[1][2];
		17 , 33 , 49, 65, 81, 97 : CNN_adder_input = Convolution_out1_reg[1][3];
		18 , 34 , 50, 66, 82, 98 : CNN_adder_input = Convolution_out1_reg[2][0];
		19 , 35 , 51, 67, 83, 99 : CNN_adder_input = Convolution_out1_reg[2][1];
		20 , 36 , 52, 68, 84, 100 : CNN_adder_input = Convolution_out1_reg[2][2];
		21 , 37 , 53, 69, 85, 101 : CNN_adder_input = Convolution_out1_reg[2][3];
		22 , 38 , 54, 70, 86, 102 : CNN_adder_input = Convolution_out1_reg[3][0];
		23 , 39 , 55, 71, 87, 103 : CNN_adder_input = Convolution_out1_reg[3][1];
		24 , 40 , 56, 72, 88, 104 : CNN_adder_input = Convolution_out1_reg[3][2];
		25 , 41 , 57, 73, 89, 105 : CNN_adder_input = Convolution_out1_reg[3][3];
		
	endcase
end
wire CNN_adder_CG;
GATED_OR GATED_11(.CLOCK(clk), .SLEEP_CTRL((counter_reg < 10 || counter_reg > 105) & cg_en), .RST_N(rst_n), .CLOCK_GATED(CNN_adder_CG));
always @(posedge CNN_adder_CG or negedge rst_n) begin//03_fail
	if(!rst_n)begin
		CNN_adder_input_reg <= 0;
	end
	else begin
		CNN_adder_input_reg <= CNN_adder_input;
	end
end
//=====================================================//
//                    CNN adder                        //
//=====================================================//
DW_fp_add_inst add(.inst_a(CNN_adder_input_reg), .inst_b(CNN_out), .inst_rnd(0), .z_inst(CNN_adder_output));
always@(*)begin
	if(out_valid == 1)begin
		for(i = 0; i < 4; i = i + 1)begin
			for(j = 0 ; j < 4 ; j = j + 1)begin
				Convolution_out1_comb[i][j] = 0;
				//Convolution_out2_comb[i][j] = 0;
			end
		end
	end
	else begin
		for(i = 0; i < 4; i = i + 1)begin
			for(j = 0 ; j < 4 ; j = j + 1)begin
				Convolution_out1_comb[i][j] = Convolution_out1_reg[i][j];
				//Convolution_out2_comb[i][j] = Convolution_out2_reg[i][j];
			end
		end
		case(counter_reg)
			11, 27, 43, 75, 91 :Convolution_out1_comb[0][0] = CNN_adder_output;
			12, 28, 44, 76, 92 :Convolution_out1_comb[0][1] = CNN_adder_output;
			13, 29, 45, 77, 93 :Convolution_out1_comb[0][2] = CNN_adder_output;
			14, 30, 46, 78, 94 :Convolution_out1_comb[0][3] = CNN_adder_output;
			15, 31, 47, 79, 95 :Convolution_out1_comb[1][0] = CNN_adder_output;
			16, 32, 48, 80, 96 :Convolution_out1_comb[1][1] = CNN_adder_output;
			17, 33, 49, 81, 97 :Convolution_out1_comb[1][2] = CNN_adder_output;
			18, 34, 50, 82, 98 :Convolution_out1_comb[1][3] = CNN_adder_output;
			19, 35, 51, 83, 99 :Convolution_out1_comb[2][0] = CNN_adder_output;
			20, 36, 52, 84, 100:Convolution_out1_comb[2][1] = CNN_adder_output;
			21, 37, 53, 85, 101:Convolution_out1_comb[2][2] = CNN_adder_output;
			22, 38, 54, 86, 102:Convolution_out1_comb[2][3] = CNN_adder_output;
			23, 39, 55, 87, 103:Convolution_out1_comb[3][0] = CNN_adder_output;
			24, 40, 56, 88, 104:Convolution_out1_comb[3][1] = CNN_adder_output;
			25, 41, 57, 89, 105:Convolution_out1_comb[3][2] = CNN_adder_output;
			26, 42, 58, 90, 106:Convolution_out1_comb[3][3] = CNN_adder_output;

			59:Convolution_out1_comb[0][0] = CNN_out;
			60:Convolution_out1_comb[0][1] = CNN_out;
			61:Convolution_out1_comb[0][2] = CNN_out;
			62:Convolution_out1_comb[0][3] = CNN_out;
			63:Convolution_out1_comb[1][0] = CNN_out;
			64:Convolution_out1_comb[1][1] = CNN_out;
			65:Convolution_out1_comb[1][2] = CNN_out;
			66:Convolution_out1_comb[1][3] = CNN_out;
			67:Convolution_out1_comb[2][0] = CNN_out;
			68:Convolution_out1_comb[2][1] = CNN_out;
			69:Convolution_out1_comb[2][2] = CNN_out;
			70:Convolution_out1_comb[2][3] = CNN_out;
			71:Convolution_out1_comb[3][0] = CNN_out;
			72:Convolution_out1_comb[3][1] = CNN_out;
			73:Convolution_out1_comb[3][2] = CNN_out;
			74:Convolution_out1_comb[3][3] = CNN_out;

		endcase
	
	end	
end
//====================================================//
//                   Equalizer                        //
//====================================================//
reg [31:0] E_sum3_in  [0:2][0:2];
reg [31:0] E_sum3_out [0:2];
reg [31:0] E_div_in;
reg [31:0] E_div_in_reg;
reg [31:0] E_div_out;
reg [31:0] E_div_out_reg;
wire E_div_out_clk;//jg run very long might fail
GATED_OR GATED_12(.CLOCK(clk), .SLEEP_CTRL(((counter_reg < 50 || counter_reg > 65) && (counter_reg < 98 || counter_reg > 113)) & cg_en), .RST_N(rst_n), .CLOCK_GATED(E_div_out_clk));
always @(posedge E_div_out_clk or negedge rst_n) begin
    if(!rst_n)begin
        E_div_out_reg <= 0;
        
    end
    else begin
        E_div_out_reg <= E_div_out;
        
    end
end
wire E_div_in_clk;//jg run very long might fail
GATED_OR GATED_13(.CLOCK(clk), .SLEEP_CTRL(((counter_reg < 49 || counter_reg > 64) && (counter_reg < 97 || counter_reg > 112)) & cg_en), .RST_N(rst_n), .CLOCK_GATED(E_div_in_clk));
always @(posedge E_div_in_clk or negedge rst_n) begin // DFF before divide //here before syn
    if(!rst_n)begin
        E_div_in_reg <= 0;
    end
    else begin
		if((counter_reg >= 49 && counter_reg <= 64) || (counter_reg >= 97 && counter_reg <= 112))
        	E_div_in_reg <= E_div_in;
		else 
			E_div_in_reg <= {counter_reg,counter_reg,counter_reg,counter_reg};
    end
end

always @(*) begin
	for(i = 0; i < 6; i = i + 1)begin
			for(j = 0 ; j < 6; j = j + 1)begin
				if(i == 0 && j > 0 && j < 5)begin
					Equalizer_in[i][j] = Convolution_out1_reg[0][j - 1] & ({32{~Opt_reg[0]}});
				end
				else if(i == 5 && j > 0 && j < 5)begin
					Equalizer_in[i][j] = Convolution_out1_reg[3][j - 1] & ({32{~Opt_reg[0]}});
				end
				else if(j == 0 && i > 0 && i < 5)begin
					Equalizer_in[i][j] = Convolution_out1_reg[i -1][0] & ({32{~Opt_reg[0]}});
				end
				else if(j == 5 && i > 0 && i < 5)begin
					Equalizer_in[i][j] = Convolution_out1_reg[i - 1][3] & ({32{~Opt_reg[0]}});
				end
				else if(i >= 1 && i <= 4 && j >= 1 && j <= 4)begin
					Equalizer_in[i][j] = Convolution_out1_reg[i - 1][j - 1] ;
				end
			end
		end
	Equalizer_in[0][0] = Convolution_out1_reg[0][0] & ({32{~Opt_reg[0]}});
	Equalizer_in[0][5] = Convolution_out1_reg[0][3] & ({32{~Opt_reg[0]}});
	Equalizer_in[5][0] = Convolution_out1_reg[3][0] & ({32{~Opt_reg[0]}});
	Equalizer_in[5][5] = Convolution_out1_reg[3][3] & ({32{~Opt_reg[0]}});
end
//DW_fp_sum3_inst E1(.inst_a(Equalizer_in[0][0]), .inst_b(Equalizer_in[0][1]), .inst_c(Equalizer_in[0][2]), inst_rnd(1'b0), .z_inst());
//reg [31:0] E_sum3 [0:3][0:3][0:2];

always @(*) begin
    for(i = 0; i < 3; i = i + 1)begin
        for(j = 0; j < 3; j = j + 1)
            E_sum3_in[i][j] = Equalizer_in[i][j];
    end
    case(counter_reg)
        49, 97:begin
            for(i = 0; i < 3; i = i + 1)begin
                for(j = 0; j < 3; j = j + 1)begin
                    E_sum3_in[i][j] = Equalizer_in[i][j];
                end
            end
        end
        50, 98:begin
            for(i = 0; i < 3; i = i + 1)begin
                for(j = 0 ; j < 3; j = j + 1)begin
                    E_sum3_in[i][j] = Equalizer_in[i][j + 1];
                end
            end
        end
        51, 99:begin
            for(i = 0; i < 3; i = i + 1)begin
                for(j = 0; j < 3; j = j + 1)begin
                    E_sum3_in[i][j] = Equalizer_in[i][j + 2];
                end
            end
        end
        52, 100:begin
            for(i = 0; i < 3; i = i + 1)begin
                for(j = 0; j < 3; j = j + 1)begin
                    E_sum3_in[i][j] = Equalizer_in[i][j + 3];
                end
            end
        end
        53, 101:begin
            for(i = 0; i < 3; i = i + 1)begin
                for(j = 0 ;j < 3; j = j + 1)begin
                    E_sum3_in[i][j] = Equalizer_in[i + 1][j];
                end
            end
        end
        54, 102:begin
            for(i = 0; i < 3; i = i + 1)begin
                for(j = 0; j < 3; j = j + 1)begin
                    E_sum3_in[i][j] = Equalizer_in[i + 1][j + 1];
                end
            end
        end
        55, 103:begin
            for(i = 0; i < 3; i = i + 1)begin
                for(j = 0; j < 3; j = j + 1)begin
                    E_sum3_in[i][j] = Equalizer_in[i + 1][j + 2];
                end
            end
        end
        56, 104:begin
            for( i = 0; i < 3; i = i + 1)begin
                for(j = 0; j < 3; j = j + 1)begin
                    E_sum3_in[i][j] = Equalizer_in[i + 1][j + 3];
                end
            end
        end
        57, 105:begin
            for(i = 0; i < 3; i = i + 1)begin
                for(j = 0; j < 3; j = j + 1)begin
                    E_sum3_in[i][j] = Equalizer_in[i + 2][j];
                end
            end
        end
        58, 106:begin
            for(i = 0; i < 3 ;i = i + 1)begin
                for(j = 0; j < 3; j = j + 1)begin
                    E_sum3_in[i][j] = Equalizer_in[i + 2][j + 1];
                end
            end
        end
        59, 107:begin
            for(i = 0; i < 3; i = i + 1)begin
                for(j = 0; j < 3; j = j + 1)begin
                    E_sum3_in[i][j] =  Equalizer_in[i + 2][j + 2];
                end
            end
        end
        60, 108:begin
            for(i = 0; i < 3; i = i + 1)begin
                for(j = 0; j < 3; j = j + 1)begin
                    E_sum3_in[i][j] = Equalizer_in[i + 2][j + 3];
                end
            end
        end
        61, 109:begin
            for(i = 0; i < 3 ; i= i + 1)begin
                for(j = 0; j < 3; j = j + 1)begin
                    E_sum3_in[i][j] = Equalizer_in[i + 3][j];
                end
            end
        end
        62, 110:begin
            for(i = 0; i < 3; i = i + 1)begin
                for(j = 0; j < 3; j = j + 1)begin
                    E_sum3_in[i][j] = Equalizer_in[i + 3][j + 1];
                end
            end
        end
        63, 111:begin
            for (i = 0; i < 3;i = i + 1 ) begin
                for (j = 0; j < 3; j = j + 1 ) begin
                    E_sum3_in[i][j] = Equalizer_in[i + 3][j + 2];
                end
            end
        end
        64, 112:begin
            for (i = 0; i < 3 ;i = i + 1) begin
                for(j = 0; j < 3; j = j + 1)begin
                    E_sum3_in[i][j] = Equalizer_in[i + 3][j + 3];
                end
            end
        end
    endcase
end
// generate
//     for(a = 0; a < 4; a = a + 1)begin
//         for(b = 0; b < 4; b = b + 1)begin
//             DW_fp_sum3_inst E1(.inst_a(Equalizer_in[a][b]), .inst_b(Equalizer_in[a][b + 1]), .inst_c(Equalizer_in[a][b + 2]), .inst_rnd(0), .z_inst(E_sum3[a][b][0]));
//             DW_fp_sum3_inst E2(.inst_a(Equalizer_in[a + 1][b]), .inst_b(Equalizer_in[a + 1][b + 1]), .inst_c(Equalizer_in[a + 1][b + 2]), .inst_rnd(0), .z_inst(E_sum3[a][b][1]));
//             DW_fp_sum3_inst E3(.inst_a(Equalizer_in[a + 2][b]), .inst_b(Equalizer_in[a + 2][b + 1]), .inst_c(Equalizer_in[a + 2][b + 2]), .inst_rnd(0), .z_inst(E_sum3[a][b][2]));
//             DW_fp_sum3_inst E4(.inst_a(E_sum3[a][b][0]), .inst_b(E_sum3[a][b][1]), .inst_c(E_sum3[a][b][2]), .inst_rnd(0), .z_inst(Equalizer_out_div[a][b]));
//             DW_fp_div_inst E5(.inst_a(Equalizer_out_div_reg[a][b]), .inst_b(32'h4110_0000), .inst_rnd(0), .z_inst(Equalizer_out[a][b]));
//         end
//     end
// endgenerate
DW_fp_sum3_inst E1(.inst_a(E_sum3_in[0][0]), .inst_b(E_sum3_in[0][1]), .inst_c(E_sum3_in[0][2]), .inst_rnd(0), .z_inst(E_sum3_out[0]));
DW_fp_sum3_inst E2(.inst_a(E_sum3_in[1][0]), .inst_b(E_sum3_in[1][1]), .inst_c(E_sum3_in[1][2]), .inst_rnd(0), .z_inst(E_sum3_out[1]));
DW_fp_sum3_inst E3(.inst_a(E_sum3_in[2][0]), .inst_b(E_sum3_in[2][1]), .inst_c(E_sum3_in[2][2]), .inst_rnd(0), .z_inst(E_sum3_out[2]));
DW_fp_sum3_inst E4(.inst_a(E_sum3_out[0]), .inst_b(E_sum3_out[1]), .inst_c(E_sum3_out[2]), .inst_rnd(0), .z_inst(E_div_in));

DW_fp_div_inst E5(.inst_a(E_div_in_reg), .inst_b(32'h4110_0000), .inst_rnd(0), .z_inst(E_div_out));
//====================================================//
//                  max pooling                       //
//====================================================//
reg [31:0] Max_pool_in_reg [0:3][0:3];
wire E_Max_in_clk;//timing violation 
GATED_OR GATED_14(.CLOCK(clk), .SLEEP_CTRL(((counter_reg < 48 || counter_reg > 68) && (counter_reg < 97 || counter_reg > 116)) & cg_en), .RST_N(rst_n), .CLOCK_GATED(E_Max_in_clk));
always @(posedge clk or negedge rst_n) begin // timing violation
    if(!rst_n)begin
        for(i = 0; i < 4; i = i + 1)begin
            for(j = 0; j < 4; j = j + 1)begin
                Max_pool_in_reg[i][j] <= 0;
            end
        end
    end
    else begin
        for(i = 0; i < 4; i = i + 1)begin
            for(j = 0; j < 4; j = j + 1)begin
                Max_pool_in_reg[i][j] <= Max_pool_in[i][j];
            end
        end
    end
end
always@(*)begin
	
    // for(i = 0; i < 4;i = i + 1)begin//here
    //     for(j = 0; j < 4; j = j + 1)begin
    //         Max_pool_in[i][j] = Max_pool_in_reg[i][j];//for power spreading
    //     end
    // end
    // case(counter_reg)
    //     51, 99:Max_pool_in[0][0] = E_div_out_reg;
    //     52, 100:Max_pool_in[0][1] = E_div_out_reg;
    //     53, 101:Max_pool_in[0][2] = E_div_out_reg;
    //     54, 102:Max_pool_in[0][3] = E_div_out_reg;
    //     55, 103:Max_pool_in[1][0] = E_div_out_reg;
    //     56, 104:Max_pool_in[1][1] = E_div_out_reg;
    //     57, 105:Max_pool_in[1][2] = E_div_out_reg;
    //     58, 106:Max_pool_in[1][3] = E_div_out_reg;
    //     59, 107:Max_pool_in[2][0] = E_div_out_reg;
    //     60, 108:Max_pool_in[2][1] = E_div_out_reg;
    //     61, 109:Max_pool_in[2][2] = E_div_out_reg;
    //     62, 110:Max_pool_in[2][3] = E_div_out_reg;
    //     63, 111:Max_pool_in[3][0] = E_div_out_reg;
    //     64, 112:Max_pool_in[3][1] = E_div_out_reg;
    //     65, 113:Max_pool_in[3][2] = E_div_out_reg;
    //     66, 114:Max_pool_in[3][3] = E_div_out_reg;  
    // endcase
	for(i = 0; i < 4;i = i + 1)begin
        for(j = 0; j < 4; j = j + 1)begin
            Max_pool_in[i][j] = E_div_out_reg;//for power spreading
        end
    end
	case(counter_reg)
        52, 100:Max_pool_in[0][0] = Max_pool_in_reg[0][0];
        53, 101:begin 
			Max_pool_in[0][0] = Max_pool_in_reg[0][0];
			Max_pool_in[0][1] = Max_pool_in_reg[0][1];
		end
        54, 102:begin 
			Max_pool_in[0][0] = Max_pool_in_reg[0][0];
			Max_pool_in[0][1] = Max_pool_in_reg[0][1];
			Max_pool_in[0][2] = Max_pool_in_reg[0][2];
		end
		55, 103:begin
			Max_pool_in[0][0] = Max_pool_in_reg[0][0];
			Max_pool_in[0][1] = Max_pool_in_reg[0][1];
			Max_pool_in[0][2] = Max_pool_in_reg[0][2];
			Max_pool_in[0][3] = Max_pool_in_reg[0][3];
		end
		56, 104:begin
			Max_pool_in[0][0] = Max_pool_in_reg[0][0];
			Max_pool_in[0][1] = Max_pool_in_reg[0][1];
			Max_pool_in[0][2] = Max_pool_in_reg[0][2];
			Max_pool_in[0][3] = Max_pool_in_reg[0][3];
			Max_pool_in[1][0] = Max_pool_in_reg[1][0];
		end
		57, 105:begin 
			Max_pool_in[0][0] = Max_pool_in_reg[0][0];
			Max_pool_in[0][1] = Max_pool_in_reg[0][1];
			Max_pool_in[0][2] = Max_pool_in_reg[0][2];
			Max_pool_in[0][3] = Max_pool_in_reg[0][3];
			Max_pool_in[1][0] = Max_pool_in_reg[1][0];
			Max_pool_in[1][1] = Max_pool_in_reg[1][1];
		end
		58, 106:begin 
			Max_pool_in[0][0] = Max_pool_in_reg[0][0];
			Max_pool_in[0][1] = Max_pool_in_reg[0][1];
			Max_pool_in[0][2] = Max_pool_in_reg[0][2];
			Max_pool_in[0][3] = Max_pool_in_reg[0][3];
			Max_pool_in[1][0] = Max_pool_in_reg[1][0];
			Max_pool_in[1][1] = Max_pool_in_reg[1][1];
			Max_pool_in[1][2] = Max_pool_in_reg[1][2];
		end
		59, 107:begin 
			Max_pool_in[0][0] = Max_pool_in_reg[0][0];
			Max_pool_in[0][1] = Max_pool_in_reg[0][1];
			Max_pool_in[0][2] = Max_pool_in_reg[0][2];
			Max_pool_in[0][3] = Max_pool_in_reg[0][3];
			Max_pool_in[1][0] = Max_pool_in_reg[1][0];
			Max_pool_in[1][1] = Max_pool_in_reg[1][1];
			Max_pool_in[1][2] = Max_pool_in_reg[1][2];
			Max_pool_in[1][3] = Max_pool_in_reg[1][3];
		end
		60, 108:begin 
			Max_pool_in[0][0] = Max_pool_in_reg[0][0];
			Max_pool_in[0][1] = Max_pool_in_reg[0][1];
			Max_pool_in[0][2] = Max_pool_in_reg[0][2];
			Max_pool_in[0][3] = Max_pool_in_reg[0][3];
			Max_pool_in[1][0] = Max_pool_in_reg[1][0];
			Max_pool_in[1][1] = Max_pool_in_reg[1][1];
			Max_pool_in[1][2] = Max_pool_in_reg[1][2];
			Max_pool_in[1][3] = Max_pool_in_reg[1][3];
			Max_pool_in[2][0] = Max_pool_in_reg[2][0];
		end
		61, 109:begin 
			Max_pool_in[0][0] = Max_pool_in_reg[0][0];
			Max_pool_in[0][1] = Max_pool_in_reg[0][1];
			Max_pool_in[0][2] = Max_pool_in_reg[0][2];
			Max_pool_in[0][3] = Max_pool_in_reg[0][3];
			Max_pool_in[1][0] = Max_pool_in_reg[1][0];
			Max_pool_in[1][1] = Max_pool_in_reg[1][1];
			Max_pool_in[1][2] = Max_pool_in_reg[1][2];
			Max_pool_in[1][3] = Max_pool_in_reg[1][3];
			Max_pool_in[2][0] = Max_pool_in_reg[2][0];
			Max_pool_in[2][1] = Max_pool_in_reg[2][1];
		end
		62, 110:begin
			Max_pool_in[0][0] = Max_pool_in_reg[0][0];
			Max_pool_in[0][1] = Max_pool_in_reg[0][1];
			Max_pool_in[0][2] = Max_pool_in_reg[0][2];
			Max_pool_in[0][3] = Max_pool_in_reg[0][3];
			Max_pool_in[1][0] = Max_pool_in_reg[1][0];
			Max_pool_in[1][1] = Max_pool_in_reg[1][1];
			Max_pool_in[1][2] = Max_pool_in_reg[1][2];
			Max_pool_in[1][3] = Max_pool_in_reg[1][3];
			Max_pool_in[2][0] = Max_pool_in_reg[2][0];
			Max_pool_in[2][1] = Max_pool_in_reg[2][1];
			Max_pool_in[2][2] = Max_pool_in_reg[2][2];
		end
		63, 111:begin 
			Max_pool_in[0][0] = Max_pool_in_reg[0][0];
			Max_pool_in[0][1] = Max_pool_in_reg[0][1];
			Max_pool_in[0][2] = Max_pool_in_reg[0][2];
			Max_pool_in[0][3] = Max_pool_in_reg[0][3];
			Max_pool_in[1][0] = Max_pool_in_reg[1][0];
			Max_pool_in[1][1] = Max_pool_in_reg[1][1];
			Max_pool_in[1][2] = Max_pool_in_reg[1][2];
			Max_pool_in[1][3] = Max_pool_in_reg[1][3];
			Max_pool_in[2][0] = Max_pool_in_reg[2][0];
			Max_pool_in[2][1] = Max_pool_in_reg[2][1];
			Max_pool_in[2][2] = Max_pool_in_reg[2][2];
			Max_pool_in[2][3] = Max_pool_in_reg[2][3];
		end
		64, 112:begin 
			Max_pool_in[0][0] = Max_pool_in_reg[0][0];
			Max_pool_in[0][1] = Max_pool_in_reg[0][1];
			Max_pool_in[0][2] = Max_pool_in_reg[0][2];
			Max_pool_in[0][3] = Max_pool_in_reg[0][3];
			Max_pool_in[1][0] = Max_pool_in_reg[1][0];
			Max_pool_in[1][1] = Max_pool_in_reg[1][1];
			Max_pool_in[1][2] = Max_pool_in_reg[1][2];
			Max_pool_in[1][3] = Max_pool_in_reg[1][3];
			Max_pool_in[2][0] = Max_pool_in_reg[2][0];
			Max_pool_in[2][1] = Max_pool_in_reg[2][1];
			Max_pool_in[2][2] = Max_pool_in_reg[2][2];
			Max_pool_in[2][3] = Max_pool_in_reg[2][3];
			Max_pool_in[3][0] = Max_pool_in_reg[3][0];
		end
		65, 113:begin
			Max_pool_in[0][0] = Max_pool_in_reg[0][0];
			Max_pool_in[0][1] = Max_pool_in_reg[0][1];
			Max_pool_in[0][2] = Max_pool_in_reg[0][2];
			Max_pool_in[0][3] = Max_pool_in_reg[0][3];
			Max_pool_in[1][0] = Max_pool_in_reg[1][0];
			Max_pool_in[1][1] = Max_pool_in_reg[1][1];
			Max_pool_in[1][2] = Max_pool_in_reg[1][2];
			Max_pool_in[1][3] = Max_pool_in_reg[1][3];
			Max_pool_in[2][0] = Max_pool_in_reg[2][0];
			Max_pool_in[2][1] = Max_pool_in_reg[2][1];
			Max_pool_in[2][2] = Max_pool_in_reg[2][2];
			Max_pool_in[2][3] = Max_pool_in_reg[2][3];
			Max_pool_in[3][0] = Max_pool_in_reg[3][0]; 
			Max_pool_in[3][1] = Max_pool_in_reg[3][1];
		end
		66, 114:begin 
			Max_pool_in[0][0] = Max_pool_in_reg[0][0];
			Max_pool_in[0][1] = Max_pool_in_reg[0][1];
			Max_pool_in[0][2] = Max_pool_in_reg[0][2];
			Max_pool_in[0][3] = Max_pool_in_reg[0][3];
			Max_pool_in[1][0] = Max_pool_in_reg[1][0];
			Max_pool_in[1][1] = Max_pool_in_reg[1][1];
			Max_pool_in[1][2] = Max_pool_in_reg[1][2];
			Max_pool_in[1][3] = Max_pool_in_reg[1][3];
			Max_pool_in[2][0] = Max_pool_in_reg[2][0];
			Max_pool_in[2][1] = Max_pool_in_reg[2][1];
			Max_pool_in[2][2] = Max_pool_in_reg[2][2];
			Max_pool_in[2][3] = Max_pool_in_reg[2][3];
			Max_pool_in[3][0] = Max_pool_in_reg[3][0]; 
			Max_pool_in[3][1] = Max_pool_in_reg[3][1];
			Max_pool_in[3][2] = Max_pool_in_reg[3][2];
		end
		67, 115:begin 
			Max_pool_in[0][0] = Max_pool_in_reg[0][0];
			Max_pool_in[0][1] = Max_pool_in_reg[0][1];
			Max_pool_in[0][2] = Max_pool_in_reg[0][2];
			Max_pool_in[0][3] = Max_pool_in_reg[0][3];
			Max_pool_in[1][0] = Max_pool_in_reg[1][0];
			Max_pool_in[1][1] = Max_pool_in_reg[1][1];
			Max_pool_in[1][2] = Max_pool_in_reg[1][2];
			Max_pool_in[1][3] = Max_pool_in_reg[1][3];
			Max_pool_in[2][0] = Max_pool_in_reg[2][0];
			Max_pool_in[2][1] = Max_pool_in_reg[2][1];
			Max_pool_in[2][2] = Max_pool_in_reg[2][2];
			Max_pool_in[2][3] = Max_pool_in_reg[2][3];
			Max_pool_in[3][0] = Max_pool_in_reg[3][0]; 
			Max_pool_in[3][1] = Max_pool_in_reg[3][1];
			Max_pool_in[3][2] = Max_pool_in_reg[3][2];
			Max_pool_in[3][3] = Max_pool_in_reg[3][3];  
		end
    endcase
end
generate
for(a = 0; a < 2; a = a + 1)begin
	for(b = 0; b < 2; b = b + 1)begin
		DW_fp_cmp_inst d1(.inst_a(Max_pool_in[a * 2][b * 2]), .inst_b(Max_pool_in[a * 2][b * 2 + 1]), .inst_zctr(0), .z1_inst(for_max_1[a][b][0]));
		DW_fp_cmp_inst d2(.inst_a(Max_pool_in[a * 2 + 1][b * 2]), .inst_b(Max_pool_in[a * 2 + 1][b * 2 + 1]), .inst_zctr(0), .z1_inst(for_max_1[a][b][1]));
		DW_fp_cmp_inst d3(.inst_a(for_max_1[a][b][0]), .inst_b(for_max_1[a][b][1]), .inst_zctr(0), .z1_inst(Max_pool_out[a][b]));
	end
end
endgenerate
//====================================//
//             FC                     //
//====================================//
wire [31:0] fc_mul_out [0:7];
// DW_fp_dp2_inst Dp1_1(.inst_a(Max_pool_out[0][0]), .inst_b(In_weight_reg[0][0]), .inst_c(Max_pool_out[0][1]), .inst_d(In_weight_reg[1][0]), .inst_rnd(0), .z_inst(fc_out[0]));
// DW_fp_dp2_inst Dp1_2(.inst_a(Max_pool_out[0][0]), .inst_b(In_weight_reg[0][1]), .inst_c(Max_pool_out[0][1]), .inst_d(In_weight_reg[1][1]), .inst_rnd(0), .z_inst(fc_out[1]));
// DW_fp_dp2_inst Dp1_3(.inst_a(Max_pool_out[1][0]), .inst_b(In_weight_reg[0][0]), .inst_c(Max_pool_out[1][1]), .inst_d(In_weight_reg[1][0]), .inst_rnd(0), .z_inst(fc_out[2]));
// DW_fp_dp2_inst Dp1_4(.inst_a(Max_pool_out[1][0]), .inst_b(In_weight_reg[0][1]), .inst_c(Max_pool_out[1][1]), .inst_d(In_weight_reg[1][1]), .inst_rnd(0), .z_inst(fc_out[3]));
DW_fp_mult_inst mul_fc1( .inst_a(Max_pool_out[0][0]), .inst_b(In_weight_reg[0][0]), .inst_rnd(0), .z_inst(fc_mul_out[0]));
DW_fp_mult_inst mul_fc2( .inst_a(Max_pool_out[0][1]), .inst_b(In_weight_reg[1][0]), .inst_rnd(0), .z_inst(fc_mul_out[1]));
DW_fp_add_inst add_fc1( .inst_a(fc_mul_out[0]), .inst_b(fc_mul_out[1]), .inst_rnd(0), .z_inst(fc_out[0]));

DW_fp_mult_inst mul_fc3( .inst_a(Max_pool_out[0][0]), .inst_b(In_weight_reg[0][1]), .inst_rnd(0), .z_inst(fc_mul_out[2]));
DW_fp_mult_inst mul_fc4( .inst_a(Max_pool_out[0][1]), .inst_b(In_weight_reg[1][1]), .inst_rnd(0), .z_inst(fc_mul_out[3]));
DW_fp_add_inst add_fc2( .inst_a(fc_mul_out[2]), .inst_b(fc_mul_out[3]), .inst_rnd(0), .z_inst(fc_out[1]));

DW_fp_mult_inst mul_fc5( .inst_a(Max_pool_out[1][0]), .inst_b(In_weight_reg[0][0]), .inst_rnd(0), .z_inst(fc_mul_out[4]));
DW_fp_mult_inst mul_fc6( .inst_a(Max_pool_out[1][1]), .inst_b(In_weight_reg[1][0]), .inst_rnd(0), .z_inst(fc_mul_out[5]));
DW_fp_add_inst add_fc3( .inst_a(fc_mul_out[4]), .inst_b(fc_mul_out[5]), .inst_rnd(0), .z_inst(fc_out[2]));

DW_fp_mult_inst mul_fc7( .inst_a(Max_pool_out[1][0]), .inst_b(In_weight_reg[0][1]), .inst_rnd(0), .z_inst(fc_mul_out[6]));
DW_fp_mult_inst mul_fc8( .inst_a(Max_pool_out[1][1]), .inst_b(In_weight_reg[1][1]), .inst_rnd(0), .z_inst(fc_mul_out[7]));
DW_fp_add_inst add_fc4( .inst_a(fc_mul_out[6]), .inst_b(fc_mul_out[7]), .inst_rnd(0), .z_inst(fc_out[3]));
//=======================================================//
//               fully connect DFF                       //
//=======================================================//
always@(*)begin
    // for(i = 0 ;i < 4; i = i + 1)begin// heavy timing violation
    //     fc_1_comb[i] = fc_1_reg[i];
    //     fc_2_comb[i] = fc_2_reg[i];
    // end
	// fc_1_comb[0] = counter_reg << 19;//gated no violation non_gated has
	// fc_1_comb[1] = counter_reg << 20;
	// fc_1_comb[2] = counter_reg << 21;
	// fc_1_comb[3] = counter_reg << 23;
	// fc_2_comb[0] = counter_reg << 19;
	// fc_2_comb[1] = counter_reg << 20;
	// fc_2_comb[2] = counter_reg << 21;
	// fc_2_comb[3] = counter_reg << 23;
	for(i = 0 ;i < 4; i = i + 1)begin
        fc_1_comb[i] = fc_out[i];
        fc_2_comb[i] = fc_out[i];
    end
	case(counter_reg)
		0:begin
			for(i = 0; i < 4 ;i = i + 1)begin
				fc_1_comb[i] = 0;
				fc_2_comb[i] = 0;
			end
		end
		66:begin
			for(i = 0; i < 4 ;i = i + 1)begin
				fc_1_comb[i] = fc_out[i];
			end
		end
		114:begin
			for(i = 0; i < 4; i = i + 1)begin
				fc_2_comb[i] = fc_out[i];
			end
		end
		67, 68, 69:begin
			for(i = 0; i < 4; i = i + 1)begin
				fc_1_comb[i] = fc_1_reg[i];
			end
		end
		115, 116, 117:begin
			for(i = 0; i < 4; i = i + 1)begin
				fc_2_comb[i] = fc_2_reg[i];
			end
		end
    endcase
end
wire fc_out_clk;//
GATED_OR GATED_15(.CLOCK(clk), .SLEEP_CTRL((counter_reg != 66 && counter_reg != 114) & cg_en), .RST_N(rst_n), .CLOCK_GATED(fc_out_clk));
always@(posedge fc_out_clk or negedge rst_n)begin// here might timing violate
	if(!rst_n)begin
		for(i = 0; i < 4; i = i + 1)begin
			fc_1_reg[i] <= 0;
			fc_2_reg[i] <= 0;
		end
	end
	else begin
		for(i = 0; i < 4; i = i + 1)begin
			fc_1_reg[i] <= fc_1_comb[i];
			fc_2_reg[i] <= fc_2_comb[i];
		end
	end
end
//===================================================//
//              Normalization                        //
//===================================================//
reg [31:0] no1_reg, no2_reg, no3_reg, no4_reg, de_reg;
wire Norm_clk;//
GATED_OR GATED_16(.CLOCK(clk), .SLEEP_CTRL((counter_reg != 67 && counter_reg != 115) & cg_en), .RST_N(rst_n), .CLOCK_GATED(Norm_clk));
always @(posedge Norm_clk or negedge rst_n) begin
	if(!rst_n)begin
		no1_reg <= 0;
		no2_reg <= 0;
		no3_reg <= 0;
		no4_reg <= 0;
		de_reg <= 0;
	end
	else begin
		no1_reg <= no1;
		no2_reg <= no2;
		no3_reg <= no3;
		no4_reg <= no4;
		de_reg <=  de; 
	end
end
always @(*) begin
	if(counter_reg == 67 || counter_reg == 68 || counter_reg == 69 || counter_reg == 70)begin
		for(i = 0; i < 4; i = i + 1)begin
			Norm_input[i] = fc_1_reg[i];
		end
	end
	else if(counter_reg == 115 || counter_reg == 116 || counter_reg == 117 || counter_reg == 118)begin
		for(i = 0; i < 4; i = i + 1)begin
			Norm_input[i] = fc_2_reg[i];
		end
	end
	else begin
		for(i = 0; i < 4; i = i + 1)begin
			Norm_input[i] = fc_1_reg[i];
		end
	end
	
end
DW_fp_cmp_inst cmp1(.inst_a(Norm_input[0]), .inst_b(Norm_input[1]), .inst_zctr(0), .z1_inst(max_1), .z0_inst(min_1));
DW_fp_cmp_inst cmp2(.inst_a(Norm_input[2]), .inst_b(Norm_input[3]), .inst_zctr(0), .z1_inst(max_2), .z0_inst(min_2));
DW_fp_cmp_inst cmp3(.inst_a(max_1), .inst_b(max_2), .inst_zctr(0), .z1_inst(max_true));
DW_fp_cmp_inst cmp4(.inst_a(min_1), .inst_b(min_2), .inst_zctr(0), .z0_inst(min_true));
DW_fp_sub_inst sub1(.inst_a(Norm_input[0]), .inst_b(min_true), .inst_rnd(0), .z_inst(no1));
DW_fp_sub_inst sub2(.inst_a(Norm_input[1]), .inst_b(min_true), .inst_rnd(0), .z_inst(no2));
DW_fp_sub_inst sub3(.inst_a(Norm_input[2]), .inst_b(min_true), .inst_rnd(0), .z_inst(no3));
DW_fp_sub_inst sub4(.inst_a(Norm_input[3]), .inst_b(min_true), .inst_rnd(0), .z_inst(no4));
DW_fp_sub_inst sub5(.inst_a(max_true), .inst_b(min_true), .inst_rnd(0), .z_inst(de));

reg [31:0] div_in;
reg [31:0] div_out;
always @(*) begin
	div_in = no1_reg;//for power spreading//here
	case(counter_reg)
		116, 68:div_in = no1_reg;
		117, 69:div_in = no2_reg;
		118, 70:div_in = no3_reg;
		119, 71:div_in = no4_reg;
	endcase
end
DW_fp_div_inst div1(.inst_a(div_in), .inst_b(de_reg), .inst_rnd(0), .z_inst(div_out));

always @(*) begin
	// for(i = 0; i < 4; i = i + 1)begin
	// 	Norm_1_comb[i] = Norm_1_reg[i];
	// 	Norm_2_comb[i] = Norm_2_reg[i];
	// end
	for(i = 0; i < 4; i = i + 1)begin
		Norm_1_comb[i] = div_out;
		Norm_2_comb[i] = div_out;
	end
	// case(counter_reg)
	// 	61:Norm_1_comb[0] = div_out;
	// 	62:Norm_1_comb[1] = div_out;
	// 	63:Norm_1_comb[2] = div_out;
	// 	64:Norm_1_comb[3] = div_out;
	// 	109:Norm_2_comb[0] = div_out;
	// 	110:Norm_2_comb[1] = div_out;
	// 	111:Norm_2_comb[2] = div_out;
	// 	112:Norm_2_comb[3] = div_out;
	// endcase
end
wire Norm_out_clk;//
GATED_OR GATED_17(.CLOCK(clk), .SLEEP_CTRL(((counter_reg < 68 || counter_reg > 71) && (counter_reg < 116 || counter_reg > 119)) & cg_en), .RST_N(rst_n), .CLOCK_GATED(Norm_out_clk));
always @(posedge Norm_out_clk or negedge rst_n) begin
	if (!rst_n) begin
		for(i = 0; i < 4; i = i + 1)begin
			Norm_1_reg[i] <= 0;
			Norm_2_reg[i] <= 0;
		end
	end
	else begin
		for(i = 0; i < 4; i = i + 1)begin
			Norm_1_reg[i] <= Norm_1_comb[i];
			Norm_2_reg[i] <= Norm_2_comb[i];
		end

	end
end
//===================================================//
//              sigmoid & tanh                       //
//===================================================//
wire exp_out_clk;//
GATED_OR GATED_18(.CLOCK(clk), .SLEEP_CTRL(((counter_reg < 69 || counter_reg > 72) && (counter_reg < 117 || counter_reg > 120)) & cg_en), .RST_N(rst_n), .CLOCK_GATED(exp_out_clk));

always @(posedge exp_out_clk or negedge rst_n) begin
	if(!rst_n)begin
		for(i = 0; i < 4;i = i + 1)begin
			expZ_reg <= 0;
			exp_neg_Z_reg <= 0;
		end
	end
	else begin
		for(i = 0; i < 4; i = i + 1)begin
			exp_neg_Z_reg <= exp_neg_Z;
			expZ_reg <= expZ;
		end
	end
end
reg [31:0] Exp_ST_in;

always @(*) begin
	Exp_ST_in = Norm_2_reg[3]; //for power spreading 
	case(counter_reg)//actually just need Exp_ST_in = Norm_1_reg[0];
		69: Exp_ST_in = Norm_1_reg[0];
		70: Exp_ST_in = Norm_1_reg[1];
		71: Exp_ST_in = Norm_1_reg[2];
		72: Exp_ST_in = Norm_1_reg[3];
		117:Exp_ST_in = Norm_2_reg[0];
		118:Exp_ST_in = Norm_2_reg[1];
		119:Exp_ST_in = Norm_2_reg[2];
		120:Exp_ST_in = Norm_2_reg[3];
	endcase
end
	DW_fp_exp_inst exp1(.inst_a(Exp_ST_in), .z_inst(expZ));
	DW_fp_exp_inst exp2(.inst_a({~Exp_ST_in[31], Exp_ST_in[30:0]}), .z_inst(exp_neg_Z));
	DW_fp_add_inst add1(.inst_a(exp_neg_Z_reg), .inst_b({1'b0, 8'd127,23'b0}), .inst_rnd(0), .z_inst(exp_neg_Z_plus_1));
	DW_fp_add_inst add2(.inst_a(expZ_reg), .inst_b(exp_neg_Z_reg), .inst_rnd(0), .z_inst(tanh_de));
	DW_fp_sub_inst sub1_st(.inst_a(expZ_reg), .inst_b(exp_neg_Z_reg), .inst_rnd(0), .z_inst(tanh_no));

reg [31:0] tanh_de_reg;
reg [31:0] tanh_no_reg;
reg [31:0] exp_neg_Z_plus_1_reg;
wire ST_div_clk;//
GATED_OR GATED_19(.CLOCK(clk), .SLEEP_CTRL(((counter_reg < 69 || counter_reg > 74) && (counter_reg < 117 || counter_reg > 122)) & cg_en), .RST_N(rst_n), .CLOCK_GATED(ST_div_clk));

always @(posedge ST_div_clk or negedge rst_n) begin
	if(!rst_n)begin
		tanh_no_reg <= 0;
		tanh_de_reg <= 0;
		exp_neg_Z_plus_1_reg <= 0;
	end
	else begin
		tanh_no_reg <= tanh_no;
		tanh_de_reg <= tanh_de;
		exp_neg_Z_plus_1_reg <= exp_neg_Z_plus_1;
		
	end
end
always @(*) begin
	if(Opt_reg[1] == 0 )begin
		div_in_de = exp_neg_Z_plus_1_reg;
		div_in_no = {1'b0, 8'd127, 23'b0};
	end
	else begin
		div_in_de = tanh_de_reg;
		div_in_no = tanh_no_reg;
	end
end
DW_fp_div_inst div1_st(.inst_a(div_in_no), .inst_b(div_in_de), .inst_rnd(0), .z_inst(ST_stage_out));

always @(*) begin
	for(i = 0 ; i < 4; i = i + 1)begin
		encode_1_comb[i] = encode_1_reg[i];
		encode_2_comb[i] = ST_stage_out;
	end
	case(counter_reg)
		71:encode_1_comb[0] = ST_stage_out;
		72:begin encode_1_comb[1] = ST_stage_out;encode_1_comb[0] = encode_1_reg[0]; end
		73:begin encode_1_comb[2] = ST_stage_out;encode_1_comb[0] = encode_1_reg[0]; encode_1_comb[1] = encode_1_reg[1];end
		74:begin encode_1_comb[3] = ST_stage_out;encode_1_comb[0] = encode_1_reg[0]; encode_1_comb[1] = encode_1_reg[1]; encode_1_comb[2] = encode_1_reg[2];end
		119:encode_2_comb[0] = ST_stage_out;
		120:begin encode_2_comb[1] = ST_stage_out;encode_2_comb[0] = encode_2_reg[0];end
		121:begin encode_2_comb[2] = ST_stage_out;encode_2_comb[0] = encode_2_reg[0]; encode_2_comb[1] = encode_2_reg[1];end
		122:begin encode_2_comb[3] = ST_stage_out;encode_2_comb[0] = encode_2_reg[0]; encode_2_comb[1] = encode_2_reg[1];encode_2_comb[2] = encode_2_reg[2];end
	endcase
end
wire encode_clk;//
GATED_OR GATED_20(.CLOCK(clk), .SLEEP_CTRL(((counter_reg < 71 || counter_reg > 75) && (counter_reg < 119 || counter_reg > 123)) & cg_en), .RST_N(rst_n), .CLOCK_GATED(encode_clk));

always @(posedge encode_clk or negedge rst_n) begin
	if(!rst_n)begin
		for(i = 0;i < 4;i = i + 1)begin
			encode_1_reg[i] <= 0;
			encode_2_reg[i] <= 0;
		end
	end
	else begin
		for(i = 0;i < 4;i = i + 1)begin
			encode_1_reg[i] <= encode_1_comb[i];
			encode_2_reg[i] <= encode_2_comb[i];
		end
	end
end
//============================================//
//               L1 & output                  //
//============================================//
generate
	for(a = 0; a < 4; a = a + 1)begin
		DW_fp_sub_inst subL(.inst_a(encode_1_reg[a]), .inst_b(encode_2_reg[a]), .inst_rnd(0), .z_inst(L1_distance_in[a]));
	end
endgenerate
always @(*) begin
	for(i = 0; i < 4; i = i + 1)begin
		L1_distance_in_abs[i] = {1'b0, L1_distance_in[i][30:0]};
	end
end
DW_fp_sum4_inst L1out(.inst_a(L1_distance_in_abs[0]), .inst_b(L1_distance_in_abs[1]), .inst_c(L1_distance_in_abs[2]), .inst_d(L1_distance_in_abs[3]), .inst_rnd(0), .z_inst(L1_ditance_out));

endmodule
module CNN(
	//Input
	Image1, Image2, Image3,
	Image4, Image5, Image6,
	Image7, Image8, Image9,
	filter1, filter2, filter3,
	filter4, filter5, filter6,
	filter7, filter8, filter9,
	clk,
	rst_n,
	//Output
	out
	);
	input [31:0] Image1, Image2, Image3,
	Image4, Image5, Image6,
	Image7, Image8, Image9,
	filter1, filter2, filter3,
	filter4, filter5, filter6,
	filter7, filter8, filter9;
	input clk, rst_n;
	output [31:0] out;
	wire [31:0] mult_out [0:8];
	reg [31:0] mult_out_dff[0:8];
    wire [31:0] out1, out2, out3;
    integer i;
	always@(posedge clk or negedge rst_n)begin
		if(!rst_n)begin
			for(i = 0; i< 9; i = i + 1)begin
                mult_out_dff[i] <= 0; 
            end
		end
		else begin
			for(i = 0; i< 9; i = i + 1)begin
                mult_out_dff[i] <= mult_out[i]; 
            end
		end
	end

	DW_fp_mult_inst mul1(.inst_a(Image1), .inst_b(filter1) ,.inst_rnd(0), .z_inst(mult_out[0]));
    DW_fp_mult_inst mul2(.inst_a(Image2), .inst_b(filter2) ,.inst_rnd(0), .z_inst(mult_out[1]));
    DW_fp_mult_inst mul3(.inst_a(Image3), .inst_b(filter3) ,.inst_rnd(0), .z_inst(mult_out[2]));
    DW_fp_mult_inst mul4(.inst_a(Image4), .inst_b(filter4) ,.inst_rnd(0), .z_inst(mult_out[3]));
    DW_fp_mult_inst mul5(.inst_a(Image5), .inst_b(filter5) ,.inst_rnd(0), .z_inst(mult_out[4]));
    DW_fp_mult_inst mul6(.inst_a(Image6), .inst_b(filter6) ,.inst_rnd(0), .z_inst(mult_out[5]));
    DW_fp_mult_inst mul7(.inst_a(Image7), .inst_b(filter7) ,.inst_rnd(0), .z_inst(mult_out[6]));
    DW_fp_mult_inst mul8(.inst_a(Image8), .inst_b(filter8) ,.inst_rnd(0), .z_inst(mult_out[7]));
    DW_fp_mult_inst mul9(.inst_a(Image9), .inst_b(filter9) ,.inst_rnd(0), .z_inst(mult_out[8]));

	DW_fp_sum3_inst SUM1(.inst_a(mult_out_dff[0]), .inst_b(mult_out_dff[1]), .inst_c(mult_out_dff[2]), .inst_rnd(0), .z_inst(out1));
    DW_fp_sum3_inst SUM2(.inst_a(mult_out_dff[3]), .inst_b(mult_out_dff[4]), .inst_c(mult_out_dff[5]), .inst_rnd(0), .z_inst(out2));
    DW_fp_sum3_inst SUM3(.inst_a(mult_out_dff[6]), .inst_b(mult_out_dff[7]), .inst_c(mult_out_dff[8]), .inst_rnd(0), .z_inst(out3));
    DW_fp_sum3_inst SUM4(.inst_a(out1), .inst_b(out2), .inst_c(out3), .inst_rnd(0), .z_inst(out));

endmodule
module DW_fp_recip_inst( inst_a, inst_rnd, z_inst, status_inst );
	parameter inst_sig_width = 23;
	parameter inst_exp_width = 8;
	parameter inst_ieee_compliance = 0;
	parameter inst_faithful_round = 0;

	input [inst_sig_width+inst_exp_width : 0] inst_a;
	input [2 : 0] inst_rnd;
	output [inst_sig_width+inst_exp_width : 0] z_inst;
	output [7 : 0] status_inst;
	// Instance of DW_fp_recip
	DW_fp_recip #(inst_sig_width, inst_exp_width, inst_ieee_compliance,
	inst_faithful_round) U1 (
	.a(inst_a),
	.rnd(inst_rnd),
	.z(z_inst),
	.status(status_inst) );
endmodule
module DW_fp_dp3_inst( inst_a, inst_b, inst_c, inst_d, inst_e,
inst_f, inst_rnd, z_inst, status_inst );
	parameter inst_sig_width = 23;
	parameter inst_exp_width = 8;
	parameter inst_ieee_compliance = 0;
	parameter inst_arch_type = 0;

	input [inst_sig_width+inst_exp_width : 0] inst_a;
	input [inst_sig_width+inst_exp_width : 0] inst_b;
	input [inst_sig_width+inst_exp_width : 0] inst_c;
	input [inst_sig_width+inst_exp_width : 0] inst_d;
	input [inst_sig_width+inst_exp_width : 0] inst_e;
	input [inst_sig_width+inst_exp_width : 0] inst_f;
	input [2 : 0] inst_rnd;
	output [inst_sig_width+inst_exp_width : 0] z_inst;
	output [7 : 0] status_inst;
	// Instance of DW_fp_dp3
	DW_fp_dp3 #(inst_sig_width, inst_exp_width, inst_ieee_compliance, inst_arch_type)
	U1 (
	.a(inst_a),
	.b(inst_b),
	.c(inst_c),
	.d(inst_d),
	.e(inst_e),
	.f(inst_f),
	.rnd(inst_rnd),
	.z(z_inst),
	.status(status_inst) );
endmodule
module DW_fp_sum3_inst( inst_a, inst_b, inst_c, inst_rnd, z_inst,
status_inst );
	parameter inst_sig_width = 23;
	parameter inst_exp_width = 8;
	parameter inst_ieee_compliance = 0;
	parameter inst_arch_type = 0;

	input [inst_sig_width+inst_exp_width : 0] inst_a;
	input [inst_sig_width+inst_exp_width : 0] inst_b;
	input [inst_sig_width+inst_exp_width : 0] inst_c;
	input [2 : 0] inst_rnd;
	output [inst_sig_width+inst_exp_width : 0] z_inst;
	output [7 : 0] status_inst;
	// Instance of DW_fp_sum3
	DW_fp_sum3 #(inst_sig_width, inst_exp_width, inst_ieee_compliance, inst_arch_type)
	U1 (
	.a(inst_a),
	.b(inst_b),
	.c(inst_c),
	.rnd(inst_rnd),
	.z(z_inst),
	.status(status_inst) );
endmodule

module DW_fp_cmp_inst( inst_a, inst_b, inst_zctr, aeqb_inst, altb_inst,
agtb_inst, unordered_inst, z0_inst, z1_inst, status0_inst,
status1_inst );
	parameter sig_width = 23;
	parameter exp_width = 8;
	parameter ieee_compliance = 0;
	input [sig_width+exp_width : 0] inst_a;
	input [sig_width+exp_width : 0] inst_b;
	input inst_zctr;
	output aeqb_inst;
	output altb_inst;
	output agtb_inst;
	output unordered_inst;
	output [sig_width+exp_width : 0] z0_inst;
	output [sig_width+exp_width : 0] z1_inst;
	output [7 : 0] status0_inst;
	output [7 : 0] status1_inst;
	// Instance of DW_fp_cmp
	DW_fp_cmp #(sig_width, exp_width, ieee_compliance)
	U1 ( .a(inst_a), .b(inst_b), .zctr(inst_zctr), .aeqb(aeqb_inst),
	.altb(altb_inst),.agtb(agtb_inst), .unordered(unordered_inst),
	.z0(z0_inst), .z1(z1_inst), .status0(status0_inst),
	.status1(status1_inst));
endmodule

module DW_fp_dp4_inst( inst_a, inst_b, inst_c, inst_d, inst_e,
inst_f, inst_g, inst_h, inst_rnd, z_inst,
status_inst );
	parameter inst_sig_width = 23;
	parameter inst_exp_width = 8;
	parameter inst_ieee_compliance = 0;
	parameter inst_arch_type = 0;

	input [inst_sig_width+inst_exp_width : 0] inst_a;
	input [inst_sig_width+inst_exp_width : 0] inst_b;
	input [inst_sig_width+inst_exp_width : 0] inst_c;
	input [inst_sig_width+inst_exp_width : 0] inst_d;
	input [inst_sig_width+inst_exp_width : 0] inst_e;
	input [inst_sig_width+inst_exp_width : 0] inst_f;
	input [inst_sig_width+inst_exp_width : 0] inst_g;
	input [inst_sig_width+inst_exp_width : 0] inst_h;
	input [2 : 0] inst_rnd;
	output [inst_sig_width+inst_exp_width : 0] z_inst;
	output [7 : 0] status_inst;
	// Instance of DW_fp_dp4
	DW_fp_dp4 #(inst_sig_width, inst_exp_width, inst_ieee_compliance, inst_arch_type)
	U1 (
	.a(inst_a),
	.b(inst_b),
	.c(inst_c),
	.d(inst_d),
	.e(inst_e),
	.f(inst_f),
	.g(inst_g),
	.h(inst_h),
	.rnd(inst_rnd),
	.z(z_inst),
	.status(status_inst) );
endmodule
module DW_fp_sub_inst( inst_a, inst_b, inst_rnd, z_inst, status_inst );
	parameter sig_width = 23;
	parameter exp_width = 8;
	parameter ieee_compliance = 0;
	input [sig_width+exp_width : 0] inst_a;
	input [sig_width+exp_width : 0] inst_b;
	input [2 : 0] inst_rnd;
	output [sig_width+exp_width : 0] z_inst;
	output [7 : 0] status_inst;
	// Instance of DW_fp_sub
	DW_fp_sub #(sig_width, exp_width, ieee_compliance)
	U1 ( .a(inst_a), .b(inst_b), .rnd(inst_rnd), .z(z_inst), .status(status_inst) );
endmodule
module DW_fp_div_inst( inst_a, inst_b, inst_rnd, z_inst, status_inst );
	parameter sig_width = 23;
	parameter exp_width = 8;
	parameter ieee_compliance = 0;
	parameter faithful_round = 0;

	input [sig_width+exp_width : 0] inst_a;
	input [sig_width+exp_width : 0] inst_b;
	input [2 : 0] inst_rnd;
	output [sig_width+exp_width : 0] z_inst;
	output [7 : 0] status_inst;
	// Instance of DW_fp_div
	DW_fp_div #(sig_width, exp_width, ieee_compliance, faithful_round) U1
	( .a(inst_a), .b(inst_b), .rnd(inst_rnd), .z(z_inst), .status(status_inst)
	);
endmodule
module DW_fp_exp_inst( inst_a, z_inst, status_inst );
	parameter inst_sig_width = 23;
	parameter inst_exp_width = 8;
	parameter inst_ieee_compliance = 0;
	parameter inst_arch = 0;
	input [inst_sig_width+inst_exp_width : 0] inst_a;
	output [inst_sig_width+inst_exp_width : 0] z_inst;
	output [7 : 0] status_inst;
	// Instance of DW_fp_exp
	DW_fp_exp #(inst_sig_width, inst_exp_width, inst_ieee_compliance, inst_arch) U1 (
	.a(inst_a),
	.z(z_inst),
	.status(status_inst) );
endmodule
module DW_fp_add_inst( inst_a, inst_b, inst_rnd, z_inst, status_inst );
	parameter sig_width = 23;
	parameter exp_width = 8;
	parameter ieee_compliance = 0;
	input [sig_width+exp_width : 0] inst_a;
	input [sig_width+exp_width : 0] inst_b;
	input [2 : 0] inst_rnd;
	output [sig_width+exp_width : 0] z_inst;
	output [7 : 0] status_inst;
	// Instance of DW_fp_add
	DW_fp_add #(sig_width, exp_width, ieee_compliance)
	U1 ( .a(inst_a), .b(inst_b), .rnd(inst_rnd), .z(z_inst), .status(status_inst) );
endmodule
module DW_fp_dp2_inst( inst_a, inst_b, inst_c, inst_d, inst_rnd,
z_inst, status_inst );
	parameter inst_sig_width = 23;
	parameter inst_exp_width = 8;
	parameter inst_ieee_compliance = 0;
	parameter inst_arch_type = 0;
	
	input [inst_sig_width+inst_exp_width : 0] inst_a;
	input [inst_sig_width+inst_exp_width : 0] inst_b;
	input [inst_sig_width+inst_exp_width : 0] inst_c;
	input [inst_sig_width+inst_exp_width : 0] inst_d;
	input [2 : 0] inst_rnd;
	output [inst_sig_width+inst_exp_width : 0] z_inst;
	output [7 : 0] status_inst;
	// Instance of DW_fp_dp2
	DW_fp_dp2 #(inst_sig_width, inst_exp_width, inst_ieee_compliance, inst_arch_type)
	U1 (
	.a(inst_a),
	.b(inst_b),
	.c(inst_c),
	.d(inst_d),
	.rnd(inst_rnd),
	.z(z_inst),
	.status(status_inst) );
endmodule
module DW_fp_sum4_inst( inst_a, inst_b, inst_c, inst_d, inst_rnd,
z_inst, status_inst );
	parameter inst_sig_width = 23;
	parameter inst_exp_width = 8;
	parameter inst_ieee_compliance = 0;
	parameter inst_arch_type = 0;

	input [inst_sig_width+inst_exp_width : 0] inst_a;
	input [inst_sig_width+inst_exp_width : 0] inst_b;
	input [inst_sig_width+inst_exp_width : 0] inst_c;
	input [inst_sig_width+inst_exp_width : 0] inst_d;
	input [2 : 0] inst_rnd;
	output [inst_sig_width+inst_exp_width : 0] z_inst;
	output [7 : 0] status_inst;
	// Instance of DW_fp_sum4
	DW_fp_sum4 #(inst_sig_width, inst_exp_width, inst_ieee_compliance, inst_arch_type)
	U1 (
	.a(inst_a),
	.b(inst_b),
	.c(inst_c),
	.d(inst_d),
	.rnd(inst_rnd),
	.z(z_inst),
	.status(status_inst) );
endmodule
module DW_fp_mult_inst( inst_a, inst_b, inst_rnd, z_inst, status_inst );
    parameter sig_width = 23;
    parameter exp_width = 8;
    parameter ieee_compliance = 0;
    input [sig_width+exp_width : 0] inst_a;
    input [sig_width+exp_width : 0] inst_b;
    input [2 : 0] inst_rnd;
    output [sig_width+exp_width : 0] z_inst;
    output [7 : 0] status_inst;
    // Instance of DW_fp_mult
    DW_fp_mult #(sig_width, exp_width, ieee_compliance)
    U1 ( .a(inst_a), .b(inst_b), .rnd(inst_rnd), .z(z_inst), .status(status_inst) );
endmodule
