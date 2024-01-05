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

reg [3:0] array_pattern_character [0:IP_WIDTH - 1];
reg [4:0] array_pattern_weight [0:IP_WIDTH - 1];
reg [3:0] temp1;
reg [4:0] temp2;
reg clk,flag;
real CYCLE = `CYCLE_TIME;
always #(CYCLE / 2.0) clk = ~clk;
initial clk = 0;

integer i,j,PATNUM;
// ========================================
// Parameter
// ========================================

//================================================================
// design
//================================================================
initial begin

    for(PATNUM = 0; PATNUM < 100; PATNUM = PATNUM + 1)begin
        input_task;
        Cal_ans;
        repeat (1)@(negedge clk);
        check_ans;
        
    end
    you_pass_task;
end
task input_task;
    flag = 0;
    for(i = 0; i < IP_WIDTH;i = i + 1)begin
        array_pattern_weight[i] = $urandom_range(0,31);
        array_pattern_character[i] = i;
    end
    for(i = 1; i <= IP_WIDTH; i = i + 1)begin
        IN_weight[(i * 5-1) -: 5] = array_pattern_weight[i-1];
        IN_character[(i * 4 - 1) -: 4] = array_pattern_character[i - 1];
    end
endtask
task Cal_ans;
    for(i = 0; i < IP_WIDTH - 1; i = i + 1)begin
        for(j = 0 ;j < IP_WIDTH - i - 1 ; j = j + 1)begin
            if(array_pattern_weight[j + 1] < array_pattern_weight[j] )begin
                temp1 = array_pattern_character[j + 1];
                array_pattern_character[j + 1] = array_pattern_character[j];
                array_pattern_character[j] = temp1;

                temp2 = array_pattern_weight[j + 1];
                array_pattern_weight[j + 1] = array_pattern_weight[j];
                array_pattern_weight[j] = temp2;
            end
        end
    end
endtask
task check_ans;
    for(i = 1; i <= IP_WIDTH; i = i + 1)begin
        if(OUT_character[(i * 4 - 1)-:4] !== array_pattern_character[i - 1])begin
            flag = 1;
        end
    end
    if(flag == 0)begin
       $display(" pass %d pattern ",PATNUM + 1);
    end
    else begin
        $display("correct answer");
        for(i = 0; i < IP_WIDTH; i = i + 1)begin
            $write("%d ",array_pattern_character[i]);
        end
		$display("\n");
        $display("your answer");
        for(i = 1 ;i <= IP_WIDTH; i = i + 1)begin
            $write("%d ",OUT_character[(i * 4 - 1) -: 4]);
        end
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
    end

endtask
task you_pass_task;
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
    $finish;
endtask
endmodule