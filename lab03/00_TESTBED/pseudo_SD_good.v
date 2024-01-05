//############################################################################
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//   (C) Copyright Laboratory System Integration and Silicon Implementation
//   All Right Reserved
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
//   2023 ICLAB Fall Course
//   Lab03      : BRIDGE
//   Author     : Ting-Yu Chang
//                
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
//   File Name   : pseudo_SD.v
//   Module Name : pseudo_SD
//   Release version : v1.0 (Release Date: Sep-2023)
//
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//############################################################################

module pseudo_SD (
    clk,
    MOSI,
    MISO
);

input clk;
input MOSI;
output reg MISO;

parameter SD_p_r = "../00_TESTBED/SD_init.dat";


integer i, unit, i_pat, PAT_NUM, pat_read, cnt;


reg [5:0]command;
reg [31:0]address;
reg [6:0]crc7;
reg [6:0]golden_crc7;

reg [15:0]crc16;
reg [15:0]temp;
reg [15:0]golden_crc16;

reg [63:0] data;
reg [63:0] SD [0:65535];
reg [63:0] SD_data_temp;


initial begin
    $readmemh(SD_p_r, SD);
    pat_read = $fopen("../00_TESTBED/Input.txt", "r");
    i = $fscanf(pat_read, "%d", PAT_NUM);
    MISO = 1;
    i_pat = 0;
    command = 0;
    address = 0;
    crc7 = 0;
    cnt = 0;
    for (i_pat = 1; i_pat <= PAT_NUM; i_pat = i_pat + 1) begin
        WAIT_COMMAND;
        cnt = 0;
        if(command == 17) begin
            RESPONSE;
            DATA_READ;
            MISO = 1;
        end
        else if(command == 24) begin
            RESPONSE;
            DATA_WRITE;
            DATA_RESPONSE;
            MISO = 1;
        end
    end
