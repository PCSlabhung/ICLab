`ifdef RTL
    `define CYCLE_TIME 20.0
`endif
`ifdef GATE
    `define CYCLE_TIME 20.0
`endif

module PATTERN #(parameter IP_WIDTH = 8)(
    //Output Port
    IN_character,
	IN_weight,
    //Input Port
	OUT_character
);
// ========================================
// Input & Output
// ========================================
output reg [IP_WIDTH*4-1:0] IN_character;
output reg [IP_WIDTH*5-1:0] IN_weight;

input [IP_WIDTH*4-1:0] OUT_character;

// ========================================
// Parameter
// ========================================
integer PATNUM;
integer patcount;
integer input_file, output_file;
integer k,i,j, length, h, l, t;

reg [3:0] in_char_seq [0:IP_WIDTH - 1];
reg [4:0] in_wght_seq [0:IP_WIDTH - 1];
reg [3:0] char_temp;
reg [4:0] wght_temp;
reg [IP_WIDTH*4-1:0] golden;

reg clk;
real	CYCLE = `CYCLE_TIME;
always	#(CYCLE/2.0) clk = ~clk;
initial	clk = 0;


//================================================================
// design
//================================================================

initial begin
    for(patcount = 0; patcount < 100; patcount = patcount + 1) begin		
        input_task;
        repeat(1) @(negedge clk);
		check_ans;
        $display("pass pattern no.%d", patcount);
		repeat($urandom_range(3, 5)) @(negedge clk);
	end
    $display("IP_WIDTH = %d", IP_WIDTH);
	display_pass;
    repeat(3) @(negedge clk);
    $finish;
end


task input_task; begin
    //k = $urandom_range(3, 8);
    //IP_WIDTH = k;
    //length = k;
    for (j = 0; j < IP_WIDTH; j = j + 1) begin
        in_char_seq[j] = j;
        IN_character[(j+1)*4 - 1 -: 4] = in_char_seq[j];
        in_wght_seq[j] = $urandom_range(0, 31);
        IN_weight[(j+1)*5 - 1 -: 5] = in_wght_seq[j];
    end
end endtask

task check_ans; begin
    for (h = 0; h < IP_WIDTH - 1; h = h + 1) begin
        for (l = 0; l < IP_WIDTH - h - 1; l = l + 1) begin
            if (in_wght_seq[l+1] < in_wght_seq[l]) begin
                char_temp = in_char_seq[l];
                wght_temp = in_wght_seq[l];
                in_char_seq[l] = in_char_seq[l+1];
                in_wght_seq[l] = in_wght_seq[l+1];
                in_char_seq[l+1] = char_temp;
                in_wght_seq[l+1] = wght_temp;
            end
        end
    end
    for (t = 0; t < IP_WIDTH; t = t + 1) begin
        golden[(t+1)*4 - 1 -: 4] = in_char_seq[t];
    end

    if (golden !== OUT_character) begin
        display_fail;
    end
end endtask

task display_fail; begin
        $display("\n");
        $display("\n");
        $display("        ----------------------------               ");
        $display("        --                        --       |\__||  ");
        $display("        --  OOPS!!                --      / X,X  | ");
        $display("        --                        --    /_____   | ");
        $display("        --  \033[0;31mSimulation FAIL!!\033[m   --   /^ ^ ^ \\  |");
        $display("        --                        --  |^ ^ ^ ^ |w| ");
        $display("        ----------------------------   \\m___m__|_|");
        $display("\n");
        $finish;
end endtask

task display_pass; begin
        $display("\n");
        $display("\n");
        $display("        ----------------------------               ");
        $display("        --                        --       |\__||  ");
        $display("        --  Congratulations !!    --      / O.O  | ");
        $display("        --                        --    /_____   | ");
        $display("        --  \033[0;32mSimulation PASS!!\033[m     --   /^ ^ ^ \\  |");
        $display("        --                        --  |^ ^ ^ ^ |w| ");
        $display("        ----------------------------   \\m___m__|_|");
        $display("\n");
end endtask

endmodule