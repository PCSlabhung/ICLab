
module CAD(//output
    out_valid,out_value,
    //input
    clk, rst_n, in_valid, in_valid2,
	mode, matrix, matrix_size, matrix_idx
);
input clk, rst_n, in_valid, in_valid2, mode;
input [7:0] matrix;
input [1:0] matrix_size;
input [3:0] matrix_idx;
output reg out_valid, out_value;
//===================================================//
//                  parameter                        //
//===================================================//
parameter Input_1 = 0;
parameter Input_kernel = 1;
parameter Input_2 = 2;
parameter Inti_M_K = 3;
parameter Stall = 4;
parameter Maxpool = 5;
parameter Stall2 = 6;
parameter Out = 7;
//================================================//
//             genvar & integer                   //
//================================================//
genvar  a,b;
integer i,j,k;

reg [3:0]  counter_outer, counter_outer_dff;
reg [9:0]  counter_address , counter_address_dff ; 
reg [8:0]  counter_address_kernel , counter_address_kernel_dff;
reg [10:0] counter_address_out , counter_address_out_dff;
reg [10:0] counter_address_out_2, counter_address_out_2_dff, counter_address_out_2_dff_delay;
reg [2:0]  Matrix_size, Matrix_size_dff;
reg [3:0]  cur_state, nxt_state; 
reg [3:0]  Matrix_idx, Matrix_idx_dff, Kernel_idx, Kernel_idx_dff;
reg Mode,  Mode_dff;
reg true_out_comb;
reg out_valid_comb;
reg signed [7:0] Conv_image_or_deConv_out [0:4][0:4];
reg signed [7:0] Kernel_Cal [0:4][0:4];
reg signed [7:0] Conv_out_or_deConv_image;
reg signed [7:0] Conv_image_or_deConv_out_dff [0:4][0:4];
reg signed [7:0] Kernel_Cal_dff [0:4][0:4];
reg signed [7:0] Conv_out_or_deConv_image_dff;
reg signed [7:0] mult_input , mult_input_dff;
reg signed [7:0] mult_input2, mult_input2_dff;
reg signed [19:0] Conv_deConv_out, Conv_deConv_out_dff;
reg signed [19:0] to_minus, to_minus_dff;
reg signed [19:0] to_mem, to_mem_dff;
reg signed [19:0] out_value_dff, out_comb;
reg signed [19:0] max_pooling, max_pooling_dff;
reg [11:0] counter, counter_dff;
reg [4:0] counter_25, counter_25_dff, counter_25_dff_delay;
reg [3:0] cur_state_delay, cur_state_delay_delay;
//========================================================================//
//          input and output and counter and FSM register                 //
//========================================================================//
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
        Matrix_size_dff <= 0;
        counter_address_dff <= 0;
        counter_address_kernel_dff <= 0;
        counter_outer_dff <= 0;
        counter_address_out_dff <= 0;
        counter_address_out_2_dff <= 1;
        counter_address_out_2_dff_delay <= 0;
        counter_dff <= 0;
        cur_state <= 0;
        out_valid <= 0;
        out_value <= 0;
        Matrix_idx_dff <= 0;
        Kernel_idx_dff <= 0;
        Mode_dff <= 0;
    end
    else begin
        counter_dff <= counter;
        Matrix_size_dff <= Matrix_size;
        counter_address_dff <= counter_address;
        counter_address_kernel_dff <= counter_address_kernel;
        counter_outer_dff <= counter_outer;
        counter_address_out_dff <= counter_address_out;
        counter_address_out_2_dff <= counter_address_out_2;
        counter_address_out_2_dff_delay <= counter_address_out_2_dff;
        out_valid <= out_valid_comb;
        out_value <= true_out_comb;
        cur_state <= nxt_state;
        Matrix_idx_dff <= Matrix_idx;
        Kernel_idx_dff <= Kernel_idx;
        Mode_dff <= Mode;
    end
end

//===================================================//
//              calculation register                 //
//===================================================//
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
        for(i = 0; i < 5; i = i + 1)begin
            for(j = 0; j < 5; j = j + 1)begin
                Conv_image_or_deConv_out_dff[i][j] <= 0;
                Kernel_Cal_dff[i][j] <= 0;
            end
        end
        Conv_out_or_deConv_image_dff <= 0;
    end
    else begin
        for(i = 0; i < 5; i = i + 1)begin
            for(j = 0; j < 5; j = j + 1)begin
                Conv_image_or_deConv_out_dff[i][j] <= Conv_image_or_deConv_out[i][j];
                Kernel_Cal_dff[i][j] <= Kernel_Cal[i][j];
            end
        end
        Conv_out_or_deConv_image_dff <= Conv_out_or_deConv_image;
    end
end
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
        mult_input2_dff <= 0;
        mult_input_dff <= 0;
        Conv_deConv_out_dff <= 0;
        to_minus_dff <= 0;
        to_mem_dff <= 0;
    end
    else begin
        mult_input2_dff <= mult_input2;
        mult_input_dff <= mult_input;
        Conv_deConv_out_dff <= Conv_deConv_out;
        to_minus_dff <= to_minus;
        to_mem_dff <= to_mem;
    end
end


//===============================================================//
//                     memory varible                            //
//===============================================================// 
reg signed [7:0] in_f_map_data_out [0:15];
reg in_f_map_WEB[0:15]; 

reg signed [7:0] kernel_data_out;
reg kernel_WEB;
reg [8:0] kernel_address;

reg signed [19:0] out_f_map_data_out;
reg signed [19:0] out_f_map_data_out_2;
reg signed [19:0] out_f_map_data_out_2_dff;
reg out_f_map_WEB,out_f_map_WEB_dff;

