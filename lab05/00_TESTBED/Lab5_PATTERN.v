//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
//   2023 ICLAB Fall Course
//   Lab05      : PATTERN
//   Author     : Ian Lai
//                
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

`define CYCLE_TIME 10.0
`define PATTERN_NUMBER 20

module PATTERN(
    // Input Port
    clk, 
    rst_n, 
    in_valid, 
    in_valid2, 
    mode, 
    matrix_size, 
    matrix, 
    matrix_idx, 
    // Output Port
    out_valid, 
    out_value
    );

output reg clk, rst_n, in_valid, in_valid2, mode;
output reg [1:0] matrix_size;
output reg [3:0] matrix_idx;
output reg signed [7:0] matrix;

input out_valid;
input out_value;

// ========== Start of pattern ==========
real CYCLE = `CYCLE_TIME;
always #(CYCLE/2.0) clk = ~clk;

integer latency, total_latency;
integer i_pat, sub_pat;
integer i, j, k, p, q;
integer pat_num = `PATTERN_NUMBER;

reg [1:0] mat_size;
reg signed [7:0] mat[15:0][31:0][31:0]; // image
reg signed [7:0] ker[15:0][4:0][4:0]; // kernel
reg [3:0] image_idx, kernel_idx;
reg mod;
reg signed [19:0] present_out;

// calculation of answer
reg signed [19:0] conv[27:0][27:0];
reg signed [19:0] pool[13:0][13:0]; // conv+pool answer
reg signed [19:0] deconv[35:0][35:0]; // de-convolution answer

initial begin
    reset_task;
    total_latency = 0;

    for(i_pat=1;i_pat<=pat_num;i_pat++) begin
        @(negedge clk); 
        input_task;

        for(sub_pat=0;sub_pat<16;sub_pat++) begin
            input2_task;
            wait_outvalid_task;
            check_ans_task;
            total_latency = total_latency + latency;
            $display("PASS sub-PATTERN NO.%4d - %.4d", i_pat, sub_pat);
        end
        $display("PASS PATTERN NO.%4d", i_pat);
    end

    YOU_PASS_TASK;
end

