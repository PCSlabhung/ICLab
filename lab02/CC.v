module CC(
    //Input Port
    clk,
    rst_n,
	in_valid,
	mode,
    xi,
    yi,

    //Output Port
    out_valid,
	xo,
	yo
    );

input               clk, rst_n, in_valid;
input       [1:0]   mode;
input       [7:0]   xi, yi;  

output reg          out_valid;
output reg signed [7:0]   xo, yo;

//reg [2:0] current_state, next_state;
reg current_state, next_state;
reg signed [7:0] X_input, Y_input;
reg signed [7:0] X_ur_dff, X_ul_dff, X_lr_dff, X_ll_dff, Y_ur_dff,Y_ul_dff, Y_lr_dff, Y_ll_dff;
reg [1:0] mode_dff;
reg [7:0] xo_comb, yo_comb;

reg signed [8:0] delta_y,delta_y_dff;//changed

reg out_valid_comb;

reg signed [7:0] lowerB_r, upperB_r, newlowerB_r;//changed
//==============================================//
//             Parameter and Integer            //
//==============================================//

parameter IDLE = 1'd0;
parameter Calculation = 1'd1;
//==============================================//
//            FSM State Declaration             //
//==============================================//
reg[2:0] timer, time_dff;
always@(negedge rst_n or posedge clk)begin 
	if(!rst_n)begin
		current_state <= IDLE;
		time_dff <= 0;
		
	end
	else begin
		
		time_dff <= timer;
		current_state <= next_state;
		
	end
	
end 

always@(*)begin
	timer = time_dff;
	if(current_state == IDLE)begin
		if(in_valid == 1)begin
			timer = time_dff + 1;
		end
		else if(time_dff == 3)begin
			timer = 0;
		end
		else begin
			timer = 0;
		end
		if(time_dff == 3)begin
			next_state = Calculation;
		end
		else begin
			next_state = IDLE;
		end
	end
	else begin
		if(mode_dff == 0)begin
			//next_state = output_mode_0;
			if(xo == X_ur_dff && yo == Y_ur_dff)begin
				next_state = IDLE;
			end
			else begin
				next_state = Calculation;
			end
		end
		else begin
			next_state = IDLE;
		end 
	end
end
//==============================================//
//                 input shift register         //
//==============================================//
always@(negedge rst_n or posedge clk)begin
	if(!rst_n)begin
		X_ur_dff <= 0;
		X_ul_dff <= 0;
		X_lr_dff <= 0;
		X_ll_dff <= 0;
		
		Y_ul_dff <= 0;
		Y_ur_dff <= 0;
		Y_ll_dff <= 0;
		Y_lr_dff <= 0;
		
		mode_dff <= 0;
	end
	else begin
		if(in_valid == 1)begin
			mode_dff <= mode;
			X_lr_dff <= xi;
			X_ll_dff <= X_lr_dff;
			X_ur_dff <= X_ll_dff;
			X_ul_dff <= X_ur_dff;
			
			Y_lr_dff <= yi;
			Y_ll_dff <= Y_lr_dff;
			Y_ur_dff <= Y_ll_dff;
			Y_ul_dff <= Y_ur_dff;
		end
		else begin
			mode_dff <= mode_dff;
			X_ul_dff <= X_ul_dff; 
			X_ur_dff <= X_ur_dff;
			X_ll_dff <= X_ll_dff;
			X_lr_dff <= X_lr_dff;
			
			Y_ul_dff <= Y_ul_dff;
			Y_ur_dff <= Y_ur_dff;
			Y_ll_dff <= Y_ll_dff;
			Y_lr_dff <= Y_lr_dff;
		end
		
	end
end
//==============================================//
//             Current State Block              //
//==============================================//



//==============================================//
//              Next State Block                //
//==============================================//


//==============================================//
//                  Input Block                 //
//==============================================//


//==============================================//
//              Calculation Block1              //
//==============================================//
//line1_dy, line1_dx,line2_dy, line1_dx;
reg signed [8:0] line1_dy, line1_dx, line2_dy, line2_dx;
reg signed [15:0] area1, area2, area3, area4, area5, area1_reg, area2_reg, area3_reg, area4_reg ;
reg signed [15:0] area5_reg, area5_reg_reg;

