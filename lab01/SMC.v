//############################################################################
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//   (C) Copyright Laboratory System Integration and Silicon Implementation
//   All Right Reserved
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
//   ICLAB 2023 Fall
//   Lab01 Exercise		: Supper MOSFET Calculator
//   Author     		: Lin-Hung Lai (lhlai@ieee.org)
//
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
//   File Name   : SMC.v
//   Module Name : SMC
//   Release version : V1.0 (Release Date: 2023-09)
//
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//############################################################################


module SMC(
  // Input signals
    mode,
    W_0, V_GS_0, V_DS_0,
    W_1, V_GS_1, V_DS_1,
    W_2, V_GS_2, V_DS_2,
    W_3, V_GS_3, V_DS_3,
    W_4, V_GS_4, V_DS_4,
    W_5, V_GS_5, V_DS_5,   
  // Output signals
    out_n
);

//================================================================
//   INPUT AND OUTPUT DECLARATION                         
//================================================================
input [2:0] W_0, V_GS_0, V_DS_0;
input [2:0] W_1, V_GS_1, V_DS_1;
input [2:0] W_2, V_GS_2, V_DS_2;
input [2:0] W_3, V_GS_3, V_DS_3;
input [2:0] W_4, V_GS_4, V_DS_4;
input [2:0] W_5, V_GS_5, V_DS_5;
input [1:0] mode;
//output [7:0] out_n;         					// use this if using continuous assignment for out_n  // Ex: assign out_n = XXX;
output reg [7:0] out_n; 								// use this if using procedure assignment for out_n   // Ex: always@(*) begin out_n = XXX; end

//================================================================
//    logic & Registers 
//================================================================
// Declare the logic/reg you would use in your circuit
// remember 
// logic for port connection and cont. assignment
// reg for proc. assignment
logic [7:0] result_0, result_1, result_2, result_3, result_4, result_5;
logic [7:0] result_0_as, result_1_as, result_2_as, result_3_as, result_4_as, result_5_as;
//================================================================
//    DESIGN
//================================================================
CaculateId_gm C1(.W(W_0), .V_GS(V_GS_0), .V_DS(V_DS_0), .mode(mode[0]), .result(result_0));
CaculateId_gm C2(.W(W_1), .V_GS(V_GS_1), .V_DS(V_DS_1), .mode(mode[0]), .result(result_1));
CaculateId_gm C3(.W(W_2), .V_GS(V_GS_2), .V_DS(V_DS_2), .mode(mode[0]), .result(result_2));
CaculateId_gm C4(.W(W_3), .V_GS(V_GS_3), .V_DS(V_DS_3), .mode(mode[0]), .result(result_3));
CaculateId_gm C5(.W(W_4), .V_GS(V_GS_4), .V_DS(V_DS_4), .mode(mode[0]), .result(result_4));
CaculateId_gm C6(.W(W_5), .V_GS(V_GS_5), .V_DS(V_DS_5), .mode(mode[0]), .result(result_5));

sortingNet(.IN0(result_0), .IN1(result_1), .IN2(result_2), .IN3(result_3), .IN4(result_4), .IN5(result_5),
		.OUT0(result_0_as), .OUT1(result_1_as), .OUT2(result_2_as), .OUT3(result_3_as), .OUT4(result_4_as), .OUT5(result_5_as)
			);

logic [7:0] mux_C1_output_b, mux_C2_output_b, mux_C3_output_b;
logic [6:0] mux_C1_output, mux_C2_output, mux_C3_output;
always@(*)begin
	if(mode[1] == 0)begin
		mux_C1_output_b = result_2_as ;
		mux_C2_output_b = result_1_as ;
		mux_C3_output_b = result_0_as ;
	end
	else begin
		mux_C1_output_b = result_5_as ;
		mux_C2_output_b = result_4_as ;
		mux_C3_output_b = result_3_as ;
	end
end
assign mux_C1_output = mux_C1_output_b *4 / 12;
assign mux_C2_output = mux_C2_output_b *4 / 12;
assign mux_C3_output = mux_C3_output_b *4 / 12;
logic [2:0] weight1;
logic [2:0] weight3;
assign weight1 = (mode[0] == 0)? 4:3;
//assign weight3 = (mode[0] == 0)? 4:5;
assign weight3 = 8 - weight1;
logic [9:0] out_n_b;
always@(*)begin
	out_n_b = (weight1 * mux_C1_output + 4 * mux_C2_output + weight3 * mux_C3_output) ;
	out_n = out_n_b / 12;
