module CHIP(
    //Input Port
    clk,
    rst_n,
    in_valid,
    in_valid2,
    mode,
    matrix,
    matrix_idx,
    matrix_size,

    //Output Port
    out_valid,
    out_value
);


input           clk, rst_n, in_valid, in_valid2;
input           mode;
input   [ 7:0]  matrix;
input   [ 3:0]  matrix_idx;
input   [ 1:0]  matrix_size;
output          out_valid;
output          out_value;

wire C_clk;
wire C_rst_n;
wire C_in_valid;
wire C_in_valid2;
wire C_mode;
wire [7:0] C_matrix;
wire [3:0] C_matrix_idx;
wire [1:0] C_matrix_size;
wire C_out_valid;
wire C_out_value;

//TA has already defined for you
// CLKBUFX20 buf0(.A(C_clk),.Y(BUF_CLK));
//LBP module
CAD CORE(
    .clk(C_clk),
    .rst_n(C_rst_n),
    .in_valid(C_in_valid),
    .in_valid2(C_in_valid2),
    .mode(C_mode),
    .matrix(C_matrix),
    .matrix_size(C_matrix_size),
    .matrix_idx(C_matrix_idx),
    .out_valid(C_out_valid),
    .out_value(C_out_value)
    );

// CLKBUFX20 buf0(.A(C_clk),.Y(BUF_CLK));

XMD I_CLK               ( .O(C_clk),            .I(clk),                .PU(1'b0), .PD(1'b0), .SMT(1'b0));
XMD I_rstn              ( .O(C_rst_n),          .I(rst_n),              .PU(1'b0), .PD(1'b0), .SMT(1'b0));
XMD I_in_valid          ( .O(C_in_valid),       .I(in_valid),           .PU(1'b0), .PD(1'b0), .SMT(1'b0));
XMD I_mode              ( .O(C_mode),           .I(mode),               .PU(1'b0), .PD(1'b0), .SMT(1'b0));
XMD I_in_valid2         ( .O(C_in_valid2),      .I(in_valid2),          .PU(1'b0), .PD(1'b0), .SMT(1'b0));
XMD I_c_matrix1          ( .O(C_matrix[0]),         .I(matrix[0]),             .PU(1'b0), .PD(1'b0), .SMT(1'b0));
XMD I_c_matrix2         ( .O(C_matrix[1]),         .I(matrix[1]),             .PU(1'b0), .PD(1'b0), .SMT(1'b0));
XMD I_c_matrix3          ( .O(C_matrix[2]),         .I(matrix[2]),             .PU(1'b0), .PD(1'b0), .SMT(1'b0));
XMD I_c_matrix4          ( .O(C_matrix[3]),         .I(matrix[3]),             .PU(1'b0), .PD(1'b0), .SMT(1'b0));
XMD I_c_matrix5          ( .O(C_matrix[4]),         .I(matrix[4]),             .PU(1'b0), .PD(1'b0), .SMT(1'b0));
XMD I_c_matrix6          ( .O(C_matrix[5]),         .I(matrix[5]),             .PU(1'b0), .PD(1'b0), .SMT(1'b0));
XMD I_c_matrix7          ( .O(C_matrix[6]),         .I(matrix[6]),             .PU(1'b0), .PD(1'b0), .SMT(1'b0));
XMD I_c_matrix8          ( .O(C_matrix[7]),         .I(matrix[7]),             .PU(1'b0), .PD(1'b0), .SMT(1'b0));
XMD I_c_matrix_idx1      ( .O(C_matrix_idx[0]),     .I(matrix_idx[0]),         .PU(1'b0), .PD(1'b0), .SMT(1'b0));
XMD I_c_matrix_idx2      ( .O(C_matrix_idx[1]),     .I(matrix_idx[1]),         .PU(1'b0), .PD(1'b0), .SMT(1'b0));
XMD I_c_matrix_idx3      ( .O(C_matrix_idx[2]),     .I(matrix_idx[2]),         .PU(1'b0), .PD(1'b0), .SMT(1'b0));
XMD I_c_matrix_idx4      ( .O(C_matrix_idx[3]),     .I(matrix_idx[3]),         .PU(1'b0), .PD(1'b0), .SMT(1'b0));
XMD I_c_matrix_size1     ( .O(C_matrix_size[0]),    .I(matrix_size[0]),        .PU(1'b0), .PD(1'b0), .SMT(1'b0));
XMD I_c_matrix_size2     ( .O(C_matrix_size[1]),    .I(matrix_size[1]),        .PU(1'b0), .PD(1'b0), .SMT(1'b0));

YA2GSD O_VALID          ( .I(C_out_valid),      .O(out_valid),          .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0));
YA2GSD O_VALUE          ( .I(C_out_value),      .O(out_value),          .E(1'b1), .E2(1'b1), .E4(1'b1), .E8(1'b0), .SR(1'b0));
//I/O power 3.3V pads x? (DVDD + DGND)
VCC3IOD VDDP0 ();
GNDIOD  GNDP0 ();
VCC3IOD VDDP1 ();
GNDIOD  GNDP1 ();
VCC3IOD VDDP2 ();
GNDIOD  GNDP2 ();
VCC3IOD VDDP3 ();
GNDIOD  GNDP3 ();
//...

//Core poweri 1.8V pads x? (VDD + GND)
VCCKD VDDC0 ();
GNDKD GNDC0 ();
VCCKD VDDC1 ();
GNDKD GNDC1 ();
VCCKD VDDC2 ();
GNDKD GNDC2 ();
VCCKD VDDC3 ();
GNDKD GNDC3 ();
//...



endmodule