reg signed [8:0] lineRD_dy_dff, lineRD_dy;
reg signed [25:0] check_p1,check_p2;
reg signed [7:0] new_check_r, new_input_r_b_reg, new_next_lowerB_r_dff, new_upper_r_dff;
reg signed [17:0] for_round_down;  
wire signed [17:0] for_round_down_comb;
wire signed [17:0] new_upper, new_next_lowerB;
reg flag, flag_dff;
//wire signed [7:0] new_upper_r_b, new_next_lowerB_r_b;
wire signed [7:0] new_input_r_b;
reg signed [7:0] new_input_r;
reg signed [7:0] new_upper_r, new_next_lowerB_r;

assign new_next_lowerB = line1_dy * X_ll_dff + line1_dx * delta_y_dff + line1_dx;
assign new_upper = line2_dy * X_lr_dff + line2_dx * delta_y_dff;
/* assign new_next_lowerB_r_b = new_next_lowerB / line1_dy;
assign new_upper_r_b = new_upper / line2_dy; */

assign for_round_down_comb = (flag == 1)? new_next_lowerB : new_upper;
assign lineRD_dy = (flag == 1)? line1_dy: line2_dy;
assign new_input_r_b =  for_round_down_comb / lineRD_dy ;
always@(posedge clk or negedge rst_n)begin
	if(!rst_n)begin
		new_next_lowerB_r_dff <= 0;
		new_upper_r_dff <= 0; 
		new_input_r_b_reg <= 0;
		flag_dff <= 0;
		lineRD_dy_dff <= 0;
		for_round_down <= 0;
	end
	else begin
		lineRD_dy_dff <= lineRD_dy;
		new_next_lowerB_r_dff <= new_next_lowerB_r;
		new_upper_r_dff <= new_upper_r; 
		new_input_r_b_reg <= new_input_r_b;
		flag_dff <= flag;
		for_round_down <= for_round_down_comb;
	end
end
/* always@(*)begin
	if(new_next_lowerB_r_b * line1_dy != new_next_lowerB  && new_next_lowerB[17] ^ line1_dy[8])begin
		new_next_lowerB_r = new_next_lowerB_r_b - 1;
	end
	else begin
		new_next_lowerB_r = new_next_lowerB_r_b;
	end
	if(new_upper_r_b * line2_dy != new_upper && new_upper[17] ^ line2_dy[8])begin
		new_upper_r = new_upper_r_b - 1;
	end
	else begin
		new_upper_r = new_upper_r_b;
	end
end */
always@(*)begin
	if(new_input_r_b_reg * lineRD_dy_dff != for_round_down  && for_round_down[17] ^ lineRD_dy_dff[8])begin
		new_input_r = new_input_r_b_reg - 1;
	end
	else begin
		new_input_r = new_input_r_b_reg;
	end
end
assign line1_dx = (mode_dff == 0) ? X_ul_dff - X_ll_dff : X_ul_dff - X_ur_dff;
assign line1_dy = (mode_dff == 0) ? Y_ul_dff - Y_ll_dff : Y_ul_dff - Y_ur_dff;
assign line2_dx = (mode_dff == 0) ? X_ur_dff - X_lr_dff : X_ll_dff - X_lr_dff;
assign line2_dy = (mode_dff == 0) ? Y_ur_dff - Y_lr_dff : Y_ll_dff - Y_lr_dff; 
always@(*)begin
	area1 = 0;
	area2 = 0; 
	area3 =	0;
	area4 = 0;
	area5 = 0;
	if(current_state == Calculation)begin
		if(mode_dff == 0)begin
			
			
			area1 = line1_dy * X_ll_dff;
			area2 = line2_dy * X_lr_dff;
			area3 =	(X_ll_dff * Y_lr_dff - X_lr_dff * Y_ll_dff) ;
			area4 =	(X_lr_dff * Y_ul_dff - X_ul_dff * Y_lr_dff) ;
			area5 = 2;
		end
		else if(mode_dff == 1)begin
			area1 = (line1_dy * X_ll_dff - line1_dx * Y_ll_dff);
			area2 = (line1_dy * X_ll_dff - line1_dx * Y_ll_dff); 
			area3 =	(line1_dy * X_ul_dff - line1_dx * Y_ul_dff);
			area4 = line2_dy * line2_dy + line2_dx * line2_dx;
			area5 = line1_dy * line1_dy + line1_dx * line1_dx;

		end
		else begin
			
			/* area1 = (X_ul_dff * Y_ur_dff - X_ur_dff * Y_ul_dff);
			area2 = (X_ur_dff * Y_ll_dff - X_ll_dff * Y_ur_dff);
			area3 =	(X_ll_dff * Y_lr_dff - X_lr_dff * Y_ll_dff) ;
			area4 =	(X_lr_dff * Y_ul_dff - X_ul_dff * Y_lr_dff) ; */
			area1 = X_ul_dff - X_ll_dff;
			area2 = Y_ur_dff - Y_lr_dff;
			area3 =	Y_ul_dff - Y_ll_dff;
			area4 =	X_lr_dff - X_ur_dff;
			area5 = (area1 * area2 + area3 * area4) / 2;
			
		end
	end	

