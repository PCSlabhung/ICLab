//############################################################################
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//    (C) Copyright System Integration and Silicon Implementation Laboratory
//    All Right Reserved
//		Date		: 2023/10
//		Version		: v1.0
//   	File Name   : HT_TOP.v
//   	Module Name : HT_TOP
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//############################################################################

//synopsys translate_off
`include "SORT_IP.v"
//synopsys translate_on

module HT_TOP(
    // Input signals
    clk,
	rst_n,
	in_valid,
    in_weight, 
	out_mode,
    // Output signals
    out_valid, 
	out_code
);

// ===============================================================
// Input & Output Declaration
// ===============================================================
input clk, rst_n, in_valid, out_mode;
input [2:0] in_weight;

output reg out_valid, out_code;
//==============================================================//
//                   parameter                                  //
//==============================================================//
parameter Input = 0;
parameter Sort_Huffman = 1;
parameter Huffman = 2;
parameter Out1 = 3;
parameter Out2 = 4;
parameter Out3 = 5;
parameter Out4 = 6;
parameter Out5 = 7;
integer i,j;
// ===============================================================
// Reg & Wire Declaration
// ===============================================================
reg [4:0] array_weight    [7:0];
reg [4:0] array_weight_dff[7:0];
reg [7:0] Node    [7:0];
reg [7:0] Node_dff[7:0];
reg [3:0] count_8, count_8_dff;
reg [2:0] cur_state, nxt_state;
reg [6:0] huffman    [7:0];
reg [6:0] huffman_dff[7:0];
reg [3:0] length     [7:0];
reg [3:0] length_dff [7:0];
reg [31:0] IN_character;
wire [31:0] OUT_character;
reg [39:0] IN_weight;
reg out_valid_comb, out_code_comb, mode, mode_dff;
// ===============================================================
// Design
// ===============================================================
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
        //out_valid <= 0;
        //out_code <= 0;
        cur_state <= 0;
        count_8_dff <= 0;
        mode_dff <= 0;
        Node_dff[7] <= 8'b1000_0000;
        Node_dff[6] <= 8'b0100_0000;
        Node_dff[5] <= 8'b0010_0000;
        Node_dff[4] <= 8'b0001_0000;
        Node_dff[3] <= 8'b0000_1000;
        Node_dff[2] <= 8'b0000_0100;
        Node_dff[1] <= 8'b0000_0010;
        Node_dff[0] <= 8'b0000_0001;
        for(i = 0; i <= 7; i = i + 1)begin
            length_dff[i] <= 0;
            huffman_dff[i] <= 0;
            array_weight_dff[i] <= 0;
        end
    end
    else begin
        //out_code <= out_code_comb;
        //out_valid <= out_valid_comb;
        cur_state <= nxt_state;
        count_8_dff <= count_8;
        mode_dff <= mode;
        for(i = 0; i <= 7; i = i + 1)begin
            huffman_dff[i] <= huffman[i];
            length_dff[i] <= length[i];
            Node_dff[i] <= Node[i]; 
            array_weight_dff[i] <= array_weight[i];
        end
    end
end
//============================================================//
//                   SORT_IP_TA                               // 
//============================================================//
//assign IN_character = {4'd7,4'd6,4'd5,4'd4,4'd3,4'd2,4'd1,4'd0};
//assign IN_weight = { array_weight[7], array_weight[6], array_weight[5], array_weight[4], array_weight[3], array_weight[2], array_weight[1], array_weight[0]};
SORT_IP #(.IP_WIDTH(8)) I_SORT_IP(.IN_character(IN_character), .IN_weight(IN_weight), .OUT_character(OUT_character));
assign IN_character = { 4'd7, 4'd6, 4'd5, 4'd4, 4'd3, 4'd2, 4'd1, 4'd0};
assign IN_weight = {array_weight_dff[7], array_weight_dff[6], array_weight_dff[5], array_weight_dff[4], array_weight_dff[3], array_weight_dff[2], array_weight_dff[1], array_weight_dff[0]};

//============================================================//
//                         FSM                                //
//============================================================//
always @(*) begin
    if(cur_state == Input)begin
        out_code = 0;
        out_valid = 0;
        count_8 = 0;
        if(in_valid)begin
            count_8 = count_8_dff + 1;
        end
        if(count_8_dff == 7)begin
            nxt_state = Sort_Huffman;  
            count_8 = 7;   
        end
        else begin
            nxt_state = Input;
        end
    end
    else if(cur_state == Sort_Huffman)begin
        out_code = 0;
        out_valid = 0;
        nxt_state = Huffman;
        count_8 = count_8_dff - 1;
        //if(count_8_dff == 1)begin
        if(count_8_dff == 0)begin
            nxt_state = Out1;
        end
        else begin
            nxt_state = Sort_Huffman;
        end
    end
    else if(cur_state == Out1)begin
        //length[3] = length_dff[3] - 1;
        count_8 = 0;
        out_valid = 1;
        out_code = huffman_dff[3][6];
        if(length_dff[3] == 1)begin
            nxt_state = Out2;
        end
        else begin
            nxt_state = Out1;
        end
    end
    else if(cur_state == Out2)begin
        count_8 = 0;
        out_valid = 1;
        if(mode_dff == 0)begin
            //length[2] = length_dff[2] - 1;
            out_code = huffman_dff[2][6];
            if(length_dff[2] == 1)begin
                nxt_state = Out3;
            end
            else begin
                nxt_state = Out2;
            end
        end
        else begin
            //length[5] = length_dff[5] - 1;
            out_code = huffman_dff[5][6];
            if(length_dff[5] == 1)begin
                nxt_state = Out3;
            end
            else begin
                nxt_state = Out2;
            end
        end
    end
    else if(cur_state == Out3)begin
        count_8 = 0;
        out_valid = 1;
        if(mode_dff == 0)begin
            out_code = huffman_dff[1][6];
            if(length_dff[1] == 1)begin
                nxt_state = Out4;
            end
            else begin
                nxt_state = Out3;
            end
        end
        else begin
            out_code = huffman_dff[2][6];
            if(length_dff[2] == 1)begin
                nxt_state = Out4;
            end
            else begin
                nxt_state = Out3;
            end
        end
    end
    else if(cur_state == Out4)begin
        count_8 = 0;
        out_valid = 1;
        if(mode_dff == 0)begin
            out_code = huffman_dff[0][6];
            if(length_dff[0] == 1)begin
                nxt_state = Out5;
            end
            else begin
                nxt_state = Out4;
            end
        end
        else begin
            out_code = huffman_dff[7][6];
            if(length_dff[7] == 1)begin
                nxt_state = Out5;
            end
            else begin
                nxt_state = Out4;
            end
        end
    end
    //Out5 state
    else begin
        count_8 = 0;
        out_valid = 1;
        if(mode_dff == 0)begin
            out_code = huffman_dff[4][6];
            if(length_dff[4] == 1)begin
                nxt_state = Input;
            end
            else begin
                nxt_state = Out5;
            end
        end
        else begin
            out_code = huffman_dff[6][6];
            if(length_dff[6] == 1)begin
                nxt_state = Input;
            end
            else begin
                nxt_state = Out5;
            end
        end
    end
    
end
//===========================================================//
//                    input                                  //
//===========================================================//
always @(*) begin
    if(cur_state == Input)begin
        for(i = 0; i < 8; i = i + 1)begin
            array_weight[i] = array_weight_dff[i];
        end
        mode = mode_dff;
        if(in_valid)begin
            for(i = 7; i > 0; i = i - 1)begin
                array_weight[i] = array_weight_dff[i - 1];
            end
            array_weight[0] = in_weight;
        end
        if(in_valid && count_8_dff == 0)begin
            mode = out_mode;
        end
    end
    else if(cur_state == Sort_Huffman)begin
        mode = mode_dff;
        for(i = 0; i < 8; i = i + 1)begin
            array_weight[i] = array_weight_dff[i];
        end
        if(count_8_dff == 7)begin
            for(i = 7; i >= 0; i = i - 1)begin
                case(OUT_character[(i + 1)*4 - 1 -: 4])
                    0:array_weight[i] = array_weight_dff[0];
                    1:array_weight[i] = array_weight_dff[1];
                    2:array_weight[i] = array_weight_dff[2];
                    3:array_weight[i] = array_weight_dff[3];
                    4:array_weight[i] = array_weight_dff[4];
                    5:array_weight[i] = array_weight_dff[5];
                    6:array_weight[i] = array_weight_dff[6];
                    7:array_weight[i] = array_weight_dff[7];
                    default:array_weight[i] = 0;
                endcase
            end
            array_weight[0] = 0;
            array_weight[1] = array_weight_dff[OUT_character[3:0]] + array_weight_dff[OUT_character[7:4]];
        end
        else if(count_8_dff == 6)begin
            for(i = 7; i >= 1; i = i - 1)begin
                case(OUT_character[(i + 1)*4 - 1 -: 4])
                    1:array_weight[i] = array_weight_dff[1];
                    2:array_weight[i] = array_weight_dff[2];
                    3:array_weight[i] = array_weight_dff[3];
                    4:array_weight[i] = array_weight_dff[4];
                    5:array_weight[i] = array_weight_dff[5];
                    6:array_weight[i] = array_weight_dff[6];
                    7:array_weight[i] = array_weight_dff[7];
                    default:array_weight[i] = 0;
                endcase
            end
            array_weight[1] = 0;
            array_weight[2] = array_weight_dff[OUT_character[7:4]] + array_weight_dff[OUT_character[11:8]];
        end
        else if(count_8_dff == 5)begin
            for(i = 7; i >= 2; i = i - 1)begin
                case(OUT_character[(i + 1)*4 - 1 -: 4])
                    2:array_weight[i] = array_weight_dff[2];
                    3:array_weight[i] = array_weight_dff[3];
                    4:array_weight[i] = array_weight_dff[4];
                    5:array_weight[i] = array_weight_dff[5];
                    6:array_weight[i] = array_weight_dff[6];
                    7:array_weight[i] = array_weight_dff[7];
                    default:array_weight[i] = 0;
                endcase
            end
            array_weight[2] = 0;
            array_weight[3] = array_weight_dff[OUT_character[11:8]] + array_weight_dff[OUT_character[15:12]];
        end
        else if(count_8_dff == 4)begin
            for(i = 7; i >= 3; i = i - 1)begin
                case(OUT_character[(i + 1)*4 - 1 -: 4])
                    3:array_weight[i] = array_weight_dff[3];
                    4:array_weight[i] = array_weight_dff[4];
                    5:array_weight[i] = array_weight_dff[5];
                    6:array_weight[i] = array_weight_dff[6];
                    7:array_weight[i] = array_weight_dff[7];
                    default:array_weight[i] = 0;
                endcase
            end
            array_weight[3] = 0;
            array_weight[4] = array_weight_dff[OUT_character[15:12]] + array_weight_dff[OUT_character[19:16]];
        end
        else if(count_8_dff == 3)begin
            for(i = 7; i >= 4; i = i - 1)begin
                case(OUT_character[(i + 1)*4 - 1 -: 4])
                    4:array_weight[i] = array_weight_dff[4];
                    5:array_weight[i] = array_weight_dff[5];
                    6:array_weight[i] = array_weight_dff[6];
                    7:array_weight[i] = array_weight_dff[7];
                    default:array_weight[i] = 0;
                endcase
            end
            array_weight[4] = 0;
            array_weight[5] = array_weight_dff[OUT_character[19:16]] + array_weight_dff[OUT_character[23:20]];
        end
        else if(count_8_dff == 2)begin
            for(i = 7; i >= 5; i = i - 1)begin
                case(OUT_character[(i + 1)*4 - 1 -: 4])
                    5:array_weight[i] = array_weight_dff[5];
                    6:array_weight[i] = array_weight_dff[6];
                    7:array_weight[i] = array_weight_dff[7];
                    default:array_weight[i] = 0;
                endcase
            end
            array_weight[5] = 0;
            array_weight[6] = array_weight_dff[OUT_character[23:20]] + array_weight_dff[OUT_character[27:24]];
        end
        else if(count_8_dff == 1)begin
            for(i = 0; i < 8; i = i + 1)begin
                array_weight[i] = array_weight_dff[i];
            end
        end
        else begin
            array_weight[6] = 0;
            array_weight[7] = 0;
        end
    end
    else begin
        for(i = 0; i < 8; i = i + 1)begin
            array_weight[i] = array_weight_dff[i];
        end
        mode = mode_dff;
    end
end

//==========================================================//
//                Node     mux                              //
//==========================================================//
always @(*) begin
    if(cur_state == Sort_Huffman)begin
        for(i = 0 ; i < 8; i = i + 1)begin
            Node[i] = Node_dff[i];
            huffman[i] = huffman_dff[i];
            length[i] = length_dff[i];
        end
        if(count_8_dff == 7)begin
            for(i = 7 ; i >= 0 ; i = i - 1)begin
                case(OUT_character[(i + 1)*4 - 1 -: 4])
                    0:Node[i] = Node_dff[0];
                    1:Node[i] = Node_dff[1];
                    2:Node[i] = Node_dff[2];
                    3:Node[i] = Node_dff[3];
                    4:Node[i] = Node_dff[4];
                    5:Node[i] = Node_dff[5];
                    6:Node[i] = Node_dff[6];
                    7:Node[i] = Node_dff[7];
                    default:Node[i] = 0;
                endcase
            end
            // for(i = 7; i >= 0 ;i = i - 1)begin
            //     if(Node[0][i] == 1)begin
            //         huffman[i] = huffman_dff[i] >> 1;
            //         huffman[i][6] = 1'b1;
            //         length[i] = length_dff[i] + 1;
            //     end
            // end
            // for(i = 7; i >= 0; i = i - 1)begin
            //     if(Node[1][i] == 1)begin
            //         huffman[i] = huffman_dff[i] >> 1;
            //         huffman[i][6] = 1'b0;
            //         length[i] = length_dff[i] + 1;
            //     end
            // end
            //Node[0] = 0;
            //Node[1] = Node_dff[OUT_character[3:0]] | Node_dff[OUT_character[7:4]];
        end
        else if(count_8_dff == 6)begin
            for(i = 7; i >= 0; i = i - 1)begin
                if(Node_dff[0][i] == 1)begin
                    huffman[i] = huffman_dff[i] >> 1;
                    huffman[i][6] = 1'b1;
                    length[i] = length_dff[i] + 1;
                end
            end
            for(i = 7;i >= 0;i = i - 1)begin
                if(Node_dff[1][i] == 1)begin
                    huffman[i] = huffman_dff[i] >> 1;
                    huffman[i][6] = 1'b0;
                    length[i] = length_dff[i] + 1;
                end
            end
            Node[0] = 0;
            for(i = 7 ; i >= 1; i = i - 1)begin
                case(OUT_character[(i+1)*4 -1 -: 4])
                    7:Node[i] = Node_dff[7];
                    6:Node[i] = Node_dff[6];
                    5:Node[i] = Node_dff[5];
                    4:Node[i] = Node_dff[4];
                    3:Node[i] = Node_dff[3];
                    2:Node[i] = Node_dff[2];
                    1:Node[i] = Node_dff[0] | Node_dff[1];
                    default: Node[i] = 0;
                endcase
            end
            //Node[1] = 0;
            //Node[2] = Node_dff[OUT_character[7:4]] | Node_dff[OUT_character[11:8]];
        end
        else if(count_8_dff == 5)begin
            for(i = 7; i >= 0; i = i - 1)begin
                if(Node_dff[1][i] == 1)begin
                    huffman[i] = huffman_dff[i] >> 1;
                    huffman[i][6] = 1'b1;
                    length[i] = length_dff[i] + 1;
                end
            end
            for(i = 7; i >= 0; i = i - 1)begin
                if(Node_dff[2][i] == 1)begin
                    huffman[i] = huffman_dff[i] >> 1;
                    huffman[i][6] = 1'b0;
                    length[i] = length_dff[i] + 1;
                end
            end
            Node[1] = 0;
            for(i = 7 ; i >= 2; i = i - 1)begin
                case(OUT_character[(i+1)*4 -1 -: 4])
                    7:Node[i] = Node_dff[7];
                    6:Node[i] = Node_dff[6];
                    5:Node[i] = Node_dff[5];
                    4:Node[i] = Node_dff[4];
                    3:Node[i] = Node_dff[3];
                    2:Node[i] = Node_dff[2] | Node_dff[1];
                    default: Node[i] = 0;
                endcase
            end
            //Node[2] = 0;
            //Node[3] = Node_dff[OUT_character[11:8]] | Node_dff[OUT_character[15:12]];
        end
        else if(count_8_dff == 4)begin
            for(i = 7; i >= 0; i = i - 1)begin
                if(Node_dff[2][i] == 1)begin
                    huffman[i] = huffman_dff[i] >> 1;
                    huffman[i][6] = 1'b1;
                    length[i] = length_dff[i] + 1;
                end
            end
            for(i = 7; i >= 0; i = i - 1)begin
                if(Node_dff[3][i] == 1)begin
                    huffman[i] = huffman_dff[i] >> 1;
                    huffman[i][6] = 1'b0;
                    length[i] = length_dff[i] + 1;
                end
            end
            Node[2] = 0;
            for(i = 7;i >= 3; i = i - 1)begin
                case(OUT_character[(i+1)*4 -1 -: 4])
                    7:Node[i] = Node_dff[7];
                    6:Node[i] = Node_dff[6];
                    5:Node[i] = Node_dff[5];
                    4:Node[i] = Node_dff[4];
                    3:Node[i] = Node_dff[3] | Node_dff[2];
                    default: Node[i] = 0;
                endcase
            end
            //Node[3] = 0;
            //Node[4] = Node_dff[OUT_character[15:12]] | Node_dff[OUT_character[19:16]];
        end
        else if(count_8_dff == 3)begin
            for(i = 7; i >= 0; i = i - 1)begin
                if(Node_dff[3][i] == 1)begin
                    huffman[i] = huffman_dff[i] >> 1;
                    huffman[i][6] = 1'b1;
                    length[i] = length_dff[i] + 1;
                end
            end
            for(i = 7;i >= 0;i = i - 1)begin
                if(Node_dff[4][i] == 1)begin
                    huffman[i] = huffman_dff[i] >> 1;
                    huffman[i][6] = 1'b0;
                    length[i] = length_dff[i] + 1;
                end
            end
            Node[3] = 0;
            for(i = 7;i >= 4; i = i - 1)begin
                case(OUT_character[(i+1)*4 -1 -: 4])
                    7:Node[i] = Node_dff[7];
                    6:Node[i] = Node_dff[6];
                    5:Node[i] = Node_dff[5];
                    4:Node[i] = Node_dff[4] | Node_dff[3];
                    default: Node[i] = 0;
                endcase
            end
            //Node[4] = 0;
            //Node[5] = Node_dff[OUT_character[23:20]] | Node_dff[OUT_character[19:16]];
        end
        else if(count_8_dff == 2)begin
            for(i = 7; i >= 0;i = i - 1)begin
                if(Node_dff[4][i] == 1)begin
                    huffman[i] = huffman_dff[i] >> 1;
                    huffman[i][6] = 1'b1;
                    length[i] = length_dff[i] + 1;
                end
            end
            for(i = 7; i >= 0;i = i - 1)begin
                if(Node_dff[5][i] == 1)begin
                    huffman[i] = huffman_dff[i] >> 1;
                    huffman[i][6] = 1'b0;
                    length[i] = length_dff[i] + 1;
                end
            end
            Node[4] = 0;
            for(i = 7;i >= 5; i = i - 1)begin
                case(OUT_character[(i+1)*4 -1 -: 4])
                    7:Node[i] = Node_dff[7];
                    6:Node[i] = Node_dff[6];
                    5:Node[i] = Node_dff[5] | Node_dff[4];
                    default: Node[i] = 0;
                endcase
            end
            //Node[5] = 0;
            //Node[6] = Node_dff[OUT_character[27:24]] | Node_dff[OUT_character[23:20]];
        end
        else if(count_8_dff == 1)begin
            for(i = 7 ; i >= 0; i = i - 1)begin
                if(Node_dff[5][i] == 1)begin
                    huffman[i] = huffman_dff[i] >> 1;
                    huffman[i][6] = 1'b1;
                    length[i] = length_dff[i] + 1;
                end
            end
            for(i = 7; i >= 0;i = i - 1)begin
                if(Node_dff[6][i] == 1)begin
                    huffman[i] = huffman_dff[i] >> 1;
                    huffman[i][6] = 1'b0;
                    length[i] = length_dff[i] + 1;
                end
            end
            Node[5] = 0;
            if(array_weight_dff[7] < array_weight_dff[6])begin
                Node[7] = Node_dff[6] | Node_dff[5];
                Node[6] = Node_dff[7];
            end
            else begin
                Node[7] = Node_dff[7];
                Node[6] = Node_dff[6] | Node_dff[5]; 
            end
            
        end
        else if(count_8_dff == 0)begin
            for(i = 7 ; i >= 0; i = i - 1)begin
                if(Node_dff[7][i] == 1)begin
                    huffman[i] = huffman_dff[i] >> 1;
                    huffman[i][6] = 1'b0;
                    length[i] = length_dff[i] + 1;
                end
            end
            for(i = 7; i >= 0;i = i - 1)begin
                if(Node_dff[6][i] == 1)begin
                    huffman[i] = huffman_dff[i] >> 1;
                    huffman[i][6] = 1'b1;
                    length[i] = length_dff[i] + 1;
                end
            end
            Node[6] = 0;
            Node[7] = 0; 
        end
    end
    else if(cur_state == Out1)begin
        Node[7] = 8'b1000_0000;
        Node[6] = 8'b0100_0000;
        Node[5] = 8'b0010_0000;
        Node[4] = 8'b0001_0000;
        Node[3] = 8'b0000_1000;
        Node[2] = 8'b0000_0100;
        Node[1] = 8'b0000_0010;
        Node[0] = 8'b0000_0001;
        for(i = 0; i < 8;i = i + 1)begin
            huffman[i] = huffman_dff[i];
            length[i] = length_dff[i];
        end
        for(i = 6;i > 0; i = i - 1)begin
            huffman[3][i] = huffman_dff[3][i - 1];
        end
        huffman[3][0] = 0;
        length[3] = length_dff[3] - 1;
    end
    else if(cur_state == Out2)begin
        for(i = 0; i < 8;i = i + 1)begin
            huffman[i] = huffman_dff[i];
            length[i] = length_dff[i];
            Node[i] = Node_dff[i];
        end
        if(mode_dff == 0)begin
            for(i = 6;i > 0; i = i - 1)begin
                huffman[2][i] = huffman_dff[2][i - 1];
            end
            huffman[2][0] = 0;
            length[2] = length_dff[2] - 1;
        end
        else begin
            for(i = 6;i > 0; i = i - 1)begin
                huffman[5][i] = huffman_dff[5][i - 1];
            end
            huffman[5][0] = 0;
            length[5] = length_dff[5] - 1;
        end
    end
    else if(cur_state == Out3)begin
        for(i = 0; i < 8;i = i + 1)begin
            huffman[i] = huffman_dff[i];
            length[i] = length_dff[i];
            Node[i] = Node_dff[i];
        end
        if(mode_dff == 0)begin
            for(i = 6;i > 0; i = i - 1)begin
                huffman[1][i] = huffman_dff[1][i - 1];
            end
            huffman[1][0] = 0;
            length[1] = length_dff[1] - 1;
        end
        else begin
            for(i = 6;i > 0; i = i - 1)begin
                huffman[2][i] = huffman_dff[2][i - 1];
            end
            huffman[2][0] = 0;
            length[2] = length_dff[2] - 1;
        end
    end
    else if(cur_state == Out4)begin
        for(i = 0; i < 8;i = i + 1)begin
            huffman[i] = huffman_dff[i];
            length[i] = length_dff[i];
            Node[i] = Node_dff[i];
        end
        if(mode_dff == 0)begin
            for(i = 6;i > 0; i = i - 1)begin
                huffman[0][i] = huffman_dff[0][i - 1];
            end
            huffman[0][0] = 0;
            length[0] = length_dff[0] - 1;
        end
        else begin
            for(i = 6;i > 0; i = i - 1)begin
                huffman[7][i] = huffman_dff[7][i - 1];
            end
            huffman[7][0] = 0;
            length[7] = length_dff[7] - 1;
        end
    end
    else if(cur_state == Out5)begin
        for(i = 0; i < 8;i = i + 1)begin
            huffman[i] = huffman_dff[i];
            length[i] = length_dff[i];
            Node[i] = Node_dff[i];
        end
        if(mode_dff == 0)begin
            for(i = 6;i > 0; i = i - 1)begin
                huffman[4][i] = huffman_dff[4][i - 1];
            end
            huffman[4][0] = 0;
            length[4] = length_dff[4] - 1;
        end
        else begin
            for(i = 6;i > 0; i = i - 1)begin
                huffman[6][i] = huffman_dff[6][i - 1];
            end
            huffman[6][0] = 0;
            length[6] = length_dff[6] - 1;
        end
    end
    else begin
        for(i = 0; i < 8; i = i + 1)begin
            Node[i] = Node_dff[i];
            huffman[i] = 0;
            length[i] = 0;
        end
    end
end
endmodule