end 
/* always@(*)begin
	if(mode[0] == 0)begin
		out_n = (mux_C1_output + mux_C2_output + mux_C3_output) /3;
	end
	else begin
		out_n = (mux_C1_output * 3+ mux_C2_output * 4 + mux_C3_output * 5)/12;
	end

end */
/* always@(*)begin
	case(mode)
		2'b00:begin
			out_n = (result_0_as + result_1_as + result_2_as) / 3;
		end
		2'b10:begin
			out_n = (result_3_as + result_4_as + result_5_as) / 3;
		end
		2'b11:begin
			out_n = (result_5_as * 3 + result_4_as * 4 + result_3_as * 5) / 12;
		end
		2'b01:begin
			out_n = (result_2_as * 3 + result_1_as * 4 + result_0_as * 5) / 12;
		end
			
	endcase
end */

// --------------------------------------------------
// write your design here
// --------------------------------------------------

/*Calculate Id or gm*/

/*Sort*/

/*Select according to mode*/

/*Output*/

endmodule


//================================================================
//   SUB MODULE
//================================================================
/* module CaculateId_gm(W, V_GS, V_DS, mode, result);
	input [2:0] W, V_GS, V_DS;
	input mode;
	logic bool;
	logic [2:0] V_GS_minus_one,V_DS_or_V_GS_minus_one;
	logic [4:0] mux2_output_shift;
	logic [5:0] V_GS_times_V_DS, V_DS_square, V_GS_minus_times_V_DS, V_GS_minus_square;
	logic [6:0] V_GS_minus_times_V_DS_shift;
	logic [6:0] mux1_input, mux1_output;
	logic [6:0] mux3_output;
	logic [9:0] result_before_divide_3;
	output logic [8:0] result;
	
	assign V_GS_times_V_DS = V_DS * V_GS;
	assign V_DS_square = V_DS * V_DS;
	assign V_GS_minus_one = V_GS - 1;
	assign V_GS_minus_times_V_DS = V_GS_minus_one * V_DS;
	assign V_GS_minus_square = V_GS_minus_one * V_GS_minus_one;
	assign bool = V_GS_minus_one <= V_DS;
	
	assign V_DS_or_V_GS_minus_one = (bool)? V_GS_minus_one : V_DS;
	assign V_GS_minus_times_V_DS_shift = V_GS_minus_times_V_DS << 1;
	assign mux1_input = V_GS_minus_times_V_DS_shift - V_DS_square;
	assign mux1_output = (bool)? V_GS_minus_square : mux1_input;
	assign mux2_output_shift = V_DS_or_V_GS_minus_one << 1;
	assign mux3_output = (mode == 1'b1)?mux1_output : mux2_output_shift;
	
	assign result_before_divide_3 = W * mux3_output;
	assign result = result_before_divide_3 / 3;
	//divide_3 divide3(.IN(result_before_divide_3), .OUT(result));
endmodule */
module CaculateId_gm(W, V_GS, V_DS, mode, result);
	input [2:0] W, V_GS, V_DS;
	input mode;
	output logic [7:0] result;
	
	logic [2:0] mux1_output;
	logic [3:0] mux2_output;
	logic [2:0] V_GS_minus;
	logic [5:0] mux1_x_mux2;
	logic bool;
	assign V_GS_minus = V_GS - 1;
	assign bool = (V_GS_minus) <= V_DS;
	
	//mux1 & mux2
	always@(*)begin
		if(bool)begin
			mux1_output = V_GS_minus;
		end
		else begin
			mux1_output = V_DS;
		end
		casez({bool,mode})
			2'b?0:begin
				mux2_output = 2;
			end
			2'b11:begin
				mux2_output = V_GS_minus;
			end
			2'b01:begin
				mux2_output = 2 * (V_GS_minus) - V_DS;
			end
		
		endcase
		/* if(mode == 0)begin
			mux2_output = 2;
		end
		else begin
			mux2_output = 2 * V_GS_minus - mux1_output;
		end */
	end
	assign mux1_x_mux2 = mux1_output * W;
	logic [7:0] middle;
	assign middle = mux1_x_mux2 * mux2_output;
	assign result = middle;
endmodule