end

//==============================================//
//              Calculation Block2              //
//==============================================//



//==============================================//
//              Calculation Block3              //
//==============================================//

//==============================================//
//                Output Block                  //
//==============================================//

always@(negedge rst_n or posedge clk)begin
	if(!rst_n)begin
		xo <= 0;
		delta_y_dff <= 0;
		yo <= 0;
		out_valid <= 0;
	end
	else begin
		delta_y_dff <= delta_y;
		xo <= xo_comb;
		yo <= yo_comb;
		out_valid <= out_valid_comb;
	end
end
//assign out_valid_delay = (mode_dff == 0 )?out_valid_reg : out_valid_comb;  
reg signed [24:0] temp;
reg check_bool3;
reg signed [24:0] temp_minus;
reg gg;
always@(*)begin
	delta_y = delta_y_dff;
	temp = 0;
	temp_minus = -1 * area5;
	check_p2 = 0;
	flag = 0;
	new_upper_r = new_upper_r_dff;
	new_next_lowerB_r = new_next_lowerB_r_dff;
	if(current_state == Calculation)begin
		
		out_valid_comb = 1;
		if(mode_dff == 2)begin
			if(area5 > 0)begin
				xo_comb = area5[15:8];
				yo_comb = area5[7:0];
			end
			else begin
				xo_comb = temp_minus[15:8];
				yo_comb = temp_minus[7:0];
			end
		end
		else if(mode_dff == 1)begin
			temp = (area1  - area3 ) * (area1  - area3);
			check_p2 = area4 * area5;
			if(temp > check_p2)begin
				xo_comb = 0;
				yo_comb = 0;
			end
			else if (temp < check_p2)begin
				xo_comb = 0;
				yo_comb = 1;
			end
			else begin
				xo_comb = 0;
				yo_comb = 2;
			end
		end	
		else begin
			if(xo > X_ur_dff - 1 && yo == Y_ul_dff )begin
				out_valid_comb = 0;
			end
		
			if(out_valid == 1)begin
				/* if(xo < new_upper_r )begin
					xo_comb = xo + 1;
					yo_comb = yo;
				end */
				if(flag_dff == 1)begin
					new_next_lowerB_r =  new_input_r;
				end
				else begin
					new_upper_r = new_input_r;
				end
				xo_comb = xo + 1;
				yo_comb = yo;
				gg = xo == new_upper_r;
				if(xo == new_upper_r )begin
					xo_comb = new_next_lowerB_r;
					yo_comb = yo + 1;
				end
				if(xo  == new_upper_r - 1 )begin
					delta_y = delta_y_dff + 1;
					flag = 1;
				end
				
				
			end
			else begin
				xo_comb = X_ll_dff;
				yo_comb = Y_ll_dff;
			end
		end	
	end
	//IDLE
	else begin
		delta_y = 0;
		out_valid_comb = 0;
		xo_comb = 0;
		yo_comb = 0;

	end
end





endmodule 