reg [4:0] counter_row_kernel, counter_row_kernel_dff ,counter_column_kernel, counter_column_kernel_dff;
reg [2:0] counter_0to4_row, counter_0to4_row_dff,counter_0to4_column, counter_0to4_column_dff;
//================================================================//
//                  kernel & image & output Memory                //
//================================================================//
generate
    for(a = 0; a < 16; a = a + 1)begin
        input_feature_map input_feature_map_1(.A0(counter_address_dff[0]), .A1(counter_address_dff[1]), .A2(counter_address_dff[2]), .A3(counter_address_dff[3]), .A4(counter_address_dff[4]),
                                        .A5(counter_address_dff[5]), .A6(counter_address_dff[6]), .A7(counter_address_dff[7]), .A8(counter_address_dff[8]), .A9(counter_address_dff[9]),
                                        .DI0(matrix[0]), .DI1(matrix[1]), .DI2(matrix[2]),.DI3(matrix[3]), .DI4(matrix[4]),
                                        .DI5(matrix[5]), .DI6(matrix[6]), .DI7(matrix[7]),
                                        .DO0(in_f_map_data_out[a][0]), .DO1(in_f_map_data_out[a][1]), .DO2(in_f_map_data_out[a][2]),.DO3(in_f_map_data_out[a][3]), .DO4(in_f_map_data_out[a][4]),
                                        .DO5(in_f_map_data_out[a][5]), .DO6(in_f_map_data_out[a][6]), .DO7(in_f_map_data_out[a][7]),
                                        .CK(clk), .WEB(in_f_map_WEB[a]), .OE(1'b1), .CS(1'b1)
                                            );
    end
endgenerate

kernel kernel_map(.A0(kernel_address[0]), .A1(kernel_address[1]), .A2(kernel_address[2]), .A3(kernel_address[3]), .A4(kernel_address[4]),
                .A5(kernel_address[5]), .A6(kernel_address[6]), .A7(kernel_address[7]), .A8(kernel_address[8]),
                .DI0(matrix[0]), .DI1(matrix[1]), .DI2(matrix[2]),.DI3(matrix[3]), .DI4(matrix[4]),
                .DI5(matrix[5]), .DI6(matrix[6]), .DI7(matrix[7]),
                .DO0(kernel_data_out[0]), .DO1(kernel_data_out[1]), .DO2(kernel_data_out[2]),.DO3(kernel_data_out[3]), .DO4(kernel_data_out[4]),
                .DO5(kernel_data_out[5]), .DO6(kernel_data_out[6]), .DO7(kernel_data_out[7]),
                .CK(clk), .WEB(kernel_WEB), .OE(1'b1), .CS(1'b1)
                    );
assign kernel_address = (cur_state == Input_kernel)? counter_address_dff[8:0] : counter_address_kernel_dff;

