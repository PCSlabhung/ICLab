module Train(
    //Input Port
    clk,
    rst_n,
	in_valid,
	data,

    //Output Port
    out_valid,
	result
);

input        clk;
input 	     in_valid;
input        rst_n;
input  [3:0] data;
output   reg out_valid;
output   reg result; 
reg [3:0] counter_11_dff, counter_11_comb;
reg [3:0] IN_num, IN_num_dff;
reg [3:0] cur_state, nxt_state;
reg [3:0] stack [0:9];
reg [3:0] stack_dff [0:9];
reg [3:0] format [0:9];
reg [3:0] format_dff [0:9];
reg [3:0] quene [0:9];
reg [3:0] quene_dff [0:9];
reg [3:0] cur_addr, cur_addr_dff;
reg [3:0] counter, counter_dff;
reg out_valid_comb, result_comb;
parameter   INPUT = 0;
parameter   PUSH = 1;
parameter   POP = 2;
parameter   OUT = 3;
integer  i;
//===================//
//        FSM        //
//===================//
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
        cur_state <= 0;
        cur_addr_dff <= 0;
        counter_11_dff <= 0;
        counter_dff <= 0;
        out_valid <= 0;
        result <= 0;
        IN_num_dff <= 0;
        for(i = 0; i < 10; i = i + 1)begin
            format_dff[i] <= 0;
            quene_dff[i] <= i + 1;
            stack_dff[i] <= 0;
        end 
    end
    else begin
        cur_state <= nxt_state;
        cur_addr_dff <= cur_addr;
        counter_11_dff <= counter_11_comb; 
        counter_dff <= counter;
        out_valid <= out_valid_comb;
        result <= result_comb;
        IN_num_dff <= IN_num;
        for(i = 0; i < 10; i = i + 1)begin
            format_dff[i] <= format[i];
            quene_dff[i] <= quene[i];
            stack_dff[i] <= stack[i];
        end
    end
end
always @(*) begin
    if(cur_state == INPUT)begin
        counter_11_comb = counter_11_dff;
        out_valid_comb = 0;
        result_comb = 0;
        if(in_valid)begin
            counter_11_comb = counter_11_dff + 1;
        end
        if(counter_11_dff == IN_num_dff && IN_num_dff != 0)begin
            nxt_state = PUSH;
        end 
        else begin
            nxt_state = INPUT;
        end
    end
    else if(cur_state == PUSH)begin
        out_valid_comb = 0;
        result_comb = 0;
        counter_11_comb = 0;
        if(stack_dff[0] == format_dff[cur_addr_dff])begin
            nxt_state = POP;
        end
        else begin
            if(counter_dff == IN_num + 1)begin
                nxt_state = OUT;
                out_valid_comb = 1;
                result_comb = 0;
            end
            else begin
                nxt_state = PUSH;
            end
        end
    end
    else if(cur_state == POP)begin
        out_valid_comb = 0;
        result_comb = 0;
        counter_11_comb = 0;
        if(stack_dff[0] == 0)begin
            nxt_state = OUT;
            out_valid_comb = 1;
            result_comb = 1;
        end
        else begin
            nxt_state = PUSH;
        end
    end
    else begin
        counter_11_comb = 0;
        out_valid_comb = 0;
        result_comb = 0;
        nxt_state = INPUT;
    end
end            
//=======================================//
//              INPUT                    //
//=======================================//
always @(*) begin
    if(cur_state == INPUT)begin
        cur_addr = 0;
        counter = 0;
        if(in_valid)begin
            IN_num = IN_num_dff;
            for(i = 0; i < 10; i = i + 1)begin
                quene[i] = i + 1;
                format[i] = format_dff[i];
                stack[i] = 0;
            end
            if(in_valid)begin
                case(counter_11_dff)
                    0:IN_num = data;
                    1:format[0] = data;
                    2:format[1] = data;
                    3:format[2] = data;
                    4:format[3] = data;
                    5:format[4] = data;
                    6:format[5] = data;
                    7:format[6] = data;
                    8:format[7] = data;
                    9:format[8] = data;
                    10:format[9] = data;
                endcase
            end
        end
        else begin
            IN_num = IN_num_dff;
            for(i = 0; i < 10; i = i + 1)begin
                quene[i] = i + 1;
                format[i] = format_dff[i];
                stack[i] = 0;
            end
        end
    end
    else if(cur_state == PUSH)begin
        IN_num = IN_num_dff;
        for(i = 0; i < 10; i = i + 1)begin
            format[i] = format_dff[i];
        end
        if(stack_dff[0] != format_dff[cur_addr_dff])begin
            stack[0] = quene_dff[0];
            counter = counter_dff + 1;
            for(i = 1; i < 10; i = i + 1)begin
                stack[i] = stack_dff[i - 1];
            end
            quene[9] = 0;
            for(i = 0; i < 9; i = i + 1)begin
                quene[i] = quene_dff[i + 1];
            end
            cur_addr = cur_addr_dff;
        end
        else begin
            cur_addr = cur_addr_dff ;
            counter = counter_dff;
            for(i = 0; i < 10; i = i + 1)begin
                stack[i] = stack_dff[i];
                quene[i] = quene_dff[i];
            end
        end
    end
    else if(cur_state == POP)begin
        IN_num = IN_num_dff;
        cur_addr = cur_addr_dff + 1;
        counter = counter_dff;
        for(i = 0; i < 10;i = i + 1)begin
            format[i] = format_dff[i];
            quene[i] = quene_dff[i];
        end
        stack[9] = 0;
        for(i = 0; i < 9; i = i + 1)begin
            stack[i] = stack_dff[i + 1];
        end
    end
    else begin
        IN_num = 0;
        cur_addr = 0;
        counter = 0;
        for(i = 0; i < 10; i = i + 1)begin
            format[i] = 0;
            quene[i] = i + 1;
            stack[i] = 0;
        end
    end
end
endmodule