module sortingNet( IN0, IN1, IN2, IN3, IN4, IN5,
					OUT0, OUT1, OUT2, OUT3, OUT4, OUT5
					);
	input [7:0] IN0, IN1, IN2, IN3, IN4, IN5;
	output logic [7:0] OUT0, OUT1, OUT2, OUT3, OUT4, OUT5;
	//smallest first
	//first layer
	logic [7:0] layer1_0, layer1_1, layer1_2, layer1_3, layer1_4, layer1_5;
	always@(*)begin
		if(IN0 > IN5)begin
			layer1_0 = IN5;
			layer1_5 = IN0;
		end
		else begin
			layer1_0 = IN0;
			layer1_5 = IN5;
		end
		if(IN1 > IN3)begin
			layer1_1 = IN3;
			layer1_3 = IN1;
		end
		else begin
			layer1_1 = IN1;
			layer1_3 = IN3;
		end
		if(IN2 > IN4)begin
			layer1_2 = IN4;
			layer1_4 = IN2;
		end
		else begin
			layer1_2 = IN2;
			layer1_4 = IN4;
		end
	end
	//second layer
	logic [7:0] layer2_0, layer2_1, layer2_2, layer2_3, layer2_4, layer2_5;
	/* assign layer2_0 = layer1_0;
	assign layer2_5 = layer1_5; */
	always@(*)begin
		if(layer1_1 > layer1_2)begin
			layer2_1 = layer1_2;
			layer2_2 = layer1_1;
		end
		else begin
			layer2_1 = layer1_1;
			layer2_2 = layer1_2;
		end
		if(layer1_3 > layer1_4)begin
			layer2_3 = layer1_4;
			layer2_4 = layer1_3;
		end
		else begin
			layer2_3 = layer1_3;
			layer2_4 = layer1_4;
		end
	end
	//third layer
	logic [7:0] layer3_0, layer3_1, layer3_2, layer3_3, layer3_4, layer3_5;
	/* assign layer3_1 = layer2_1;
	assign layer3_4 = layer2_4; */
	always@(*)begin
		if(layer1_0 > layer2_3)begin
			layer3_0 = layer2_3;
			layer3_3 = layer1_0;
		end
		else begin
			layer3_0 = layer1_0;
			layer3_3 = layer2_3;
		end
		if(layer2_2 > layer1_5)begin
			layer3_2 = layer1_5;
			layer3_5 = layer2_2;
		end
		else begin
			layer3_2 = layer2_2;
			layer3_5 = layer1_5;
		end	
	end
	//forth layer
	logic [7:0] layer4_0, layer4_1, layer4_2, layer4_3, layer4_4, layer4_5;
	always@(*)begin
		if(layer3_0 > layer2_1)begin
			layer4_0 = layer2_1;
			layer4_1 = layer3_0;
		end
		else begin
			layer4_0 = layer3_0;
			layer4_1 = layer2_1;
		end
		if(layer3_2 > layer3_3)begin
			layer4_2 = layer3_3;
			layer4_3 = layer3_2;
		end
		else begin
			layer4_2 = layer3_2;
			layer4_3 = layer3_3;
		end
		if(layer2_4 > layer3_5)begin
			layer4_4 = layer3_5;
			layer4_5 = layer2_4;
		end
		else begin
			layer4_4 = layer2_4;
			layer4_5 = layer3_5;
		end
	end
	logic [7:0] layer5_0, layer5_1, layer5_2, layer5_3, layer5_4, layer5_5;
	always@(*)begin
		OUT0 = layer4_0;
		OUT5 = layer4_5;
		if(layer4_1 > layer4_2)begin
			OUT1 = layer4_2;
			OUT2 = layer4_1;
		end
		else begin
			OUT1 = layer4_1;
			OUT2 = layer4_2;
		end
		if(layer4_3 > layer4_4)begin
			OUT3 = layer4_4;
			OUT4 = layer4_3;
		end
		else begin
			OUT3 = layer4_3;
			OUT4 = layer4_4;
		end
	end

endmodule
// module BBQ (meat,vagetable,water,cost);
// input XXX;
// output XXX;
// 
// endmodule

// --------------------------------------------------
// Example for using submodule 
// BBQ bbq0(.meat(meat_0), .vagetable(vagetable_0), .water(water_0),.cost(cost[0]));
// --------------------------------------------------
// Example for continuous assignment
// assign out_n = XXX;
// --------------------------------------------------
// Example for procedure assignment
// always@(*) begin 
// 	out_n = XXX; 
// end
// --------------------------------------------------
// Example for case statement
// always @(*) begin
// 	case(op)
// 		2'b00: output_reg = a + b;
// 		2'b10: output_reg = a - b;
// 		2'b01: output_reg = a * b;
// 		2'b11: output_reg = a / b;
// 		default: output_reg = 0;
// 	endcase
// end
// --------------------------------------------------