out_MEM_true output_feature_map( .A0(counter_address_out_dff[0]), .A1(counter_address_out_dff[1]), .A2(counter_address_out_dff[2]), .A3(counter_address_out_dff[3]), .A4(counter_address_out_dff[4]),
                            .A5(counter_address_out_dff[5]), .A6(counter_address_out_dff[6]), .A7(counter_address_out_dff[7]), .A8(counter_address_out_dff[8]), .A9(counter_address_out_dff[9]),
                            .A10(counter_address_out_dff[10]),
                            .B0(counter_address_out_2_dff[0]), .B1(counter_address_out_2_dff[1]), .B2(counter_address_out_2_dff[2]), .B3(counter_address_out_2_dff[3]), .B4(counter_address_out_2_dff[4]),
                            .B5(counter_address_out_2_dff[5]), .B6(counter_address_out_2_dff[6]), .B7(counter_address_out_2_dff[7]), .B8(counter_address_out_2_dff[8]), .B9(counter_address_out_2_dff[9]),
                            .B10(counter_address_out_2_dff[10]),
                            .DIA0(to_mem[0]), .DIA1(to_mem[1]), .DIA2(to_mem[2]), .DIA3(to_mem[3]), .DIA4(to_mem[4]), .DIA5(to_mem[5]), .DIA6(to_mem[6]), .DIA7(to_mem[7]), .DIA8(to_mem[8]), .DIA9(to_mem[9]), 
                            .DIA10(to_mem[10]), .DIA11(to_mem[11]), .DIA12(to_mem[12]), .DIA13(to_mem[13]), .DIA14(to_mem[14]), .DIA15(to_mem[15]), .DIA16(to_mem[16]), .DIA17(to_mem[17]), .DIA18(to_mem[18]), .DIA19(to_mem[19]),
                            .DIB0(to_mem[0]), .DIB1(to_mem[1]), .DIB2(to_mem[2]), .DIB3(to_mem[3]), .DIB4(to_mem[4]), .DIB5(to_mem[5]), .DIB6(to_mem[6]), .DIB7(to_mem[7]), .DIB8(to_mem[8]), .DIB9(to_mem[9]), 
                            .DIB10(to_mem[10]), .DIB11(to_mem[11]), .DIB12(to_mem[12]), .DIB13(to_mem[13]), .DIB14(to_mem[14]), .DIB15(to_mem[15]), .DIB16(to_mem[16]), .DIB17(to_mem[17]), .DIB18(to_mem[18]), .DIB19(to_mem[19]),
                            .DOA0(out_f_map_data_out[0]), .DOA1(out_f_map_data_out[1]), .DOA2(out_f_map_data_out[2]), .DOA3(out_f_map_data_out[3]), .DOA4(out_f_map_data_out[4]), .DOA5(out_f_map_data_out[5]),
                            .DOA6(out_f_map_data_out[6]), .DOA7(out_f_map_data_out[7]), .DOA8(out_f_map_data_out[8]), .DOA9(out_f_map_data_out[9]), .DOA10(out_f_map_data_out[10]), .DOA11(out_f_map_data_out[11]),
                            .DOA12(out_f_map_data_out[12]), .DOA13(out_f_map_data_out[13]), .DOA14(out_f_map_data_out[14]), .DOA15(out_f_map_data_out[15]), .DOA16(out_f_map_data_out[16]), .DOA17(out_f_map_data_out[17]),
                            .DOA18(out_f_map_data_out[18]), .DOA19(out_f_map_data_out[19]), 
                            .DOB0(out_f_map_data_out_2[0]), .DOB1(out_f_map_data_out_2[1]), .DOB2(out_f_map_data_out_2[2]), .DOB3(out_f_map_data_out_2[3]), .DOB4(out_f_map_data_out_2[4]), .DOB5(out_f_map_data_out_2[5]),
                            .DOB6(out_f_map_data_out_2[6]), .DOB7(out_f_map_data_out_2[7]), .DOB8(out_f_map_data_out_2[8]), .DOB9(out_f_map_data_out_2[9]), .DOB10(out_f_map_data_out_2[10]), .DOB11(out_f_map_data_out_2[11]),
                            .DOB12(out_f_map_data_out_2[12]), .DOB13(out_f_map_data_out_2[13]), .DOB14(out_f_map_data_out_2[14]), .DOB15(out_f_map_data_out_2[15]), .DOB16(out_f_map_data_out_2[16]), .DOB17(out_f_map_data_out_2[17]),
                            .DOB18(out_f_map_data_out_2[18]), .DOB19(out_f_map_data_out_2[19]),
                            .CKA(clk), .CKB(clk), .WEAN(out_f_map_WEB), .WEBN(1'b1), .OEA(1'b1), .OEB(1'b1), .CSA(1'b1), .CSB(1'b1)
                            );
//========================================================================//
//                              FSM                                       //
//========================================================================//
reg [5:0] iteration , iteration_dff;
reg [10:0] counter_outer_2, counter_outer_2_dff;
reg [4:0] counter_iteration, counter_iteration_dff;
reg flag , flag_dff;
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
        counter_iteration_dff <= 0;
        counter_0to4_column_dff <= 0;
        counter_0to4_row_dff <= 0;
        counter_column_kernel_dff <= 0;
        counter_row_kernel_dff <= 0;
        counter_outer_2_dff <= 0;
        out_f_map_data_out_2_dff <= 0;
        out_f_map_WEB_dff <= 1;
    end
    else begin
        counter_iteration_dff <= counter_iteration;
        counter_outer_2_dff <= counter_outer_2;
        counter_0to4_column_dff <= counter_0to4_column;
        counter_0to4_row_dff <= counter_0to4_row;
        counter_column_kernel_dff <= counter_column_kernel;
        counter_row_kernel_dff <= counter_row_kernel;
        out_f_map_WEB_dff <= out_f_map_WEB;
        out_f_map_data_out_2_dff <= out_f_map_data_out_2;
    end
end

always @(*) begin
    if(cur_state == Input_1)begin
        counter_iteration = 0;
        if(in_valid)begin
            counter_outer = counter_outer_dff;
            counter_address = counter_address_dff + 1;
            counter_address_kernel = 0;
            if(Matrix_size_dff == 0)begin
                if(counter_address_dff == 63)begin
                    counter_outer = counter_outer_dff + 1;
                    counter_address = 0;
                end
                else begin
                    counter_outer = counter_outer_dff;
                end
                if(counter_address_dff == 63 && counter_outer_dff == 15)begin
                    nxt_state = Input_kernel;
                    counter_address = 0;
                end
                else begin
                    nxt_state = Input_1;
                end
            end
            else if(Matrix_size_dff == 1)begin
                if(counter_address_dff == 255)begin
                    counter_outer = counter_outer_dff + 1;
                    counter_address = 0;
                end
                else begin
                    counter_outer = counter_outer_dff;
                end
                if(counter_address_dff == 255 && counter_outer_dff == 15)begin
                    nxt_state = Input_kernel;
                    counter_address = 0;
                end
                else begin
                    nxt_state = Input_1;
                end
            end
            else begin
                if(counter_address_dff == 1023)begin
                    counter_outer = counter_outer_dff + 1;
                    counter_address = 0;
                end
                else begin
                    counter_outer = counter_outer_dff;
                end
                if(counter_address_dff == 1023 && counter_outer_dff == 15)begin
                    nxt_state = Input_kernel;
                    counter_address = 0;
                end
                else begin
                    nxt_state = Input_1;
                end
            end
        end
        else begin
            counter_address_kernel = 0;
            counter_address = 0;
            counter_outer = 0;
            nxt_state = Input_1;
        end
    end
    else if(cur_state == Input_kernel)begin
        counter_iteration = 0;
        counter_address_kernel = 0;
        if(in_valid == 1)begin
            counter_outer = 0;
            counter_address = counter_address_dff + 1;
            if(counter_address_dff == 399)begin
                nxt_state = Input_2;
                counter_address = 0;
            end
            else begin
                nxt_state = Input_kernel;
            end
        end
        else begin
            counter_outer = 0;
            counter_address = 0;
            nxt_state = Input_1;
        end
    end
    else if(cur_state == Input_2)begin
        counter_iteration = counter_iteration_dff;
        counter_address_kernel = counter_address_kernel_dff;
        counter_address = 0;
        counter_outer = counter_outer_dff + 1;
        if(in_valid2 || counter_outer_dff != 0)begin
            if(counter_outer_dff == 1)begin
                nxt_state = Inti_M_K;
                counter_address = 0;
                counter_address_kernel = 0;
            end
            else begin
                counter_address_kernel = counter_address_kernel_dff ;
                counter_address = counter_address_dff ;
                nxt_state = Input_2;
            end
        end
        else begin
            nxt_state = Input_2;
            counter_outer = 0;
        end
    end
    else if(cur_state == Inti_M_K)begin
        counter_iteration = counter_iteration_dff;
        if (counter_0to4_column_dff == 0 && counter_0to4_row_dff == 0 ) begin
            case(Kernel_idx)
                0 :begin  counter_address_kernel = 0; end  
                1 :begin  counter_address_kernel = 25; end
                2 :begin  counter_address_kernel = 50; end
                3 :begin  counter_address_kernel = 75; end
                4 :begin  counter_address_kernel = 100; end
                5 :begin  counter_address_kernel = 125; end
                6 :begin  counter_address_kernel = 150; end
                7 :begin  counter_address_kernel = 175; end
                8 :begin  counter_address_kernel = 200; end
                9 :begin  counter_address_kernel = 225; end
                10:begin  counter_address_kernel = 250; end
                11:begin  counter_address_kernel = 275; end
                12:begin  counter_address_kernel = 300; end
                13:begin  counter_address_kernel = 325; end
                14:begin  counter_address_kernel = 350; end
                15:begin  counter_address_kernel = 375; end 
            endcase
        end
        else begin
            counter_address_kernel = counter_address_kernel_dff + 1;
        end
        counter_outer = counter_outer_dff;
        counter_address = counter_address_dff;
        if(Mode_dff == 0)begin
           if(Matrix_size_dff == 0)begin
                counter_address = counter_0to4_column_dff + counter_0to4_row_dff * 8 + counter_column_kernel_dff + counter_row_kernel_dff * 8;
           end 
           else if(Matrix_size_dff == 1)begin
                counter_address = counter_0to4_column_dff + counter_0to4_row_dff * 16 + counter_column_kernel_dff + counter_row_kernel_dff * 16;            
           end
           else begin
                counter_address = counter_0to4_column_dff + counter_0to4_row_dff * 32 + counter_column_kernel_dff + counter_row_kernel_dff * 32;            
           end
        end
        else begin
            if(counter_0to4_column_dff == 0 && counter_0to4_row_dff == 0)begin
                counter_address = counter_address_dff + 1;
                if(counter_row_kernel_dff == 0 && counter_column_kernel_dff == 0)begin
                    counter_address = 0;
                end
            end
        end
        if(Mode_dff == 0)begin
            if((Matrix_size_dff == 0 &&counter_0to4_column_dff == 4 && counter_0to4_row_dff == 4 && counter_column_kernel_dff == 3 && counter_row_kernel_dff == 3 )
                ||(Matrix_size_dff == 1 && counter_0to4_column_dff ==4 && counter_0to4_row_dff == 4 && counter_column_kernel_dff ==11 && counter_row_kernel_dff == 11 )
                ||(Matrix_size_dff == 2 && counter_0to4_column_dff ==4 && counter_0to4_row_dff == 4 && counter_column_kernel_dff ==27 && counter_row_kernel_dff == 27 ) )begin
                nxt_state = Stall;
            end
            else begin
                nxt_state = Inti_M_K;
            end
        end
        else begin
            if((Matrix_size_dff == 0 &&counter_0to4_column_dff == 4 && counter_0to4_row_dff == 4 && counter_column_kernel_dff == 7 && counter_row_kernel_dff == 7 )
                ||(Matrix_size_dff == 1 && counter_0to4_column_dff ==4 && counter_0to4_row_dff == 4 && counter_column_kernel_dff == 15 && counter_row_kernel_dff == 15 )
                ||(Matrix_size_dff == 2 && counter_0to4_column_dff ==4 && counter_0to4_row_dff == 4 && counter_column_kernel_dff ==31 && counter_row_kernel_dff == 31 ) )begin
                nxt_state = Stall;
            end
            else begin
                nxt_state = Inti_M_K;
            end
        end
    end
    else if(cur_state == Stall)begin
        counter_iteration = counter_iteration_dff + 1;
        counter_address = 0;
        counter_address_kernel = 0;
        counter_outer = 0;
        if(Mode_dff == 0)begin
            nxt_state = Maxpool;
        end
        else begin
            nxt_state = Stall2;
        end
    end
    else if(cur_state == Maxpool)begin
        counter_iteration = counter_iteration_dff;
        nxt_state = Maxpool;
        counter_outer = counter_outer_dff + 1;
        counter_address = 0;
        counter_address_kernel = 0;
        if(counter_outer_dff == 3)begin
            nxt_state = Stall2;
            counter_outer = 0;
        end
    end
    else if(cur_state == Stall2)begin
        counter_iteration = counter_iteration_dff;
        nxt_state = Stall2;
        counter_outer = counter_outer_dff + 1;
        counter_address = counter_address_dff;
        counter_address_kernel = 0;
        if(counter_outer_dff == 2)begin
            nxt_state = Out;
            counter_outer = 0;
        end
    end
    else if(cur_state == Out)begin
        counter_iteration = counter_iteration_dff;
        counter_address = counter_address_dff;
        counter_outer = counter_outer_dff;
        counter_address_kernel = 0;
        nxt_state = Out;
        if(Mode_dff == 0)begin
            if(counter_25_dff == 19)begin
                if(Matrix_size_dff == 0)begin
                    if(counter_dff == 3 && counter_iteration_dff != 16)begin
                        nxt_state = Input_2;
                    end
                    else if(counter_dff == 3 && counter_iteration_dff == 16)begin
                        nxt_state = Input_1;
                    end
                end
                else if(Matrix_size_dff == 1)begin
                    if(counter_dff == 35 && counter_iteration_dff == 16)begin
                        nxt_state = Input_1;
                    end
                    else if(counter_dff == 35 && counter_iteration_dff != 16)begin
                        nxt_state = Input_2;
                    end
                end
                else begin
                    if(counter_dff == 195 && counter_iteration_dff == 16)begin
                        nxt_state = Input_1;
                    end
                    else if(counter_dff == 195 && counter_iteration_dff != 16)begin
                        nxt_state = Input_2;    
                    end
                end
            end
        end
        else begin
            if(counter_25_dff == 19)begin
                if(Matrix_size_dff == 0)begin
                    if(counter_address_out_2_dff == 144 && counter_iteration_dff == 16)begin
                        nxt_state = Input_1;
                    end
                    else if(counter_address_out_2_dff == 144 && counter_iteration_dff != 16)begin
                        nxt_state = Input_2;
                    end
                end
                else if(Matrix_size_dff == 1)begin
                    if(counter_address_out_2_dff == 400 && counter_iteration_dff == 16)begin
                        nxt_state = Input_1;
                    end
                    else if(counter_address_out_2_dff == 400 && counter_iteration_dff != 16)begin
                        nxt_state = Input_2;
                    end
                end
                else begin
                    if(counter_address_out_2_dff == 1296 && counter_iteration_dff == 16)begin
                        nxt_state = Input_1;
                    end
                    else if(counter_address_out_2_dff == 1296 && counter_iteration_dff != 16)begin
                        nxt_state = Input_2;
                    end
                end
            end
        end
    end
    else begin
        counter_iteration = 0;
        nxt_state = Input_1;
        counter_address = 0;
        counter_outer = 0;
        counter_address_kernel = 0;
    end
end
//========================================================================//
//                input image & kernel & matrix size                      //
//========================================================================//

always@(*) begin
    if(in_valid)begin
        Matrix_size = Matrix_size_dff;
        if(counter_outer_dff == 0 && counter_address_dff == 0 && cur_state == Input_1)begin
            Matrix_size = matrix_size;
        end
    end
    else begin
      Matrix_size = Matrix_size_dff;
    end
end
always @(*) begin
    if(cur_state == Input_1)begin
        kernel_WEB = 1;
        for( i = 0; i < 16; i = i + 1)begin
            in_f_map_WEB[i] = 1;
        end
        if(in_valid)begin
            case(counter_outer_dff)
                0 :begin  in_f_map_WEB[0]  = 0; end  
                1 :begin  in_f_map_WEB[1]  = 0; end
                2 :begin  in_f_map_WEB[2]  = 0; end
                3 :begin  in_f_map_WEB[3]  = 0; end
                4 :begin  in_f_map_WEB[4]  = 0; end
                5 :begin  in_f_map_WEB[5]  = 0; end
                6 :begin  in_f_map_WEB[6]  = 0; end
                7 :begin  in_f_map_WEB[7]  = 0; end
                8 :begin  in_f_map_WEB[8]  = 0; end
                9 :begin  in_f_map_WEB[9]  = 0; end
                10:begin  in_f_map_WEB[10] = 0; end
                11:begin  in_f_map_WEB[11] = 0; end
                12:begin  in_f_map_WEB[12] = 0; end
                13:begin  in_f_map_WEB[13] = 0; end
                14:begin  in_f_map_WEB[14] = 0; end
                15:begin  in_f_map_WEB[15] = 0; end 
            endcase
        end
        
    end
    else if(cur_state == Input_kernel)begin
        for(i = 0; i < 16; i = i + 1)begin
            in_f_map_WEB[i] = 1;
         end
         if(in_valid)begin
            kernel_WEB = 0;
         end
         else begin
            kernel_WEB = 1;
         end
    end
    else begin
        for(i = 0; i < 16; i = i + 1)begin
            in_f_map_WEB[i] = 1;
        end
        kernel_WEB = 1;
    end
end
//=========================================================//
//         input matrix idx & kernel idx & mode            //
//=========================================================//
always @(*) begin
    if(cur_state == Input_2 && in_valid2 == 1)begin
        if(counter_outer_dff == 0)begin
            Matrix_idx = matrix_idx;
            Kernel_idx = Kernel_idx_dff;
            Mode = mode;
        end
        else begin
            Matrix_idx = Matrix_idx_dff;
            Kernel_idx = matrix_idx;
            Mode = Mode_dff;
        end
    end
    else begin
        Matrix_idx = Matrix_idx_dff;
        Kernel_idx = Kernel_idx_dff;
        Mode = Mode_dff;
    end
end
//=====================================================//
//             four slide counter                      //
//=====================================================//
always @(*) begin
    if(cur_state == Inti_M_K)begin
        counter_0to4_column = counter_0to4_column_dff + 1;
        counter_0to4_row = counter_0to4_row_dff;
        counter_column_kernel = counter_column_kernel_dff;
        counter_row_kernel = counter_row_kernel_dff;
        if(counter_0to4_column_dff == 4)begin
            counter_0to4_column = 0;
            if(counter_0to4_row_dff < 4)
                counter_0to4_row = counter_0to4_row_dff + 1;
            else begin
                counter_0to4_row = 0;
                if(Mode_dff == 0)begin
                    if(Matrix_size_dff == 0 )begin
                        if(counter_column_kernel_dff == 3)begin
                            counter_column_kernel = 0;
                            counter_row_kernel = counter_row_kernel_dff + 1;
                        end
                        else begin
                            counter_column_kernel = counter_column_kernel_dff + 1;
                            counter_row_kernel = counter_row_kernel_dff;
                        end
                    end
                    else if(Matrix_size_dff == 1)begin
                        if(counter_column_kernel_dff == 11)begin
                            counter_column_kernel = 0;
                            counter_row_kernel = counter_row_kernel_dff + 1;
                        end
                        else begin
                            counter_column_kernel = counter_column_kernel_dff + 1;
                            counter_row_kernel = counter_row_kernel_dff;
                        end
                    end
                    else begin
                        if(counter_column_kernel_dff == 27)begin
                            counter_column_kernel = 0;
                            counter_row_kernel = counter_row_kernel_dff + 1;
                        end
                        else begin
                            counter_column_kernel = counter_column_kernel_dff + 1;
                            counter_row_kernel = counter_row_kernel_dff;
                        end
                    end
                end
                else begin
                    if(Matrix_size_dff == 0)begin
                        if(counter_column_kernel_dff == 7)begin
                            counter_column_kernel = 0;
                            counter_row_kernel = counter_row_kernel_dff + 1;
                        end
                        else begin
                            counter_column_kernel = counter_column_kernel_dff + 1;
                            counter_row_kernel = counter_row_kernel_dff;
                        end
                    end
                    else if(Matrix_size_dff == 1)begin
                        if(counter_column_kernel_dff == 15)begin
                            counter_column_kernel = 0;
                            counter_row_kernel = counter_row_kernel_dff + 1;
                        end
                        else begin
                            counter_column_kernel = counter_column_kernel_dff + 1;
                            counter_row_kernel = counter_row_kernel_dff;
                        end
                    end
                    else begin
                        if(counter_column_kernel_dff == 31)begin
                            counter_column_kernel = 0;
                            counter_row_kernel = counter_row_kernel_dff + 1;
                        end
                        else begin
                            counter_column_kernel = counter_column_kernel_dff + 1;
                            counter_row_kernel = counter_row_kernel_dff;
                        end
                    end
                end
            end
            
        end
    end
    else if(cur_state == Out)begin
        counter_column_kernel = counter_column_kernel_dff;
        counter_row_kernel = counter_row_kernel_dff;
        counter_0to4_column = 0;
        counter_0to4_row = 0;
        if(counter_25_dff == 0)begin
            if(Matrix_size_dff == 0)begin
                if(counter_column_kernel_dff == 1)begin
                    counter_column_kernel = 0;
                    counter_row_kernel = counter_row_kernel_dff + 1;
                end
                else begin
                    counter_column_kernel = counter_column_kernel_dff + 1;
                    counter_row_kernel = counter_row_kernel_dff;
                end
            end
            else if(Matrix_size_dff == 1)begin
                if(counter_column_kernel_dff == 5)begin
                    counter_column_kernel = 0;
                    counter_row_kernel = counter_row_kernel_dff + 1;
                end
                else begin
                    counter_column_kernel = counter_column_kernel_dff + 1;
                    counter_row_kernel = counter_row_kernel_dff;
                end
            end
            else begin
                if(counter_column_kernel_dff == 13)begin
                    counter_column_kernel = 0;
                    counter_row_kernel = counter_row_kernel_dff + 1;
                end
                else begin
                    counter_column_kernel = counter_column_kernel_dff + 1;
                    counter_row_kernel = counter_row_kernel_dff;
                end
            end
        end
        
    end
    else begin
        counter_0to4_column = 0;
        counter_0to4_row = 0;
        counter_column_kernel = 0;
        counter_row_kernel = 0;
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
        counter_25_dff <= 0;
        counter_25_dff_delay <= counter_25_dff;
        cur_state_delay <= 0;
        cur_state_delay_delay <= 0;
    end
    else begin
        cur_state_delay <= cur_state;
        cur_state_delay_delay <= cur_state_delay;
        counter_25_dff <= counter_25;
        counter_25_dff_delay <= counter_25_dff;
    end
end
//==========================================================//
//              counter_address_out_2                       //
//==========================================================// 
reg [10:0] for_MEM_zero, for_MEM_zero_dff;
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
        for_MEM_zero_dff <= 0;
    end
    else begin
        for_MEM_zero_dff <= for_MEM_zero;
    end
end
always @(*) begin
    if(cur_state == Input_1)begin
        if(counter_address_out == 0)begin
            counter_address_out_2 = 1;
        end
        else begin
            counter_address_out_2 = 0;
        end
        for_MEM_zero = 0;
    end
    else if(cur_state == Inti_M_K)begin
        if(Mode_dff == 0)begin
            if(counter_address_out == 0)begin
                counter_address_out_2 = 1;
            end
            else begin
                counter_address_out_2 = 0;
            end
            for_MEM_zero = 0;
        end
        else begin
            if(Matrix_size_dff == 0)begin
                counter_address_out_2 = counter_0to4_column_dff + counter_0to4_row_dff * 12 + counter_column_kernel_dff + counter_row_kernel_dff * 12; 
            end
            else if(Matrix_size_dff == 1)begin
                counter_address_out_2 = counter_0to4_column_dff + counter_0to4_row_dff * 20 + counter_column_kernel_dff + counter_row_kernel_dff * 20;
            end
            else begin
                counter_address_out_2 = counter_0to4_column_dff + counter_0to4_row_dff * 36 + counter_column_kernel_dff + counter_row_kernel_dff * 36;
            end
            for_MEM_zero = 0;
            if(counter_address_out_2_dff >= 1295)begin
                counter_address_out_2 = 1295;
            end
        end
    end
    else if(cur_state == Maxpool)begin
        for_MEM_zero = 0;
        if(Matrix_size_dff == 0)begin
            case(counter_outer_dff)
                0:counter_address_out_2 = 0;
                1:counter_address_out_2 = 1;
                2:counter_address_out_2 = 4;
                3:counter_address_out_2 = 5;
                default:counter_address_out_2 = 0;
            endcase
        end
        else if(Matrix_size_dff == 1)begin
            case(counter_outer_dff)
                0:counter_address_out_2 = 0;
                1:counter_address_out_2 = 1;
                2:counter_address_out_2 = 12;
                3:counter_address_out_2 = 13;
                default:counter_address_out_2 = 0;
            endcase
        end
        else begin
            case(counter_outer_dff)
                0:counter_address_out_2 = 0;
                1:counter_address_out_2 = 1;
                2:counter_address_out_2 = 28;
                3:counter_address_out_2 = 29;
                default:counter_address_out_2 = 0;
            endcase
        end
    end
    else if(cur_state == Stall2)begin
        for_MEM_zero = 0;
        counter_address_out_2 = 0;
    end
    else if(cur_state == Out)begin
        if(Mode_dff == 0)begin
            for_MEM_zero = 0;
            if(Matrix_size_dff == 0)begin
                case(counter_25_dff)
                    13:counter_address_out_2 = counter_column_kernel_dff * 2 + 8 * counter_row_kernel_dff;
                    14:counter_address_out_2 = counter_address_out_2_dff + 1;
                    15:counter_address_out_2 = counter_address_out_2_dff + 3;
                    16:counter_address_out_2 = counter_address_out_2_dff + 1;
                    default: counter_address_out_2 = 0;
                endcase
                if(counter_address_out_2 > 15)begin
                    counter_address_out_2 = 15;
                end
            end
            else if(Matrix_size_dff == 1)begin
                case(counter_25_dff)
                    13:counter_address_out_2 = counter_column_kernel_dff * 2 + 24 * counter_row_kernel_dff;
                    14:counter_address_out_2 = counter_address_out_2_dff + 1;
                    15:counter_address_out_2 = counter_address_out_2_dff + 11;
                    16:counter_address_out_2 = counter_address_out_2_dff + 1;
                    default: counter_address_out_2 = 0;
                endcase
                if(counter_address_out_2 > 143)begin
                    counter_address_out_2 = 143;
                end
            end
            else begin
                case (counter_25_dff)
                    13:counter_address_out_2 = counter_column_kernel * 2 + 56 * counter_row_kernel_dff;
                    14:counter_address_out_2 = counter_address_out_2_dff + 1;
                    15:counter_address_out_2 = counter_address_out_2_dff + 27;
                    16:counter_address_out_2 = counter_address_out_2_dff + 1; 
                    default: counter_address_out_2 = 0;
                    //original counter_addresss_out_2 = counter_address_out_2_dff;
                endcase
                if(counter_address_out_2 > 783)begin
                    counter_address_out_2 = 783;
                end
            end
        end
        else begin
            counter_address_out_2 = counter_address_out_2_dff;
            if(counter_25_dff == 17)begin
                counter_address_out_2 = counter_address_out_2_dff + 1;
            end
            for_MEM_zero = counter_address_out_2;
            //there
            // if(counter_address_out_2_dff >= 1295)begin
            //     counter_address_out_2 = 0;
            // end
        end
    end
    else begin
        for_MEM_zero = 0;
        counter_address_out_2 = 0;
    end
end
//======================================================//
//                   counter_address_out                //
//======================================================//
always @(*) begin
    if(cur_state == Input_1)begin
        counter_address_out = counter_address_out_dff + 1;
        // if(counter_address_out_dff >= 1295)begin
        //     counter_address_out = 0;
        // end
        if(Matrix_size_dff == 0)begin
            if(counter_address_out_dff >= 150)begin
                counter_address_out = 0;
            end
        end
        else if(Matrix_size_dff == 1)begin
            if(counter_address_out_dff >= 410)begin
                counter_address_out = 0;
            end
        end
        else begin
            if(counter_address_out_dff >= 1295)begin
                counter_address_out = 0;
            end
        end
        if(in_valid)begin
            out_f_map_WEB = 0;
        end
        else begin
            out_f_map_WEB = 1;
        end
    end
    // else if(cur_state == Input_2)begin
    //     counter_address_out = 0;
    //     out_f_map_WEB = 1;
    //     if(counter_outer_dff == 1)begin
    //         out_f_map_WEB = 0;
    //     end
    // end
    else if(cur_state_delay_delay == Inti_M_K || cur_state_delay_delay == Stall)begin
        counter_address_out = counter_address_out_dff;
        out_f_map_WEB = 1;
        if(Mode_dff == 0)begin
            if(counter_25_dff_delay == 24)begin
                counter_address_out = counter_address_out_dff + 1;
                out_f_map_WEB = 0;
            end
        end
        else begin
            counter_address_out = counter_address_out_2_dff_delay;
            out_f_map_WEB = 0;
        end
    end
    else if( cur_state_delay_delay == Maxpool)begin
        counter_address_out = counter_address_out_2_dff;
        out_f_map_WEB = 1;
        if(Mode_dff == 0)begin
            out_f_map_WEB = 0;
        end
        // if(counter_outer_dff == 2)begin
        //     counter_address_out = counter_address_out_dff + 1;
        // end
    end
    else if(cur_state == Out)begin
        if(Mode_dff == 0)begin
            out_f_map_WEB = 1;
            counter_address_out = counter_address_out_2_dff;
            if(Matrix_size_dff == 0)begin
                if(counter_dff != 3)begin
                    case(counter_25_dff)
                        14,15,16,17,18:out_f_map_WEB = 0;
                        default:out_f_map_WEB = 1;
                    endcase
                end
            end
            else if(Matrix_size_dff == 1)begin
                if(counter_dff != 35)begin
                    case(counter_25_dff)
                        14,15,16,17,18:out_f_map_WEB = 0;
                        default:out_f_map_WEB = 1;
                    endcase
                end
            end
            else begin
                if(counter_dff != 195)begin
                    case(counter_25_dff)
                        14,15,16,17,18:out_f_map_WEB = 0;
                        default:out_f_map_WEB = 1;
                    endcase
                end
            end
            // if(counter_25_dff == 19)begin
            //     counter_address_out = counter_address_out_dff + 1;
            //     out_f_map_WEB = 0;
            // end
        end
        else begin
            counter_address_out = counter_address_out_dff;
            if(counter_address_out_2_dff != 0)begin
                counter_address_out = counter_address_out_2_dff - 1;
            end
            out_f_map_WEB = 1;
            if(counter_25_dff == 19 && counter_address_out_2_dff_delay > 0)begin
                out_f_map_WEB = 0;
            end
        end
        
    end
    else begin
        out_f_map_WEB = 1;
        counter_address_out = 0;
    end
end
always @(*) begin
    if(cur_state == Out)begin
        counter = counter_dff;
        if(counter_25_dff == 19)begin
            counter = counter_dff + 1;
        end
    end
    else begin
        counter = 0;
    end
end
always @(*) begin
    if(cur_state_delay_delay == Inti_M_K)begin
        counter_25 = counter_25_dff + 1;
        if(counter_25_dff == 24)begin
            counter_25 = 0;
        end
    end
    else if(cur_state == Out)begin
        counter_25 = counter_25_dff + 1;
        if(counter_25_dff == 19)begin
            counter_25 = 0;
        end
    end
    else begin
        counter_25 = 0;
    end
end
//===============================================//
//             multipler & adder                 //
//===============================================//                     
reg [19:0] temp;
always @(*) begin
    if(cur_state_delay_delay == Inti_M_K || cur_state_delay_delay == Stall)begin
        if(Mode_dff == 0)begin
            case(Matrix_idx_dff)
                0 :begin  mult_input = in_f_map_data_out[0]; mult_input2 = kernel_data_out;  end  
                1 :begin  mult_input = in_f_map_data_out[1]; mult_input2 = kernel_data_out;  end
                2 :begin  mult_input = in_f_map_data_out[2]; mult_input2 = kernel_data_out;  end
                3 :begin  mult_input = in_f_map_data_out[3]; mult_input2 = kernel_data_out;  end
                4 :begin  mult_input = in_f_map_data_out[4]; mult_input2 = kernel_data_out;  end
                5 :begin  mult_input = in_f_map_data_out[5]; mult_input2 = kernel_data_out;  end
                6 :begin  mult_input = in_f_map_data_out[6]; mult_input2 = kernel_data_out;  end
                7 :begin  mult_input = in_f_map_data_out[7]; mult_input2 = kernel_data_out;  end
                8 :begin  mult_input = in_f_map_data_out[8]; mult_input2 = kernel_data_out;  end
                9 :begin  mult_input = in_f_map_data_out[9]; mult_input2 = kernel_data_out;  end
                10:begin  mult_input = in_f_map_data_out[10];mult_input2 = kernel_data_out; end
                11:begin  mult_input = in_f_map_data_out[11];mult_input2 = kernel_data_out; end
                12:begin  mult_input = in_f_map_data_out[12];mult_input2 = kernel_data_out; end
                13:begin  mult_input = in_f_map_data_out[13];mult_input2 = kernel_data_out; end
                14:begin  mult_input = in_f_map_data_out[14];mult_input2 = kernel_data_out; end
                15:begin  mult_input = in_f_map_data_out[15];mult_input2 = kernel_data_out; end 
            endcase
            temp = mult_input2_dff * mult_input_dff;
            if(counter_25_dff == 0)begin
                Conv_deConv_out = 0;
            end
            else begin
                Conv_deConv_out = temp + Conv_deConv_out_dff;
            end
            if(counter_25_dff_delay == 24)begin
                to_mem = Conv_deConv_out_dff + temp;
            end
            else begin
                to_mem = 0;
            end
        end
        else begin
            case(Matrix_idx_dff)
                0 :begin  mult_input = in_f_map_data_out[0]; mult_input2 = kernel_data_out;  end  
                1 :begin  mult_input = in_f_map_data_out[1]; mult_input2 = kernel_data_out;  end
                2 :begin  mult_input = in_f_map_data_out[2]; mult_input2 = kernel_data_out;  end
                3 :begin  mult_input = in_f_map_data_out[3]; mult_input2 = kernel_data_out;  end
                4 :begin  mult_input = in_f_map_data_out[4]; mult_input2 = kernel_data_out;  end
                5 :begin  mult_input = in_f_map_data_out[5]; mult_input2 = kernel_data_out;  end
                6 :begin  mult_input = in_f_map_data_out[6]; mult_input2 = kernel_data_out;  end
                7 :begin  mult_input = in_f_map_data_out[7]; mult_input2 = kernel_data_out;  end
                8 :begin  mult_input = in_f_map_data_out[8]; mult_input2 = kernel_data_out;  end
                9 :begin  mult_input = in_f_map_data_out[9]; mult_input2 = kernel_data_out;  end
                10:begin  mult_input = in_f_map_data_out[10];mult_input2 = kernel_data_out; end
                11:begin  mult_input = in_f_map_data_out[11];mult_input2 = kernel_data_out; end
                12:begin  mult_input = in_f_map_data_out[12];mult_input2 = kernel_data_out; end
                13:begin  mult_input = in_f_map_data_out[13];mult_input2 = kernel_data_out; end
                14:begin  mult_input = in_f_map_data_out[14];mult_input2 = kernel_data_out; end
                15:begin  mult_input = in_f_map_data_out[15];mult_input2 = kernel_data_out; end 
            endcase
            temp = mult_input2_dff * mult_input_dff;
            to_mem = temp + out_f_map_data_out_2_dff;
            Conv_deConv_out = 0;
        end
    end
    else begin
        temp = 0;
        to_mem = 0;
        mult_input = 0;
        mult_input2 = 0;
        Conv_deConv_out = 0; 
    end
end
//===============================================//
//             output & maxpool                  //
//===============================================//
always @(*) begin
    if(cur_state == Maxpool)begin
        max_pooling = 0;
        if(counter_outer_dff == 3)begin
            out_comb = out_f_map_data_out_2_dff;
        end
        else begin
            out_comb = 0;
        end
    end
    else if(cur_state == Stall2)begin
        max_pooling = 0;
        if(out_f_map_data_out_2_dff > out_value_dff)begin
            out_comb = out_f_map_data_out_2_dff;
        end
        else begin
            out_comb = out_value_dff;
        end
    end
    else if(cur_state == Out)begin
        case(counter_25_dff)
            16:max_pooling = out_f_map_data_out_2_dff;
            17:max_pooling = (max_pooling_dff < out_f_map_data_out_2_dff)? out_f_map_data_out_2_dff : max_pooling_dff;
            18:max_pooling = (max_pooling_dff < out_f_map_data_out_2_dff)? out_f_map_data_out_2_dff : max_pooling_dff;
            19:max_pooling = (max_pooling_dff < out_f_map_data_out_2_dff)? out_f_map_data_out_2_dff : max_pooling_dff;
            default: max_pooling = max_pooling_dff;
        endcase
        if(counter_25_dff == 19)begin
            if(max_pooling_dff < out_f_map_data_out_2_dff)begin
                out_comb = out_f_map_data_out_2_dff;
            end
            else begin
                out_comb = max_pooling_dff;
            end
        end
        else begin
            out_comb = out_value_dff;
        end
    end
    else begin
        max_pooling = 0;
        out_comb = 0;
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
        out_value_dff <= 0;
        max_pooling_dff <= 0;
    end
    else begin
        out_value_dff <= out_comb;
        max_pooling_dff <= max_pooling;
    end
end
//=============================================//
//                output                       //
//=============================================//
always @(*) begin
    if(cur_state == Out)begin
        out_valid_comb = 1;
        if(Mode_dff == 0)begin
            case(counter_25_dff)
                0 :true_out_comb = out_value_dff[0];
                1 :true_out_comb = out_value_dff[1];
                2 :true_out_comb = out_value_dff[2];
                3 :true_out_comb = out_value_dff[3];
                4 :true_out_comb = out_value_dff[4];
                5 :true_out_comb = out_value_dff[5];
                6 :true_out_comb = out_value_dff[6];
                7 :true_out_comb = out_value_dff[7];
                8 :true_out_comb = out_value_dff[8];
                9 :true_out_comb = out_value_dff[9];
                10:true_out_comb = out_value_dff[10];
                11:true_out_comb = out_value_dff[11];
                12:true_out_comb = out_value_dff[12];
                13:true_out_comb = out_value_dff[13];
                14:true_out_comb = out_value_dff[14];
                15:true_out_comb = out_value_dff[15];
                16:true_out_comb = out_value_dff[16];
                17:true_out_comb = out_value_dff[17];
                18:true_out_comb = out_value_dff[18];
                19:true_out_comb = out_value_dff[19];
                default:true_out_comb = 0;
            endcase
        end
        else begin
            case(counter_25_dff)
                0 :true_out_comb = out_f_map_data_out_2[0];
                1 :true_out_comb = out_f_map_data_out_2_dff[1];
                2 :true_out_comb = out_f_map_data_out_2_dff[2];
                3 :true_out_comb = out_f_map_data_out_2_dff[3];
                4 :true_out_comb = out_f_map_data_out_2_dff[4];
                5 :true_out_comb = out_f_map_data_out_2_dff[5];
                6 :true_out_comb = out_f_map_data_out_2_dff[6];
                7 :true_out_comb = out_f_map_data_out_2_dff[7];
                8 :true_out_comb = out_f_map_data_out_2_dff[8];
                9 :true_out_comb = out_f_map_data_out_2_dff[9];
                10:true_out_comb = out_f_map_data_out_2_dff[10];
                11:true_out_comb = out_f_map_data_out_2_dff[11];
                12:true_out_comb = out_f_map_data_out_2_dff[12];
                13:true_out_comb = out_f_map_data_out_2_dff[13];
                14:true_out_comb = out_f_map_data_out_2_dff[14];
                15:true_out_comb = out_f_map_data_out_2_dff[15];
                16:true_out_comb = out_f_map_data_out_2_dff[16];
                17:true_out_comb = out_f_map_data_out_2_dff[17];
                18:true_out_comb = out_f_map_data_out_2_dff[18];
                19:true_out_comb = out_f_map_data_out_2_dff[19];
                default:true_out_comb = 0;
            endcase
        end
    end
    else begin
        out_valid_comb = 0;
        true_out_comb = 0;
    end
end
endmodule