end
//////////////////////////////////////////////////////////////////////
// Write your own task here
//////////////////////////////////////////////////////////////////////
task WAIT_COMMAND; begin
    while(MOSI !== 'b0)
        @(posedge clk);
    @(posedge clk); // start bit

    if(MOSI !== 'b1) begin
        $display("********************************************************");     
        $display("                          FAIL!                         ");
        $display("*                       SPEC SD-1 FAIL                 *");
        $display("********************************************************");
        repeat(2)@(negedge clk);
        $finish;
    end
    @(posedge clk); // transmission bit

    for(i = 0; i < 6; i = i + 1) begin
        command[5-i] = MOSI;
        @(posedge clk);
    end
    for(i = 0; i < 32; i = i + 1) begin
        address[31-i] = MOSI;
        @(posedge clk);
    end
    for(i = 0; i < 7; i = i + 1) begin
        crc7[6-i] = MOSI;
        @(posedge clk);
    end
    
    if(MOSI !== 'b1) begin
        $display("********************************************************");     
        $display("                          FAIL!                         ");
        $display("*                       SPEC SD-1 FAIL                 *");
        $display("********************************************************");
        repeat(2)@(negedge clk);
        $finish;
    end

    if(command !== 6'd17 && command !== 6'd24) begin
        $display("********************************************************");     
        $display("                          FAIL!                         ");
        $display("*                       SPEC SD-1 FAIL                 *");
        $display("********************************************************");
        repeat(2)@(negedge clk);
        $finish;
    end

    if(address > 65535) begin
        $display("********************************************************");     
        $display("                          FAIL!                         ");
        $display("*                       SPEC SD-2 FAIL                 *");
        $display("********************************************************");
        repeat(2)@(negedge clk);
        $finish;
    end

    golden_crc7 = CRC7({2'b01, command, address});
    if(golden_crc7 !== crc7) begin
        $display("********************************************************");     
        $display("                          FAIL!                         ");
        $display("*                       SPEC SD-3 FAIL                 *");
        $display("********************************************************");
        repeat(2)@(negedge clk);
        $finish;
    end

    unit = $urandom_range(0, 8);
    repeat(8*unit) @(posedge clk);
end endtask


task RESPONSE; begin
    for(i = 0; i < 8; i = i + 1) begin
        MISO = 0;
        @(posedge clk);
    end 
    MISO = 1;
end endtask

task DATA_READ; begin
    data = SD[address];
    temp = CRC16_CCITT(.data(data));
    for(i = 0; i < 8; i = i + 1) begin
        MISO = 1;
        if(i == 7)
            MISO = 0;
        @(posedge clk);
        
    end
    for(i = 0; i < 64; i = i + 1) begin
        MISO = data[63-i];
        @(posedge clk);
    end
    for(i = 0; i < 16; i = i + 1) begin
        MISO = temp[15-i];
        @(posedge clk);
    end
    MISO = 1;
end endtask

task DATA_WRITE; begin
    while(MOSI == 1) begin
        cnt = cnt + 1;
        @(posedge clk);
    end
    @(posedge clk); // ignore start token
    for(i = 0; i < 64; i = i + 1) begin
        SD_data_temp[63 - i] = MOSI;
        @(posedge clk);
    end
    for(i = 0; i < 16; i = i + 1) begin
        crc16[15-i] = MOSI;
        if(i != 15)
            @(posedge clk);
    end
    cnt = cnt - 8;
    if((cnt % 8) != 0 || (cnt/8) > 32 || (cnt/8) == 0) begin
        $display("********************************************************");
        $display("                          FAIL!                         ");
        $display("*                       SPEC SD-5 FAIL                 *");
        $display("********************************************************");
        repeat(2)@(negedge clk);
        $finish;
    end

    golden_crc16 = CRC16_CCITT(SD_data_temp);
    if(golden_crc16 !== crc16) begin
        $display("********************************************************");
        $display("                          FAIL!                         ");
        $display("*                       SPEC SD-4 FAIL                 *");
        $display("********************************************************");
        repeat(2)@(negedge clk);
        $finish;
    end

end endtask

task DATA_RESPONSE; begin
    for(i = 0; i < 8; i = i + 1) begin
        MISO = 0;
        if(i == 5 || i == 7)
            MISO = 1;
        @(posedge clk);
    end 

    unit = $urandom_range(0, 32);
    MISO = 0;
    repeat(8*unit)@(posedge clk);
    SD[address] = SD_data_temp;
    MISO = 1;

end endtask


//////////////////////////////////////////////////////////////////////




task YOU_FAIL_task; begin
    $display("*                              FAIL!                                    *");
    $display("*                 Error message from pseudo_SD.v                        *");
end endtask

function automatic [6:0] CRC7;  // Return 7-bit result
    input [39:0] data;  // 40-bit data input
    reg [6:0] crc;
    integer i;
    reg data_in, data_out;
    parameter polynomial = 7'h9;  // x^7 + x^3 + 1

    begin
        crc = 7'd0;
        for (i = 0; i < 40; i = i + 1) begin
            data_in = data[39-i];
            data_out = crc[6];
            crc = crc << 1;  // Shift the CRC
            if (data_in ^ data_out) begin
                crc = crc ^ polynomial;
            end
        end
        CRC7 = crc;
    end
endfunction

function automatic [15:0] CRC16_CCITT;
    input [63:0] data;  // 40-bit data input
    reg [15:0] crc;
    integer i;
    reg data_in, data_out;
    parameter polynomial = 16'h1021;  // x^16 + x^12 + x^5 + 1

    begin
        crc = 16'd0;
        for (i = 0; i < 64; i = i + 1) begin
            data_in = data[63-i];
            data_out = crc[15];
            crc = crc << 1;  // Shift the CRC
            if (data_in ^ data_out) begin
                crc = crc ^ polynomial;
            end
        end
        CRC16_CCITT = crc;
    end
endfunction

endmodule