always @(negedge clk) begin
    if(out_valid === 1'b0 && out_value !== 1'b0 && rst_n !== 1'b0) begin 
        YOU_FAIL_task;
        $display("*************************************************************************");  
        $display("            The out _value should be reset when out_valid is low         ");
        $display("*************************************************************************");  
        $finish;
    end
end

always@(*)begin
	if((in_valid && out_valid) || (in_valid2 && out_valid))begin
        YOU_FAIL_task;
        $display("*************************************************************************");     
        $display("*                The out_valid cannot overlap with in_valid             *");
        $display("*************************************************************************");  
		$finish;			
	end	
end



task reset_task; begin
    rst_n = 1'b1;
    in_valid = 1'b0;
    in_valid2 = 1'b0;
    mode = 'dx;
    matrix_size = 'dx;
    matrix_idx = 'dx;
    matrix = 'dx;

    force clk = 0;

    #CYCLE; rst_n = 1'b0;
    #(CYCLE*5.0); rst_n = 1'b1;

    // check reset
    if(out_valid !== 1'b0 || out_value !== 1'b0) begin
        YOU_FAIL_task;
        $display("*************************************************************************");  
        $display("*            Output signal should be 0 after initial RESET              *");
        $display("*************************************************************************");
        repeat(2) #CYCLE;
        $finish;
    end

    #(CYCLE); release clk;
end
endtask


task input_task; begin
    in_valid = 1'b1;
    mat_size = $urandom_range(0, 2);
    // mat_size = 0;
    matrix_size = mat_size;

    // input image
    for(i=0;i<16;i++) begin
        if(mat_size == 0) begin // 8*8
            for(j=0;j<8;j++) begin
                for(k=0;k<8;k++) begin
                    mat[i][j][k] = $urandom_range(0, 255);
                    matrix = mat[i][j][k];
                    if(j != 0 || k != 0) matrix_size = 'dx;
                    @(negedge clk);
                end
            end
        end
        else if(mat_size == 1) begin // 16*16
            for(j=0;j<16;j++) begin
                for(k=0;k<16;k++) begin
                    mat[i][j][k] = $urandom_range(0, 255);
                    matrix = mat[i][j][k];
                    if(j != 0 || k != 0) matrix_size = 'dx;
                    @(negedge clk);
                end
            end
        end
        else begin // 32*32
            for(j=0;j<32;j++) begin
                for(k=0;k<32;k++) begin
                    mat[i][j][k] = $urandom_range(0, 255);
                    matrix = mat[i][j][k];
                    if(j != 0 || k != 0) matrix_size = 'dx;
                    @(negedge clk);
                end
            end
        end
    end
    // input kernel
    for(i=0;i<16;i++) begin
        for(j=0;j<5;j++) begin
            for(k=0;k<5;k++) begin
                ker[i][j][k] = $urandom_range(0, 255);
                matrix = ker[i][j][k];
                @(negedge clk);
            end
        end
    end

    in_valid = 1'b0;
    matrix = 'dx;
end
endtask


task input2_task; begin
    repeat($urandom_range(1, 3)) @(negedge clk);
    image_idx = $urandom_range(0, 15);
    kernel_idx = $urandom_range(0, 15);
    mod = $urandom_range(0, 1);
    // mod = 0;

    in_valid2 = 1'b1;
    matrix_idx = image_idx;
    mode = mod;
    @(negedge clk);
    matrix_idx = kernel_idx;
    mode = 'dx;
    @(negedge clk);

    in_valid2 = 1'b0;
    matrix_idx = 'dx;
end
endtask


task wait_outvalid_task; begin
    latency = 0;
    while(out_valid !== 1'b1) begin
        latency = latency + 1;
        // check output latency
        if(latency == 100000) begin
            YOU_FAIL_task;
            $display("*************************************************************************");
            $display("             The execution latency is limited in 100000 cycle            ");
            $display("*************************************************************************");
            $finish;
        end
        @(negedge clk);
    end
end
endtask


task check_ans_task; begin
    // ================================================================
    // =====                 calculate answer                     =====
    // ================================================================
    if(mod === 1'b0) begin // convolution + pooling
        if(mat_size == 2'd0) begin // 8*8
            // convolution -> 4*4
            for(i=0;i<4;i++) begin
                for(j=0;j<4;j++) begin
                    conv[i][j] = 0;
                    for(p=0;p<=4;p++) begin
                        for(q=0;q<=4;q++) begin
                            conv[i][j] = conv[i][j] + (mat[image_idx][i+p][j+q] * ker[kernel_idx][p][q]);
                        end
                    end
                end
            end
            // pooling -> 2*2
            for(i=0;i<2;i++) begin
                for(j=0;j<2;j++) begin
                    pool[i][j] = conv[i*2][j*2];
                    if(conv[i*2+1][j*2] > pool[i][j])   pool[i][j] = conv[i*2+1][j*2];
                    if(conv[i*2][j*2+1] > pool[i][j])   pool[i][j] = conv[i*2][j*2+1];
                    if(conv[i*2+1][j*2+1] > pool[i][j]) pool[i][j] = conv[i*2+1][j*2+1];
                end
            end
        end
        else if(mat_size == 2'd1) begin // 16*16
            // convolution -> 12*12
            for(i=0;i<12;i++) begin
                for(j=0;j<12;j++) begin
                    conv[i][j] = 0;
                    for(p=0;p<=4;p++) begin
                        for(q=0;q<=4;q++) begin
                            conv[i][j] = conv[i][j] + (mat[image_idx][i+p][j+q] * ker[kernel_idx][p][q]);
                        end
                    end
                end
            end
            // pooling -> 6*6
            for(i=0;i<6;i++) begin
                for(j=0;j<6;j++) begin
                    pool[i][j] = conv[i*2][j*2];
                    if(conv[i*2+1][j*2] > pool[i][j])   pool[i][j] = conv[i*2+1][j*2];
                    if(conv[i*2][j*2+1] > pool[i][j])   pool[i][j] = conv[i*2][j*2+1];
                    if(conv[i*2+1][j*2+1] > pool[i][j]) pool[i][j] = conv[i*2+1][j*2+1];
                end
            end
        end
        else begin // 32*32
            // convolution -> 28*28
            for(i=0;i<28;i++) begin
                for(j=0;j<28;j++) begin
                    conv[i][j] = 0;
                    for(p=0;p<=4;p++) begin
                        for(q=0;q<=4;q++) begin
                            conv[i][j] = conv[i][j] + (mat[image_idx][i+p][j+q] * ker[kernel_idx][p][q]);
                        end
                    end
                end
            end
            // pooling -> 14*14
            for(i=0;i<14;i++) begin
                for(j=0;j<14;j++) begin
                    pool[i][j] = conv[i*2][j*2];
                    if(conv[i*2+1][j*2] > pool[i][j])   pool[i][j] = conv[i*2+1][j*2];
                    if(conv[i*2][j*2+1] > pool[i][j])   pool[i][j] = conv[i*2][j*2+1];
                    if(conv[i*2+1][j*2+1] > pool[i][j]) pool[i][j] = conv[i*2+1][j*2+1];
                end
            end
        end
    end
    else begin // de-convolution
        // reset de-convolution array to zero
        for(i=0;i<36;i++) begin
            for(j=0;j<36;j++) begin
                deconv[i][j] = 0;
            end
        end

        if(mat_size == 2'd0) begin // 8*8
            for(i=0;i<8;i++) begin
                for(j=0;j<8;j++) begin
                    for(p=0;p<5;p++) begin
                        for(q=0;q<5;q++) begin
                            deconv[i+p][j+q] = deconv[i+p][j+q] + (mat[image_idx][i][j] * ker[kernel_idx][p][q]);
                        end
                    end
                end
            end
        end
        else if(mat_size == 2'd1) begin // 16*16
            for(i=0;i<16;i++) begin
                for(j=0;j<16;j++) begin
                    for(p=0;p<5;p++) begin
                        for(q=0;q<5;q++) begin
                            deconv[i+p][j+q] = deconv[i+p][j+q] + (mat[image_idx][i][j] * ker[kernel_idx][p][q]);
                        end
                    end
                end
            end
        end
        else begin // 32*32
            for(i=0;i<32;i++) begin
                for(j=0;j<32;j++) begin
                    for(p=0;p<5;p++) begin
                        for(q=0;q<5;q++) begin
                            deconv[i+p][j+q] = deconv[i+p][j+q] + (mat[image_idx][i][j] * ker[kernel_idx][p][q]);
                        end
                    end
                end
            end
        end
    end

    // ================================================================
    // =====                     check answer                     =====
    // ================================================================
    if(mod == 1'b0) begin // convolution + pooling
        if(mat_size == 2'd0) begin // 8*8
            for(i=0;i<2;i++) begin
                for(j=0;j<2;j++) begin
                    present_out = 'd0;
                    for(k=0;k<20;k++) begin
                        present_out = present_out >> 1;
                        present_out[19] = out_value;
                        @(negedge clk);
                    end

                    if(present_out !== pool[i][j]) begin
                        YOU_FAIL_task;
                        $display("*************************************************************************");
                        $display("                               Wrong Answer                              ");
                        $display("*************************************************************************");
                        $display("pooling[%d][%d] = %d\n", i, j, pool[i][j]); 
                        $display("your answer = %d\n", present_out);
                        $finish;
                    end
                end
            end
        end
        else if(mat_size == 2'd1) begin // 16*16
            for(i=0;i<6;i++) begin
                for(j=0;j<6;j++) begin
                    present_out = 'd0;
                    for(k=0;k<20;k++) begin
                        present_out = present_out >> 1;
                        present_out[19] = out_value;
                        @(negedge clk);
                    end

                    if(present_out !== pool[i][j]) begin
                        YOU_FAIL_task;
                        $display("*************************************************************************");
                        $display("                               Wrong Answer                              ");
                        $display("*************************************************************************");
                        $display("pooling[%d][%d] = %d\n", i, j, pool[i][j]); 
                        $display("your answer = %d\n", present_out);
                        $finish;
                    end
                end
            end
        end
        else begin // 32*32
            for(i=0;i<14;i++) begin
                for(j=0;j<14;j++) begin
                    present_out = 'd0;
                    for(k=0;k<20;k++) begin
                        present_out = present_out >> 1;
                        present_out[19] = out_value;
                        @(negedge clk);
                    end

                    if(present_out !== pool[i][j]) begin
                        YOU_FAIL_task;
                        $display("*************************************************************************");
                        $display("                               Wrong Answer                              ");
                        $display("*************************************************************************");
                        $display("pooling[%d][%d] = %d\n", i, j, pool[i][j]); 
                        $display("your answer = %d\n", present_out);
                        $finish;
                    end
                end
            end
        end
    end
    else begin // de-convolution
        if(mat_size == 2'd0) begin // 8*8
            for(i=0;i<12;i++) begin
                for(j=0;j<12;j++) begin
                    present_out = 'd0;
                    for(k=0;k<20;k++) begin
                        present_out = present_out >> 1;
                        present_out[19] = out_value;
                        @(negedge clk);
                    end

                    if(present_out !== deconv[i][j]) begin
                        YOU_FAIL_task;
                        $display("*************************************************************************");
                        $display("                               Wrong Answer                              ");
                        $display("*************************************************************************");
                        $display("de-conv[%d][%d] = %d\n", i, j, deconv[i][j]); 
                        $display("your answer = %d\n", present_out);
                        $finish;
                    end
                end
            end
        end
        else if(mat_size == 2'd1) begin // 16*16
            for(i=0;i<20;i++) begin
                for(j=0;j<20;j++) begin
                    present_out = 'd0;
                    for(k=0;k<20;k++) begin
                        present_out = present_out >> 1;
                        present_out[19] = out_value;
                        @(negedge clk);
                    end

                    if(present_out !== deconv[i][j]) begin
                        YOU_FAIL_task;
                        $display("*************************************************************************");
                        $display("                               Wrong Answer                              ");
                        $display("*************************************************************************");
                        $display("de-conv[%d][%d] = %d\n", i, j, deconv[i][j]); 
                        $display("your answer = %d\n", present_out);
                        $finish;
                    end
                end
            end
        end
        else begin // 32*32
            for(i=0;i<36;i++) begin
                for(j=0;j<36;j++) begin
                    present_out = 'd0;
                    for(k=0;k<20;k++) begin
                        present_out = present_out >> 1;
                        present_out[19] = out_value;
                        @(negedge clk);
                    end

                    if(present_out !== deconv[i][j]) begin
                        YOU_FAIL_task;
                        $display("*************************************************************************");
                        $display("                               Wrong Answer                              ");
                        $display("*************************************************************************");
                        $display("de-conv[%d][%d] = %d\n", i, j, deconv[i][j]); 
                        $display("your answer = %d\n", present_out);
                        $finish;
                    end
                end
            end
        end
    end
end
endtask


task YOU_PASS_TASK; begin
    $display("*************************************************************************");
    $display("*                         Congratulations!                              *");
    $display("*                Your execution cycles = %5d cycles                   *", total_latency);
    $display("*                Your clock period = %.1f ns                            *", CYCLE);
    $display("*                Total Latency = %.1f ns                                 *", total_latency*CYCLE);
    $display("*************************************************************************");
    $finish;
end
endtask

task YOU_FAIL_task; begin
    $display("*************************************************************************");
    $display("*                              FAIL!                                    *");
    $display("*************************************************************************");
end 
endtask

endmodule
