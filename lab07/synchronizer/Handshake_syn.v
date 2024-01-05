module Handshake_syn #(parameter WIDTH=32) (
    sclk,
    dclk,
    rst_n,
    sready,
    din,
    dbusy,
    sidle,
    dvalid,
    dout,

    clk1_handshake_flag1,
    clk1_handshake_flag2,
    clk1_handshake_flag3,
    clk1_handshake_flag4,

    handshake_clk2_flag1,
    handshake_clk2_flag2,
    handshake_clk2_flag3,
    handshake_clk2_flag4
);

input sclk, dclk;
input rst_n;
input sready;
input [WIDTH-1:0] din;
input dbusy;
output reg sidle;
output reg dvalid;
output reg [WIDTH-1:0] dout;

// You can change the input / output of the custom flag ports
input clk1_handshake_flag1;
input clk1_handshake_flag2;
output clk1_handshake_flag3;
output clk1_handshake_flag4;

input handshake_clk2_flag1;
input handshake_clk2_flag2;
output handshake_clk2_flag3;
output handshake_clk2_flag4;

// Remember:
//   Don't modify the signal name
reg sreq;
wire dreq;
reg dack;
wire sack;
reg [31:0] dout_1, dout_2;
NDFF_syn N1(.clk(sclk), .rst_n(rst_n), .D(dack), .Q(sack));
NDFF_syn N2(.clk(dclk), .rst_n(rst_n), .D(sreq), .Q(dreq));
always @(*) begin
    dout = din;
end 
// always @(posedge dclk or negedge rst_n) begin
//     if(!rst_n)begin
//         dout_1 <= 0;
//     end
//     else begin
//         if(dreq)begin
//             dout_1 <= din;
//         end
//         else begin
//             dout_1 <= din;
//         end
//     end
// end
//========================================//
//            SRC crtl                    //
//========================================//
parameter IDLE = 0;
parameter Ready = 1;
parameter Stable = 2;
reg [1:0] cur_state_S;
reg sready_dff;
always@(posedge sclk or negedge rst_n)begin// for JG
	if(!rst_n)begin
		sready_dff <= 0;
	end
	else begin
		sready_dff <= sready;
	end
	
end
always @(posedge sclk or negedge rst_n) begin
    if(!rst_n)begin
        cur_state_S <= 0;
    end
    else begin
        if(cur_state_S == IDLE)begin
            if(sready_dff == 1 && sack == 0)begin
                cur_state_S <= Ready; 
            end
            else begin
                cur_state_S <= cur_state_S;
            end
        end
        else begin
            if(sack == 0)begin
				cur_state_S <= Ready;
			end
			else begin
				cur_state_S <= IDLE;
			end
        end
        /* else begin
            if(sack == 1)begin
                cur_state_S <= IDLE;
            end
            else begin
                cur_state_S <= Stable;
            end
        end */
    end
end
//================================================//
//                  sidle                         //
//================================================//
always @(*) begin
    if(cur_state_S == IDLE)begin
        if(sack == 0)
			sidle = 1;
		else 
			sidle = 0;
    end
	else begin
		sidle = 0;
	end
    /* else if(cur_state_S == Ready)begin
        sidle = 1;
    end
    else begin
        sidle = 0;
    end */
end
//==================================================//
//                    sreq                          //
//==================================================//
always @(posedge sclk or negedge rst_n) begin
    if(!rst_n)begin
        sreq <= 0;
    end
    else begin
        if(cur_state_S == IDLE)begin
            sreq <= 0;
        end
		else begin
			sreq <= 1;
		end
       /*  else if(cur_state_S == Ready)begin
            sreq <= 0;
        end
        else begin
            sreq <= 1;
        end */
    end
end
//======================================//
//              dest                    //
//======================================//
parameter d_IDLE = 0;
parameter d_Receive = 1;
parameter d_reponse = 2;
reg [1:0] cur_state_D;
always @(posedge dclk or negedge rst_n) begin
    if(!rst_n)begin
        cur_state_D <= 0;
    end
    else begin
        if(cur_state_D == d_IDLE)begin
            if(dbusy == 1)begin
                cur_state_D <= d_IDLE;
            end 
            else if(dreq == 1)begin
                cur_state_D <= d_Receive;
            end
            else begin
                cur_state_D <= d_IDLE;
            end
        end
        else if(cur_state_D == d_Receive)begin
            if(dreq == 1)
				cur_state_D <= d_reponse;//here
			else
				cur_state_D <= cur_state_D; 
			//cur_state_D <= d_IDLE;
        end
        else begin
			if(dreq == 0)
				cur_state_D <= d_IDLE;
			else cur_state_D <= cur_state_D;
        end 
    end
end
//=======================================//
//             dvalid                    //
//=======================================//
/* always @(*) begin
    if(cur_state_D == d_IDLE)begin
        dvalid = 0;
    end
    else begin
        dvalid = 1;
    end
end */ 
always@(posedge dclk or negedge rst_n)begin
	if(!rst_n)begin
		dvalid <= 0;
	end
	else begin
		if(cur_state_D == d_IDLE)begin
			dvalid <= 0;
		end
		else begin
            if(dbusy == 0)
			    dvalid <= 1;
            else
                dvalid <= 0;
		end
	end
end 
//=========================================//
//               dack                      //
//=========================================//
always @(posedge dclk or negedge rst_n) begin
    if(!rst_n)begin
        dack <= 0;
    end
    else begin
        if(cur_state_D == d_IDLE)begin
            dack <= 0;
        end
        else if(cur_state_D == d_Receive)begin
            dack <= 1;
        end 
        else begin
            dack <= 1;
        end
    end
end

/* always@(posedge dclk or negedge rst_n)begin
	if(!rst_n)begin
		dout <= 0;
	end
	else begin
		if(cur_state_D == d_IDLE)begin
			dout <= 0;
		end
		else begin
			dout <= din;
		end
	end
	
end */
endmodule