//############################################################################
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//    (C) Copyright System Integration and Silicon Implementation Laboratory
//    All Right Reserved
//		Date		: 2023/10
//		Version		: v1.0
//   	File Name   : SORT_IP.v
//   	Module Name : SORT_IP
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//############################################################################
module SORT_IP #(parameter IP_WIDTH = 8) (
    // Input signals
    IN_character, IN_weight,
    // Output signals
    OUT_character
);

// ===============================================================
// Input & Output
// ===============================================================
input [IP_WIDTH*4-1:0]  IN_character;
input [IP_WIDTH*5-1:0]  IN_weight;

output reg [IP_WIDTH*4-1:0] OUT_character;
genvar a, b;
integer i,j;
wire [3:0] array_char [IP_WIDTH:0][IP_WIDTH - 1:0];
wire [4:0] array_weight [IP_WIDTH:0][IP_WIDTH - 1:0];
reg [3:0] temp_char;
reg [4:0] temp_weight;
// ===============================================================
// Design
// ===============================================================

generate
    for(a = 1; a <= IP_WIDTH; a = a + 1)begin
        assign array_char[0][a - 1] = IN_character[a*4 - 1 -: 4];
        assign array_weight[0][a - 1] = IN_weight[a*5 - 1 -: 5];
    end
    if(IP_WIDTH % 2 == 0)begin
        for(a = 0; a < IP_WIDTH; a = a + 1)begin
            if(a % 2 == 0)begin
                for(b = 0; b < IP_WIDTH - 1;b = b + 2)begin
                    assign array_weight[a + 1][b] = (array_weight[a][b] > array_weight[a][b + 1])? array_weight[a][b + 1] : array_weight[a][b];
                    assign array_weight[a + 1][b + 1] = (array_weight[a][b] > array_weight[a][b + 1])? array_weight[a][b] : array_weight[a][b + 1];
                    assign array_char[a + 1][b] = (array_weight[a][b] > array_weight[a][b + 1])? array_char[a][b + 1] : array_char[a][b];
                    assign array_char[a + 1][b + 1] = (array_weight[a][b] > array_weight[a][b + 1])? array_char[a][b] : array_char[a][b + 1];
                
                end
            end
            else begin
                assign array_weight[a + 1][0] = array_weight[a][0];
                assign array_weight[a + 1][IP_WIDTH - 1] = array_weight[a][IP_WIDTH - 1];
                assign array_char[a + 1][0] = array_char[a][0]; 
                assign array_char[a + 1][IP_WIDTH-1] = array_char[a][IP_WIDTH - 1];
                for(b = 1; b < IP_WIDTH - 1;b = b + 2)begin
                    //if(array_weight[a][b] > array_weight[a][b + 1])begin
                    assign array_weight[a + 1][b] = (array_weight[a][b] > array_weight[a][b + 1])? array_weight[a][b + 1] : array_weight[a][b];
                    assign array_weight[a + 1][b + 1] = (array_weight[a][b] > array_weight[a][b + 1])? array_weight[a][b] : array_weight[a][b + 1];
                    assign array_char[a + 1][b] = (array_weight[a][b] > array_weight[a][b + 1])? array_char[a][b + 1] : array_char[a][b] ;
                    assign array_char[a + 1][b + 1] = (array_weight[a][b] > array_weight[a][b + 1])? array_char[a][b] : array_char[a][b + 1];
                end
            end
        end
    end
    else begin
        for(a = 0; a < IP_WIDTH; a = a + 1)begin
            if(a % 2 == 0)begin
                assign array_weight[a + 1][IP_WIDTH - 1] = array_weight[a][IP_WIDTH - 1];
                assign array_char[a + 1][IP_WIDTH - 1] = array_char[a][IP_WIDTH - 1]; 
                for(b = 0; b < IP_WIDTH - 1;b = b + 2)begin
                    assign array_weight[a + 1][b] = (array_weight[a][b] > array_weight[a][b + 1])? array_weight[a][b + 1] : array_weight[a][b];
                    assign array_weight[a + 1][b + 1] = (array_weight[a][b] > array_weight[a][b + 1])? array_weight[a][b] : array_weight[a][b + 1];
                    assign array_char[a + 1][b] = (array_weight[a][b] > array_weight[a][b + 1])? array_char[a][b + 1] : array_char[a][b];
                    assign array_char[a + 1][b + 1] = (array_weight[a][b] > array_weight[a][b + 1])? array_char[a][b] : array_char[a][b + 1];
                
                end
            end
            else begin
                assign array_weight[a + 1][0] = array_weight[a][0];
                assign array_char[a + 1][0] = array_char[a][0]; 
                for(b = 1; b < IP_WIDTH - 1;b = b + 2)begin
                    //if(array_weight[a][b] > array_weight[a][b + 1])begin
                    assign array_weight[a + 1][b] = (array_weight[a][b] > array_weight[a][b + 1])? array_weight[a][b + 1] : array_weight[a][b];
                    assign array_weight[a + 1][b + 1] = (array_weight[a][b] > array_weight[a][b + 1])? array_weight[a][b] : array_weight[a][b + 1];
                    assign array_char[a + 1][b] = (array_weight[a][b] > array_weight[a][b + 1])? array_char[a][b + 1] : array_char[a][b] ;
                    assign array_char[a + 1][b + 1] = (array_weight[a][b] > array_weight[a][b + 1])? array_char[a][b] : array_char[a][b + 1];
                end
            end
        end
    end
   
    for(a = 1; a <= IP_WIDTH; a = a + 1)begin
        assign OUT_character[a*4-1 -: 4] = array_char[IP_WIDTH][a-1];
    end
endgenerate

endmodule