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

/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : T-2022.03
// Date      : Tue Dec 12 16:18:36 2023
/////////////////////////////////////////////////////////////


module CAD ( clk, rst_n, in_valid, in_valid2, matrix_size, matrix, matrix_idx, 
        mode, out_valid, out_value );
  input [1:0] matrix_size;
  input [7:0] matrix;
  input [3:0] matrix_idx;
  input clk, rst_n, in_valid, in_valid2, mode;
  output out_valid, out_value;
  wire   SRAM0_WEB, SRAM1_WEB, SRAMK_WEB, addsub0_op, kernel_start_flag,
         input_cnt_adder_cout, N84, N89, N90, N91, N92, N93, in_valid2_cnt,
         mode_reg, cv_r_0__2_, cv_r_0__1_, cv_r_0__0_, cv_r_1__2_, cv_r_1__1_,
         cv_r_1__0_, cv_r_2__2_, cv_r_2__1_, cv_r_2__0_, cv_k_0__1_,
         cv_k_0__0_, cv_k_1__0_, cv_k_2__0_, cv_j_0__6_, cv_j_0__5_,
         cv_j_0__4_, cv_j_0__3_, cv_j_0__2_, cv_j_0__1_, cv_j_0__0_,
         cv_j_1__6_, cv_j_1__5_, cv_j_1__4_, cv_j_1__3_, cv_j_1__2_,
         cv_j_1__1_, cv_j_1__0_, cv_j_2__6_, cv_j_2__5_, cv_j_2__4_,
         cv_j_2__3_, cv_j_2__2_, cv_j_2__1_, cv_j_2__0_, cv_i_0__6_,
         cv_i_0__5_, cv_i_0__4_, cv_i_0__3_, cv_i_0__2_, cv_i_0__1_,
         cv_i_0__0_, cv_i_1__6_, cv_i_1__5_, cv_i_1__4_, cv_i_1__3_,
         cv_i_1__2_, cv_i_1__1_, cv_i_1__0_, cv_i_2__6_, cv_i_2__5_,
         cv_i_2__4_, cv_i_2__3_, cv_i_2__2_, cv_i_2__1_, cv_i_2__0_, N184,
         N185, N186, N193, N197, N198, N199, N200, N201, N202, N203, N211,
         N212, N213, N214, N215, N216, N217, N218, N219, N220, N221, N222,
         N223, N224, N232, N233, N234, N235, N236, N237, N238, N239, N240,
         N241, N243, N244, N245, N246, N247, N249, N250, done, N543, N545,
         N546, N547, N978, N979, N980, N981, N982, N983, N984, N985, N986,
         N987, N988, N989, N990, N991, N992, N993, N994, N995, N996, N997,
         n868, n869, n870, n871, n872, n873, n874, n875, n876, n877, n878,
         n879, n880, n881, n882, n883, n884, n885, n886, n887, n888, n889,
         n890, n891, n892, n893, n894, n895, n896, n897, n898, n899, n900,
         n901, n902, n903, n904, n905, n906, n907, n908, n909, n910, n911,
         n912, n913, n914, n915, n916, n917, n918, n919, n920, n921, n922,
         n923, n924, n925, n926, n927, n928, n929, n930, n931, n932, n933,
         n934, n935, n936, n937, n938, n939, n940, n941, n942, n943, n944,
         n945, n946, n947, n948, n949, n950, n951, n952, n953, n954, n955,
         n956, n957, n958, n959, n960, n961, n962, n963, n964, n965, n967,
         n968, n969, n970, n971, n972, n973, n974, n975, n976, n977, n9780,
         n9790, n9800, n9810, n9820, n9830, n9840, n9850, n9860, n9870, n9880,
         n9900, n9910, n9920, n9930, n9940, n9950, n9960, n9970, n998, n999,
         n1000, n1001, n1002, n1003, n1004, n1005, n1006, n1007, n1008,
         DP_OP_193J1_122_2323_n7, DP_OP_193J1_122_2323_n6,
         DP_OP_193J1_122_2323_n5, DP_OP_193J1_122_2323_n4,
         DP_OP_193J1_122_2323_n3, DP_OP_193J1_122_2323_n2, n1011, n1012, n1013,
         n1014, n1015, n1016, n1017, n1018, n1019, n1020, n1021, n1022, n1023,
         n1024, n1025, n1026, n1027, n1028, n1029, n1030, n1031, n1032, n1033,
         n1034, n1035, n1036, n1037, n1038, n1039, n1040, n1041, n1042, n1043,
         n1044, n1045, n1046, n1047, n1048, n1049, n1050, n1051, n1052, n1053,
         n1054, n1055, n1056, n1057, n1058, n1059, n1060, n1061, n1062, n1063,
         n1064, n1065, n1066, n1067, n1068, n1069, n1070, n1071, n1072, n1073,
         n1074, n1075, n1076, n1077, n1078, n1079, n1080, n1081, n1082, n1083,
         n1084, n1085, n1086, n1087, n1088, n1089, n1090, n1091, n1092, n1093,
         n1094, n1095, n1096, n1097, n1098, n1099, n1100, n1101, n1102, n1103,
         n1104, n1105, n1106, n1107, n1108, n1109, n1110, n1111, n1112, n1113,
         n1114, n1115, n1116, n1117, n1118, n1119, n1120, n1121, n1122, n1123,
         n1124, n1125, n1126, n1127, n1128, n1129, n1130, n1131, n1132, n1133,
         n1134, n1135, n1136, n1137, n1138, n1139, n1140, n1141, n1142, n1143,
         n1144, n1145, n1146, n1147, n1148, n1149, n1150, n1151, n1152, n1153,
         n1154, n1155, n1156, n1157, n1158, n1159, n1160, n1161, n1162, n1163,
         n1164, n1165, n1166, n1167, n1168, n1169, n1170, n1171, n1172, n1173,
         n1174, n1175, n1176, n1177, n1178, n1179, n1180, n1181, n1182, n1183,
         n1184, n1185, n1186, n1187, n1188, n1189, n1190, n1191, n1192, n1193,
         n1194, n1195, n1196, n1197, n1198, n1199, n1200, n1201, n1202, n1203,
         n1204, n1205, n1206, n1207, n1208, n1209, n1210, n1211, n1212, n1213,
         n1214, n1215, n1216, n1217, n1218, n1219, n1220, n1221, n1222, n1223,
         n1224, n1225, n1226, n1227, n1228, n1229, n1230, n1231, n1232, n1233,
         n1234, n1235, n1236, n1237, n1238, n1239, n1240, n1241, n1242, n1243,
         n1244, n1245, n1246, n1247, n1248, n1249, n1250, n1251, n1252, n1253,
         n1254, n1255, n1256, n1257, n1258, n1259, n1260, n1261, n1262, n1263,
         n1264, n1265, n1266, n1267, n1268, n1269, n1270, n1271, n1272, n1273,
         n1274, n1275, n1276, n1277, n1278, n1279, n1280, n1281, n1282, n1283,
         n1284, n1285, n1286, n1287, n1288, n1289, n1290, n1291, n1292, n1293,
         n1294, n1295, n1296, n1297, n1298, n1299, n1300, n1301, n1302, n1303,
         n1304, n1305, n1306, n1307, n1308, n1309, n1310, n1311, n1312, n1313,
         n1314, n1315, n1316, n1317, n1318, n1319, n1320, n1321, n1322, n1323,
         n1324, n1325, n1326, n1327, n1328, n1329, n1330, n1331, n1332, n1333,
         n1334, n1335, n1336, n1337, n1338, n1339, n1340, n1341, n1342, n1343,
         n1344, n1345, n1346, n1347, n1348, n1349, n1350, n1351, n1352, n1353,
         n1354, n1355, n1356, n1357, n1358, n1359, n1360, n1361, n1362, n1363,
         n1364, n1365, n1366, n1367, n1368, n1369, n1370, n1371, n1372, n1373,
         n1374, n1375, n1376, n1377, n1378, n1379, n1380, n1381, n1382, n1383,
         n1384, n1385, n1386, n1387, n1388, n1389, n1390, n1391, n1392, n1393,
         n1394, n1395, n1396, n1397, n1398, n1399, n1400, n1401, n1402, n1403,
         n1404, n1405, n1406, n1407, n1408, n1409, n1410, n1411, n1412, n1413,
         n1414, n1415, n1416, n1417, n1418, n1419, n1420, n1421, n1422, n1423,
         n1424, n1425, n1426, n1427, n1428, n1429, n1430, n1431, n1432, n1433,
         n1434, n1435, n1436, n1437, n1438, n1439, n1440, n1441, n1442, n1443,
         n1444, n1445, n1446, n1447, n1448, n1449, n1450, n1451, n1452, n1453,
         n1454, n1455, n1456, n1457, n1458, n1459, n1460, n1461, n1462, n1463,
         n1464, n1465, n1466, n1467, n1468, n1469, n1470, n1471, n1472, n1473,
         n1474, n1475, n1476, n1477, n1478, n1479, n1480, n1481, n1482, n1483,
         n1484, n1485, n1486, n1487, n1488, n1489, n1490, n1491, n1492, n1493,
         n1494, n1495, n1496, n1497, n1498, n1499, n1500, n1501, n1502, n1503,
         n1504, n1505, n1506, n1507, n1508, n1509, n1510, n1511, n1512, n1513,
         n1514, n1515, n1516, n1517, n1518, n1519, n1520, n1521, n1522, n1523,
         n1524, n1525, n1526, n1527, n1528, n1529, n1530, n1531, n1532, n1533,
         n1534, n1535, n1536, n1537, n1538, n1539, n1540, n1541, n1542, n1543,
         n1544, n1545, n1546, n1547, n1548, n1549, n1550, n1551, n1552, n1553,
         n1554, n1555, n1556, n1557, n1558, n1559, n1560, n1561, n1562, n1563,
         n1564, n1565, n1566, n1567, n1568, n1569, n1570, n1571, n1572, n1573,
         n1574, n1575, n1576, n1577, n1578, n1579, n1580, n1581, n1582, n1583,
         n1584, n1585, n1586, n1587, n1588, n1589, n1590, n1591, n1592, n1593,
         n1594, n1595, n1596, n1597, n1598, n1599, n1600, n1601, n1602, n1603,
         n1604, n1605, n1606, n1607, n1608, n1609, n1610, n1611, n1612, n1613,
         n1614, n1615, n1616, n1617, n1618, n1619, n1620, n1621, n1622, n1623,
         n1624, n1625, n1626, n1627, n1628, n1629, n1630, n1631, n1632, n1633,
         n1634, n1635, n1636, n1637, n1638, n1639, n1640, n1641, n1642, n1643,
         n1644, n1645, n1646, n1647, n1648, n1649, n1650, n1651, n1652, n1653,
         n1654, n1655, n1656, n1657, n1658, n1659, n1660, n1661, n1662, n1663,
         n1664, n1665, n1666, n1667, n1668, n1669, n1670, n1671, n1672, n1673,
         n1674, n1675, n1676, n1677, n1678, n1679, n1680, n1681, n1682, n1683,
         n1684, n1685, n1686, n1687, n1688, n1689, n1690, n1691, n1692,
         SYNOPSYS_UNCONNECTED_1, SYNOPSYS_UNCONNECTED_2,
         SYNOPSYS_UNCONNECTED_3;
  wire   [10:0] SRAM0_addr;
  wire   [31:0] SRAM0_data_o;
  wire   [31:0] SRAM0_data_i;
  wire   [10:0] SRAM1_addr;
  wire   [31:0] SRAM1_data_o;
  wire   [6:0] SRAMK_addr;
  wire   [39:0] SRAMK_data_o;
  wire   [39:32] SRAMK_data_i;
  wire   [39:0] muln_a;
  wire   [7:0] mul0_b;
  wire   [15:0] mul0_o;
  wire   [7:0] mul1_b;
  wire   [15:0] mul1_o;
  wire   [7:0] mul2_b;
  wire   [15:0] mul2_o;
  wire   [7:0] mul3_b;
  wire   [15:0] mul3_o;
  wire   [7:0] mul4_b;
  wire   [15:0] mul4_o;
  wire   [19:0] sum60_a;
  wire   [19:0] sum60_o;
  wire   [4:0] addsub0_b;
  wire   [10:0] addsub0_o;
  wire   [2:0] addsub1_b;
  wire   [10:0] addsub1_o;
  wire   [13:0] input_cnt;
  wire   [1:0] matrix_size_reg;
  wire   [13:1] input_cnt_next;
  wire   [4:1] input_kernel_cnt_sh;
  wire   [39:8] input_temp_reg_next;
  wire   [0:4] cv_v;
  wire   [1:3] cv_r_overflow;
  wire   [1:3] cv_k_overflow;
  wire   [1:3] cv_i_overflow;
  wire   [31:0] SRAM0_data_o_reg;
  wire   [31:0] SRAM1_data_o_reg;
  wire   [39:0] SRAMK_data_o_reg;
  wire   [19:0] mp_value;
  wire   [19:0] out_value20;
  wire   [4:0] out_valid_tail_cnt;

  SRAM_32x2048 SRAM0 ( .A0(SRAM0_addr[0]), .A1(SRAM0_addr[1]), .A10(
        SRAM0_addr[10]), .A2(SRAM0_addr[2]), .A3(SRAM0_addr[3]), .A4(
        SRAM0_addr[4]), .A5(SRAM0_addr[5]), .A6(SRAM0_addr[6]), .A7(
        SRAM0_addr[7]), .A8(SRAM0_addr[8]), .A9(SRAM0_addr[9]), .CK(clk), .CS(
        n905), .DI0(SRAM0_data_i[0]), .DI1(SRAM0_data_i[1]), .DI10(
        SRAM0_data_i[10]), .DI11(SRAM0_data_i[11]), .DI12(SRAM0_data_i[12]), 
        .DI13(SRAM0_data_i[13]), .DI14(SRAM0_data_i[14]), .DI15(
        SRAM0_data_i[15]), .DI16(SRAM0_data_i[16]), .DI17(SRAM0_data_i[17]), 
        .DI18(SRAM0_data_i[18]), .DI19(SRAM0_data_i[19]), .DI2(SRAM0_data_i[2]), .DI20(SRAM0_data_i[20]), .DI21(SRAM0_data_i[21]), .DI22(SRAM0_data_i[22]), 
        .DI23(SRAM0_data_i[23]), .DI24(SRAM0_data_i[24]), .DI25(
        SRAM0_data_i[25]), .DI26(SRAM0_data_i[26]), .DI27(SRAM0_data_i[27]), 
        .DI28(SRAM0_data_i[28]), .DI29(SRAM0_data_i[29]), .DI3(SRAM0_data_i[3]), .DI30(SRAM0_data_i[30]), .DI31(SRAM0_data_i[31]), .DI4(SRAM0_data_i[4]), 
        .DI5(SRAM0_data_i[5]), .DI6(SRAM0_data_i[6]), .DI7(SRAM0_data_i[7]), 
        .DI8(SRAM0_data_i[8]), .DI9(SRAM0_data_i[9]), .OE(n905), .WEB(n1007), 
        .DO0(SRAM0_data_o[0]), .DO1(SRAM0_data_o[1]), .DO10(SRAM0_data_o[10]), 
        .DO11(SRAM0_data_o[11]), .DO12(SRAM0_data_o[12]), .DO13(
        SRAM0_data_o[13]), .DO14(SRAM0_data_o[14]), .DO15(SRAM0_data_o[15]), 
        .DO16(SRAM0_data_o[16]), .DO17(SRAM0_data_o[17]), .DO18(
        SRAM0_data_o[18]), .DO19(SRAM0_data_o[19]), .DO2(SRAM0_data_o[2]), 
        .DO20(SRAM0_data_o[20]), .DO21(SRAM0_data_o[21]), .DO22(
        SRAM0_data_o[22]), .DO23(SRAM0_data_o[23]), .DO24(SRAM0_data_o[24]), 
        .DO25(SRAM0_data_o[25]), .DO26(SRAM0_data_o[26]), .DO27(
        SRAM0_data_o[27]), .DO28(SRAM0_data_o[28]), .DO29(SRAM0_data_o[29]), 
        .DO3(SRAM0_data_o[3]), .DO30(SRAM0_data_o[30]), .DO31(SRAM0_data_o[31]), .DO4(SRAM0_data_o[4]), .DO5(SRAM0_data_o[5]), .DO6(SRAM0_data_o[6]), .DO7(
        SRAM0_data_o[7]), .DO8(SRAM0_data_o[8]), .DO9(SRAM0_data_o[9]) );
  SRAM_32x2048 SRAM1 ( .A0(SRAM1_addr[0]), .A1(SRAM1_addr[1]), .A10(
        SRAM1_addr[10]), .A2(SRAM1_addr[2]), .A3(SRAM1_addr[3]), .A4(
        SRAM1_addr[4]), .A5(SRAM1_addr[5]), .A6(SRAM1_addr[6]), .A7(
        SRAM1_addr[7]), .A8(SRAM1_addr[8]), .A9(SRAM1_addr[9]), .CK(clk), .CS(
        n905), .DI0(SRAM0_data_i[0]), .DI1(SRAM0_data_i[1]), .DI10(
        SRAM0_data_i[10]), .DI11(SRAM0_data_i[11]), .DI12(SRAM0_data_i[12]), 
        .DI13(SRAM0_data_i[13]), .DI14(SRAM0_data_i[14]), .DI15(
        SRAM0_data_i[15]), .DI16(SRAM0_data_i[16]), .DI17(SRAM0_data_i[17]), 
        .DI18(SRAM0_data_i[18]), .DI19(SRAM0_data_i[19]), .DI2(SRAM0_data_i[2]), .DI20(SRAM0_data_i[20]), .DI21(SRAM0_data_i[21]), .DI22(SRAM0_data_i[22]), 
        .DI23(SRAM0_data_i[23]), .DI24(SRAM0_data_i[24]), .DI25(
        SRAM0_data_i[25]), .DI26(SRAM0_data_i[26]), .DI27(SRAM0_data_i[27]), 
        .DI28(SRAM0_data_i[28]), .DI29(SRAM0_data_i[29]), .DI3(SRAM0_data_i[3]), .DI30(SRAM0_data_i[30]), .DI31(SRAM0_data_i[31]), .DI4(SRAM0_data_i[4]), 
        .DI5(SRAM0_data_i[5]), .DI6(SRAM0_data_i[6]), .DI7(SRAM0_data_i[7]), 
        .DI8(SRAM0_data_i[8]), .DI9(SRAM0_data_i[9]), .OE(n905), .WEB(n1008), 
        .DO0(SRAM1_data_o[0]), .DO1(SRAM1_data_o[1]), .DO10(SRAM1_data_o[10]), 
        .DO11(SRAM1_data_o[11]), .DO12(SRAM1_data_o[12]), .DO13(
        SRAM1_data_o[13]), .DO14(SRAM1_data_o[14]), .DO15(SRAM1_data_o[15]), 
        .DO16(SRAM1_data_o[16]), .DO17(SRAM1_data_o[17]), .DO18(
        SRAM1_data_o[18]), .DO19(SRAM1_data_o[19]), .DO2(SRAM1_data_o[2]), 
        .DO20(SRAM1_data_o[20]), .DO21(SRAM1_data_o[21]), .DO22(
        SRAM1_data_o[22]), .DO23(SRAM1_data_o[23]), .DO24(SRAM1_data_o[24]), 
        .DO25(SRAM1_data_o[25]), .DO26(SRAM1_data_o[26]), .DO27(
        SRAM1_data_o[27]), .DO28(SRAM1_data_o[28]), .DO29(SRAM1_data_o[29]), 
        .DO3(SRAM1_data_o[3]), .DO30(SRAM1_data_o[30]), .DO31(SRAM1_data_o[31]), .DO4(SRAM1_data_o[4]), .DO5(SRAM1_data_o[5]), .DO6(SRAM1_data_o[6]), .DO7(
        SRAM1_data_o[7]), .DO8(SRAM1_data_o[8]), .DO9(SRAM1_data_o[9]) );
  SRAM_40x80 SRAMK ( .A0(SRAMK_addr[0]), .A1(SRAMK_addr[1]), .A2(SRAMK_addr[2]), .A3(SRAMK_addr[3]), .A4(SRAMK_addr[4]), .A5(SRAMK_addr[5]), .A6(
        SRAMK_addr[6]), .CK(clk), .CS(n905), .DI0(SRAM0_data_i[0]), .DI1(
        SRAM0_data_i[1]), .DI10(SRAM0_data_i[10]), .DI11(SRAM0_data_i[11]), 
        .DI12(SRAM0_data_i[12]), .DI13(SRAM0_data_i[13]), .DI14(
        SRAM0_data_i[14]), .DI15(SRAM0_data_i[15]), .DI16(SRAM0_data_i[16]), 
        .DI17(SRAM0_data_i[17]), .DI18(SRAM0_data_i[18]), .DI19(
        SRAM0_data_i[19]), .DI2(SRAM0_data_i[2]), .DI20(SRAM0_data_i[20]), 
        .DI21(SRAM0_data_i[21]), .DI22(SRAM0_data_i[22]), .DI23(
        SRAM0_data_i[23]), .DI24(SRAM0_data_i[24]), .DI25(SRAM0_data_i[25]), 
        .DI26(SRAM0_data_i[26]), .DI27(SRAM0_data_i[27]), .DI28(
        SRAM0_data_i[28]), .DI29(SRAM0_data_i[29]), .DI3(SRAM0_data_i[3]), 
        .DI30(SRAM0_data_i[30]), .DI31(SRAM0_data_i[31]), .DI32(
        SRAMK_data_i[32]), .DI33(SRAMK_data_i[33]), .DI34(SRAMK_data_i[34]), 
        .DI35(SRAMK_data_i[35]), .DI36(SRAMK_data_i[36]), .DI37(
        SRAMK_data_i[37]), .DI38(SRAMK_data_i[38]), .DI39(SRAMK_data_i[39]), 
        .DI4(SRAM0_data_i[4]), .DI5(SRAM0_data_i[5]), .DI6(SRAM0_data_i[6]), 
        .DI7(SRAM0_data_i[7]), .DI8(SRAM0_data_i[8]), .DI9(SRAM0_data_i[9]), 
        .OE(n905), .WEB(n1006), .DO0(SRAMK_data_o[0]), .DO1(SRAMK_data_o[1]), 
        .DO10(SRAMK_data_o[10]), .DO11(SRAMK_data_o[11]), .DO12(
        SRAMK_data_o[12]), .DO13(SRAMK_data_o[13]), .DO14(SRAMK_data_o[14]), 
        .DO15(SRAMK_data_o[15]), .DO16(SRAMK_data_o[16]), .DO17(
        SRAMK_data_o[17]), .DO18(SRAMK_data_o[18]), .DO19(SRAMK_data_o[19]), 
        .DO2(SRAMK_data_o[2]), .DO20(SRAMK_data_o[20]), .DO21(SRAMK_data_o[21]), .DO22(SRAMK_data_o[22]), .DO23(SRAMK_data_o[23]), .DO24(SRAMK_data_o[24]), 
        .DO25(SRAMK_data_o[25]), .DO26(SRAMK_data_o[26]), .DO27(
        SRAMK_data_o[27]), .DO28(SRAMK_data_o[28]), .DO29(SRAMK_data_o[29]), 
        .DO3(SRAMK_data_o[3]), .DO30(SRAMK_data_o[30]), .DO31(SRAMK_data_o[31]), .DO32(SRAMK_data_o[32]), .DO33(SRAMK_data_o[33]), .DO34(SRAMK_data_o[34]), 
        .DO35(SRAMK_data_o[35]), .DO36(SRAMK_data_o[36]), .DO37(
        SRAMK_data_o[37]), .DO38(SRAMK_data_o[38]), .DO39(SRAMK_data_o[39]), 
        .DO4(SRAMK_data_o[4]), .DO5(SRAMK_data_o[5]), .DO6(SRAMK_data_o[6]), 
        .DO7(SRAMK_data_o[7]), .DO8(SRAMK_data_o[8]), .DO9(SRAMK_data_o[9]) );
  MULTIPLIER_4 mul_inst0 ( .clk(clk), .rst_n(n1692), .a(muln_a[7:0]), .b(
        mul0_b), .o(mul0_o) );
  MULTIPLIER_3 mul_inst1 ( .clk(clk), .rst_n(n1692), .a(muln_a[15:8]), .b(
        mul1_b), .o(mul1_o) );
  MULTIPLIER_2 mul_inst2 ( .clk(clk), .rst_n(n1692), .a(muln_a[23:16]), .b(
        mul2_b), .o(mul2_o) );
  MULTIPLIER_1 mul_inst3 ( .clk(clk), .rst_n(n1692), .a(muln_a[31:24]), .b(
        mul3_b), .o(mul3_o) );
  MULTIPLIER_0 mul_inst4 ( .clk(clk), .rst_n(n1692), .a(muln_a[39:32]), .b(
        mul4_b), .o(mul4_o) );
  SUM6 sum6_inst0 ( .clk(clk), .rst_n(n1692), .a(sum60_a), .b({n1692, 
        mul0_o[15], n1692, n1692, n1692, mul0_o[14:0]}), .c({n1692, mul1_o[15], 
        n1692, n1692, n1692, mul1_o[14:0]}), .d({n1692, mul2_o[15], n1692, 
        n1692, n1692, mul2_o[14:0]}), .e({n1692, mul3_o[15], n1692, n1692, 
        n1692, mul3_o[14:0]}), .f({n1692, mul4_o[15], n1692, n1692, n1692, 
        mul4_o[14:0]}), .o(sum60_o) );
  ADDR_ADDSUB_1 addr_addsun_inst0 ( .a({n1692, SRAM0_addr}), .b({n1692, n1692, 
        n1692, n1692, n1692, n1692, n1692, addsub0_b}), .op(addsub0_op), .o({
        SYNOPSYS_UNCONNECTED_1, addsub0_o}) );
  ADDR_ADDSUB_0 addr_addsun_inst1 ( .a({n1692, SRAM1_addr}), .b({n1692, n1692, 
        n1692, n1692, n1692, n1692, n1692, addsub0_b[4:3], addsub1_b}), .op(
        addsub0_op), .o({SYNOPSYS_UNCONNECTED_2, addsub1_o}) );
  INPUT_CNT_ADDER input_cnt_adder_inst ( .cnt(input_cnt), .matrix_size(
        matrix_size_reg), .flag(kernel_start_flag), .cnt_next({input_cnt_next, 
        SYNOPSYS_UNCONNECTED_3}), .cout(input_cnt_adder_cout) );
  QDFFRBS input_cnt_reg_0_ ( .D(n1005), .CK(clk), .RB(n1691), .Q(input_cnt[0])
         );
  QDFFRBS kernel_start_flag_reg ( .D(N84), .CK(clk), .RB(n1011), .Q(
        kernel_start_flag) );
  QDFFRBS input_kernel_cnt_sh_reg_4_ ( .D(N93), .CK(clk), .RB(n1687), .Q(
        input_kernel_cnt_sh[4]) );
  QDFFRBS input_kernel_cnt_sh_reg_1_ ( .D(N90), .CK(clk), .RB(n1686), .Q(
        input_kernel_cnt_sh[1]) );
  QDFFRBS input_kernel_cnt_sh_reg_2_ ( .D(N91), .CK(clk), .RB(n1687), .Q(
        input_kernel_cnt_sh[2]) );
  QDFFRBS input_kernel_cnt_sh_reg_3_ ( .D(N92), .CK(clk), .RB(n1686), .Q(
        input_kernel_cnt_sh[3]) );
  QDFFRBS input_cnt_reg_1_ ( .D(n1004), .CK(clk), .RB(n1687), .Q(input_cnt[1])
         );
  QDFFRBS input_cnt_reg_2_ ( .D(n1003), .CK(clk), .RB(n1687), .Q(input_cnt[2])
         );
  QDFFRBS input_cnt_reg_3_ ( .D(n1002), .CK(clk), .RB(n1687), .Q(input_cnt[3])
         );
  QDFFRBS input_cnt_reg_4_ ( .D(n1001), .CK(clk), .RB(n1689), .Q(input_cnt[4])
         );
  QDFFRBS input_cnt_reg_5_ ( .D(n1000), .CK(clk), .RB(n1689), .Q(input_cnt[5])
         );
  QDFFRBS input_cnt_reg_6_ ( .D(n999), .CK(clk), .RB(n1690), .Q(input_cnt[6])
         );
  QDFFRBS input_cnt_reg_7_ ( .D(n998), .CK(clk), .RB(n1691), .Q(input_cnt[7])
         );
  QDFFRBS input_cnt_reg_8_ ( .D(n9970), .CK(clk), .RB(n1688), .Q(input_cnt[8])
         );
  QDFFRBS input_cnt_reg_9_ ( .D(n9960), .CK(clk), .RB(n1011), .Q(input_cnt[9])
         );
  QDFFRBS input_cnt_reg_10_ ( .D(n9950), .CK(clk), .RB(n1690), .Q(
        input_cnt[10]) );
  QDFFRBS input_cnt_reg_11_ ( .D(n9940), .CK(clk), .RB(n1688), .Q(
        input_cnt[11]) );
  QDFFRBS input_cnt_reg_12_ ( .D(n9930), .CK(clk), .RB(n1011), .Q(
        input_cnt[12]) );
  QDFFRBS input_cnt_reg_13_ ( .D(n9920), .CK(clk), .RB(n1011), .Q(
        input_cnt[13]) );
  QDFFRBS mode_reg_reg ( .D(n9910), .CK(clk), .RB(n1011), .Q(mode_reg) );
  QDFFRBS cv_r_reg_0__0_ ( .D(n951), .CK(clk), .RB(n1011), .Q(cv_r_0__0_) );
  QDFFRBS cv_r_reg_0__1_ ( .D(n952), .CK(clk), .RB(n1011), .Q(cv_r_0__1_) );
  QDFFRBS cv_r_reg_0__2_ ( .D(n955), .CK(clk), .RB(n1011), .Q(cv_r_0__2_) );
  QDFFRBS cv_r_reg_1__2_ ( .D(n1666), .CK(clk), .RB(n1011), .Q(cv_r_1__2_) );
  QDFFRBS cv_r_reg_1__1_ ( .D(n1674), .CK(clk), .RB(n1011), .Q(cv_r_1__1_) );
  QDFFRBS cv_r_reg_1__0_ ( .D(n1673), .CK(clk), .RB(n1011), .Q(cv_r_1__0_) );
  QDFFRBS cv_r_reg_2__2_ ( .D(N186), .CK(clk), .RB(n1011), .Q(cv_r_2__2_) );
  QDFFRBS cv_r_reg_2__1_ ( .D(N185), .CK(clk), .RB(n1011), .Q(cv_r_2__1_) );
  QDFFRBS cv_r_reg_2__0_ ( .D(N184), .CK(clk), .RB(n1011), .Q(cv_r_2__0_) );
  QDFFRBS cv_k_reg_0__0_ ( .D(n953), .CK(clk), .RB(n1011), .Q(cv_k_0__0_) );
  QDFFRBS cv_k_reg_0__1_ ( .D(n954), .CK(clk), .RB(rst_n), .Q(cv_k_0__1_) );
  QDFFRBS cv_k_reg_1__0_ ( .D(n1675), .CK(clk), .RB(n1011), .Q(cv_k_1__0_) );
  QDFFRBS cv_k_reg_2__0_ ( .D(N193), .CK(clk), .RB(n1011), .Q(cv_k_2__0_) );
  QDFFRBS cv_j_reg_0__0_ ( .D(N211), .CK(clk), .RB(n1011), .Q(cv_j_0__0_) );
  QDFFRBS cv_j_reg_0__1_ ( .D(N212), .CK(clk), .RB(n1011), .Q(cv_j_0__1_) );
  QDFFRBS cv_j_reg_0__3_ ( .D(N214), .CK(clk), .RB(n1011), .Q(cv_j_0__3_) );
  QDFFRBS cv_j_reg_0__4_ ( .D(N215), .CK(clk), .RB(n1011), .Q(cv_j_0__4_) );
  QDFFRBS cv_j_reg_0__5_ ( .D(N216), .CK(clk), .RB(n1011), .Q(cv_j_0__5_) );
  QDFFRBS cv_j_reg_0__6_ ( .D(N217), .CK(clk), .RB(n1011), .Q(cv_j_0__6_) );
  QDFFRBS cv_j_reg_1__6_ ( .D(n1667), .CK(clk), .RB(n1011), .Q(cv_j_1__6_) );
  QDFFRBS cv_j_reg_1__5_ ( .D(n1672), .CK(clk), .RB(n1011), .Q(cv_j_1__5_) );
  QDFFRBS cv_j_reg_1__4_ ( .D(n1670), .CK(clk), .RB(n1011), .Q(cv_j_1__4_) );
  QDFFRBS cv_j_reg_1__3_ ( .D(n1671), .CK(clk), .RB(n1011), .Q(cv_j_1__3_) );
  QDFFRBS cv_j_reg_1__2_ ( .D(n1665), .CK(clk), .RB(n1011), .Q(cv_j_1__2_) );
  QDFFRBS cv_j_reg_1__1_ ( .D(n1669), .CK(clk), .RB(n1011), .Q(cv_j_1__1_) );
  QDFFRBS cv_j_reg_1__0_ ( .D(n1684), .CK(clk), .RB(n1011), .Q(cv_j_1__0_) );
  QDFFRBS cv_j_reg_2__6_ ( .D(N203), .CK(clk), .RB(n1011), .Q(cv_j_2__6_) );
  QDFFRBS cv_j_reg_2__5_ ( .D(N202), .CK(clk), .RB(n1011), .Q(cv_j_2__5_) );
  QDFFRBS cv_j_reg_2__4_ ( .D(N201), .CK(clk), .RB(n1011), .Q(cv_j_2__4_) );
  QDFFRBS cv_j_reg_2__3_ ( .D(N200), .CK(clk), .RB(n1011), .Q(cv_j_2__3_) );
  QDFFRBS cv_j_reg_2__2_ ( .D(N199), .CK(clk), .RB(n1011), .Q(cv_j_2__2_) );
  QDFFRBS cv_j_reg_2__1_ ( .D(N198), .CK(clk), .RB(n1011), .Q(cv_j_2__1_) );
  QDFFRBS cv_j_reg_2__0_ ( .D(N197), .CK(clk), .RB(n1011), .Q(cv_j_2__0_) );
  QDFFRBS cv_i_reg_0__0_ ( .D(N232), .CK(clk), .RB(n1011), .Q(cv_i_0__0_) );
  QDFFRBS cv_i_reg_0__1_ ( .D(N233), .CK(clk), .RB(n1011), .Q(cv_i_0__1_) );
  QDFFRBS cv_i_reg_0__2_ ( .D(N234), .CK(clk), .RB(n1011), .Q(cv_i_0__2_) );
  QDFFRBS cv_i_reg_0__3_ ( .D(N235), .CK(clk), .RB(n1687), .Q(cv_i_0__3_) );
  QDFFRBS cv_i_reg_0__4_ ( .D(N236), .CK(clk), .RB(n1011), .Q(cv_i_0__4_) );
  QDFFRBS cv_i_reg_0__5_ ( .D(N237), .CK(clk), .RB(n1011), .Q(cv_i_0__5_) );
  QDFFRBS cv_i_reg_0__6_ ( .D(N238), .CK(clk), .RB(n1011), .Q(cv_i_0__6_) );
  QDFFRBS cv_i_reg_1__6_ ( .D(n1683), .CK(clk), .RB(n1687), .Q(cv_i_1__6_) );
  QDFFRBS cv_i_reg_1__5_ ( .D(n1682), .CK(clk), .RB(n1687), .Q(cv_i_1__5_) );
  QDFFRBS cv_i_reg_1__4_ ( .D(n1681), .CK(clk), .RB(n1687), .Q(cv_i_1__4_) );
  QDFFRBS cv_i_reg_1__3_ ( .D(n1680), .CK(clk), .RB(n1687), .Q(cv_i_1__3_) );
  QDFFRBS cv_i_reg_1__2_ ( .D(n1679), .CK(clk), .RB(n1687), .Q(cv_i_1__2_) );
  QDFFRBS cv_i_reg_1__1_ ( .D(n1678), .CK(clk), .RB(n1687), .Q(cv_i_1__1_) );
  QDFFRBS cv_i_reg_1__0_ ( .D(n1677), .CK(clk), .RB(n1687), .Q(cv_i_1__0_) );
  QDFFRBS cv_i_reg_2__6_ ( .D(N224), .CK(clk), .RB(n1687), .Q(cv_i_2__6_) );
  QDFFRBS cv_i_reg_2__5_ ( .D(N223), .CK(clk), .RB(n1686), .Q(cv_i_2__5_) );
  QDFFRBS cv_i_reg_2__4_ ( .D(N222), .CK(clk), .RB(n1686), .Q(cv_i_2__4_) );
  QDFFRBS cv_i_reg_2__3_ ( .D(N221), .CK(clk), .RB(n1686), .Q(cv_i_2__3_) );
  QDFFRBS cv_i_reg_2__2_ ( .D(N220), .CK(clk), .RB(n1686), .Q(cv_i_2__2_) );
  QDFFRBS cv_i_reg_2__1_ ( .D(N219), .CK(clk), .RB(n1686), .Q(cv_i_2__1_) );
  QDFFRBS cv_i_reg_2__0_ ( .D(N218), .CK(clk), .RB(n1686), .Q(cv_i_2__0_) );
  QDFFRBS cv_v_reg_1_ ( .D(n1668), .CK(clk), .RB(n1686), .Q(cv_v[1]) );
  QDFFRBS cv_v_reg_2_ ( .D(N241), .CK(clk), .RB(n1686), .Q(cv_v[2]) );
  QDFFRBS cv_v_reg_3_ ( .D(N240), .CK(clk), .RB(n1686), .Q(cv_v[3]) );
  QDFFRBS cv_v_reg_4_ ( .D(N239), .CK(clk), .RB(n1687), .Q(cv_v[4]) );
  QDFFRBS cv_i_overflow_reg_1_ ( .D(N245), .CK(clk), .RB(n1686), .Q(
        cv_i_overflow[1]) );
  QDFFRBS cv_i_overflow_reg_2_ ( .D(N244), .CK(clk), .RB(rst_n), .Q(
        cv_i_overflow[2]) );
  QDFFRBS cv_i_overflow_reg_3_ ( .D(N243), .CK(clk), .RB(n1686), .Q(
        cv_i_overflow[3]) );
  QDFFRBS cv_r_overflow_reg_1_ ( .D(n1676), .CK(clk), .RB(n1686), .Q(
        cv_r_overflow[1]) );
  QDFFRBS cv_r_overflow_reg_2_ ( .D(N247), .CK(clk), .RB(n1686), .Q(
        cv_r_overflow[2]) );
  QDFFRBS cv_r_overflow_reg_3_ ( .D(N246), .CK(clk), .RB(n1686), .Q(
        cv_r_overflow[3]) );
  QDFFRBS cv_k_overflow_reg_1_ ( .D(n1664), .CK(clk), .RB(n1686), .Q(
        cv_k_overflow[1]) );
  QDFFRBS cv_k_overflow_reg_2_ ( .D(N250), .CK(clk), .RB(n1686), .Q(
        cv_k_overflow[2]) );
  QDFFRBS cv_k_overflow_reg_3_ ( .D(N249), .CK(clk), .RB(n1686), .Q(
        cv_k_overflow[3]) );
  QDFFRBS done_reg ( .D(n977), .CK(clk), .RB(n1687), .Q(done) );
  QDFFRBS SRAMK_WEB_reg ( .D(n976), .CK(clk), .RB(n1686), .Q(SRAMK_WEB) );
  QDFFRBS SRAM0_addr_reg_0_ ( .D(n9880), .CK(clk), .RB(n1687), .Q(
        SRAM0_addr[0]) );
  QDFFRBS SRAM0_addr_reg_1_ ( .D(n9780), .CK(clk), .RB(n1687), .Q(
        SRAM0_addr[1]) );
  QDFFRBS SRAM0_addr_reg_2_ ( .D(n9790), .CK(clk), .RB(n1687), .Q(
        SRAM0_addr[2]) );
  QDFFRBS SRAM0_addr_reg_3_ ( .D(n9800), .CK(clk), .RB(n1687), .Q(
        SRAM0_addr[3]) );
  QDFFRBS SRAM0_addr_reg_4_ ( .D(n9810), .CK(clk), .RB(n1687), .Q(
        SRAM0_addr[4]) );
  QDFFRBS SRAM0_addr_reg_5_ ( .D(n9820), .CK(clk), .RB(n1011), .Q(
        SRAM0_addr[5]) );
  QDFFRBS SRAM0_addr_reg_6_ ( .D(n9830), .CK(clk), .RB(n1011), .Q(
        SRAM0_addr[6]) );
  QDFFRBS SRAM0_addr_reg_7_ ( .D(n9840), .CK(clk), .RB(n1011), .Q(
        SRAM0_addr[7]) );
  QDFFRBS SRAM0_addr_reg_8_ ( .D(n9850), .CK(clk), .RB(n1011), .Q(
        SRAM0_addr[8]) );
  QDFFRBS SRAM0_addr_reg_9_ ( .D(n9860), .CK(clk), .RB(n1011), .Q(
        SRAM0_addr[9]) );
  QDFFRBS SRAM0_addr_reg_10_ ( .D(n9870), .CK(clk), .RB(n1687), .Q(
        SRAM0_addr[10]) );
  QDFFRBS SRAM1_addr_reg_0_ ( .D(n967), .CK(clk), .RB(n1011), .Q(SRAM1_addr[0]) );
  QDFFRBS SRAM1_addr_reg_1_ ( .D(n956), .CK(clk), .RB(n1011), .Q(SRAM1_addr[1]) );
  QDFFRBS SRAM1_addr_reg_2_ ( .D(n957), .CK(clk), .RB(n1011), .Q(SRAM1_addr[2]) );
  QDFFRBS SRAM1_addr_reg_3_ ( .D(n958), .CK(clk), .RB(n1011), .Q(SRAM1_addr[3]) );
  QDFFRBS SRAM1_addr_reg_4_ ( .D(n959), .CK(clk), .RB(n1687), .Q(SRAM1_addr[4]) );
  QDFFRBS SRAM1_addr_reg_5_ ( .D(n960), .CK(clk), .RB(n1686), .Q(SRAM1_addr[5]) );
  QDFFRBS SRAM1_addr_reg_6_ ( .D(n961), .CK(clk), .RB(n1011), .Q(SRAM1_addr[6]) );
  QDFFRBS SRAM1_addr_reg_7_ ( .D(n962), .CK(clk), .RB(n1686), .Q(SRAM1_addr[7]) );
  QDFFRBS SRAM1_addr_reg_8_ ( .D(n963), .CK(clk), .RB(n1686), .Q(SRAM1_addr[8]) );
  QDFFRBS SRAM1_addr_reg_9_ ( .D(n964), .CK(clk), .RB(n1686), .Q(SRAM1_addr[9]) );
  QDFFRBS SRAM1_addr_reg_10_ ( .D(n965), .CK(clk), .RB(n1011), .Q(
        SRAM1_addr[10]) );
  QDFFRBS SRAM0_WEB_reg ( .D(n968), .CK(clk), .RB(n1689), .Q(SRAM0_WEB) );
  QDFFRBS SRAM1_WEB_reg ( .D(n969), .CK(clk), .RB(n1691), .Q(SRAM1_WEB) );
  QDFFRBS SRAMK_addr_reg_6_ ( .D(n970), .CK(clk), .RB(n1691), .Q(SRAMK_addr[6]) );
  QDFFRBS SRAMK_addr_reg_5_ ( .D(n971), .CK(clk), .RB(n1691), .Q(SRAMK_addr[5]) );
  QDFFRBS SRAMK_addr_reg_4_ ( .D(n972), .CK(clk), .RB(n1691), .Q(SRAMK_addr[4]) );
  QDFFRBS SRAMK_addr_reg_3_ ( .D(n973), .CK(clk), .RB(n1691), .Q(SRAMK_addr[3]) );
  QDFFRBS SRAMK_addr_reg_2_ ( .D(n974), .CK(clk), .RB(n1691), .Q(SRAMK_addr[2]) );
  QDFFRBS SRAMK_addr_reg_1_ ( .D(n975), .CK(clk), .RB(n1691), .Q(SRAMK_addr[1]) );
  QDFFRBS SRAMK_addr_reg_0_ ( .D(n9900), .CK(clk), .RB(n1691), .Q(
        SRAMK_addr[0]) );
  QDFFRBS conv_sum_reg_0_ ( .D(n950), .CK(clk), .RB(n1691), .Q(sum60_a[0]) );
  QDFFRBS conv_sum_reg_1_ ( .D(n949), .CK(clk), .RB(n1691), .Q(sum60_a[1]) );
  QDFFRBS conv_sum_reg_2_ ( .D(n948), .CK(clk), .RB(n1691), .Q(sum60_a[2]) );
  QDFFRBS conv_sum_reg_3_ ( .D(n947), .CK(clk), .RB(n1691), .Q(sum60_a[3]) );
  QDFFRBS conv_sum_reg_4_ ( .D(n946), .CK(clk), .RB(n1691), .Q(sum60_a[4]) );
  QDFFRBS conv_sum_reg_5_ ( .D(n945), .CK(clk), .RB(n1691), .Q(sum60_a[5]) );
  QDFFRBS conv_sum_reg_6_ ( .D(n944), .CK(clk), .RB(n1691), .Q(sum60_a[6]) );
  QDFFRBS conv_sum_reg_7_ ( .D(n943), .CK(clk), .RB(n1691), .Q(sum60_a[7]) );
  QDFFRBS conv_sum_reg_8_ ( .D(n942), .CK(clk), .RB(n1691), .Q(sum60_a[8]) );
  QDFFRBS conv_sum_reg_9_ ( .D(n941), .CK(clk), .RB(n1691), .Q(sum60_a[9]) );
  QDFFRBS conv_sum_reg_10_ ( .D(n940), .CK(clk), .RB(n1691), .Q(sum60_a[10])
         );
  QDFFRBS conv_sum_reg_11_ ( .D(n939), .CK(clk), .RB(n1691), .Q(sum60_a[11])
         );
  QDFFRBS conv_sum_reg_12_ ( .D(n938), .CK(clk), .RB(n1691), .Q(sum60_a[12])
         );
  QDFFRBS conv_sum_reg_13_ ( .D(n937), .CK(clk), .RB(n1691), .Q(sum60_a[13])
         );
  QDFFRBS conv_sum_reg_14_ ( .D(n936), .CK(clk), .RB(n1691), .Q(sum60_a[14])
         );
  QDFFRBS conv_sum_reg_15_ ( .D(n935), .CK(clk), .RB(n1690), .Q(sum60_a[15])
         );
  QDFFRBS conv_sum_reg_16_ ( .D(n934), .CK(clk), .RB(n1690), .Q(sum60_a[16])
         );
  QDFFRBS conv_sum_reg_17_ ( .D(n933), .CK(clk), .RB(n1690), .Q(sum60_a[17])
         );
  QDFFRBS conv_sum_reg_18_ ( .D(n932), .CK(clk), .RB(n1690), .Q(sum60_a[18])
         );
  QDFFRBS conv_sum_reg_19_ ( .D(n931), .CK(clk), .RB(n1690), .Q(sum60_a[19])
         );
  QDFFRBS mp_value_reg_18_ ( .D(n912), .CK(clk), .RB(n1690), .Q(mp_value[18])
         );
  QDFFRBS mp_value_reg_17_ ( .D(n913), .CK(clk), .RB(n1690), .Q(mp_value[17])
         );
  QDFFRBS mp_value_reg_16_ ( .D(n914), .CK(clk), .RB(n1690), .Q(mp_value[16])
         );
  QDFFRBS mp_value_reg_15_ ( .D(n915), .CK(clk), .RB(n1690), .Q(mp_value[15])
         );
  QDFFRBS mp_value_reg_14_ ( .D(n916), .CK(clk), .RB(n1690), .Q(mp_value[14])
         );
  QDFFRBS mp_value_reg_13_ ( .D(n917), .CK(clk), .RB(n1690), .Q(mp_value[13])
         );
  QDFFRBS mp_value_reg_12_ ( .D(n918), .CK(clk), .RB(n1690), .Q(mp_value[12])
         );
  QDFFRBS mp_value_reg_11_ ( .D(n919), .CK(clk), .RB(n1690), .Q(mp_value[11])
         );
  QDFFRBS mp_value_reg_10_ ( .D(n920), .CK(clk), .RB(n1690), .Q(mp_value[10])
         );
  QDFFRBS mp_value_reg_9_ ( .D(n921), .CK(clk), .RB(n1690), .Q(mp_value[9]) );
  QDFFRBS mp_value_reg_8_ ( .D(n922), .CK(clk), .RB(n1690), .Q(mp_value[8]) );
  QDFFRBS mp_value_reg_7_ ( .D(n923), .CK(clk), .RB(n1690), .Q(mp_value[7]) );
  QDFFRBS mp_value_reg_6_ ( .D(n924), .CK(clk), .RB(n1690), .Q(mp_value[6]) );
  QDFFRBS mp_value_reg_5_ ( .D(n925), .CK(clk), .RB(n1690), .Q(mp_value[5]) );
  QDFFRBS mp_value_reg_4_ ( .D(n926), .CK(clk), .RB(n1690), .Q(mp_value[4]) );
  QDFFRBS mp_value_reg_3_ ( .D(n927), .CK(clk), .RB(n1690), .Q(mp_value[3]) );
  QDFFRBS mp_value_reg_2_ ( .D(n928), .CK(clk), .RB(n1690), .Q(mp_value[2]) );
  QDFFRBS mp_value_reg_1_ ( .D(n929), .CK(clk), .RB(n1690), .Q(mp_value[1]) );
  QDFFRBS mp_value_reg_0_ ( .D(n930), .CK(clk), .RB(n1690), .Q(mp_value[0]) );
  QDFFRBS out_value20_reg_19_ ( .D(N997), .CK(clk), .RB(n1690), .Q(
        out_value20[19]) );
  QDFFRBS out_value20_reg_18_ ( .D(N996), .CK(clk), .RB(n1690), .Q(
        out_value20[18]) );
  QDFFRBS out_value20_reg_17_ ( .D(N995), .CK(clk), .RB(n1689), .Q(
        out_value20[17]) );
  QDFFRBS out_value20_reg_16_ ( .D(N994), .CK(clk), .RB(n1689), .Q(
        out_value20[16]) );
  QDFFRBS out_value20_reg_15_ ( .D(N993), .CK(clk), .RB(n1689), .Q(
        out_value20[15]) );
  QDFFRBS out_value20_reg_14_ ( .D(N992), .CK(clk), .RB(n1689), .Q(
        out_value20[14]) );
  QDFFRBS out_value20_reg_13_ ( .D(N991), .CK(clk), .RB(n1689), .Q(
        out_value20[13]) );
  QDFFRBS out_value20_reg_12_ ( .D(N990), .CK(clk), .RB(n1689), .Q(
        out_value20[12]) );
  QDFFRBS out_value20_reg_11_ ( .D(N989), .CK(clk), .RB(n1687), .Q(
        out_value20[11]) );
  QDFFRBS out_value20_reg_10_ ( .D(N988), .CK(clk), .RB(n1689), .Q(
        out_value20[10]) );
  QDFFRBS out_value20_reg_9_ ( .D(N987), .CK(clk), .RB(n1689), .Q(
        out_value20[9]) );
  QDFFRBS out_value20_reg_8_ ( .D(N986), .CK(clk), .RB(n1689), .Q(
        out_value20[8]) );
  QDFFRBS out_value20_reg_7_ ( .D(N985), .CK(clk), .RB(n1689), .Q(
        out_value20[7]) );
  QDFFRBS out_value20_reg_6_ ( .D(N984), .CK(clk), .RB(n1689), .Q(
        out_value20[6]) );
  QDFFRBS out_value20_reg_5_ ( .D(N983), .CK(clk), .RB(n1689), .Q(
        out_value20[5]) );
  QDFFRBS out_value20_reg_4_ ( .D(N982), .CK(clk), .RB(n1689), .Q(
        out_value20[4]) );
  QDFFRBS out_value20_reg_3_ ( .D(N981), .CK(clk), .RB(n1689), .Q(
        out_value20[3]) );
  QDFFRBS out_value20_reg_2_ ( .D(N980), .CK(clk), .RB(n1689), .Q(
        out_value20[2]) );
  QDFFRBS out_value20_reg_1_ ( .D(N979), .CK(clk), .RB(n1689), .Q(
        out_value20[1]) );
  QDFFRBS out_value20_reg_0_ ( .D(N978), .CK(clk), .RB(n1689), .Q(
        out_value20[0]) );
  QDFFRBS out_valid_tail_cnt_reg_0_ ( .D(n910), .CK(clk), .RB(n1689), .Q(
        out_valid_tail_cnt[0]) );
  QDFFRBS out_valid_tail_cnt_reg_3_ ( .D(n909), .CK(clk), .RB(n1689), .Q(
        out_valid_tail_cnt[3]) );
  QDFFRBS out_valid_tail_cnt_reg_1_ ( .D(n908), .CK(clk), .RB(n1689), .Q(
        out_valid_tail_cnt[1]) );
  QDFFRBS out_valid_tail_cnt_reg_2_ ( .D(n907), .CK(clk), .RB(n1689), .Q(
        out_valid_tail_cnt[2]) );
  QDFFRBS out_valid_tail_cnt_reg_4_ ( .D(n906), .CK(clk), .RB(n1689), .Q(
        out_valid_tail_cnt[4]) );
  QDFFRBS matrix_size_reg_reg_0_ ( .D(n902), .CK(clk), .RB(n1689), .Q(
        matrix_size_reg[0]) );
  QDFFRBS input_temp_reg_reg_7_ ( .D(n901), .CK(clk), .RB(n1688), .Q(
        input_temp_reg_next[15]) );
  QDFFRBS input_temp_reg_reg_15_ ( .D(n900), .CK(clk), .RB(n1688), .Q(
        input_temp_reg_next[23]) );
  QDFFRBS input_temp_reg_reg_23_ ( .D(n899), .CK(clk), .RB(n1688), .Q(
        input_temp_reg_next[31]) );
  QDFFRBS input_temp_reg_reg_31_ ( .D(n898), .CK(clk), .RB(n1688), .Q(
        input_temp_reg_next[39]) );
  QDFFRBS input_temp_reg_reg_6_ ( .D(n897), .CK(clk), .RB(n1688), .Q(
        input_temp_reg_next[14]) );
  QDFFRBS input_temp_reg_reg_14_ ( .D(n896), .CK(clk), .RB(n1688), .Q(
        input_temp_reg_next[22]) );
  QDFFRBS input_temp_reg_reg_22_ ( .D(n895), .CK(clk), .RB(n1688), .Q(
        input_temp_reg_next[30]) );
  QDFFRBS input_temp_reg_reg_30_ ( .D(n894), .CK(clk), .RB(n1688), .Q(
        input_temp_reg_next[38]) );
  QDFFRBS input_temp_reg_reg_5_ ( .D(n893), .CK(clk), .RB(n1688), .Q(
        input_temp_reg_next[13]) );
  QDFFRBS input_temp_reg_reg_13_ ( .D(n892), .CK(clk), .RB(n1688), .Q(
        input_temp_reg_next[21]) );
  QDFFRBS input_temp_reg_reg_21_ ( .D(n891), .CK(clk), .RB(n1688), .Q(
        input_temp_reg_next[29]) );
  QDFFRBS input_temp_reg_reg_29_ ( .D(n890), .CK(clk), .RB(n1688), .Q(
        input_temp_reg_next[37]) );
  QDFFRBS input_temp_reg_reg_4_ ( .D(n889), .CK(clk), .RB(n1688), .Q(
        input_temp_reg_next[12]) );
  QDFFRBS input_temp_reg_reg_12_ ( .D(n888), .CK(clk), .RB(n1688), .Q(
        input_temp_reg_next[20]) );
  QDFFRBS input_temp_reg_reg_20_ ( .D(n887), .CK(clk), .RB(n1688), .Q(
        input_temp_reg_next[28]) );
  QDFFRBS input_temp_reg_reg_28_ ( .D(n886), .CK(clk), .RB(n1688), .Q(
        input_temp_reg_next[36]) );
  QDFFRBS input_temp_reg_reg_3_ ( .D(n885), .CK(clk), .RB(n1688), .Q(
        input_temp_reg_next[11]) );
  QDFFRBS input_temp_reg_reg_11_ ( .D(n884), .CK(clk), .RB(n1688), .Q(
        input_temp_reg_next[19]) );
  QDFFRBS input_temp_reg_reg_19_ ( .D(n883), .CK(clk), .RB(n1688), .Q(
        input_temp_reg_next[27]) );
  QDFFRBS input_temp_reg_reg_27_ ( .D(n882), .CK(clk), .RB(n1688), .Q(
        input_temp_reg_next[35]) );
  QDFFRBS input_temp_reg_reg_2_ ( .D(n881), .CK(clk), .RB(n1688), .Q(
        input_temp_reg_next[10]) );
  QDFFRBS input_temp_reg_reg_10_ ( .D(n880), .CK(clk), .RB(n1688), .Q(
        input_temp_reg_next[18]) );
  QDFFRBS input_temp_reg_reg_18_ ( .D(n879), .CK(clk), .RB(n1688), .Q(
        input_temp_reg_next[26]) );
  QDFFRBS input_temp_reg_reg_26_ ( .D(n878), .CK(clk), .RB(n1688), .Q(
        input_temp_reg_next[34]) );
  QDFFRBS input_temp_reg_reg_1_ ( .D(n877), .CK(clk), .RB(n1688), .Q(
        input_temp_reg_next[9]) );
  QDFFRBS input_temp_reg_reg_9_ ( .D(n876), .CK(clk), .RB(n1688), .Q(
        input_temp_reg_next[17]) );
  QDFFRBS input_temp_reg_reg_17_ ( .D(n875), .CK(clk), .RB(n1686), .Q(
        input_temp_reg_next[25]) );
  QDFFRBS input_temp_reg_reg_25_ ( .D(n874), .CK(clk), .RB(n1687), .Q(
        input_temp_reg_next[33]) );
  QDFFRBS input_temp_reg_reg_0_ ( .D(n873), .CK(clk), .RB(n1687), .Q(
        input_temp_reg_next[8]) );
  QDFFRBS input_temp_reg_reg_8_ ( .D(n872), .CK(clk), .RB(n1686), .Q(
        input_temp_reg_next[16]) );
  QDFFRBS input_temp_reg_reg_16_ ( .D(n871), .CK(clk), .RB(n1687), .Q(
        input_temp_reg_next[24]) );
  QDFFRBS input_temp_reg_reg_24_ ( .D(n870), .CK(clk), .RB(n1686), .Q(
        input_temp_reg_next[32]) );
  QDFFRBS in_valid2_cnt_reg ( .D(n869), .CK(clk), .RB(rst_n), .Q(in_valid2_cnt) );
  DFFSBN input_kernel_cnt_sh_reg_0_ ( .D(N89), .CK(clk), .SB(n1691), .QB(n1685) );
  DFFSBN mp_value_reg_19_ ( .D(n911), .CK(clk), .SB(n1691), .Q(mp_value[19])
         );
  QDFFS SRAM0_data_o_reg_reg_9_ ( .D(SRAM0_data_o[9]), .CK(clk), .Q(
        SRAM0_data_o_reg[9]) );
  QDFFS SRAM0_data_o_reg_reg_8_ ( .D(SRAM0_data_o[8]), .CK(clk), .Q(
        SRAM0_data_o_reg[8]) );
  QDFFS SRAM0_data_o_reg_reg_7_ ( .D(SRAM0_data_o[7]), .CK(clk), .Q(
        SRAM0_data_o_reg[7]) );
  QDFFS SRAM0_data_o_reg_reg_6_ ( .D(SRAM0_data_o[6]), .CK(clk), .Q(
        SRAM0_data_o_reg[6]) );
  QDFFS SRAM0_data_o_reg_reg_5_ ( .D(SRAM0_data_o[5]), .CK(clk), .Q(
        SRAM0_data_o_reg[5]) );
  QDFFS SRAM0_data_o_reg_reg_4_ ( .D(SRAM0_data_o[4]), .CK(clk), .Q(
        SRAM0_data_o_reg[4]) );
  QDFFS SRAM0_data_o_reg_reg_31_ ( .D(SRAM0_data_o[31]), .CK(clk), .Q(
        SRAM0_data_o_reg[31]) );
  QDFFS SRAM0_data_o_reg_reg_30_ ( .D(SRAM0_data_o[30]), .CK(clk), .Q(
        SRAM0_data_o_reg[30]) );
  QDFFS SRAM0_data_o_reg_reg_3_ ( .D(SRAM0_data_o[3]), .CK(clk), .Q(
        SRAM0_data_o_reg[3]) );
  QDFFS SRAM0_data_o_reg_reg_29_ ( .D(SRAM0_data_o[29]), .CK(clk), .Q(
        SRAM0_data_o_reg[29]) );
  QDFFS SRAM0_data_o_reg_reg_28_ ( .D(SRAM0_data_o[28]), .CK(clk), .Q(
        SRAM0_data_o_reg[28]) );
  QDFFS SRAM0_data_o_reg_reg_27_ ( .D(SRAM0_data_o[27]), .CK(clk), .Q(
        SRAM0_data_o_reg[27]) );
  QDFFS SRAM0_data_o_reg_reg_26_ ( .D(SRAM0_data_o[26]), .CK(clk), .Q(
        SRAM0_data_o_reg[26]) );
  QDFFS SRAM0_data_o_reg_reg_25_ ( .D(SRAM0_data_o[25]), .CK(clk), .Q(
        SRAM0_data_o_reg[25]) );
  QDFFS SRAM0_data_o_reg_reg_24_ ( .D(SRAM0_data_o[24]), .CK(clk), .Q(
        SRAM0_data_o_reg[24]) );
  QDFFS SRAM0_data_o_reg_reg_23_ ( .D(SRAM0_data_o[23]), .CK(clk), .Q(
        SRAM0_data_o_reg[23]) );
  QDFFS SRAM0_data_o_reg_reg_22_ ( .D(SRAM0_data_o[22]), .CK(clk), .Q(
        SRAM0_data_o_reg[22]) );
  QDFFS SRAM0_data_o_reg_reg_21_ ( .D(SRAM0_data_o[21]), .CK(clk), .Q(
        SRAM0_data_o_reg[21]) );
  QDFFS SRAM0_data_o_reg_reg_20_ ( .D(SRAM0_data_o[20]), .CK(clk), .Q(
        SRAM0_data_o_reg[20]) );
  QDFFS SRAM0_data_o_reg_reg_2_ ( .D(SRAM0_data_o[2]), .CK(clk), .Q(
        SRAM0_data_o_reg[2]) );
  QDFFS SRAM0_data_o_reg_reg_19_ ( .D(SRAM0_data_o[19]), .CK(clk), .Q(
        SRAM0_data_o_reg[19]) );
  QDFFS SRAM0_data_o_reg_reg_18_ ( .D(SRAM0_data_o[18]), .CK(clk), .Q(
        SRAM0_data_o_reg[18]) );
  QDFFS SRAM0_data_o_reg_reg_17_ ( .D(SRAM0_data_o[17]), .CK(clk), .Q(
        SRAM0_data_o_reg[17]) );
  QDFFS SRAM0_data_o_reg_reg_16_ ( .D(SRAM0_data_o[16]), .CK(clk), .Q(
        SRAM0_data_o_reg[16]) );
  QDFFS SRAM0_data_o_reg_reg_15_ ( .D(SRAM0_data_o[15]), .CK(clk), .Q(
        SRAM0_data_o_reg[15]) );
  QDFFS SRAM0_data_o_reg_reg_14_ ( .D(SRAM0_data_o[14]), .CK(clk), .Q(
        SRAM0_data_o_reg[14]) );
  QDFFS SRAM0_data_o_reg_reg_13_ ( .D(SRAM0_data_o[13]), .CK(clk), .Q(
        SRAM0_data_o_reg[13]) );
  QDFFS SRAM0_data_o_reg_reg_12_ ( .D(SRAM0_data_o[12]), .CK(clk), .Q(
        SRAM0_data_o_reg[12]) );
  QDFFS SRAM0_data_o_reg_reg_11_ ( .D(SRAM0_data_o[11]), .CK(clk), .Q(
        SRAM0_data_o_reg[11]) );
  QDFFS SRAM0_data_o_reg_reg_10_ ( .D(SRAM0_data_o[10]), .CK(clk), .Q(
        SRAM0_data_o_reg[10]) );
  QDFFS SRAM0_data_o_reg_reg_1_ ( .D(SRAM0_data_o[1]), .CK(clk), .Q(
        SRAM0_data_o_reg[1]) );
  QDFFS SRAM0_data_o_reg_reg_0_ ( .D(SRAM0_data_o[0]), .CK(clk), .Q(
        SRAM0_data_o_reg[0]) );
  QDFFS SRAM1_data_o_reg_reg_9_ ( .D(SRAM1_data_o[9]), .CK(clk), .Q(
        SRAM1_data_o_reg[9]) );
  QDFFS SRAM1_data_o_reg_reg_8_ ( .D(SRAM1_data_o[8]), .CK(clk), .Q(
        SRAM1_data_o_reg[8]) );
  QDFFS SRAM1_data_o_reg_reg_7_ ( .D(SRAM1_data_o[7]), .CK(clk), .Q(
        SRAM1_data_o_reg[7]) );
  QDFFS SRAM1_data_o_reg_reg_6_ ( .D(SRAM1_data_o[6]), .CK(clk), .Q(
        SRAM1_data_o_reg[6]) );
  QDFFS SRAM1_data_o_reg_reg_5_ ( .D(SRAM1_data_o[5]), .CK(clk), .Q(
        SRAM1_data_o_reg[5]) );
  QDFFS SRAM1_data_o_reg_reg_4_ ( .D(SRAM1_data_o[4]), .CK(clk), .Q(
        SRAM1_data_o_reg[4]) );
  QDFFS SRAM1_data_o_reg_reg_31_ ( .D(SRAM1_data_o[31]), .CK(clk), .Q(
        SRAM1_data_o_reg[31]) );
  QDFFS SRAM1_data_o_reg_reg_30_ ( .D(SRAM1_data_o[30]), .CK(clk), .Q(
        SRAM1_data_o_reg[30]) );
  QDFFS SRAM1_data_o_reg_reg_3_ ( .D(SRAM1_data_o[3]), .CK(clk), .Q(
        SRAM1_data_o_reg[3]) );
  QDFFS SRAM1_data_o_reg_reg_29_ ( .D(SRAM1_data_o[29]), .CK(clk), .Q(
        SRAM1_data_o_reg[29]) );
  QDFFS SRAM1_data_o_reg_reg_28_ ( .D(SRAM1_data_o[28]), .CK(clk), .Q(
        SRAM1_data_o_reg[28]) );
  QDFFS SRAM1_data_o_reg_reg_27_ ( .D(SRAM1_data_o[27]), .CK(clk), .Q(
        SRAM1_data_o_reg[27]) );
  QDFFS SRAM1_data_o_reg_reg_26_ ( .D(SRAM1_data_o[26]), .CK(clk), .Q(
        SRAM1_data_o_reg[26]) );
  QDFFS SRAM1_data_o_reg_reg_25_ ( .D(SRAM1_data_o[25]), .CK(clk), .Q(
        SRAM1_data_o_reg[25]) );
  QDFFS SRAM1_data_o_reg_reg_24_ ( .D(SRAM1_data_o[24]), .CK(clk), .Q(
        SRAM1_data_o_reg[24]) );
  QDFFS SRAM1_data_o_reg_reg_23_ ( .D(SRAM1_data_o[23]), .CK(clk), .Q(
        SRAM1_data_o_reg[23]) );
  QDFFS SRAM1_data_o_reg_reg_22_ ( .D(SRAM1_data_o[22]), .CK(clk), .Q(
        SRAM1_data_o_reg[22]) );
  QDFFS SRAM1_data_o_reg_reg_21_ ( .D(SRAM1_data_o[21]), .CK(clk), .Q(
        SRAM1_data_o_reg[21]) );
  QDFFS SRAM1_data_o_reg_reg_20_ ( .D(SRAM1_data_o[20]), .CK(clk), .Q(
        SRAM1_data_o_reg[20]) );
  QDFFS SRAM1_data_o_reg_reg_2_ ( .D(SRAM1_data_o[2]), .CK(clk), .Q(
        SRAM1_data_o_reg[2]) );
  QDFFS SRAM1_data_o_reg_reg_19_ ( .D(SRAM1_data_o[19]), .CK(clk), .Q(
        SRAM1_data_o_reg[19]) );
  QDFFS SRAM1_data_o_reg_reg_18_ ( .D(SRAM1_data_o[18]), .CK(clk), .Q(
        SRAM1_data_o_reg[18]) );
  QDFFS SRAM1_data_o_reg_reg_17_ ( .D(SRAM1_data_o[17]), .CK(clk), .Q(
        SRAM1_data_o_reg[17]) );
  QDFFS SRAM1_data_o_reg_reg_16_ ( .D(SRAM1_data_o[16]), .CK(clk), .Q(
        SRAM1_data_o_reg[16]) );
  QDFFS SRAM1_data_o_reg_reg_15_ ( .D(SRAM1_data_o[15]), .CK(clk), .Q(
        SRAM1_data_o_reg[15]) );
  QDFFS SRAM1_data_o_reg_reg_14_ ( .D(SRAM1_data_o[14]), .CK(clk), .Q(
        SRAM1_data_o_reg[14]) );
  QDFFS SRAM1_data_o_reg_reg_13_ ( .D(SRAM1_data_o[13]), .CK(clk), .Q(
        SRAM1_data_o_reg[13]) );
  QDFFS SRAM1_data_o_reg_reg_12_ ( .D(SRAM1_data_o[12]), .CK(clk), .Q(
        SRAM1_data_o_reg[12]) );
  QDFFS SRAM1_data_o_reg_reg_11_ ( .D(SRAM1_data_o[11]), .CK(clk), .Q(
        SRAM1_data_o_reg[11]) );
  QDFFS SRAM1_data_o_reg_reg_10_ ( .D(SRAM1_data_o[10]), .CK(clk), .Q(
        SRAM1_data_o_reg[10]) );
  QDFFS SRAM1_data_o_reg_reg_1_ ( .D(SRAM1_data_o[1]), .CK(clk), .Q(
        SRAM1_data_o_reg[1]) );
  QDFFS SRAM1_data_o_reg_reg_0_ ( .D(SRAM1_data_o[0]), .CK(clk), .Q(
        SRAM1_data_o_reg[0]) );
  QDFFS SRAMK_data_o_reg_reg_9_ ( .D(SRAMK_data_o[9]), .CK(clk), .Q(
        SRAMK_data_o_reg[9]) );
  QDFFS SRAMK_data_o_reg_reg_8_ ( .D(SRAMK_data_o[8]), .CK(clk), .Q(
        SRAMK_data_o_reg[8]) );
  QDFFS SRAMK_data_o_reg_reg_7_ ( .D(SRAMK_data_o[7]), .CK(clk), .Q(
        SRAMK_data_o_reg[7]) );
  QDFFS SRAMK_data_o_reg_reg_6_ ( .D(SRAMK_data_o[6]), .CK(clk), .Q(
        SRAMK_data_o_reg[6]) );
  QDFFS SRAMK_data_o_reg_reg_5_ ( .D(SRAMK_data_o[5]), .CK(clk), .Q(
        SRAMK_data_o_reg[5]) );
  QDFFS SRAMK_data_o_reg_reg_4_ ( .D(SRAMK_data_o[4]), .CK(clk), .Q(
        SRAMK_data_o_reg[4]) );
  QDFFS SRAMK_data_o_reg_reg_39_ ( .D(SRAMK_data_o[39]), .CK(clk), .Q(
        SRAMK_data_o_reg[39]) );
  QDFFS SRAMK_data_o_reg_reg_38_ ( .D(SRAMK_data_o[38]), .CK(clk), .Q(
        SRAMK_data_o_reg[38]) );
  QDFFS SRAMK_data_o_reg_reg_37_ ( .D(SRAMK_data_o[37]), .CK(clk), .Q(
        SRAMK_data_o_reg[37]) );
  QDFFS SRAMK_data_o_reg_reg_36_ ( .D(SRAMK_data_o[36]), .CK(clk), .Q(
        SRAMK_data_o_reg[36]) );
  QDFFS SRAMK_data_o_reg_reg_35_ ( .D(SRAMK_data_o[35]), .CK(clk), .Q(
        SRAMK_data_o_reg[35]) );
  QDFFS SRAMK_data_o_reg_reg_34_ ( .D(SRAMK_data_o[34]), .CK(clk), .Q(
        SRAMK_data_o_reg[34]) );
  QDFFS SRAMK_data_o_reg_reg_33_ ( .D(SRAMK_data_o[33]), .CK(clk), .Q(
        SRAMK_data_o_reg[33]) );
  QDFFS SRAMK_data_o_reg_reg_32_ ( .D(SRAMK_data_o[32]), .CK(clk), .Q(
        SRAMK_data_o_reg[32]) );
  QDFFS SRAMK_data_o_reg_reg_31_ ( .D(SRAMK_data_o[31]), .CK(clk), .Q(
        SRAMK_data_o_reg[31]) );
  QDFFS SRAMK_data_o_reg_reg_30_ ( .D(SRAMK_data_o[30]), .CK(clk), .Q(
        SRAMK_data_o_reg[30]) );
  QDFFS SRAMK_data_o_reg_reg_3_ ( .D(SRAMK_data_o[3]), .CK(clk), .Q(
        SRAMK_data_o_reg[3]) );
  QDFFS SRAMK_data_o_reg_reg_29_ ( .D(SRAMK_data_o[29]), .CK(clk), .Q(
        SRAMK_data_o_reg[29]) );
  QDFFS SRAMK_data_o_reg_reg_28_ ( .D(SRAMK_data_o[28]), .CK(clk), .Q(
        SRAMK_data_o_reg[28]) );
  QDFFS SRAMK_data_o_reg_reg_27_ ( .D(SRAMK_data_o[27]), .CK(clk), .Q(
        SRAMK_data_o_reg[27]) );
  QDFFS SRAMK_data_o_reg_reg_26_ ( .D(SRAMK_data_o[26]), .CK(clk), .Q(
        SRAMK_data_o_reg[26]) );
  QDFFS SRAMK_data_o_reg_reg_25_ ( .D(SRAMK_data_o[25]), .CK(clk), .Q(
        SRAMK_data_o_reg[25]) );
  QDFFS SRAMK_data_o_reg_reg_24_ ( .D(SRAMK_data_o[24]), .CK(clk), .Q(
        SRAMK_data_o_reg[24]) );
  QDFFS SRAMK_data_o_reg_reg_23_ ( .D(SRAMK_data_o[23]), .CK(clk), .Q(
        SRAMK_data_o_reg[23]) );
  QDFFS SRAMK_data_o_reg_reg_22_ ( .D(SRAMK_data_o[22]), .CK(clk), .Q(
        SRAMK_data_o_reg[22]) );
  QDFFS SRAMK_data_o_reg_reg_21_ ( .D(SRAMK_data_o[21]), .CK(clk), .Q(
        SRAMK_data_o_reg[21]) );
  QDFFS SRAMK_data_o_reg_reg_20_ ( .D(SRAMK_data_o[20]), .CK(clk), .Q(
        SRAMK_data_o_reg[20]) );
  QDFFS SRAMK_data_o_reg_reg_2_ ( .D(SRAMK_data_o[2]), .CK(clk), .Q(
        SRAMK_data_o_reg[2]) );
  QDFFS SRAMK_data_o_reg_reg_19_ ( .D(SRAMK_data_o[19]), .CK(clk), .Q(
        SRAMK_data_o_reg[19]) );
  QDFFS SRAMK_data_o_reg_reg_18_ ( .D(SRAMK_data_o[18]), .CK(clk), .Q(
        SRAMK_data_o_reg[18]) );
  QDFFS SRAMK_data_o_reg_reg_17_ ( .D(SRAMK_data_o[17]), .CK(clk), .Q(
        SRAMK_data_o_reg[17]) );
  QDFFS SRAMK_data_o_reg_reg_16_ ( .D(SRAMK_data_o[16]), .CK(clk), .Q(
        SRAMK_data_o_reg[16]) );
  QDFFS SRAMK_data_o_reg_reg_15_ ( .D(SRAMK_data_o[15]), .CK(clk), .Q(
        SRAMK_data_o_reg[15]) );
  QDFFS SRAMK_data_o_reg_reg_14_ ( .D(SRAMK_data_o[14]), .CK(clk), .Q(
        SRAMK_data_o_reg[14]) );
  QDFFS SRAMK_data_o_reg_reg_13_ ( .D(SRAMK_data_o[13]), .CK(clk), .Q(
        SRAMK_data_o_reg[13]) );
  QDFFS SRAMK_data_o_reg_reg_12_ ( .D(SRAMK_data_o[12]), .CK(clk), .Q(
        SRAMK_data_o_reg[12]) );
  QDFFS SRAMK_data_o_reg_reg_11_ ( .D(SRAMK_data_o[11]), .CK(clk), .Q(
        SRAMK_data_o_reg[11]) );
  QDFFS SRAMK_data_o_reg_reg_10_ ( .D(SRAMK_data_o[10]), .CK(clk), .Q(
        SRAMK_data_o_reg[10]) );
  QDFFS SRAMK_data_o_reg_reg_1_ ( .D(SRAMK_data_o[1]), .CK(clk), .Q(
        SRAMK_data_o_reg[1]) );
  QDFFS SRAMK_data_o_reg_reg_0_ ( .D(SRAMK_data_o[0]), .CK(clk), .Q(
        SRAMK_data_o_reg[0]) );
  FA1S DP_OP_193J1_122_2323_U7 ( .A(SRAMK_addr[1]), .B(n1017), .CI(
        DP_OP_193J1_122_2323_n7), .CO(DP_OP_193J1_122_2323_n6), .S(N543) );
  FA1S DP_OP_193J1_122_2323_U5 ( .A(SRAMK_addr[3]), .B(n1017), .CI(
        DP_OP_193J1_122_2323_n5), .CO(DP_OP_193J1_122_2323_n4), .S(N545) );
  FA1S DP_OP_193J1_122_2323_U4 ( .A(SRAMK_addr[4]), .B(n1017), .CI(
        DP_OP_193J1_122_2323_n4), .CO(DP_OP_193J1_122_2323_n3), .S(N546) );
  FA1S DP_OP_193J1_122_2323_U3 ( .A(SRAMK_addr[5]), .B(n1017), .CI(
        DP_OP_193J1_122_2323_n3), .CO(DP_OP_193J1_122_2323_n2), .S(N547) );
  QDFFRBS cv_j_reg_0__2_ ( .D(N213), .CK(clk), .RB(n1011), .Q(cv_j_0__2_) );
  QDFFRBS matrix_size_reg_reg_1_ ( .D(n903), .CK(clk), .RB(n1689), .Q(
        matrix_size_reg[1]) );
  QDFFRBS cv_v_reg_0_ ( .D(n868), .CK(clk), .RB(n1687), .Q(cv_v[0]) );
  QDFFRBN out_valid_reg ( .D(n904), .CK(clk), .RB(n1689), .Q(out_valid) );
  ND3 U1227 ( .I1(n1400), .I2(n1399), .I3(n1398), .O(muln_a[11]) );
  ND3S U1228 ( .I1(n1218), .I2(n1217), .I3(n1216), .O(muln_a[15]) );
  ND3 U1229 ( .I1(n1372), .I2(n1371), .I3(n1370), .O(muln_a[27]) );
  ND3S U1230 ( .I1(n1056), .I2(n1055), .I3(n1054), .O(muln_a[31]) );
  ND3S U1231 ( .I1(n1243), .I2(n1242), .I3(n1241), .O(muln_a[39]) );
  ND3S U1232 ( .I1(n1264), .I2(n1263), .I3(n1262), .O(muln_a[7]) );
  INV1CK U1233 ( .I(cv_k_overflow[3]), .O(n1631) );
  NR2P U1234 ( .I1(n1631), .I2(n1632), .O(n1633) );
  MAO222S U1235 ( .A1(n1308), .B1(sum60_o[14]), .C1(n1175), .O(n1176) );
  MAO222S U1236 ( .A1(n1174), .B1(sum60_o[13]), .C1(n1306), .O(n1175) );
  ND3S U1237 ( .I1(n1076), .I2(n1075), .I3(n1074), .O(muln_a[23]) );
  BUF1 U1238 ( .I(n1291), .O(n1636) );
  NR2P U1239 ( .I1(n1016), .I2(n1015), .O(n1017) );
  NR2P U1240 ( .I1(in_valid2_cnt), .I2(n1663), .O(n1013) );
  BUF2 U1241 ( .I(rst_n), .O(n1011) );
  INV1 U1242 ( .I(in_valid), .O(n1012) );
  INV1S U1243 ( .I(n1041), .O(n1044) );
  ND2S U1244 ( .I1(n1085), .I2(n1082), .O(n1405) );
  ND2S U1245 ( .I1(n1093), .I2(n1094), .O(n1407) );
  AN2S U1246 ( .I1(n1097), .I2(n1098), .O(n1070) );
  AN2S U1247 ( .I1(n1090), .I2(n1091), .O(n1069) );
  ND2S U1248 ( .I1(n1040), .I2(n1062), .O(n1087) );
  AO12S U1249 ( .B1(n1102), .B2(n1101), .A1(n1108), .O(n1461) );
  ND2S U1250 ( .I1(n1048), .I2(n1051), .O(n1085) );
  ND2S U1251 ( .I1(n1051), .I2(n1046), .O(n1083) );
  ND2S U1252 ( .I1(n1063), .I2(n1101), .O(n1091) );
  ND2S U1253 ( .I1(n1051), .I2(n1050), .O(n1095) );
  ND2S U1254 ( .I1(n1051), .I2(n1047), .O(n1093) );
  AN2S U1255 ( .I1(n1087), .I2(n1086), .O(n1118) );
  ND2S U1256 ( .I1(n1063), .I2(n1112), .O(n1119) );
  AN2S U1257 ( .I1(n1090), .I2(n1089), .O(n1120) );
  ND3S U1258 ( .I1(n1087), .I2(n1117), .I3(n1096), .O(n1404) );
  ND2S U1259 ( .I1(n1071), .I2(n1089), .O(n1401) );
  ND2S U1260 ( .I1(n1070), .I2(n1084), .O(n1402) );
  ND2S U1261 ( .I1(n1071), .I2(n1094), .O(n1375) );
  ND2S U1262 ( .I1(n1070), .I2(n1086), .O(n1376) );
  ND2S U1263 ( .I1(n1069), .I2(n1099), .O(n1374) );
  ND3S U1264 ( .I1(n1082), .I2(n1087), .I3(n1088), .O(n1373) );
  ND2S U1265 ( .I1(n1083), .I2(n1082), .O(n1457) );
  ND2S U1266 ( .I1(n1118), .I2(n1088), .O(n1459) );
  ND2S U1267 ( .I1(n1120), .I2(n1091), .O(n1458) );
  ND2S U1268 ( .I1(n1093), .I2(n1092), .O(n1499) );
  ND2S U1269 ( .I1(n1118), .I2(n1117), .O(n1498) );
  ND2S U1270 ( .I1(n1120), .I2(n1119), .O(n1497) );
  AN2S U1271 ( .I1(n1020), .I2(n1022), .O(n1037) );
  AN4B1S U1272 ( .I1(mode_reg), .I2(n1035), .I3(n1034), .B1(cv_i_2__6_), .O(
        n1041) );
  MOAI1S U1273 ( .A1(n1193), .A2(cv_i_2__5_), .B1(n1193), .B2(cv_i_2__5_), .O(
        n1034) );
  ND2S U1274 ( .I1(cv_j_2__4_), .I2(n1022), .O(n1023) );
  ND3S U1275 ( .I1(n1021), .I2(n1615), .I3(n1020), .O(n1024) );
  OA222S U1276 ( .A1(matrix_size_reg[1]), .A2(cv_j_2__3_), .B1(n1520), .B2(
        cv_j_2__5_), .C1(n1019), .C2(n1018), .O(n1021) );
  ND2S U1277 ( .I1(n1040), .I2(n1102), .O(n1100) );
  ND2S U1278 ( .I1(n1040), .I2(n1111), .O(n1097) );
  ND2S U1279 ( .I1(n1063), .I2(n1040), .O(n1090) );
  ND2S U1280 ( .I1(n1093), .I2(n1099), .O(n1435) );
  ND2S U1281 ( .I1(n1083), .I2(n1096), .O(n1433) );
  ND2S U1282 ( .I1(n1084), .I2(n1083), .O(n1377) );
  ND2S U1283 ( .I1(n1092), .I2(n1095), .O(n1379) );
  ND2S U1284 ( .I1(n1071), .I2(n1092), .O(n1431) );
  ND2S U1285 ( .I1(n1070), .I2(n1082), .O(n1432) );
  ND2S U1286 ( .I1(n1069), .I2(n1094), .O(n1430) );
  ND3S U1287 ( .I1(n1084), .I2(n1087), .I3(n1117), .O(n1429) );
  ND3S U1288 ( .I1(n1257), .I2(n1256), .I3(n1255), .O(muln_a[1]) );
  ND3S U1289 ( .I1(n1233), .I2(n1232), .I3(n1231), .O(muln_a[32]) );
  ND3S U1290 ( .I1(n1250), .I2(n1249), .I3(n1248), .O(muln_a[0]) );
  ND2S U1291 ( .I1(matrix_size_reg[0]), .I2(cv_i_2__4_), .O(n1030) );
  MOAI1S U1292 ( .A1(n1028), .A2(cv_r_2__2_), .B1(cv_i_2__2_), .B2(n1027), .O(
        n1029) );
  ND2S U1293 ( .I1(n1028), .I2(cv_r_2__2_), .O(n1027) );
  MOAI1S U1294 ( .A1(cv_i_2__0_), .A2(n1026), .B1(cv_r_2__1_), .B2(n1025), .O(
        n1028) );
  MAO222S U1295 ( .A1(sum60_o[9]), .B1(n1165), .C1(n1164), .O(n1166) );
  OR2S U1296 ( .I1(n1037), .I2(n1042), .O(n1036) );
  ND2S U1297 ( .I1(n1111), .I2(n1101), .O(n1098) );
  AN2S U1298 ( .I1(n1047), .I2(n1043), .O(n1102) );
  AN2S U1299 ( .I1(cv_k_2__0_), .I2(n1638), .O(n1045) );
  AN2S U1300 ( .I1(n1041), .I2(n1037), .O(n1101) );
  AN2S U1301 ( .I1(n1112), .I2(n1102), .O(n1109) );
  ND2S U1302 ( .I1(n1100), .I2(n1099), .O(n1108) );
  AN2S U1303 ( .I1(n1043), .I2(n1046), .O(n1111) );
  ND2S U1304 ( .I1(n1097), .I2(n1096), .O(n1110) );
  AN2S U1305 ( .I1(n1048), .I2(n1043), .O(n1062) );
  AN2S U1306 ( .I1(n1042), .I2(n1041), .O(n1112) );
  AN2S U1307 ( .I1(n1050), .I2(n1043), .O(n1063) );
  MAO222S U1308 ( .A1(mp_value[11]), .B1(n1651), .C1(n1171), .O(n1173) );
  MAO222S U1309 ( .A1(n1170), .B1(mp_value[10]), .C1(n1650), .O(n1171) );
  ND2S U1310 ( .I1(mp_value[12]), .I2(n1173), .O(n1172) );
  ND2S U1311 ( .I1(n1048), .I2(n1045), .O(n1096) );
  AN2S U1312 ( .I1(n1083), .I2(n1086), .O(n1406) );
  AN2S U1313 ( .I1(n1095), .I2(n1099), .O(n1408) );
  ND2S U1314 ( .I1(n1048), .I2(n1049), .O(n1089) );
  AN2S U1315 ( .I1(SRAMK_data_o_reg[10]), .I2(n1635), .O(mul1_b[2]) );
  ND3S U1316 ( .I1(n1390), .I2(n1389), .I3(n1388), .O(muln_a[10]) );
  AN2S U1317 ( .I1(SRAMK_data_o_reg[12]), .I2(n1635), .O(mul1_b[4]) );
  AN2S U1318 ( .I1(SRAMK_data_o_reg[13]), .I2(n1635), .O(mul1_b[5]) );
  ND3S U1319 ( .I1(n1395), .I2(n1394), .I3(n1393), .O(muln_a[12]) );
  AN2S U1320 ( .I1(SRAMK_data_o_reg[14]), .I2(n1635), .O(mul1_b[6]) );
  AN2S U1321 ( .I1(n1095), .I2(n1089), .O(n1436) );
  AN2S U1322 ( .I1(n1085), .I2(n1086), .O(n1434) );
  AN2S U1323 ( .I1(SRAMK_data_o_reg[18]), .I2(n1635), .O(mul2_b[2]) );
  ND3S U1324 ( .I1(n1418), .I2(n1417), .I3(n1416), .O(muln_a[18]) );
  AN2S U1325 ( .I1(SRAMK_data_o_reg[20]), .I2(n1635), .O(mul2_b[4]) );
  AN2S U1326 ( .I1(SRAMK_data_o_reg[21]), .I2(n1635), .O(mul2_b[5]) );
  ND3S U1327 ( .I1(n1423), .I2(n1422), .I3(n1421), .O(muln_a[20]) );
  AN2S U1328 ( .I1(SRAMK_data_o_reg[22]), .I2(n1635), .O(mul2_b[6]) );
  AN2S U1329 ( .I1(n1085), .I2(n1096), .O(n1378) );
  AN2S U1330 ( .I1(n1093), .I2(n1089), .O(n1380) );
  ND2S U1331 ( .I1(n1045), .I2(n1047), .O(n1086) );
  ND2S U1332 ( .I1(n1047), .I2(n1049), .O(n1099) );
  AN2S U1333 ( .I1(SRAMK_data_o_reg[26]), .I2(n1635), .O(mul3_b[2]) );
  ND3S U1334 ( .I1(n1362), .I2(n1361), .I3(n1360), .O(muln_a[26]) );
  AN2S U1335 ( .I1(SRAMK_data_o_reg[28]), .I2(n1635), .O(mul3_b[4]) );
  AN2S U1336 ( .I1(SRAMK_data_o_reg[29]), .I2(n1635), .O(mul3_b[5]) );
  ND3S U1337 ( .I1(n1367), .I2(n1366), .I3(n1365), .O(muln_a[28]) );
  AN2S U1338 ( .I1(SRAMK_data_o_reg[30]), .I2(n1635), .O(mul3_b[6]) );
  ND2S U1339 ( .I1(n1050), .I2(n1045), .O(n1084) );
  ND2S U1340 ( .I1(n1045), .I2(n1046), .O(n1082) );
  ND2S U1341 ( .I1(n1062), .I2(n1101), .O(n1088) );
  AN2S U1342 ( .I1(SRAMK_data_o_reg[34]), .I2(n1635), .O(mul4_b[2]) );
  ND3S U1343 ( .I1(n1446), .I2(n1445), .I3(n1444), .O(muln_a[34]) );
  AN2S U1344 ( .I1(SRAMK_data_o_reg[36]), .I2(n1635), .O(mul4_b[4]) );
  AN2S U1345 ( .I1(SRAMK_data_o_reg[37]), .I2(n1635), .O(mul4_b[5]) );
  ND3S U1346 ( .I1(n1451), .I2(n1450), .I3(n1449), .O(muln_a[36]) );
  AN2S U1347 ( .I1(SRAMK_data_o_reg[38]), .I2(n1635), .O(mul4_b[6]) );
  AO12S U1348 ( .B1(n1112), .B2(n1111), .A1(n1110), .O(n1489) );
  ND2S U1349 ( .I1(n1046), .I2(n1049), .O(n1094) );
  ND2S U1350 ( .I1(n1050), .I2(n1049), .O(n1092) );
  ND2S U1351 ( .I1(n1112), .I2(n1062), .O(n1117) );
  AN2S U1352 ( .I1(SRAMK_data_o_reg[2]), .I2(n1635), .O(mul0_b[2]) );
  AN2S U1353 ( .I1(SRAMK_data_o_reg[4]), .I2(n1635), .O(mul0_b[4]) );
  AN2S U1354 ( .I1(SRAMK_data_o_reg[5]), .I2(n1635), .O(mul0_b[5]) );
  ND3S U1355 ( .I1(n1481), .I2(n1480), .I3(n1479), .O(muln_a[4]) );
  AN2S U1356 ( .I1(SRAMK_data_o_reg[6]), .I2(n1635), .O(mul0_b[6]) );
  MAO222S U1357 ( .A1(n1309), .B1(sum60_o[15]), .C1(n1176), .O(n1178) );
  OAI12HS U1358 ( .B1(n1570), .B2(n1594), .A1(cv_k_0__0_), .O(n1630) );
  AN2S U1359 ( .I1(SRAMK_data_o_reg[11]), .I2(n1635), .O(mul1_b[3]) );
  ND3S U1360 ( .I1(n1068), .I2(n1067), .I3(n1066), .O(muln_a[13]) );
  ND3S U1361 ( .I1(n1413), .I2(n1412), .I3(n1411), .O(muln_a[14]) );
  AN2S U1362 ( .I1(SRAMK_data_o_reg[15]), .I2(n1635), .O(mul1_b[7]) );
  AN2S U1363 ( .I1(SRAMK_data_o_reg[19]), .I2(n1635), .O(mul2_b[3]) );
  ND3S U1364 ( .I1(n1081), .I2(n1080), .I3(n1079), .O(muln_a[21]) );
  ND3S U1365 ( .I1(n1441), .I2(n1440), .I3(n1439), .O(muln_a[22]) );
  AN2S U1366 ( .I1(SRAMK_data_o_reg[23]), .I2(n1635), .O(mul2_b[7]) );
  AN2S U1367 ( .I1(SRAMK_data_o_reg[27]), .I2(n1635), .O(mul3_b[3]) );
  ND3S U1368 ( .I1(n1061), .I2(n1060), .I3(n1059), .O(muln_a[29]) );
  AN2S U1369 ( .I1(SRAMK_data_o_reg[31]), .I2(n1635), .O(mul3_b[7]) );
  AN2S U1370 ( .I1(SRAMK_data_o_reg[35]), .I2(n1635), .O(mul4_b[3]) );
  ND3S U1371 ( .I1(n1107), .I2(n1106), .I3(n1105), .O(muln_a[37]) );
  ND3S U1372 ( .I1(n1467), .I2(n1466), .I3(n1465), .O(muln_a[38]) );
  AN2S U1373 ( .I1(SRAMK_data_o_reg[39]), .I2(n1635), .O(mul4_b[7]) );
  AN2S U1374 ( .I1(SRAMK_data_o_reg[3]), .I2(n1635), .O(mul0_b[3]) );
  ND3S U1375 ( .I1(n1123), .I2(n1122), .I3(n1121), .O(muln_a[5]) );
  ND3S U1376 ( .I1(n1503), .I2(n1502), .I3(n1501), .O(muln_a[6]) );
  AN2S U1377 ( .I1(SRAMK_data_o_reg[7]), .I2(n1635), .O(mul0_b[7]) );
  MAO222S U1378 ( .A1(mp_value[19]), .B1(n1640), .C1(n1184), .O(n1632) );
  ND2S U1379 ( .I1(n1183), .I2(n1182), .O(n1184) );
  MAO222S U1380 ( .A1(mp_value[18]), .B1(n1181), .C1(n1656), .O(n1182) );
  OR3B2S U1381 ( .I1(n1179), .B1(n1178), .B2(n1177), .O(n1183) );
  ND2S U1382 ( .I1(cv_r_overflow[3]), .I2(n1632), .O(n1185) );
  ND3S U1383 ( .I1(n1662), .I2(n1290), .I3(n1286), .O(n1297) );
  ND3S U1384 ( .I1(n1566), .I2(n1626), .I3(n1620), .O(n1612) );
  OA12S U1385 ( .B1(mode_reg), .B2(n1630), .A1(n1017), .O(addsub0_b[4]) );
  ND3S U1386 ( .I1(n1351), .I2(n1613), .I3(n1614), .O(addsub0_b[1]) );
  ND2S U1387 ( .I1(n1017), .I2(n1638), .O(n1629) );
  AN2S U1388 ( .I1(n1565), .I2(n1594), .O(n1618) );
  OR2S U1389 ( .I1(cv_r_0__0_), .I2(cv_r_0__1_), .O(n1015) );
  ND2S U1390 ( .I1(cv_v[0]), .I2(cv_r_0__2_), .O(n1016) );
  OA12S U1391 ( .B1(input_kernel_cnt_sh[4]), .B2(n1290), .A1(n1662), .O(n1126)
         );
  AN2S U1392 ( .I1(SRAMK_data_o_reg[9]), .I2(n1635), .O(mul1_b[1]) );
  ND3S U1393 ( .I1(n1208), .I2(n1207), .I3(n1206), .O(muln_a[8]) );
  AN2S U1394 ( .I1(SRAMK_data_o_reg[8]), .I2(n1635), .O(mul1_b[0]) );
  AN2S U1395 ( .I1(SRAMK_data_o_reg[17]), .I2(n1635), .O(mul2_b[1]) );
  ND3S U1396 ( .I1(n1223), .I2(n1222), .I3(n1221), .O(muln_a[16]) );
  AN2S U1397 ( .I1(SRAMK_data_o_reg[16]), .I2(n1635), .O(mul2_b[0]) );
  AN2S U1398 ( .I1(SRAMK_data_o_reg[25]), .I2(n1635), .O(mul3_b[1]) );
  AN2S U1399 ( .I1(SRAMK_data_o_reg[24]), .I2(n1635), .O(mul3_b[0]) );
  AN2S U1400 ( .I1(SRAMK_data_o_reg[33]), .I2(n1635), .O(mul4_b[1]) );
  AN2S U1401 ( .I1(SRAMK_data_o_reg[32]), .I2(n1635), .O(mul4_b[0]) );
  AN2S U1402 ( .I1(SRAMK_data_o_reg[1]), .I2(n1635), .O(mul0_b[1]) );
  AN2S U1403 ( .I1(SRAMK_data_o_reg[0]), .I2(n1635), .O(mul0_b[0]) );
  ND2S U1404 ( .I1(n1266), .I2(n1132), .O(n1657) );
  ND2S U1405 ( .I1(n1265), .I2(n1267), .O(n1132) );
  ND3S U1406 ( .I1(out_valid_tail_cnt[2]), .I2(n1661), .I3(n1265), .O(n1270)
         );
  ND2S U1407 ( .I1(n1131), .I2(n1130), .O(n1266) );
  ND2S U1408 ( .I1(n1185), .I2(n1576), .O(n1574) );
  ND2S U1409 ( .I1(n1581), .I2(N546), .O(n1585) );
  ND3S U1410 ( .I1(n1527), .I2(n1580), .I3(n1340), .O(n1586) );
  AN2S U1411 ( .I1(n1313), .I2(cv_v[0]), .O(n1581) );
  AN2S U1412 ( .I1(n1313), .I2(n1627), .O(n1526) );
  ND2S U1413 ( .I1(n1527), .I2(matrix_idx[2]), .O(n1589) );
  ND2S U1414 ( .I1(n1662), .I2(input_cnt_next[9]), .O(n1540) );
  ND2S U1415 ( .I1(n1662), .I2(input_cnt_next[8]), .O(n1531) );
  ND2S U1416 ( .I1(n1662), .I2(input_cnt_next[7]), .O(n1536) );
  ND2S U1417 ( .I1(n1662), .I2(input_cnt_next[6]), .O(n1547) );
  ND2S U1418 ( .I1(n1662), .I2(input_cnt_next[5]), .O(n1544) );
  ND2S U1419 ( .I1(n1662), .I2(input_cnt_next[4]), .O(n1542) );
  ND2S U1420 ( .I1(n1662), .I2(input_cnt_next[3]), .O(n1538) );
  ND3S U1421 ( .I1(n1594), .I2(n1593), .I3(n1591), .O(n1608) );
  OA22S U1422 ( .A1(n1353), .A2(n1147), .B1(n1141), .B2(n1139), .O(n1152) );
  ND2S U1423 ( .I1(n1664), .I2(n1607), .O(n1611) );
  ND2S U1424 ( .I1(n1017), .I2(cv_k_0__0_), .O(n1569) );
  ND2S U1425 ( .I1(n1013), .I2(mode), .O(n1573) );
  INV1 U1426 ( .I(n1013), .O(n1591) );
  INV2 U1427 ( .I(n1012), .O(n1662) );
  ND2S U1428 ( .I1(n1576), .I2(n1575), .O(n911) );
  OR2S U1429 ( .I1(n1637), .I2(input_cnt_adder_cout), .O(N89) );
  AO12S U1430 ( .B1(input_temp_reg_next[32]), .B2(n1012), .A1(SRAM0_data_i[24]), .O(n870) );
  AO12S U1431 ( .B1(input_temp_reg_next[24]), .B2(n1012), .A1(SRAM0_data_i[16]), .O(n871) );
  AO12S U1432 ( .B1(input_temp_reg_next[16]), .B2(n1012), .A1(SRAM0_data_i[8]), 
        .O(n872) );
  AO12S U1433 ( .B1(input_temp_reg_next[8]), .B2(n1012), .A1(SRAM0_data_i[0]), 
        .O(n873) );
  AO12S U1434 ( .B1(input_temp_reg_next[33]), .B2(n1012), .A1(SRAM0_data_i[25]), .O(n874) );
  AO12S U1435 ( .B1(input_temp_reg_next[25]), .B2(n1012), .A1(SRAM0_data_i[17]), .O(n875) );
  AO12S U1436 ( .B1(input_temp_reg_next[17]), .B2(n1012), .A1(SRAM0_data_i[9]), 
        .O(n876) );
  AO12S U1437 ( .B1(input_temp_reg_next[9]), .B2(n1012), .A1(SRAM0_data_i[1]), 
        .O(n877) );
  AO12S U1438 ( .B1(input_temp_reg_next[34]), .B2(n1012), .A1(SRAM0_data_i[26]), .O(n878) );
  AO12S U1439 ( .B1(input_temp_reg_next[26]), .B2(n1012), .A1(SRAM0_data_i[18]), .O(n879) );
  AO12S U1440 ( .B1(input_temp_reg_next[18]), .B2(n1012), .A1(SRAM0_data_i[10]), .O(n880) );
  AO12S U1441 ( .B1(input_temp_reg_next[10]), .B2(n1012), .A1(SRAM0_data_i[2]), 
        .O(n881) );
  AO12S U1442 ( .B1(input_temp_reg_next[35]), .B2(n1012), .A1(SRAM0_data_i[27]), .O(n882) );
  AO12S U1443 ( .B1(input_temp_reg_next[27]), .B2(n1012), .A1(SRAM0_data_i[19]), .O(n883) );
  AO12S U1444 ( .B1(input_temp_reg_next[19]), .B2(n1012), .A1(SRAM0_data_i[11]), .O(n884) );
  AO12S U1445 ( .B1(input_temp_reg_next[11]), .B2(n1012), .A1(SRAM0_data_i[3]), 
        .O(n885) );
  AO12S U1446 ( .B1(input_temp_reg_next[36]), .B2(n1012), .A1(SRAM0_data_i[28]), .O(n886) );
  AO12S U1447 ( .B1(input_temp_reg_next[28]), .B2(n1012), .A1(SRAM0_data_i[20]), .O(n887) );
  AO12S U1448 ( .B1(input_temp_reg_next[20]), .B2(n1012), .A1(SRAM0_data_i[12]), .O(n888) );
  AO12S U1449 ( .B1(input_temp_reg_next[12]), .B2(n1012), .A1(SRAM0_data_i[4]), 
        .O(n889) );
  AO12S U1450 ( .B1(input_temp_reg_next[37]), .B2(n1012), .A1(SRAM0_data_i[29]), .O(n890) );
  AO12S U1451 ( .B1(input_temp_reg_next[29]), .B2(n1012), .A1(SRAM0_data_i[21]), .O(n891) );
  AO12S U1452 ( .B1(input_temp_reg_next[21]), .B2(n1012), .A1(SRAM0_data_i[13]), .O(n892) );
  AO12S U1453 ( .B1(input_temp_reg_next[13]), .B2(n1012), .A1(SRAM0_data_i[5]), 
        .O(n893) );
  AO12S U1454 ( .B1(input_temp_reg_next[38]), .B2(n1012), .A1(SRAM0_data_i[30]), .O(n894) );
  AO12S U1455 ( .B1(input_temp_reg_next[30]), .B2(n1012), .A1(SRAM0_data_i[22]), .O(n895) );
  AO12S U1456 ( .B1(input_temp_reg_next[22]), .B2(n1012), .A1(SRAM0_data_i[14]), .O(n896) );
  AO12S U1457 ( .B1(input_temp_reg_next[14]), .B2(n1012), .A1(SRAM0_data_i[6]), 
        .O(n897) );
  AO12S U1458 ( .B1(input_temp_reg_next[39]), .B2(n1012), .A1(SRAM0_data_i[31]), .O(n898) );
  AO12S U1459 ( .B1(input_temp_reg_next[31]), .B2(n1012), .A1(SRAM0_data_i[23]), .O(n899) );
  AO12S U1460 ( .B1(input_temp_reg_next[23]), .B2(n1012), .A1(SRAM0_data_i[15]), .O(n900) );
  AO12S U1461 ( .B1(input_temp_reg_next[15]), .B2(n1012), .A1(SRAM0_data_i[7]), 
        .O(n901) );
  AO22S U1462 ( .A1(out_valid_tail_cnt[0]), .A2(n1658), .B1(
        out_valid_tail_cnt[1]), .B2(n1657), .O(n908) );
  AO222S U1463 ( .A1(n1631), .A2(out_value20[1]), .B1(sum60_o[0]), .B2(n1634), 
        .C1(n1633), .C2(mp_value[0]), .O(N978) );
  AO222S U1464 ( .A1(n1631), .A2(out_value20[2]), .B1(sum60_o[1]), .B2(n1634), 
        .C1(n1633), .C2(mp_value[1]), .O(N979) );
  AO222S U1465 ( .A1(n1631), .A2(out_value20[3]), .B1(sum60_o[2]), .B2(n1634), 
        .C1(n1633), .C2(mp_value[2]), .O(N980) );
  AO222S U1466 ( .A1(n1631), .A2(out_value20[4]), .B1(sum60_o[3]), .B2(n1634), 
        .C1(n1633), .C2(mp_value[3]), .O(N981) );
  AO222S U1467 ( .A1(n1631), .A2(out_value20[5]), .B1(sum60_o[4]), .B2(n1634), 
        .C1(n1633), .C2(mp_value[4]), .O(N982) );
  AO222S U1468 ( .A1(n1631), .A2(out_value20[6]), .B1(sum60_o[5]), .B2(n1634), 
        .C1(n1633), .C2(mp_value[5]), .O(N983) );
  AO222S U1469 ( .A1(n1631), .A2(out_value20[7]), .B1(sum60_o[6]), .B2(n1634), 
        .C1(n1633), .C2(mp_value[6]), .O(N984) );
  AO222S U1470 ( .A1(n1631), .A2(out_value20[8]), .B1(sum60_o[7]), .B2(n1634), 
        .C1(n1633), .C2(mp_value[7]), .O(N985) );
  AO222S U1471 ( .A1(n1631), .A2(out_value20[9]), .B1(sum60_o[8]), .B2(n1634), 
        .C1(n1633), .C2(mp_value[8]), .O(N986) );
  AO222S U1472 ( .A1(n1631), .A2(out_value20[10]), .B1(sum60_o[9]), .B2(n1634), 
        .C1(n1633), .C2(mp_value[9]), .O(N987) );
  AO222S U1473 ( .A1(n1631), .A2(out_value20[11]), .B1(sum60_o[10]), .B2(n1634), .C1(n1633), .C2(mp_value[10]), .O(N988) );
  AO222S U1474 ( .A1(n1631), .A2(out_value20[12]), .B1(sum60_o[11]), .B2(n1634), .C1(n1633), .C2(mp_value[11]), .O(N989) );
  AO222S U1475 ( .A1(n1631), .A2(out_value20[13]), .B1(sum60_o[12]), .B2(n1634), .C1(n1633), .C2(mp_value[12]), .O(N990) );
  AO222S U1476 ( .A1(n1631), .A2(out_value20[14]), .B1(sum60_o[13]), .B2(n1634), .C1(n1633), .C2(mp_value[13]), .O(N991) );
  AO222S U1477 ( .A1(n1631), .A2(out_value20[15]), .B1(sum60_o[14]), .B2(n1634), .C1(n1633), .C2(mp_value[14]), .O(N992) );
  AO222S U1478 ( .A1(n1631), .A2(out_value20[16]), .B1(sum60_o[15]), .B2(n1634), .C1(n1633), .C2(mp_value[15]), .O(N993) );
  AO222S U1479 ( .A1(n1631), .A2(out_value20[17]), .B1(sum60_o[16]), .B2(n1634), .C1(n1633), .C2(mp_value[16]), .O(N994) );
  AO222S U1480 ( .A1(n1631), .A2(out_value20[18]), .B1(sum60_o[17]), .B2(n1634), .C1(n1633), .C2(mp_value[17]), .O(N995) );
  AO222S U1481 ( .A1(n1631), .A2(out_value20[19]), .B1(sum60_o[18]), .B2(n1634), .C1(n1633), .C2(mp_value[18]), .O(N996) );
  ND2S U1482 ( .I1(n1636), .I2(input_cnt[0]), .O(n1320) );
  ND2S U1483 ( .I1(n1527), .I2(matrix_idx[0]), .O(n1318) );
  ND3S U1484 ( .I1(n1316), .I2(n1315), .I3(n1314), .O(n975) );
  ND2S U1485 ( .I1(n1636), .I2(input_cnt[1]), .O(n1316) );
  ND2S U1486 ( .I1(n1527), .I2(matrix_idx[1]), .O(n1314) );
  ND3S U1487 ( .I1(n1331), .I2(n1330), .I3(n1329), .O(n974) );
  ND2S U1488 ( .I1(n1636), .I2(input_cnt[2]), .O(n1329) );
  ND2S U1489 ( .I1(n1339), .I2(n1327), .O(n1331) );
  ND3S U1490 ( .I1(n1337), .I2(n1336), .I3(n1335), .O(n973) );
  ND2S U1491 ( .I1(n1346), .I2(n1334), .O(n1335) );
  ND2S U1492 ( .I1(input_cnt[4]), .I2(n1636), .O(n1587) );
  ND3S U1493 ( .I1(n1349), .I2(n1348), .I3(n1347), .O(n971) );
  ND3S U1494 ( .I1(n1346), .I2(matrix_idx[1]), .I3(n1345), .O(n1347) );
  ND3S U1495 ( .I1(matrix_idx[3]), .I2(n1339), .I3(n1338), .O(n1349) );
  ND3S U1496 ( .I1(n1326), .I2(n1325), .I3(n1324), .O(n970) );
  ND2S U1497 ( .I1(n1636), .I2(input_cnt[6]), .O(n1326) );
  OR3B2S U1498 ( .I1(n1589), .B1(matrix_idx[3]), .B2(n1321), .O(n1325) );
  ND2S U1499 ( .I1(n1556), .I2(n1551), .O(n965) );
  ND2S U1500 ( .I1(n1564), .I2(n1563), .O(n964) );
  ND2S U1501 ( .I1(n1560), .I2(n1559), .O(n963) );
  ND2S U1502 ( .I1(n1553), .I2(n1550), .O(n962) );
  ND2S U1503 ( .I1(n1541), .I2(n1540), .O(n961) );
  ND2S U1504 ( .I1(n1529), .I2(n1531), .O(n960) );
  ND2S U1505 ( .I1(n1535), .I2(n1536), .O(n959) );
  ND2S U1506 ( .I1(n1546), .I2(n1547), .O(n958) );
  ND2S U1507 ( .I1(n1533), .I2(n1544), .O(n957) );
  ND2S U1508 ( .I1(n1528), .I2(n1542), .O(n956) );
  ND2S U1509 ( .I1(n1530), .I2(n1538), .O(n967) );
  ND2S U1510 ( .I1(n1556), .I2(n1555), .O(n9870) );
  ND2S U1511 ( .I1(n1564), .I2(n1554), .O(n9860) );
  ND2S U1512 ( .I1(n1560), .I2(n1558), .O(n9850) );
  ND2S U1513 ( .I1(n1553), .I2(n1552), .O(n9840) );
  ND2S U1514 ( .I1(n1534), .I2(n1540), .O(n9830) );
  ND2S U1515 ( .I1(n1532), .I2(n1531), .O(n9820) );
  ND2S U1516 ( .I1(n1537), .I2(n1536), .O(n9810) );
  ND2S U1517 ( .I1(n1548), .I2(n1547), .O(n9800) );
  ND2S U1518 ( .I1(n1545), .I2(n1544), .O(n9790) );
  ND2S U1519 ( .I1(n1543), .I2(n1542), .O(n9780) );
  ND2S U1520 ( .I1(n1539), .I2(n1538), .O(n9880) );
  AN2S U1521 ( .I1(cv_k_overflow[2]), .I2(n1591), .O(N249) );
  AN2S U1522 ( .I1(cv_k_overflow[1]), .I2(n1591), .O(N250) );
  AN2S U1523 ( .I1(cv_r_overflow[2]), .I2(n1591), .O(N246) );
  AN2S U1524 ( .I1(cv_r_overflow[1]), .I2(n1591), .O(N247) );
  AN2S U1525 ( .I1(cv_i_overflow[2]), .I2(n1591), .O(N243) );
  AN2S U1526 ( .I1(cv_i_overflow[1]), .I2(n1591), .O(N244) );
  AN2S U1527 ( .I1(cv_v[3]), .I2(n1591), .O(N239) );
  AN2S U1528 ( .I1(cv_v[2]), .I2(n1591), .O(N240) );
  AN2S U1529 ( .I1(cv_v[1]), .I2(n1591), .O(N241) );
  AN2S U1530 ( .I1(cv_i_1__0_), .I2(n1591), .O(N218) );
  AN2S U1531 ( .I1(cv_i_1__1_), .I2(n1591), .O(N219) );
  AN2S U1532 ( .I1(cv_i_1__2_), .I2(n1591), .O(N220) );
  AN2S U1533 ( .I1(cv_i_1__3_), .I2(n1591), .O(N221) );
  AN2S U1534 ( .I1(cv_i_1__4_), .I2(n1591), .O(N222) );
  AN2S U1535 ( .I1(cv_i_1__5_), .I2(n1591), .O(N223) );
  AN2S U1536 ( .I1(cv_i_1__6_), .I2(n1591), .O(N224) );
  AN2S U1537 ( .I1(n1591), .I2(cv_i_0__0_), .O(n1677) );
  AN2S U1538 ( .I1(n1591), .I2(cv_i_0__6_), .O(n1683) );
  ND2S U1539 ( .I1(n1594), .I2(n1591), .O(n1592) );
  AN2S U1540 ( .I1(cv_j_1__0_), .I2(n1591), .O(N197) );
  AN2S U1541 ( .I1(cv_j_1__1_), .I2(n1591), .O(N198) );
  AN2S U1542 ( .I1(cv_j_1__2_), .I2(n1591), .O(N199) );
  AN2S U1543 ( .I1(cv_j_1__3_), .I2(n1591), .O(N200) );
  AN2S U1544 ( .I1(cv_j_1__4_), .I2(n1591), .O(N201) );
  AN2S U1545 ( .I1(cv_j_1__5_), .I2(n1591), .O(N202) );
  AN2S U1546 ( .I1(cv_j_1__6_), .I2(n1591), .O(N203) );
  AN2S U1547 ( .I1(n1591), .I2(cv_j_0__6_), .O(n1667) );
  AN2S U1548 ( .I1(cv_k_1__0_), .I2(n1591), .O(N193) );
  ND2S U1549 ( .I1(n1573), .I2(n1572), .O(n954) );
  ND2S U1550 ( .I1(n1505), .I2(n1573), .O(n953) );
  AN2S U1551 ( .I1(cv_r_1__0_), .I2(n1591), .O(N184) );
  AN2S U1552 ( .I1(cv_r_1__1_), .I2(n1591), .O(N185) );
  AN2S U1553 ( .I1(cv_r_1__2_), .I2(n1591), .O(N186) );
  AN2S U1554 ( .I1(n1591), .I2(cv_r_0__1_), .O(n1674) );
  AN2S U1555 ( .I1(n1591), .I2(cv_r_0__2_), .O(n1666) );
  ND2S U1556 ( .I1(cv_v[0]), .I2(n1673), .O(n1312) );
  ND2S U1557 ( .I1(n1668), .I2(n1506), .O(n1268) );
  AN2S U1558 ( .I1(n1662), .I2(input_temp_reg_next[39]), .O(SRAMK_data_i[39])
         );
  AN2S U1559 ( .I1(n1662), .I2(input_temp_reg_next[38]), .O(SRAMK_data_i[38])
         );
  AN2S U1560 ( .I1(n1662), .I2(input_temp_reg_next[37]), .O(SRAMK_data_i[37])
         );
  AN2S U1561 ( .I1(n1662), .I2(input_temp_reg_next[36]), .O(SRAMK_data_i[36])
         );
  AN2S U1562 ( .I1(n1662), .I2(input_temp_reg_next[35]), .O(SRAMK_data_i[35])
         );
  AN2S U1563 ( .I1(n1662), .I2(input_temp_reg_next[34]), .O(SRAMK_data_i[34])
         );
  AN2S U1564 ( .I1(n1662), .I2(input_temp_reg_next[33]), .O(SRAMK_data_i[33])
         );
  AN2S U1565 ( .I1(n1662), .I2(input_temp_reg_next[32]), .O(SRAMK_data_i[32])
         );
  AN2S U1566 ( .I1(n1662), .I2(input_temp_reg_next[9]), .O(SRAM0_data_i[9]) );
  AN2S U1567 ( .I1(n1662), .I2(input_temp_reg_next[8]), .O(SRAM0_data_i[8]) );
  AN2S U1568 ( .I1(n1662), .I2(matrix[7]), .O(SRAM0_data_i[7]) );
  AN2S U1569 ( .I1(n1662), .I2(matrix[6]), .O(SRAM0_data_i[6]) );
  AN2S U1570 ( .I1(n1662), .I2(matrix[5]), .O(SRAM0_data_i[5]) );
  AN2S U1571 ( .I1(n1662), .I2(matrix[4]), .O(SRAM0_data_i[4]) );
  AN2S U1572 ( .I1(n1662), .I2(input_temp_reg_next[31]), .O(SRAM0_data_i[31])
         );
  AN2S U1573 ( .I1(n1662), .I2(input_temp_reg_next[30]), .O(SRAM0_data_i[30])
         );
  AN2S U1574 ( .I1(n1662), .I2(matrix[3]), .O(SRAM0_data_i[3]) );
  AN2S U1575 ( .I1(n1662), .I2(input_temp_reg_next[29]), .O(SRAM0_data_i[29])
         );
  AN2S U1576 ( .I1(n1662), .I2(input_temp_reg_next[28]), .O(SRAM0_data_i[28])
         );
  AN2S U1577 ( .I1(n1662), .I2(input_temp_reg_next[27]), .O(SRAM0_data_i[27])
         );
  AN2S U1578 ( .I1(n1662), .I2(input_temp_reg_next[26]), .O(SRAM0_data_i[26])
         );
  AN2S U1579 ( .I1(n1662), .I2(input_temp_reg_next[25]), .O(SRAM0_data_i[25])
         );
  AN2S U1580 ( .I1(n1662), .I2(input_temp_reg_next[24]), .O(SRAM0_data_i[24])
         );
  AN2S U1581 ( .I1(n1662), .I2(input_temp_reg_next[23]), .O(SRAM0_data_i[23])
         );
  AN2S U1582 ( .I1(n1662), .I2(input_temp_reg_next[22]), .O(SRAM0_data_i[22])
         );
  AN2S U1583 ( .I1(n1662), .I2(input_temp_reg_next[21]), .O(SRAM0_data_i[21])
         );
  AN2S U1584 ( .I1(n1662), .I2(input_temp_reg_next[20]), .O(SRAM0_data_i[20])
         );
  AN2S U1585 ( .I1(n1662), .I2(matrix[2]), .O(SRAM0_data_i[2]) );
  AN2S U1586 ( .I1(n1662), .I2(input_temp_reg_next[19]), .O(SRAM0_data_i[19])
         );
  AN2S U1587 ( .I1(n1662), .I2(input_temp_reg_next[18]), .O(SRAM0_data_i[18])
         );
  AN2S U1588 ( .I1(n1662), .I2(input_temp_reg_next[17]), .O(SRAM0_data_i[17])
         );
  AN2S U1589 ( .I1(n1662), .I2(input_temp_reg_next[16]), .O(SRAM0_data_i[16])
         );
  AN2S U1590 ( .I1(n1662), .I2(input_temp_reg_next[15]), .O(SRAM0_data_i[15])
         );
  AN2S U1591 ( .I1(n1662), .I2(input_temp_reg_next[14]), .O(SRAM0_data_i[14])
         );
  AN2S U1592 ( .I1(n1662), .I2(input_temp_reg_next[13]), .O(SRAM0_data_i[13])
         );
  AN2S U1593 ( .I1(n1662), .I2(input_temp_reg_next[12]), .O(SRAM0_data_i[12])
         );
  AN2S U1594 ( .I1(n1662), .I2(input_temp_reg_next[11]), .O(SRAM0_data_i[11])
         );
  AN2S U1595 ( .I1(n1662), .I2(input_temp_reg_next[10]), .O(SRAM0_data_i[10])
         );
  AN2S U1596 ( .I1(n1662), .I2(matrix[1]), .O(SRAM0_data_i[1]) );
  AN2S U1597 ( .I1(n1662), .I2(matrix[0]), .O(SRAM0_data_i[0]) );
  MOAI1S U1598 ( .A1(n1033), .A2(n1031), .B1(n1033), .B2(n1030), .O(n1032) );
  INV1S U1599 ( .I(cv_i_2__1_), .O(n1025) );
  NR2 U1600 ( .I1(n1044), .I2(n1043), .O(n1051) );
  ND3S U1601 ( .I1(n1456), .I2(n1455), .I3(n1454), .O(muln_a[35]) );
  NR2 U1602 ( .I1(cv_i_2__3_), .I2(n1029), .O(n1033) );
  OR3B2S U1603 ( .I1(n1616), .B1(n1612), .B2(n1357), .O(addsub1_b[0]) );
  ND3S U1604 ( .I1(n1092), .I2(n1090), .I3(n1119), .O(n1403) );
  ND3S U1605 ( .I1(n1385), .I2(n1384), .I3(n1383), .O(muln_a[30]) );
  ND3S U1606 ( .I1(n1474), .I2(n1473), .I3(n1472), .O(muln_a[2]) );
  ND3S U1607 ( .I1(cv_i_0__1_), .I2(n1518), .I3(n1517), .O(n1523) );
  ND3S U1608 ( .I1(n1213), .I2(n1212), .I3(n1211), .O(muln_a[9]) );
  ND3S U1609 ( .I1(n1228), .I2(n1227), .I3(n1226), .O(muln_a[17]) );
  ND3S U1610 ( .I1(n1203), .I2(n1202), .I3(n1201), .O(muln_a[25]) );
  ND3S U1611 ( .I1(n1238), .I2(n1237), .I3(n1236), .O(muln_a[33]) );
  ND3S U1612 ( .I1(n1300), .I2(n1299), .I3(n1298), .O(n1301) );
  ND3S U1613 ( .I1(n1198), .I2(n1197), .I3(n1196), .O(muln_a[24]) );
  ND3S U1614 ( .I1(n1594), .I2(n1525), .I3(n1524), .O(n1593) );
  ND3S U1615 ( .I1(n1153), .I2(n1152), .I3(n1151), .O(n1607) );
  ND3S U1616 ( .I1(n1571), .I2(n1591), .I3(n1610), .O(n1572) );
  INV1S U1617 ( .I(in_valid2), .O(n1663) );
  ND3S U1618 ( .I1(n1320), .I2(n1319), .I3(n1318), .O(n9900) );
  TIE1 U1619 ( .O(n905) );
  TIE0 U1620 ( .O(n1692) );
  OAI22S U1621 ( .A1(matrix_size_reg[0]), .A2(n1515), .B1(cv_i_0__3_), .B2(
        n1515), .O(n1525) );
  OAI22S U1622 ( .A1(n1520), .A2(cv_j_0__2_), .B1(n1354), .B2(cv_j_0__2_), .O(
        n1143) );
  INV1S U1623 ( .I(cv_r_0__0_), .O(n1014) );
  NR2 U1624 ( .I1(n1013), .I2(n1014), .O(n1673) );
  INV1S U1625 ( .I(cv_k_0__0_), .O(n1504) );
  NR2 U1626 ( .I1(n1013), .I2(n1504), .O(n1675) );
  INV1S U1627 ( .I(cv_j_0__5_), .O(n1353) );
  NR2 U1628 ( .I1(n1013), .I2(n1353), .O(n1672) );
  INV1S U1629 ( .I(cv_j_0__4_), .O(n1352) );
  NR2 U1630 ( .I1(n1013), .I2(n1352), .O(n1670) );
  INV1S U1631 ( .I(cv_j_0__3_), .O(n1354) );
  NR2 U1632 ( .I1(n1013), .I2(n1354), .O(n1671) );
  INV1S U1633 ( .I(cv_j_0__2_), .O(n1146) );
  NR2 U1634 ( .I1(n1013), .I2(n1146), .O(n1665) );
  INV1S U1635 ( .I(cv_j_0__1_), .O(n1350) );
  NR2 U1636 ( .I1(n1013), .I2(n1350), .O(n1669) );
  INV1S U1637 ( .I(cv_j_0__0_), .O(n1138) );
  NR2 U1638 ( .I1(n1013), .I2(n1138), .O(n1684) );
  INV1S U1639 ( .I(cv_i_0__5_), .O(n1605) );
  NR2 U1640 ( .I1(n1013), .I2(n1605), .O(n1682) );
  INV1S U1641 ( .I(cv_i_0__4_), .O(n1516) );
  NR2 U1642 ( .I1(n1013), .I2(n1516), .O(n1681) );
  INV1S U1643 ( .I(cv_i_0__3_), .O(n1519) );
  NR2 U1644 ( .I1(n1013), .I2(n1519), .O(n1680) );
  INV1S U1645 ( .I(cv_i_0__2_), .O(n1598) );
  NR2 U1646 ( .I1(n1013), .I2(n1598), .O(n1679) );
  INV1S U1647 ( .I(cv_i_0__1_), .O(n1508) );
  NR2 U1648 ( .I1(n1013), .I2(n1508), .O(n1678) );
  INV1S U1649 ( .I(cv_v[0]), .O(n1627) );
  NR2 U1650 ( .I1(n1013), .I2(n1627), .O(n1668) );
  INV1S U1651 ( .I(n1017), .O(n1506) );
  NR2 U1652 ( .I1(n1013), .I2(n1506), .O(n1676) );
  INV1S U1653 ( .I(cv_k_0__1_), .O(n1570) );
  NR2 U1654 ( .I1(n1570), .I2(n1569), .O(n1153) );
  INV1S U1655 ( .I(n1153), .O(n1610) );
  NR2 U1656 ( .I1(n1013), .I2(n1610), .O(n1664) );
  INV1S U1657 ( .I(mode_reg), .O(n1638) );
  INV1S U1658 ( .I(n1629), .O(n1566) );
  AO13S U1659 ( .B1(cv_v[0]), .B2(mode_reg), .B3(n1506), .A1(n1566), .O(
        addsub0_op) );
  INV1S U1660 ( .I(cv_j_2__1_), .O(n1038) );
  NR2 U1661 ( .I1(cv_j_2__0_), .I2(n1038), .O(n1050) );
  INV1S U1662 ( .I(cv_j_2__2_), .O(n1043) );
  INV1S U1663 ( .I(cv_j_2__4_), .O(n1020) );
  NR3 U1664 ( .I1(cv_j_2__3_), .I2(cv_j_2__5_), .I3(cv_j_2__6_), .O(n1022) );
  INV1S U1665 ( .I(matrix_size_reg[1]), .O(n1520) );
  INV1S U1666 ( .I(cv_j_2__3_), .O(n1019) );
  INV1S U1667 ( .I(cv_j_2__5_), .O(n1018) );
  INV1S U1668 ( .I(matrix_size_reg[0]), .O(n1615) );
  OAI22S U1669 ( .A1(cv_j_2__6_), .A2(n1024), .B1(n1615), .B2(n1023), .O(n1042) );
  OAI12HS U1670 ( .B1(cv_r_2__1_), .B2(n1025), .A1(cv_r_2__0_), .O(n1026) );
  AOI13HS U1671 ( .B1(cv_i_2__3_), .B2(n1029), .B3(n1615), .A1(cv_i_2__4_), 
        .O(n1031) );
  MOAI1S U1672 ( .A1(matrix_size_reg[1]), .A2(n1032), .B1(matrix_size_reg[1]), 
        .B2(n1615), .O(n1035) );
  AN2B1S U1673 ( .I1(n1033), .B1(cv_i_2__4_), .O(n1193) );
  NR2 U1674 ( .I1(n1036), .I2(n1044), .O(n1040) );
  NR2 U1675 ( .I1(cv_j_2__0_), .I2(cv_j_2__1_), .O(n1047) );
  NR2 U1676 ( .I1(mode_reg), .I2(cv_k_2__0_), .O(n1049) );
  INV1S U1677 ( .I(cv_j_2__0_), .O(n1039) );
  NR2 U1678 ( .I1(n1039), .I2(n1038), .O(n1046) );
  NR2 U1679 ( .I1(cv_j_2__1_), .I2(n1039), .O(n1048) );
  AOI22S U1680 ( .A1(SRAM0_data_o_reg[23]), .A2(n1374), .B1(
        SRAM0_data_o_reg[31]), .B2(n1373), .O(n1056) );
  AN2B1S U1681 ( .I1(n1100), .B1(n1109), .O(n1071) );
  AOI22S U1682 ( .A1(SRAM0_data_o_reg[15]), .A2(n1376), .B1(
        SRAM1_data_o_reg[7]), .B2(n1375), .O(n1055) );
  INV1S U1683 ( .I(SRAM1_data_o_reg[31]), .O(n1258) );
  MOAI1S U1684 ( .A1(n1378), .A2(n1258), .B1(SRAM1_data_o_reg[15]), .B2(n1377), 
        .O(n1053) );
  INV1S U1685 ( .I(SRAM0_data_o_reg[7]), .O(n1259) );
  MOAI1S U1686 ( .A1(n1380), .A2(n1259), .B1(SRAM1_data_o_reg[23]), .B2(n1379), 
        .O(n1052) );
  NR2 U1687 ( .I1(n1053), .I2(n1052), .O(n1054) );
  AOI22S U1688 ( .A1(SRAM0_data_o_reg[21]), .A2(n1374), .B1(
        SRAM0_data_o_reg[29]), .B2(n1373), .O(n1061) );
  AOI22S U1689 ( .A1(SRAM0_data_o_reg[13]), .A2(n1376), .B1(
        SRAM1_data_o_reg[5]), .B2(n1375), .O(n1060) );
  INV1S U1690 ( .I(SRAM1_data_o_reg[29]), .O(n1113) );
  MOAI1S U1691 ( .A1(n1378), .A2(n1113), .B1(SRAM1_data_o_reg[13]), .B2(n1377), 
        .O(n1058) );
  INV1S U1692 ( .I(SRAM0_data_o_reg[5]), .O(n1114) );
  MOAI1S U1693 ( .A1(n1380), .A2(n1114), .B1(SRAM1_data_o_reg[21]), .B2(n1379), 
        .O(n1057) );
  NR2 U1694 ( .I1(n1058), .I2(n1057), .O(n1059) );
  AOI22S U1695 ( .A1(SRAM0_data_o_reg[29]), .A2(n1402), .B1(
        SRAM1_data_o_reg[21]), .B2(n1401), .O(n1068) );
  AOI22S U1696 ( .A1(SRAM1_data_o_reg[13]), .A2(n1404), .B1(
        SRAM1_data_o_reg[5]), .B2(n1403), .O(n1067) );
  MOAI1S U1697 ( .A1(n1406), .A2(n1113), .B1(SRAM0_data_o_reg[13]), .B2(n1405), 
        .O(n1065) );
  MOAI1S U1698 ( .A1(n1408), .A2(n1114), .B1(SRAM0_data_o_reg[21]), .B2(n1407), 
        .O(n1064) );
  NR2 U1699 ( .I1(n1065), .I2(n1064), .O(n1066) );
  AOI22S U1700 ( .A1(SRAM0_data_o_reg[31]), .A2(n1430), .B1(
        SRAM1_data_o_reg[7]), .B2(n1429), .O(n1076) );
  AOI22S U1701 ( .A1(SRAM0_data_o_reg[23]), .A2(n1432), .B1(
        SRAM1_data_o_reg[15]), .B2(n1431), .O(n1075) );
  MOAI1S U1702 ( .A1(n1434), .A2(n1259), .B1(SRAM1_data_o_reg[23]), .B2(n1433), 
        .O(n1073) );
  MOAI1S U1703 ( .A1(n1436), .A2(n1258), .B1(SRAM0_data_o_reg[15]), .B2(n1435), 
        .O(n1072) );
  NR2 U1704 ( .I1(n1073), .I2(n1072), .O(n1074) );
  AOI22S U1705 ( .A1(SRAM0_data_o_reg[29]), .A2(n1430), .B1(
        SRAM1_data_o_reg[5]), .B2(n1429), .O(n1081) );
  AOI22S U1706 ( .A1(SRAM0_data_o_reg[21]), .A2(n1432), .B1(
        SRAM1_data_o_reg[13]), .B2(n1431), .O(n1080) );
  MOAI1S U1707 ( .A1(n1434), .A2(n1114), .B1(SRAM1_data_o_reg[21]), .B2(n1433), 
        .O(n1078) );
  MOAI1S U1708 ( .A1(n1436), .A2(n1113), .B1(SRAM0_data_o_reg[13]), .B2(n1435), 
        .O(n1077) );
  NR2 U1709 ( .I1(n1078), .I2(n1077), .O(n1079) );
  ND2 U1710 ( .I1(n1085), .I2(n1084), .O(n1492) );
  AOI22S U1711 ( .A1(SRAM1_data_o_reg[5]), .A2(n1457), .B1(
        SRAM1_data_o_reg[21]), .B2(n1492), .O(n1107) );
  AOI22S U1712 ( .A1(SRAM0_data_o_reg[21]), .A2(n1459), .B1(
        SRAM0_data_o_reg[13]), .B2(n1458), .O(n1106) );
  INV1S U1713 ( .I(n1499), .O(n1460) );
  ND2 U1714 ( .I1(n1095), .I2(n1094), .O(n1500) );
  MOAI1S U1715 ( .A1(n1460), .A2(n1113), .B1(SRAM1_data_o_reg[13]), .B2(n1500), 
        .O(n1104) );
  AN2B1S U1716 ( .I1(n1098), .B1(n1110), .O(n1462) );
  MOAI1S U1717 ( .A1(n1462), .A2(n1114), .B1(SRAM0_data_o_reg[29]), .B2(n1461), 
        .O(n1103) );
  NR2 U1718 ( .I1(n1104), .I2(n1103), .O(n1105) );
  NR2 U1719 ( .I1(n1109), .I2(n1108), .O(n1491) );
  MOAI1S U1720 ( .A1(n1491), .A2(n1113), .B1(SRAM1_data_o_reg[5]), .B2(n1489), 
        .O(n1116) );
  INV1S U1721 ( .I(n1457), .O(n1494) );
  MOAI1S U1722 ( .A1(n1494), .A2(n1114), .B1(SRAM0_data_o_reg[21]), .B2(n1492), 
        .O(n1115) );
  NR2 U1723 ( .I1(n1116), .I2(n1115), .O(n1123) );
  AOI22S U1724 ( .A1(SRAM1_data_o_reg[21]), .A2(n1498), .B1(
        SRAM1_data_o_reg[13]), .B2(n1497), .O(n1122) );
  AOI22S U1725 ( .A1(SRAM0_data_o_reg[13]), .A2(n1500), .B1(
        SRAM0_data_o_reg[29]), .B2(n1499), .O(n1121) );
  INV1S U1726 ( .I(out_valid_tail_cnt[3]), .O(n1125) );
  ND2S U1727 ( .I1(out_valid_tail_cnt[1]), .I2(out_valid_tail_cnt[0]), .O(
        n1134) );
  INV1S U1728 ( .I(n1134), .O(n1661) );
  OA13S U1729 ( .B1(out_valid_tail_cnt[2]), .B2(n1661), .B3(
        out_valid_tail_cnt[3]), .A1(out_valid_tail_cnt[4]), .O(n1124) );
  OR2B1S U1730 ( .I1(n1124), .B1(done), .O(n1130) );
  NR2 U1731 ( .I1(in_valid2), .I2(cv_i_overflow[3]), .O(n1131) );
  OR2B1S U1732 ( .I1(n1130), .B1(n1131), .O(n1133) );
  INV1S U1733 ( .I(n1133), .O(n1265) );
  INV1S U1734 ( .I(out_valid_tail_cnt[2]), .O(n1137) );
  OA13S U1735 ( .B1(n1137), .B2(n1134), .B3(n1130), .A1(n1131), .O(n1269) );
  MOAI1S U1736 ( .A1(n1125), .A2(n1270), .B1(out_valid_tail_cnt[4]), .B2(n1269), .O(n906) );
  INV1S U1737 ( .I(input_cnt[7]), .O(n1127) );
  INV1S U1738 ( .I(kernel_start_flag), .O(n1290) );
  OR2 U1739 ( .I1(in_valid2), .I2(n1126), .O(n1278) );
  AN2 U1740 ( .I1(n1126), .I2(n1663), .O(n1277) );
  MOAI1S U1741 ( .A1(n1127), .A2(n1278), .B1(input_cnt_next[7]), .B2(n1277), 
        .O(n998) );
  INV1S U1742 ( .I(input_cnt[10]), .O(n1128) );
  MOAI1S U1743 ( .A1(n1128), .A2(n1278), .B1(input_cnt_next[10]), .B2(n1277), 
        .O(n9950) );
  INV1S U1744 ( .I(input_cnt[3]), .O(n1129) );
  MOAI1S U1745 ( .A1(n1129), .A2(n1278), .B1(input_cnt_next[3]), .B2(n1277), 
        .O(n1002) );
  INV1S U1746 ( .I(input_cnt[12]), .O(n1298) );
  MOAI1S U1747 ( .A1(n1298), .A2(n1278), .B1(input_cnt_next[12]), .B2(n1277), 
        .O(n9930) );
  INV1S U1748 ( .I(input_cnt[5]), .O(n1302) );
  MOAI1S U1749 ( .A1(n1302), .A2(n1278), .B1(input_cnt_next[5]), .B2(n1277), 
        .O(n1000) );
  INV1S U1750 ( .I(input_cnt[2]), .O(n1288) );
  MOAI1S U1751 ( .A1(n1288), .A2(n1278), .B1(n1277), .B2(input_cnt_next[2]), 
        .O(n1003) );
  INV1S U1752 ( .I(input_cnt[1]), .O(n1287) );
  MOAI1S U1753 ( .A1(n1287), .A2(n1278), .B1(n1277), .B2(input_cnt_next[1]), 
        .O(n1004) );
  NR2 U1754 ( .I1(out_valid_tail_cnt[1]), .I2(n1133), .O(n1658) );
  INV1S U1755 ( .I(out_valid_tail_cnt[0]), .O(n1267) );
  NR2 U1756 ( .I1(n1658), .I2(n1657), .O(n1136) );
  NR2 U1757 ( .I1(n1134), .I2(n1133), .O(n1135) );
  MOAI1S U1758 ( .A1(n1137), .A2(n1136), .B1(n1137), .B2(n1135), .O(n907) );
  NR2 U1759 ( .I1(n1350), .I2(n1138), .O(n1620) );
  MOAI1S U1760 ( .A1(cv_j_0__2_), .A2(n1620), .B1(cv_j_0__2_), .B2(n1620), .O(
        n1154) );
  NR2 U1761 ( .I1(n1350), .I2(cv_j_0__3_), .O(n1147) );
  ND2S U1762 ( .I1(n1352), .I2(matrix_size_reg[0]), .O(n1141) );
  AN3S U1763 ( .I1(cv_j_0__2_), .I2(n1520), .I3(n1354), .O(n1139) );
  ND2S U1764 ( .I1(matrix_size_reg[1]), .I2(cv_j_0__3_), .O(n1140) );
  AOI13HS U1765 ( .B1(cv_j_0__2_), .B2(n1615), .B3(n1140), .A1(cv_j_0__6_), 
        .O(n1150) );
  NR2 U1766 ( .I1(matrix_size_reg[0]), .I2(matrix_size_reg[1]), .O(n1565) );
  AOI22S U1767 ( .A1(matrix_size_reg[1]), .A2(n1353), .B1(n1565), .B2(n1354), 
        .O(n1142) );
  ND3S U1768 ( .I1(mode_reg), .I2(n1142), .I3(n1141), .O(n1145) );
  NR2 U1769 ( .I1(mode_reg), .I2(n1143), .O(n1144) );
  MOAI1S U1770 ( .A1(n1350), .A2(n1145), .B1(n1350), .B2(n1144), .O(n1149) );
  AOI13HS U1771 ( .B1(n1147), .B2(n1353), .B3(n1146), .A1(n1352), .O(n1148) );
  AN4B1S U1772 ( .I1(cv_j_0__0_), .I2(n1150), .I3(n1149), .B1(n1148), .O(n1151) );
  MOAI1S U1773 ( .A1(n1154), .A2(n1611), .B1(n1665), .B2(n1610), .O(N213) );
  INV1S U1774 ( .I(mp_value[17]), .O(n1186) );
  INV1S U1775 ( .I(sum60_o[19]), .O(n1640) );
  NR2 U1776 ( .I1(sum60_o[17]), .I2(n1186), .O(n1179) );
  INV1S U1777 ( .I(mp_value[15]), .O(n1309) );
  INV1S U1778 ( .I(mp_value[14]), .O(n1308) );
  INV1S U1779 ( .I(sum60_o[11]), .O(n1651) );
  INV1S U1780 ( .I(sum60_o[9]), .O(n1649) );
  INV1S U1781 ( .I(sum60_o[7]), .O(n1647) );
  AOI22S U1782 ( .A1(mp_value[9]), .A2(n1649), .B1(mp_value[7]), .B2(n1647), 
        .O(n1169) );
  INV1S U1783 ( .I(mp_value[5]), .O(n1307) );
  INV1S U1784 ( .I(sum60_o[4]), .O(n1646) );
  INV1S U1785 ( .I(sum60_o[3]), .O(n1645) );
  AOI22S U1786 ( .A1(mp_value[3]), .A2(n1645), .B1(mp_value[4]), .B2(n1646), 
        .O(n1160) );
  INV1S U1787 ( .I(sum60_o[2]), .O(n1644) );
  INV1S U1788 ( .I(sum60_o[1]), .O(n1643) );
  INV1S U1789 ( .I(sum60_o[0]), .O(n1642) );
  OR2S U1790 ( .I1(n1642), .I2(mp_value[0]), .O(n1155) );
  MAO222S U1791 ( .A1(mp_value[1]), .B1(n1643), .C1(n1155), .O(n1156) );
  MAO222S U1792 ( .A1(mp_value[2]), .B1(n1644), .C1(n1156), .O(n1158) );
  OR2S U1793 ( .I1(n1645), .I2(mp_value[3]), .O(n1157) );
  ND2S U1794 ( .I1(n1158), .I2(n1157), .O(n1159) );
  MOAI1S U1795 ( .A1(mp_value[4]), .A2(n1646), .B1(n1160), .B2(n1159), .O(
        n1161) );
  MAO222S U1796 ( .A1(sum60_o[5]), .B1(n1307), .C1(n1161), .O(n1162) );
  INV1S U1797 ( .I(mp_value[6]), .O(n1310) );
  MAO222S U1798 ( .A1(sum60_o[6]), .B1(n1162), .C1(n1310), .O(n1168) );
  INV1S U1799 ( .I(sum60_o[8]), .O(n1648) );
  ND2S U1800 ( .I1(mp_value[8]), .I2(n1648), .O(n1167) );
  INV1S U1801 ( .I(mp_value[9]), .O(n1165) );
  ND2S U1802 ( .I1(sum60_o[7]), .I2(n1167), .O(n1163) );
  OAI22S U1803 ( .A1(mp_value[8]), .A2(n1648), .B1(mp_value[7]), .B2(n1163), 
        .O(n1164) );
  AOI13HS U1804 ( .B1(n1169), .B2(n1168), .B3(n1167), .A1(n1166), .O(n1170) );
  INV1S U1805 ( .I(sum60_o[10]), .O(n1650) );
  MOAI1S U1806 ( .A1(mp_value[12]), .A2(n1173), .B1(sum60_o[12]), .B2(n1172), 
        .O(n1174) );
  INV1S U1807 ( .I(mp_value[13]), .O(n1306) );
  INV1S U1808 ( .I(sum60_o[18]), .O(n1656) );
  INV1S U1809 ( .I(sum60_o[16]), .O(n1653) );
  AOI22S U1810 ( .A1(mp_value[18]), .A2(n1656), .B1(mp_value[16]), .B2(n1653), 
        .O(n1177) );
  NR2 U1811 ( .I1(n1179), .I2(mp_value[16]), .O(n1180) );
  AOI22S U1812 ( .A1(sum60_o[17]), .A2(n1186), .B1(sum60_o[16]), .B2(n1180), 
        .O(n1181) );
  NR2 U1813 ( .I1(in_valid2), .I2(cv_k_overflow[3]), .O(n1576) );
  AN2B1S U1814 ( .I1(n1576), .B1(n1185), .O(n1641) );
  MOAI1S U1815 ( .A1(n1186), .A2(n1574), .B1(sum60_o[17]), .B2(n1641), .O(n913) );
  ND3S U1816 ( .I1(cv_v[0]), .I2(cv_r_0__1_), .I3(n1673), .O(n1189) );
  ND2S U1817 ( .I1(cv_r_0__0_), .I2(cv_r_0__1_), .O(n1187) );
  AO12S U1818 ( .B1(n1506), .B2(n1187), .A1(n1627), .O(n1188) );
  MOAI1S U1819 ( .A1(cv_r_0__2_), .A2(n1189), .B1(n1666), .B2(n1188), .O(n955)
         );
  ND2S U1820 ( .I1(cv_j_0__2_), .I2(n1620), .O(n1282) );
  NR2 U1821 ( .I1(n1354), .I2(n1282), .O(n1280) );
  ND2S U1822 ( .I1(cv_j_0__4_), .I2(n1280), .O(n1284) );
  NR2 U1823 ( .I1(n1353), .I2(n1284), .O(n1190) );
  MOAI1S U1824 ( .A1(cv_j_0__6_), .A2(n1190), .B1(cv_j_0__6_), .B2(n1190), .O(
        n1191) );
  MOAI1S U1825 ( .A1(n1191), .A2(n1611), .B1(n1667), .B2(n1610), .O(N217) );
  NR2 U1826 ( .I1(cv_i_2__6_), .I2(n1638), .O(n1192) );
  OR3B2 U1827 ( .I1(cv_i_2__5_), .B1(n1193), .B2(n1192), .O(n1635) );
  AOI22S U1828 ( .A1(SRAM0_data_o_reg[16]), .A2(n1374), .B1(
        SRAM0_data_o_reg[24]), .B2(n1373), .O(n1198) );
  AOI22S U1829 ( .A1(SRAM0_data_o_reg[8]), .A2(n1376), .B1(SRAM1_data_o_reg[0]), .B2(n1375), .O(n1197) );
  INV1S U1830 ( .I(SRAM1_data_o_reg[24]), .O(n1244) );
  MOAI1S U1831 ( .A1(n1378), .A2(n1244), .B1(SRAM1_data_o_reg[8]), .B2(n1377), 
        .O(n1195) );
  INV1S U1832 ( .I(SRAM0_data_o_reg[0]), .O(n1245) );
  MOAI1S U1833 ( .A1(n1380), .A2(n1245), .B1(SRAM1_data_o_reg[16]), .B2(n1379), 
        .O(n1194) );
  NR2 U1834 ( .I1(n1195), .I2(n1194), .O(n1196) );
  AOI22S U1835 ( .A1(SRAM0_data_o_reg[17]), .A2(n1374), .B1(
        SRAM0_data_o_reg[25]), .B2(n1373), .O(n1203) );
  AOI22S U1836 ( .A1(SRAM0_data_o_reg[9]), .A2(n1376), .B1(SRAM1_data_o_reg[1]), .B2(n1375), .O(n1202) );
  INV1S U1837 ( .I(SRAM1_data_o_reg[25]), .O(n1251) );
  MOAI1S U1838 ( .A1(n1378), .A2(n1251), .B1(SRAM1_data_o_reg[9]), .B2(n1377), 
        .O(n1200) );
  INV1S U1839 ( .I(SRAM0_data_o_reg[1]), .O(n1252) );
  MOAI1S U1840 ( .A1(n1380), .A2(n1252), .B1(SRAM1_data_o_reg[17]), .B2(n1379), 
        .O(n1199) );
  NR2 U1841 ( .I1(n1200), .I2(n1199), .O(n1201) );
  AOI22S U1842 ( .A1(SRAM0_data_o_reg[24]), .A2(n1402), .B1(
        SRAM1_data_o_reg[16]), .B2(n1401), .O(n1208) );
  AOI22S U1843 ( .A1(SRAM1_data_o_reg[8]), .A2(n1404), .B1(SRAM1_data_o_reg[0]), .B2(n1403), .O(n1207) );
  MOAI1S U1844 ( .A1(n1406), .A2(n1244), .B1(SRAM0_data_o_reg[8]), .B2(n1405), 
        .O(n1205) );
  MOAI1S U1845 ( .A1(n1408), .A2(n1245), .B1(SRAM0_data_o_reg[16]), .B2(n1407), 
        .O(n1204) );
  NR2 U1846 ( .I1(n1205), .I2(n1204), .O(n1206) );
  AOI22S U1847 ( .A1(SRAM0_data_o_reg[25]), .A2(n1402), .B1(
        SRAM1_data_o_reg[17]), .B2(n1401), .O(n1213) );
  AOI22S U1848 ( .A1(SRAM1_data_o_reg[9]), .A2(n1404), .B1(SRAM1_data_o_reg[1]), .B2(n1403), .O(n1212) );
  MOAI1S U1849 ( .A1(n1406), .A2(n1251), .B1(SRAM0_data_o_reg[9]), .B2(n1405), 
        .O(n1210) );
  MOAI1S U1850 ( .A1(n1408), .A2(n1252), .B1(SRAM0_data_o_reg[17]), .B2(n1407), 
        .O(n1209) );
  NR2 U1851 ( .I1(n1210), .I2(n1209), .O(n1211) );
  AOI22S U1852 ( .A1(SRAM0_data_o_reg[31]), .A2(n1402), .B1(
        SRAM1_data_o_reg[23]), .B2(n1401), .O(n1218) );
  AOI22S U1853 ( .A1(SRAM1_data_o_reg[15]), .A2(n1404), .B1(
        SRAM1_data_o_reg[7]), .B2(n1403), .O(n1217) );
  MOAI1S U1854 ( .A1(n1406), .A2(n1258), .B1(SRAM0_data_o_reg[15]), .B2(n1405), 
        .O(n1215) );
  MOAI1S U1855 ( .A1(n1408), .A2(n1259), .B1(SRAM0_data_o_reg[23]), .B2(n1407), 
        .O(n1214) );
  NR2 U1856 ( .I1(n1215), .I2(n1214), .O(n1216) );
  AOI22S U1857 ( .A1(SRAM0_data_o_reg[24]), .A2(n1430), .B1(
        SRAM1_data_o_reg[0]), .B2(n1429), .O(n1223) );
  AOI22S U1858 ( .A1(SRAM0_data_o_reg[16]), .A2(n1432), .B1(
        SRAM1_data_o_reg[8]), .B2(n1431), .O(n1222) );
  MOAI1S U1859 ( .A1(n1434), .A2(n1245), .B1(SRAM1_data_o_reg[16]), .B2(n1433), 
        .O(n1220) );
  MOAI1S U1860 ( .A1(n1436), .A2(n1244), .B1(SRAM0_data_o_reg[8]), .B2(n1435), 
        .O(n1219) );
  NR2 U1861 ( .I1(n1220), .I2(n1219), .O(n1221) );
  AOI22S U1862 ( .A1(SRAM0_data_o_reg[25]), .A2(n1430), .B1(
        SRAM1_data_o_reg[1]), .B2(n1429), .O(n1228) );
  AOI22S U1863 ( .A1(SRAM0_data_o_reg[17]), .A2(n1432), .B1(
        SRAM1_data_o_reg[9]), .B2(n1431), .O(n1227) );
  MOAI1S U1864 ( .A1(n1434), .A2(n1252), .B1(SRAM1_data_o_reg[17]), .B2(n1433), 
        .O(n1225) );
  MOAI1S U1865 ( .A1(n1436), .A2(n1251), .B1(SRAM0_data_o_reg[9]), .B2(n1435), 
        .O(n1224) );
  NR2 U1866 ( .I1(n1225), .I2(n1224), .O(n1226) );
  AOI22S U1867 ( .A1(SRAM1_data_o_reg[0]), .A2(n1457), .B1(
        SRAM1_data_o_reg[16]), .B2(n1492), .O(n1233) );
  AOI22S U1868 ( .A1(SRAM0_data_o_reg[16]), .A2(n1459), .B1(
        SRAM0_data_o_reg[8]), .B2(n1458), .O(n1232) );
  MOAI1S U1869 ( .A1(n1460), .A2(n1244), .B1(SRAM1_data_o_reg[8]), .B2(n1500), 
        .O(n1230) );
  MOAI1S U1870 ( .A1(n1462), .A2(n1245), .B1(SRAM0_data_o_reg[24]), .B2(n1461), 
        .O(n1229) );
  NR2 U1871 ( .I1(n1230), .I2(n1229), .O(n1231) );
  AOI22S U1872 ( .A1(SRAM1_data_o_reg[1]), .A2(n1457), .B1(
        SRAM1_data_o_reg[17]), .B2(n1492), .O(n1238) );
  AOI22S U1873 ( .A1(SRAM0_data_o_reg[17]), .A2(n1459), .B1(
        SRAM0_data_o_reg[9]), .B2(n1458), .O(n1237) );
  MOAI1S U1874 ( .A1(n1460), .A2(n1251), .B1(SRAM1_data_o_reg[9]), .B2(n1500), 
        .O(n1235) );
  MOAI1S U1875 ( .A1(n1462), .A2(n1252), .B1(SRAM0_data_o_reg[25]), .B2(n1461), 
        .O(n1234) );
  NR2 U1876 ( .I1(n1235), .I2(n1234), .O(n1236) );
  AOI22S U1877 ( .A1(SRAM1_data_o_reg[7]), .A2(n1457), .B1(
        SRAM1_data_o_reg[23]), .B2(n1492), .O(n1243) );
  AOI22S U1878 ( .A1(SRAM0_data_o_reg[23]), .A2(n1459), .B1(
        SRAM0_data_o_reg[15]), .B2(n1458), .O(n1242) );
  MOAI1S U1879 ( .A1(n1460), .A2(n1258), .B1(SRAM1_data_o_reg[15]), .B2(n1500), 
        .O(n1240) );
  MOAI1S U1880 ( .A1(n1462), .A2(n1259), .B1(SRAM0_data_o_reg[31]), .B2(n1461), 
        .O(n1239) );
  NR2 U1881 ( .I1(n1240), .I2(n1239), .O(n1241) );
  MOAI1S U1882 ( .A1(n1491), .A2(n1244), .B1(SRAM1_data_o_reg[0]), .B2(n1489), 
        .O(n1247) );
  MOAI1S U1883 ( .A1(n1494), .A2(n1245), .B1(SRAM0_data_o_reg[16]), .B2(n1492), 
        .O(n1246) );
  NR2 U1884 ( .I1(n1247), .I2(n1246), .O(n1250) );
  AOI22S U1885 ( .A1(SRAM1_data_o_reg[8]), .A2(n1497), .B1(
        SRAM1_data_o_reg[16]), .B2(n1498), .O(n1249) );
  AOI22S U1886 ( .A1(SRAM0_data_o_reg[8]), .A2(n1500), .B1(
        SRAM0_data_o_reg[24]), .B2(n1499), .O(n1248) );
  MOAI1S U1887 ( .A1(n1491), .A2(n1251), .B1(SRAM1_data_o_reg[1]), .B2(n1489), 
        .O(n1254) );
  MOAI1S U1888 ( .A1(n1494), .A2(n1252), .B1(SRAM0_data_o_reg[17]), .B2(n1492), 
        .O(n1253) );
  NR2 U1889 ( .I1(n1254), .I2(n1253), .O(n1257) );
  AOI22S U1890 ( .A1(SRAM1_data_o_reg[17]), .A2(n1498), .B1(
        SRAM1_data_o_reg[9]), .B2(n1497), .O(n1256) );
  AOI22S U1891 ( .A1(SRAM0_data_o_reg[9]), .A2(n1500), .B1(
        SRAM0_data_o_reg[25]), .B2(n1499), .O(n1255) );
  MOAI1S U1892 ( .A1(n1491), .A2(n1258), .B1(SRAM1_data_o_reg[7]), .B2(n1489), 
        .O(n1261) );
  MOAI1S U1893 ( .A1(n1494), .A2(n1259), .B1(SRAM0_data_o_reg[23]), .B2(n1492), 
        .O(n1260) );
  NR2 U1894 ( .I1(n1261), .I2(n1260), .O(n1264) );
  AOI22S U1895 ( .A1(SRAM1_data_o_reg[23]), .A2(n1498), .B1(
        SRAM1_data_o_reg[15]), .B2(n1497), .O(n1263) );
  AOI22S U1896 ( .A1(SRAM0_data_o_reg[15]), .A2(n1500), .B1(
        SRAM0_data_o_reg[31]), .B2(n1499), .O(n1262) );
  BUF1 U1897 ( .I(rst_n), .O(n1690) );
  BUF1 U1898 ( .I(rst_n), .O(n1691) );
  BUF1 U1899 ( .I(rst_n), .O(n1689) );
  BUF1 U1900 ( .I(n1011), .O(n1687) );
  BUF1 U1901 ( .I(rst_n), .O(n1688) );
  BUF1 U1902 ( .I(rst_n), .O(n1686) );
  AN4S U1903 ( .I1(out_valid), .I2(out_value20[0]), .I3(cv_v[4]), .I4(n1686), 
        .O(out_value) );
  MOAI1S U1904 ( .A1(n1267), .A2(n1266), .B1(n1267), .B2(n1265), .O(n910) );
  MOAI1S U1905 ( .A1(n1268), .A2(cv_r_0__0_), .B1(n1673), .B2(n1627), .O(n951)
         );
  MOAI1S U1906 ( .A1(out_valid_tail_cnt[3]), .A2(n1270), .B1(
        out_valid_tail_cnt[3]), .B2(n1269), .O(n909) );
  INV1S U1907 ( .I(input_cnt[11]), .O(n1271) );
  MOAI1S U1908 ( .A1(n1271), .A2(n1278), .B1(input_cnt_next[11]), .B2(n1277), 
        .O(n9940) );
  INV1S U1909 ( .I(input_cnt[9]), .O(n1272) );
  MOAI1S U1910 ( .A1(n1272), .A2(n1278), .B1(input_cnt_next[9]), .B2(n1277), 
        .O(n9960) );
  INV1S U1911 ( .I(input_cnt[13]), .O(n1273) );
  MOAI1S U1912 ( .A1(n1273), .A2(n1278), .B1(input_cnt_next[13]), .B2(n1277), 
        .O(n9920) );
  INV1S U1913 ( .I(input_cnt[4]), .O(n1274) );
  MOAI1S U1914 ( .A1(n1274), .A2(n1278), .B1(input_cnt_next[4]), .B2(n1277), 
        .O(n1001) );
  INV1S U1915 ( .I(input_cnt[8]), .O(n1275) );
  MOAI1S U1916 ( .A1(n1275), .A2(n1278), .B1(input_cnt_next[8]), .B2(n1277), 
        .O(n9970) );
  INV1S U1917 ( .I(input_cnt[6]), .O(n1276) );
  MOAI1S U1918 ( .A1(n1276), .A2(n1278), .B1(input_cnt_next[6]), .B2(n1277), 
        .O(n999) );
  INV1S U1919 ( .I(input_cnt[0]), .O(n1286) );
  MOAI1S U1920 ( .A1(n1286), .A2(n1278), .B1(n1286), .B2(n1277), .O(n1005) );
  MOAI1S U1921 ( .A1(cv_j_0__1_), .A2(cv_j_0__0_), .B1(cv_j_0__1_), .B2(
        cv_j_0__0_), .O(n1279) );
  MOAI1S U1922 ( .A1(n1279), .A2(n1611), .B1(n1669), .B2(n1610), .O(N212) );
  MOAI1S U1923 ( .A1(cv_j_0__4_), .A2(n1280), .B1(cv_j_0__4_), .B2(n1280), .O(
        n1281) );
  MOAI1S U1924 ( .A1(n1281), .A2(n1611), .B1(n1670), .B2(n1610), .O(N215) );
  MOAI1S U1925 ( .A1(n1354), .A2(n1282), .B1(n1354), .B2(n1282), .O(n1283) );
  MOAI1S U1926 ( .A1(n1283), .A2(n1611), .B1(n1671), .B2(n1610), .O(N214) );
  MOAI1S U1927 ( .A1(n1353), .A2(n1284), .B1(n1353), .B2(n1284), .O(n1285) );
  MOAI1S U1928 ( .A1(n1285), .A2(n1611), .B1(n1672), .B2(n1610), .O(N216) );
  INV1S U1929 ( .I(SRAM0_WEB), .O(n1007) );
  NR3 U1930 ( .I1(in_valid2), .I2(n1662), .I3(done), .O(n1313) );
  INV1S U1931 ( .I(n1526), .O(n1582) );
  NR2 U1932 ( .I1(n1287), .I2(n1297), .O(n1289) );
  MOAI1S U1933 ( .A1(n1582), .A2(n1007), .B1(n1289), .B2(n1288), .O(n968) );
  INV1S U1934 ( .I(SRAM1_WEB), .O(n1008) );
  MOAI1S U1935 ( .A1(n1582), .A2(n1008), .B1(input_cnt[2]), .B2(n1289), .O(
        n969) );
  INV1S U1936 ( .I(SRAMK_WEB), .O(n1006) );
  NR2 U1937 ( .I1(n1012), .I2(n1290), .O(n1291) );
  MOAI1S U1938 ( .A1(n1582), .A2(n1006), .B1(n1636), .B2(
        input_kernel_cnt_sh[3]), .O(n976) );
  OR2B1S U1939 ( .I1(input_cnt_adder_cout), .B1(n1636), .O(n1296) );
  NR2 U1940 ( .I1(n1636), .I2(input_cnt_adder_cout), .O(n1294) );
  MOAI1S U1941 ( .A1(n1685), .A2(n1296), .B1(n1294), .B2(
        input_kernel_cnt_sh[1]), .O(N90) );
  INV1S U1942 ( .I(input_kernel_cnt_sh[3]), .O(n1292) );
  MOAI1S U1943 ( .A1(n1292), .A2(n1296), .B1(input_kernel_cnt_sh[4]), .B2(
        n1294), .O(N93) );
  INV1S U1944 ( .I(input_kernel_cnt_sh[1]), .O(n1293) );
  MOAI1S U1945 ( .A1(n1296), .A2(n1293), .B1(n1294), .B2(
        input_kernel_cnt_sh[2]), .O(N91) );
  INV1S U1946 ( .I(input_kernel_cnt_sh[2]), .O(n1295) );
  MOAI1S U1947 ( .A1(n1296), .A2(n1295), .B1(input_kernel_cnt_sh[3]), .B2(
        n1294), .O(N92) );
  NR3 U1948 ( .I1(input_cnt[2]), .I2(input_cnt[13]), .I3(input_cnt[1]), .O(
        n1304) );
  NR3 U1949 ( .I1(input_cnt[9]), .I2(input_cnt[7]), .I3(input_cnt[6]), .O(
        n1303) );
  NR3 U1950 ( .I1(input_cnt[11]), .I2(input_cnt[8]), .I3(input_cnt[10]), .O(
        n1300) );
  NR3 U1951 ( .I1(input_cnt[4]), .I2(input_cnt[3]), .I3(n1297), .O(n1299) );
  AN4B1S U1952 ( .I1(n1304), .I2(n1303), .I3(n1302), .B1(n1301), .O(n1305) );
  MOAI1S U1953 ( .A1(n1305), .A2(n1520), .B1(n1305), .B2(matrix_size[1]), .O(
        n903) );
  MOAI1S U1954 ( .A1(n1305), .A2(n1615), .B1(n1305), .B2(matrix_size[0]), .O(
        n902) );
  MOAI1S U1955 ( .A1(n1306), .A2(n1574), .B1(sum60_o[13]), .B2(n1641), .O(n917) );
  MOAI1S U1956 ( .A1(n1307), .A2(n1574), .B1(sum60_o[5]), .B2(n1641), .O(n925)
         );
  MOAI1S U1957 ( .A1(n1308), .A2(n1574), .B1(sum60_o[14]), .B2(n1641), .O(n916) );
  MOAI1S U1958 ( .A1(n1309), .A2(n1574), .B1(sum60_o[15]), .B2(n1641), .O(n915) );
  MOAI1S U1959 ( .A1(n1310), .A2(n1574), .B1(sum60_o[6]), .B2(n1641), .O(n924)
         );
  ND2S U1960 ( .I1(cv_v[0]), .I2(cv_r_0__0_), .O(n1311) );
  MOAI1S U1961 ( .A1(n1312), .A2(cv_r_0__1_), .B1(n1674), .B2(n1311), .O(n952)
         );
  AOI22S U1962 ( .A1(n1581), .A2(N543), .B1(n1526), .B2(SRAMK_addr[1]), .O(
        n1315) );
  NR2 U1963 ( .I1(n1662), .I2(n1663), .O(n1527) );
  XNR2HS U1964 ( .I1(SRAMK_addr[0]), .I2(n1017), .O(n1317) );
  AOI22S U1965 ( .A1(n1581), .A2(n1317), .B1(n1526), .B2(SRAMK_addr[0]), .O(
        n1319) );
  INV1S U1966 ( .I(matrix_idx[1]), .O(n1338) );
  INV1S U1967 ( .I(matrix_idx[0]), .O(n1332) );
  ND2S U1968 ( .I1(n1338), .I2(n1332), .O(n1321) );
  XOR2HS U1969 ( .I1(SRAMK_addr[6]), .I2(n1017), .O(n1322) );
  XOR2HS U1970 ( .I1(n1322), .I2(DP_OP_193J1_122_2323_n2), .O(n1323) );
  AOI22S U1971 ( .A1(n1581), .A2(n1323), .B1(n1526), .B2(SRAMK_addr[6]), .O(
        n1324) );
  INV1S U1972 ( .I(n1527), .O(n1549) );
  OAI22S U1973 ( .A1(matrix_idx[2]), .A2(n1549), .B1(matrix_idx[0]), .B2(n1549), .O(n1339) );
  INV1S U1974 ( .I(matrix_idx[2]), .O(n1340) );
  ND2S U1975 ( .I1(n1340), .I2(n1332), .O(n1327) );
  XOR2HS U1976 ( .I1(SRAMK_addr[2]), .I2(DP_OP_193J1_122_2323_n6), .O(n1328)
         );
  AOI22S U1977 ( .A1(n1581), .A2(n1328), .B1(n1526), .B2(SRAMK_addr[2]), .O(
        n1330) );
  INV1S U1978 ( .I(matrix_idx[3]), .O(n1345) );
  ND2S U1979 ( .I1(n1345), .I2(n1338), .O(n1579) );
  NR2 U1980 ( .I1(n1345), .I2(n1338), .O(n1580) );
  AN2B1S U1981 ( .I1(n1579), .B1(n1580), .O(n1333) );
  AOI22S U1982 ( .A1(n1636), .A2(input_cnt[3]), .B1(n1339), .B2(n1333), .O(
        n1337) );
  AOI22S U1983 ( .A1(n1581), .A2(N545), .B1(n1526), .B2(SRAMK_addr[3]), .O(
        n1336) );
  NR2 U1984 ( .I1(n1332), .I2(n1589), .O(n1346) );
  INV1S U1985 ( .I(n1333), .O(n1334) );
  ND2S U1986 ( .I1(n1636), .I2(input_cnt[5]), .O(n1344) );
  ND2S U1987 ( .I1(n1581), .I2(N547), .O(n1343) );
  INV1S U1988 ( .I(SRAMK_addr[5]), .O(n1341) );
  NR2 U1989 ( .I1(n1341), .I2(n1582), .O(n1342) );
  AN4B1S U1990 ( .I1(n1344), .I2(n1586), .I3(n1343), .B1(n1342), .O(n1348) );
  ND3S U1991 ( .I1(cv_k_0__1_), .I2(cv_k_0__0_), .I3(n1607), .O(n1567) );
  ND2S U1992 ( .I1(cv_j_0__0_), .I2(n1350), .O(n1625) );
  NR2 U1993 ( .I1(n1567), .I2(n1625), .O(n1617) );
  ND2S U1994 ( .I1(n1566), .I2(n1617), .O(n1351) );
  INV1S U1995 ( .I(n1607), .O(n1594) );
  ND3S U1996 ( .I1(matrix_size_reg[1]), .I2(n1566), .I3(n1594), .O(n1613) );
  ND2S U1997 ( .I1(mode_reg), .I2(n1017), .O(n1624) );
  OR3B2S U1998 ( .I1(n1624), .B1(n1594), .B2(n1520), .O(n1614) );
  NR2 U1999 ( .I1(n1565), .I2(n1607), .O(n1616) );
  INV1S U2000 ( .I(n1567), .O(n1626) );
  AN4B1S U2001 ( .I1(n1354), .I2(n1353), .I3(n1352), .B1(cv_j_0__6_), .O(n1355) );
  NR2 U2002 ( .I1(cv_j_0__2_), .I2(n1355), .O(n1356) );
  NR2 U2003 ( .I1(n1594), .I2(n1610), .O(n1619) );
  ND3S U2004 ( .I1(n1356), .I2(n1620), .I3(n1619), .O(n1357) );
  AOI22S U2005 ( .A1(SRAM0_data_o_reg[18]), .A2(n1374), .B1(
        SRAM0_data_o_reg[26]), .B2(n1373), .O(n1362) );
  AOI22S U2006 ( .A1(SRAM0_data_o_reg[10]), .A2(n1376), .B1(
        SRAM1_data_o_reg[2]), .B2(n1375), .O(n1361) );
  INV1S U2007 ( .I(SRAM1_data_o_reg[26]), .O(n1468) );
  MOAI1S U2008 ( .A1(n1378), .A2(n1468), .B1(SRAM1_data_o_reg[10]), .B2(n1377), 
        .O(n1359) );
  INV1S U2009 ( .I(SRAM0_data_o_reg[2]), .O(n1469) );
  MOAI1S U2010 ( .A1(n1380), .A2(n1469), .B1(SRAM1_data_o_reg[18]), .B2(n1379), 
        .O(n1358) );
  NR2 U2011 ( .I1(n1359), .I2(n1358), .O(n1360) );
  AOI22S U2012 ( .A1(SRAM0_data_o_reg[20]), .A2(n1374), .B1(
        SRAM0_data_o_reg[28]), .B2(n1373), .O(n1367) );
  AOI22S U2013 ( .A1(SRAM0_data_o_reg[12]), .A2(n1376), .B1(
        SRAM1_data_o_reg[4]), .B2(n1375), .O(n1366) );
  INV1S U2014 ( .I(SRAM1_data_o_reg[28]), .O(n1475) );
  MOAI1S U2015 ( .A1(n1378), .A2(n1475), .B1(SRAM1_data_o_reg[12]), .B2(n1377), 
        .O(n1364) );
  INV1S U2016 ( .I(SRAM0_data_o_reg[4]), .O(n1476) );
  MOAI1S U2017 ( .A1(n1380), .A2(n1476), .B1(SRAM1_data_o_reg[20]), .B2(n1379), 
        .O(n1363) );
  NR2 U2018 ( .I1(n1364), .I2(n1363), .O(n1365) );
  AOI22S U2019 ( .A1(SRAM0_data_o_reg[19]), .A2(n1374), .B1(
        SRAM0_data_o_reg[27]), .B2(n1373), .O(n1372) );
  AOI22S U2020 ( .A1(SRAM0_data_o_reg[11]), .A2(n1376), .B1(
        SRAM1_data_o_reg[3]), .B2(n1375), .O(n1371) );
  INV1S U2021 ( .I(SRAM1_data_o_reg[27]), .O(n1482) );
  MOAI1S U2022 ( .A1(n1378), .A2(n1482), .B1(SRAM1_data_o_reg[11]), .B2(n1377), 
        .O(n1369) );
  INV1S U2023 ( .I(SRAM0_data_o_reg[3]), .O(n1483) );
  MOAI1S U2024 ( .A1(n1380), .A2(n1483), .B1(SRAM1_data_o_reg[19]), .B2(n1379), 
        .O(n1368) );
  NR2 U2025 ( .I1(n1369), .I2(n1368), .O(n1370) );
  AOI22S U2026 ( .A1(SRAM0_data_o_reg[22]), .A2(n1374), .B1(
        SRAM0_data_o_reg[30]), .B2(n1373), .O(n1385) );
  AOI22S U2027 ( .A1(SRAM0_data_o_reg[14]), .A2(n1376), .B1(
        SRAM1_data_o_reg[6]), .B2(n1375), .O(n1384) );
  INV1S U2028 ( .I(SRAM1_data_o_reg[30]), .O(n1490) );
  MOAI1S U2029 ( .A1(n1378), .A2(n1490), .B1(SRAM1_data_o_reg[14]), .B2(n1377), 
        .O(n1382) );
  INV1S U2030 ( .I(SRAM0_data_o_reg[6]), .O(n1493) );
  MOAI1S U2031 ( .A1(n1380), .A2(n1493), .B1(SRAM1_data_o_reg[22]), .B2(n1379), 
        .O(n1381) );
  NR2 U2032 ( .I1(n1382), .I2(n1381), .O(n1383) );
  AOI22S U2033 ( .A1(SRAM0_data_o_reg[26]), .A2(n1402), .B1(
        SRAM1_data_o_reg[18]), .B2(n1401), .O(n1390) );
  AOI22S U2034 ( .A1(SRAM1_data_o_reg[10]), .A2(n1404), .B1(
        SRAM1_data_o_reg[2]), .B2(n1403), .O(n1389) );
  MOAI1S U2035 ( .A1(n1406), .A2(n1468), .B1(SRAM0_data_o_reg[10]), .B2(n1405), 
        .O(n1387) );
  MOAI1S U2036 ( .A1(n1408), .A2(n1469), .B1(SRAM0_data_o_reg[18]), .B2(n1407), 
        .O(n1386) );
  NR2 U2037 ( .I1(n1387), .I2(n1386), .O(n1388) );
  AOI22S U2038 ( .A1(SRAM0_data_o_reg[28]), .A2(n1402), .B1(
        SRAM1_data_o_reg[20]), .B2(n1401), .O(n1395) );
  AOI22S U2039 ( .A1(SRAM1_data_o_reg[12]), .A2(n1404), .B1(
        SRAM1_data_o_reg[4]), .B2(n1403), .O(n1394) );
  MOAI1S U2040 ( .A1(n1406), .A2(n1475), .B1(SRAM0_data_o_reg[12]), .B2(n1405), 
        .O(n1392) );
  MOAI1S U2041 ( .A1(n1408), .A2(n1476), .B1(SRAM0_data_o_reg[20]), .B2(n1407), 
        .O(n1391) );
  NR2 U2042 ( .I1(n1392), .I2(n1391), .O(n1393) );
  AOI22S U2043 ( .A1(SRAM0_data_o_reg[27]), .A2(n1402), .B1(
        SRAM1_data_o_reg[19]), .B2(n1401), .O(n1400) );
  AOI22S U2044 ( .A1(SRAM1_data_o_reg[11]), .A2(n1404), .B1(
        SRAM1_data_o_reg[3]), .B2(n1403), .O(n1399) );
  MOAI1S U2045 ( .A1(n1406), .A2(n1482), .B1(SRAM0_data_o_reg[11]), .B2(n1405), 
        .O(n1397) );
  MOAI1S U2046 ( .A1(n1408), .A2(n1483), .B1(SRAM0_data_o_reg[19]), .B2(n1407), 
        .O(n1396) );
  NR2 U2047 ( .I1(n1397), .I2(n1396), .O(n1398) );
  AOI22S U2048 ( .A1(SRAM0_data_o_reg[30]), .A2(n1402), .B1(
        SRAM1_data_o_reg[22]), .B2(n1401), .O(n1413) );
  AOI22S U2049 ( .A1(SRAM1_data_o_reg[14]), .A2(n1404), .B1(
        SRAM1_data_o_reg[6]), .B2(n1403), .O(n1412) );
  MOAI1S U2050 ( .A1(n1406), .A2(n1490), .B1(SRAM0_data_o_reg[14]), .B2(n1405), 
        .O(n1410) );
  MOAI1S U2051 ( .A1(n1408), .A2(n1493), .B1(SRAM0_data_o_reg[22]), .B2(n1407), 
        .O(n1409) );
  NR2 U2052 ( .I1(n1410), .I2(n1409), .O(n1411) );
  AOI22S U2053 ( .A1(SRAM0_data_o_reg[26]), .A2(n1430), .B1(
        SRAM1_data_o_reg[2]), .B2(n1429), .O(n1418) );
  AOI22S U2054 ( .A1(SRAM0_data_o_reg[18]), .A2(n1432), .B1(
        SRAM1_data_o_reg[10]), .B2(n1431), .O(n1417) );
  MOAI1S U2055 ( .A1(n1434), .A2(n1469), .B1(SRAM1_data_o_reg[18]), .B2(n1433), 
        .O(n1415) );
  MOAI1S U2056 ( .A1(n1436), .A2(n1468), .B1(SRAM0_data_o_reg[10]), .B2(n1435), 
        .O(n1414) );
  NR2 U2057 ( .I1(n1415), .I2(n1414), .O(n1416) );
  AOI22S U2058 ( .A1(SRAM0_data_o_reg[28]), .A2(n1430), .B1(
        SRAM1_data_o_reg[4]), .B2(n1429), .O(n1423) );
  AOI22S U2059 ( .A1(SRAM0_data_o_reg[20]), .A2(n1432), .B1(
        SRAM1_data_o_reg[12]), .B2(n1431), .O(n1422) );
  MOAI1S U2060 ( .A1(n1434), .A2(n1476), .B1(SRAM1_data_o_reg[20]), .B2(n1433), 
        .O(n1420) );
  MOAI1S U2061 ( .A1(n1436), .A2(n1475), .B1(SRAM0_data_o_reg[12]), .B2(n1435), 
        .O(n1419) );
  NR2 U2062 ( .I1(n1420), .I2(n1419), .O(n1421) );
  AOI22S U2063 ( .A1(SRAM0_data_o_reg[27]), .A2(n1430), .B1(
        SRAM1_data_o_reg[3]), .B2(n1429), .O(n1428) );
  AOI22S U2064 ( .A1(SRAM0_data_o_reg[19]), .A2(n1432), .B1(
        SRAM1_data_o_reg[11]), .B2(n1431), .O(n1427) );
  MOAI1S U2065 ( .A1(n1434), .A2(n1483), .B1(SRAM1_data_o_reg[19]), .B2(n1433), 
        .O(n1425) );
  MOAI1S U2066 ( .A1(n1436), .A2(n1482), .B1(SRAM0_data_o_reg[11]), .B2(n1435), 
        .O(n1424) );
  NR2 U2067 ( .I1(n1425), .I2(n1424), .O(n1426) );
  ND3 U2068 ( .I1(n1428), .I2(n1427), .I3(n1426), .O(muln_a[19]) );
  AOI22S U2069 ( .A1(SRAM0_data_o_reg[30]), .A2(n1430), .B1(
        SRAM1_data_o_reg[6]), .B2(n1429), .O(n1441) );
  AOI22S U2070 ( .A1(SRAM0_data_o_reg[22]), .A2(n1432), .B1(
        SRAM1_data_o_reg[14]), .B2(n1431), .O(n1440) );
  MOAI1S U2071 ( .A1(n1434), .A2(n1493), .B1(SRAM1_data_o_reg[22]), .B2(n1433), 
        .O(n1438) );
  MOAI1S U2072 ( .A1(n1436), .A2(n1490), .B1(SRAM0_data_o_reg[14]), .B2(n1435), 
        .O(n1437) );
  NR2 U2073 ( .I1(n1438), .I2(n1437), .O(n1439) );
  AOI22S U2074 ( .A1(SRAM1_data_o_reg[2]), .A2(n1457), .B1(
        SRAM1_data_o_reg[18]), .B2(n1492), .O(n1446) );
  AOI22S U2075 ( .A1(SRAM0_data_o_reg[18]), .A2(n1459), .B1(
        SRAM0_data_o_reg[10]), .B2(n1458), .O(n1445) );
  MOAI1S U2076 ( .A1(n1460), .A2(n1468), .B1(SRAM1_data_o_reg[10]), .B2(n1500), 
        .O(n1443) );
  MOAI1S U2077 ( .A1(n1462), .A2(n1469), .B1(SRAM0_data_o_reg[26]), .B2(n1461), 
        .O(n1442) );
  NR2 U2078 ( .I1(n1443), .I2(n1442), .O(n1444) );
  AOI22S U2079 ( .A1(SRAM1_data_o_reg[4]), .A2(n1457), .B1(
        SRAM1_data_o_reg[20]), .B2(n1492), .O(n1451) );
  AOI22S U2080 ( .A1(SRAM0_data_o_reg[20]), .A2(n1459), .B1(
        SRAM0_data_o_reg[12]), .B2(n1458), .O(n1450) );
  MOAI1S U2081 ( .A1(n1460), .A2(n1475), .B1(SRAM1_data_o_reg[12]), .B2(n1500), 
        .O(n1448) );
  MOAI1S U2082 ( .A1(n1462), .A2(n1476), .B1(SRAM0_data_o_reg[28]), .B2(n1461), 
        .O(n1447) );
  NR2 U2083 ( .I1(n1448), .I2(n1447), .O(n1449) );
  AOI22S U2084 ( .A1(SRAM1_data_o_reg[3]), .A2(n1457), .B1(
        SRAM1_data_o_reg[19]), .B2(n1492), .O(n1456) );
  AOI22S U2085 ( .A1(SRAM0_data_o_reg[19]), .A2(n1459), .B1(
        SRAM0_data_o_reg[11]), .B2(n1458), .O(n1455) );
  MOAI1S U2086 ( .A1(n1460), .A2(n1482), .B1(SRAM1_data_o_reg[11]), .B2(n1500), 
        .O(n1453) );
  MOAI1S U2087 ( .A1(n1462), .A2(n1483), .B1(SRAM0_data_o_reg[27]), .B2(n1461), 
        .O(n1452) );
  NR2 U2088 ( .I1(n1453), .I2(n1452), .O(n1454) );
  AOI22S U2089 ( .A1(SRAM1_data_o_reg[6]), .A2(n1457), .B1(
        SRAM1_data_o_reg[22]), .B2(n1492), .O(n1467) );
  AOI22S U2090 ( .A1(SRAM0_data_o_reg[22]), .A2(n1459), .B1(
        SRAM0_data_o_reg[14]), .B2(n1458), .O(n1466) );
  MOAI1S U2091 ( .A1(n1460), .A2(n1490), .B1(SRAM1_data_o_reg[14]), .B2(n1500), 
        .O(n1464) );
  MOAI1S U2092 ( .A1(n1462), .A2(n1493), .B1(SRAM0_data_o_reg[30]), .B2(n1461), 
        .O(n1463) );
  NR2 U2093 ( .I1(n1464), .I2(n1463), .O(n1465) );
  MOAI1S U2094 ( .A1(n1491), .A2(n1468), .B1(SRAM1_data_o_reg[2]), .B2(n1489), 
        .O(n1471) );
  MOAI1S U2095 ( .A1(n1494), .A2(n1469), .B1(SRAM0_data_o_reg[18]), .B2(n1492), 
        .O(n1470) );
  NR2 U2096 ( .I1(n1471), .I2(n1470), .O(n1474) );
  AOI22S U2097 ( .A1(SRAM1_data_o_reg[18]), .A2(n1498), .B1(
        SRAM1_data_o_reg[10]), .B2(n1497), .O(n1473) );
  AOI22S U2098 ( .A1(SRAM0_data_o_reg[10]), .A2(n1500), .B1(
        SRAM0_data_o_reg[26]), .B2(n1499), .O(n1472) );
  MOAI1S U2099 ( .A1(n1491), .A2(n1475), .B1(SRAM1_data_o_reg[4]), .B2(n1489), 
        .O(n1478) );
  MOAI1S U2100 ( .A1(n1494), .A2(n1476), .B1(SRAM0_data_o_reg[20]), .B2(n1492), 
        .O(n1477) );
  NR2 U2101 ( .I1(n1478), .I2(n1477), .O(n1481) );
  AOI22S U2102 ( .A1(SRAM1_data_o_reg[20]), .A2(n1498), .B1(
        SRAM1_data_o_reg[12]), .B2(n1497), .O(n1480) );
  AOI22S U2103 ( .A1(SRAM0_data_o_reg[12]), .A2(n1500), .B1(
        SRAM0_data_o_reg[28]), .B2(n1499), .O(n1479) );
  MOAI1S U2104 ( .A1(n1491), .A2(n1482), .B1(SRAM1_data_o_reg[3]), .B2(n1489), 
        .O(n1485) );
  MOAI1S U2105 ( .A1(n1494), .A2(n1483), .B1(SRAM0_data_o_reg[19]), .B2(n1492), 
        .O(n1484) );
  NR2 U2106 ( .I1(n1485), .I2(n1484), .O(n1488) );
  AOI22S U2107 ( .A1(SRAM1_data_o_reg[19]), .A2(n1498), .B1(
        SRAM1_data_o_reg[11]), .B2(n1497), .O(n1487) );
  AOI22S U2108 ( .A1(SRAM0_data_o_reg[11]), .A2(n1500), .B1(
        SRAM0_data_o_reg[27]), .B2(n1499), .O(n1486) );
  ND3 U2109 ( .I1(n1488), .I2(n1487), .I3(n1486), .O(muln_a[3]) );
  MOAI1S U2110 ( .A1(n1491), .A2(n1490), .B1(SRAM1_data_o_reg[6]), .B2(n1489), 
        .O(n1496) );
  MOAI1S U2111 ( .A1(n1494), .A2(n1493), .B1(SRAM0_data_o_reg[22]), .B2(n1492), 
        .O(n1495) );
  NR2 U2112 ( .I1(n1496), .I2(n1495), .O(n1503) );
  AOI22S U2113 ( .A1(SRAM1_data_o_reg[22]), .A2(n1498), .B1(
        SRAM1_data_o_reg[14]), .B2(n1497), .O(n1502) );
  AOI22S U2114 ( .A1(SRAM0_data_o_reg[14]), .A2(n1500), .B1(
        SRAM0_data_o_reg[30]), .B2(n1499), .O(n1501) );
  OR2B1 U2115 ( .I1(cv_r_overflow[3]), .B1(cv_v[3]), .O(n1639) );
  AN2B1S U2116 ( .I1(sum60_o[5]), .B1(n1639), .O(n945) );
  AN2B1S U2117 ( .I1(sum60_o[6]), .B1(n1639), .O(n944) );
  AN2B1S U2118 ( .I1(sum60_o[13]), .B1(n1639), .O(n937) );
  AN2B1S U2119 ( .I1(sum60_o[14]), .B1(n1639), .O(n936) );
  AN2B1S U2120 ( .I1(sum60_o[15]), .B1(n1639), .O(n935) );
  AN2B1S U2121 ( .I1(sum60_o[17]), .B1(n1639), .O(n933) );
  AOI22S U2122 ( .A1(n1676), .A2(n1504), .B1(n1675), .B2(n1506), .O(n1505) );
  INV1S U2123 ( .I(SRAMK_addr[0]), .O(n1507) );
  ND2S U2124 ( .I1(n1507), .I2(n1506), .O(DP_OP_193J1_122_2323_n7) );
  NR2 U2125 ( .I1(cv_i_0__3_), .I2(n1508), .O(n1510) );
  ND3S U2126 ( .I1(n1510), .I2(n1598), .I3(n1605), .O(n1509) );
  MOAI1S U2127 ( .A1(n1510), .A2(n1605), .B1(cv_i_0__4_), .B2(n1509), .O(n1511) );
  NR2 U2128 ( .I1(cv_i_0__6_), .I2(n1511), .O(n1514) );
  ND2S U2129 ( .I1(cv_i_0__3_), .I2(matrix_size_reg[1]), .O(n1512) );
  ND3S U2130 ( .I1(n1512), .I2(n1615), .I3(cv_i_0__2_), .O(n1513) );
  ND3S U2131 ( .I1(n1514), .I2(cv_i_0__0_), .I3(n1513), .O(n1515) );
  AOI22S U2132 ( .A1(matrix_size_reg[1]), .A2(n1605), .B1(n1565), .B2(n1519), 
        .O(n1518) );
  ND2S U2133 ( .I1(matrix_size_reg[0]), .I2(n1516), .O(n1517) );
  AOI13HS U2134 ( .B1(n1615), .B2(n1520), .B3(n1519), .A1(cv_i_0__2_), .O(
        n1521) );
  NR2 U2135 ( .I1(cv_i_0__1_), .I2(n1521), .O(n1522) );
  MOAI1S U2136 ( .A1(n1638), .A2(n1523), .B1(n1638), .B2(n1522), .O(n1524) );
  AN2 U2137 ( .I1(n1593), .I2(n1581), .O(n1562) );
  AO12 U2138 ( .B1(in_valid2_cnt), .B2(n1527), .A1(n1526), .O(n1561) );
  AOI22S U2139 ( .A1(n1562), .A2(addsub1_o[1]), .B1(SRAM1_addr[1]), .B2(n1561), 
        .O(n1528) );
  AOI22S U2140 ( .A1(n1562), .A2(addsub1_o[5]), .B1(SRAM1_addr[5]), .B2(n1561), 
        .O(n1529) );
  AOI22S U2141 ( .A1(n1562), .A2(addsub1_o[0]), .B1(SRAM1_addr[0]), .B2(n1561), 
        .O(n1530) );
  AOI22S U2142 ( .A1(n1562), .A2(addsub0_o[5]), .B1(SRAM0_addr[5]), .B2(n1561), 
        .O(n1532) );
  AOI22S U2143 ( .A1(n1562), .A2(addsub1_o[2]), .B1(SRAM1_addr[2]), .B2(n1561), 
        .O(n1533) );
  AOI22S U2144 ( .A1(n1562), .A2(addsub0_o[6]), .B1(SRAM0_addr[6]), .B2(n1561), 
        .O(n1534) );
  AOI22S U2145 ( .A1(n1562), .A2(addsub1_o[4]), .B1(SRAM1_addr[4]), .B2(n1561), 
        .O(n1535) );
  AOI22S U2146 ( .A1(n1562), .A2(addsub0_o[4]), .B1(SRAM0_addr[4]), .B2(n1561), 
        .O(n1537) );
  AOI22S U2147 ( .A1(n1562), .A2(addsub0_o[0]), .B1(SRAM0_addr[0]), .B2(n1561), 
        .O(n1539) );
  AOI22S U2148 ( .A1(n1562), .A2(addsub1_o[6]), .B1(SRAM1_addr[6]), .B2(n1561), 
        .O(n1541) );
  AOI22S U2149 ( .A1(n1562), .A2(addsub0_o[1]), .B1(SRAM0_addr[1]), .B2(n1561), 
        .O(n1543) );
  AOI22S U2150 ( .A1(n1562), .A2(addsub0_o[2]), .B1(SRAM0_addr[2]), .B2(n1561), 
        .O(n1545) );
  AOI22S U2151 ( .A1(n1562), .A2(addsub1_o[3]), .B1(SRAM1_addr[3]), .B2(n1561), 
        .O(n1546) );
  AOI22S U2152 ( .A1(n1562), .A2(addsub0_o[3]), .B1(SRAM0_addr[3]), .B2(n1561), 
        .O(n1548) );
  NR2 U2153 ( .I1(in_valid2_cnt), .I2(n1549), .O(n1557) );
  AOI22S U2154 ( .A1(n1662), .A2(input_cnt_next[10]), .B1(n1557), .B2(
        matrix_idx[0]), .O(n1553) );
  AOI22S U2155 ( .A1(n1562), .A2(addsub1_o[7]), .B1(SRAM1_addr[7]), .B2(n1561), 
        .O(n1550) );
  AOI22S U2156 ( .A1(n1662), .A2(input_cnt_next[13]), .B1(n1557), .B2(
        matrix_idx[3]), .O(n1556) );
  AOI22S U2157 ( .A1(n1562), .A2(addsub1_o[10]), .B1(SRAM1_addr[10]), .B2(
        n1561), .O(n1551) );
  AOI22S U2158 ( .A1(n1562), .A2(addsub0_o[7]), .B1(SRAM0_addr[7]), .B2(n1561), 
        .O(n1552) );
  AOI22S U2159 ( .A1(n1662), .A2(input_cnt_next[12]), .B1(n1557), .B2(
        matrix_idx[2]), .O(n1564) );
  AOI22S U2160 ( .A1(n1562), .A2(addsub0_o[9]), .B1(SRAM0_addr[9]), .B2(n1561), 
        .O(n1554) );
  AOI22S U2161 ( .A1(n1562), .A2(addsub0_o[10]), .B1(SRAM0_addr[10]), .B2(
        n1561), .O(n1555) );
  AOI22S U2162 ( .A1(n1662), .A2(input_cnt_next[11]), .B1(n1557), .B2(
        matrix_idx[1]), .O(n1560) );
  AOI22S U2163 ( .A1(n1562), .A2(addsub0_o[8]), .B1(SRAM0_addr[8]), .B2(n1561), 
        .O(n1558) );
  AOI22S U2164 ( .A1(n1562), .A2(addsub1_o[8]), .B1(SRAM1_addr[8]), .B2(n1561), 
        .O(n1559) );
  AOI22S U2165 ( .A1(n1562), .A2(addsub1_o[9]), .B1(SRAM1_addr[9]), .B2(n1561), 
        .O(n1563) );
  OAI112HS U2166 ( .C1(n1620), .C2(n1567), .A1(n1566), .B1(n1630), .O(n1568)
         );
  OA112S U2167 ( .C1(n1618), .C2(n1624), .A1(cv_v[0]), .B1(n1568), .O(
        addsub1_b[2]) );
  ND2S U2168 ( .I1(n1570), .I2(n1569), .O(n1571) );
  INV1S U2169 ( .I(n1574), .O(n1654) );
  AOI22S U2170 ( .A1(sum60_o[19]), .A2(n1641), .B1(mp_value[19]), .B2(n1654), 
        .O(n1575) );
  INV1S U2171 ( .I(SRAMK_addr[2]), .O(n1578) );
  INV1S U2172 ( .I(DP_OP_193J1_122_2323_n6), .O(n1577) );
  NR2 U2173 ( .I1(n1578), .I2(n1577), .O(DP_OP_193J1_122_2323_n5) );
  MUX2S U2174 ( .A(cv_v[0]), .B(in_valid2_cnt), .S(in_valid2), .O(n868) );
  OA12S U2175 ( .B1(matrix_idx[0]), .B2(n1580), .A1(n1579), .O(n1590) );
  INV1S U2176 ( .I(SRAMK_addr[4]), .O(n1583) );
  NR2 U2177 ( .I1(n1583), .I2(n1582), .O(n1584) );
  AN4B1S U2178 ( .I1(n1587), .I2(n1586), .I3(n1585), .B1(n1584), .O(n1588) );
  OAI12HS U2179 ( .B1(n1590), .B2(n1589), .A1(n1588), .O(n972) );
  NR2 U2180 ( .I1(n1013), .I2(n1593), .O(N245) );
  MOAI1S U2181 ( .A1(cv_i_0__0_), .A2(n1592), .B1(n1677), .B2(n1607), .O(N232)
         );
  MOAI1S U2182 ( .A1(cv_i_0__1_), .A2(cv_i_0__0_), .B1(cv_i_0__1_), .B2(
        cv_i_0__0_), .O(n1595) );
  MOAI1S U2183 ( .A1(n1595), .A2(n1608), .B1(n1678), .B2(n1607), .O(N233) );
  ND2S U2184 ( .I1(cv_i_0__1_), .I2(cv_i_0__0_), .O(n1597) );
  MOAI1S U2185 ( .A1(n1598), .A2(n1597), .B1(n1598), .B2(n1597), .O(n1596) );
  MOAI1S U2186 ( .A1(n1596), .A2(n1608), .B1(n1679), .B2(n1607), .O(N234) );
  NR2 U2187 ( .I1(n1598), .I2(n1597), .O(n1602) );
  MOAI1S U2188 ( .A1(cv_i_0__3_), .A2(n1602), .B1(cv_i_0__3_), .B2(n1602), .O(
        n1599) );
  MOAI1S U2189 ( .A1(n1599), .A2(n1608), .B1(n1680), .B2(n1607), .O(N235) );
  AN2S U2190 ( .I1(cv_i_0__3_), .I2(n1602), .O(n1600) );
  MOAI1S U2191 ( .A1(cv_i_0__4_), .A2(n1600), .B1(cv_i_0__4_), .B2(n1600), .O(
        n1601) );
  MOAI1S U2192 ( .A1(n1601), .A2(n1608), .B1(n1681), .B2(n1607), .O(N236) );
  ND3S U2193 ( .I1(cv_i_0__3_), .I2(cv_i_0__4_), .I3(n1602), .O(n1604) );
  MOAI1S U2194 ( .A1(n1605), .A2(n1604), .B1(n1605), .B2(n1604), .O(n1603) );
  MOAI1S U2195 ( .A1(n1603), .A2(n1608), .B1(n1682), .B2(n1607), .O(N237) );
  NR2 U2196 ( .I1(n1605), .I2(n1604), .O(n1606) );
  MOAI1S U2197 ( .A1(cv_i_0__6_), .A2(n1606), .B1(cv_i_0__6_), .B2(n1606), .O(
        n1609) );
  MOAI1S U2198 ( .A1(n1609), .A2(n1608), .B1(n1683), .B2(n1607), .O(N238) );
  MOAI1S U2199 ( .A1(cv_j_0__0_), .A2(n1611), .B1(n1684), .B2(n1610), .O(N211)
         );
  OAI112HS U2200 ( .C1(n1615), .C2(n1614), .A1(n1613), .B1(n1612), .O(
        addsub1_b[1]) );
  NR2 U2201 ( .I1(n1617), .I2(n1616), .O(n1622) );
  AOI13HS U2202 ( .B1(cv_j_0__2_), .B2(n1620), .B3(n1619), .A1(n1618), .O(
        n1621) );
  OAI22S U2203 ( .A1(n1622), .A2(n1629), .B1(n1621), .B2(n1624), .O(
        addsub0_b[0]) );
  INV1S U2204 ( .I(addsub0_b[4]), .O(n1623) );
  AOI13HS U2205 ( .B1(n1626), .B2(n1625), .B3(n1624), .A1(n1623), .O(n1628) );
  NR2 U2206 ( .I1(n1628), .I2(n1627), .O(addsub0_b[2]) );
  NR2 U2207 ( .I1(n1630), .I2(n1629), .O(addsub0_b[3]) );
  AN2 U2208 ( .I1(n1632), .I2(cv_k_overflow[3]), .O(n1634) );
  AN3S U2209 ( .I1(mp_value[19]), .I2(cv_k_overflow[3]), .I3(sum60_o[19]), .O(
        N997) );
  MOAI1S U2210 ( .A1(n1685), .A2(n1636), .B1(input_kernel_cnt_sh[4]), .B2(
        n1636), .O(n1637) );
  OA12S U2211 ( .B1(kernel_start_flag), .B2(input_cnt_adder_cout), .A1(n1663), 
        .O(N84) );
  MOAI1S U2212 ( .A1(n1013), .A2(n1638), .B1(n1013), .B2(mode), .O(n9910) );
  OA12S U2213 ( .B1(done), .B2(cv_i_overflow[3]), .A1(n1663), .O(n977) );
  NR2 U2214 ( .I1(n1642), .I2(n1639), .O(n950) );
  NR2 U2215 ( .I1(n1643), .I2(n1639), .O(n949) );
  NR2 U2216 ( .I1(n1644), .I2(n1639), .O(n948) );
  NR2 U2217 ( .I1(n1645), .I2(n1639), .O(n947) );
  NR2 U2218 ( .I1(n1646), .I2(n1639), .O(n946) );
  NR2 U2219 ( .I1(n1647), .I2(n1639), .O(n943) );
  NR2 U2220 ( .I1(n1648), .I2(n1639), .O(n942) );
  NR2 U2221 ( .I1(n1649), .I2(n1639), .O(n941) );
  NR2 U2222 ( .I1(n1650), .I2(n1639), .O(n940) );
  NR2 U2223 ( .I1(n1651), .I2(n1639), .O(n939) );
  INV1S U2224 ( .I(sum60_o[12]), .O(n1652) );
  NR2 U2225 ( .I1(n1652), .I2(n1639), .O(n938) );
  NR2 U2226 ( .I1(n1653), .I2(n1639), .O(n934) );
  NR2 U2227 ( .I1(n1656), .I2(n1639), .O(n932) );
  NR2 U2228 ( .I1(n1640), .I2(n1639), .O(n931) );
  INV1S U2229 ( .I(n1641), .O(n1655) );
  MOAI1S U2230 ( .A1(n1642), .A2(n1655), .B1(mp_value[0]), .B2(n1654), .O(n930) );
  MOAI1S U2231 ( .A1(n1643), .A2(n1655), .B1(mp_value[1]), .B2(n1654), .O(n929) );
  MOAI1S U2232 ( .A1(n1644), .A2(n1655), .B1(mp_value[2]), .B2(n1654), .O(n928) );
  MOAI1S U2233 ( .A1(n1645), .A2(n1655), .B1(mp_value[3]), .B2(n1654), .O(n927) );
  MOAI1S U2234 ( .A1(n1646), .A2(n1655), .B1(mp_value[4]), .B2(n1654), .O(n926) );
  MOAI1S U2235 ( .A1(n1647), .A2(n1655), .B1(mp_value[7]), .B2(n1654), .O(n923) );
  MOAI1S U2236 ( .A1(n1648), .A2(n1655), .B1(mp_value[8]), .B2(n1654), .O(n922) );
  MOAI1S U2237 ( .A1(n1649), .A2(n1655), .B1(mp_value[9]), .B2(n1654), .O(n921) );
  MOAI1S U2238 ( .A1(n1650), .A2(n1655), .B1(mp_value[10]), .B2(n1654), .O(
        n920) );
  MOAI1S U2239 ( .A1(n1651), .A2(n1655), .B1(mp_value[11]), .B2(n1654), .O(
        n919) );
  MOAI1S U2240 ( .A1(n1652), .A2(n1655), .B1(mp_value[12]), .B2(n1654), .O(
        n918) );
  MOAI1S U2241 ( .A1(n1653), .A2(n1655), .B1(mp_value[16]), .B2(n1654), .O(
        n914) );
  MOAI1S U2242 ( .A1(n1656), .A2(n1655), .B1(mp_value[18]), .B2(n1654), .O(
        n912) );
  NR2 U2243 ( .I1(out_valid_tail_cnt[2]), .I2(out_valid_tail_cnt[3]), .O(n1660) );
  NR2 U2244 ( .I1(cv_k_overflow[3]), .I2(out_valid), .O(n1659) );
  AOI13HS U2245 ( .B1(n1661), .B2(out_valid_tail_cnt[4]), .B3(n1660), .A1(
        n1659), .O(n904) );
  MOAI1S U2246 ( .A1(in_valid2_cnt), .A2(n1663), .B1(in_valid2_cnt), .B2(n1663), .O(n869) );
endmodule


module MULTIPLIER_3 ( clk, rst_n, a, b, o );
  input [7:0] a;
  input [7:0] b;
  output [15:0] o;
  input clk, rst_n;
  wire   N1, N2, N3, N4, N5, N6, N7, N8, N9, N10, N11, N12, N13, N14, N15,
         intadd_23_A_11_, intadd_23_A_10_, intadd_23_A_9_, intadd_23_A_8_,
         intadd_23_A_7_, intadd_23_A_6_, intadd_23_A_5_, intadd_23_A_4_,
         intadd_23_A_3_, intadd_23_A_2_, intadd_23_A_1_, intadd_23_A_0_,
         intadd_23_B_11_, intadd_23_B_10_, intadd_23_B_9_, intadd_23_B_8_,
         intadd_23_B_7_, intadd_23_B_6_, intadd_23_B_5_, intadd_23_B_4_,
         intadd_23_B_3_, intadd_23_B_2_, intadd_23_B_1_, intadd_23_B_0_,
         intadd_23_CI, intadd_23_n12, intadd_23_n11, intadd_23_n10,
         intadd_23_n9, intadd_23_n8, intadd_23_n7, intadd_23_n6, intadd_23_n5,
         intadd_23_n4, intadd_23_n3, intadd_23_n2, intadd_23_n1, n200, n300,
         n400, n500, n600, n700, n800, n900, n1000, n1100, n1200, n1300, n140,
         n150, n16, n17, n18, n19, n201, n21, n22, n23, n24, n25, n26, n27,
         n28, n29, n301, n31, n32, n33, n34, n35, n36, n37, n38, n39, n401,
         n41, n42, n43, n44, n45, n46, n47, n48, n49, n501, n51, n52, n53, n54,
         n55, n56, n57, n58, n59, n601, n61, n62, n63, n64, n65, n66, n67, n68,
         n69, n701, n71, n72, n73, n74, n75, n76, n77, n78, n79, n801, n81,
         n82, n83, n84, n85, n86, n87, n88, n89, n901, n91, n92, n93, n94, n95,
         n96, n97, n98, n99, n1001, n101, n102, n103, n104, n105, n106, n107,
         n108, n109, n1101, n111, n112, n113, n114, n115, n116, n117, n118,
         n119, n1201, n121, n122, n123, n124, n125, n126, n127, n128, n129,
         n1301, n131, n132, n133;

  QDFFS o_reg_15_ ( .D(N15), .CK(clk), .Q(o[15]) );
  QDFFS o_reg_14_ ( .D(N14), .CK(clk), .Q(o[14]) );
  QDFFS o_reg_13_ ( .D(N13), .CK(clk), .Q(o[13]) );
  QDFFS o_reg_12_ ( .D(N12), .CK(clk), .Q(o[12]) );
  QDFFS o_reg_11_ ( .D(N11), .CK(clk), .Q(o[11]) );
  QDFFS o_reg_10_ ( .D(N10), .CK(clk), .Q(o[10]) );
  QDFFS o_reg_9_ ( .D(N9), .CK(clk), .Q(o[9]) );
  QDFFS o_reg_8_ ( .D(N8), .CK(clk), .Q(o[8]) );
  QDFFS o_reg_7_ ( .D(N7), .CK(clk), .Q(o[7]) );
  QDFFS o_reg_6_ ( .D(N6), .CK(clk), .Q(o[6]) );
  QDFFS o_reg_5_ ( .D(N5), .CK(clk), .Q(o[5]) );
  QDFFS o_reg_4_ ( .D(N4), .CK(clk), .Q(o[4]) );
  QDFFS o_reg_3_ ( .D(N3), .CK(clk), .Q(o[3]) );
  QDFFS o_reg_2_ ( .D(N2), .CK(clk), .Q(o[2]) );
  QDFFS o_reg_1_ ( .D(N1), .CK(clk), .Q(o[1]) );
  QDFFS o_reg_0_ ( .D(n133), .CK(clk), .Q(o[0]) );
  FA1S intadd_23_U13 ( .A(intadd_23_B_0_), .B(intadd_23_A_0_), .CI(
        intadd_23_CI), .CO(intadd_23_n12), .S(N3) );
  FA1S intadd_23_U12 ( .A(intadd_23_B_1_), .B(intadd_23_A_1_), .CI(
        intadd_23_n12), .CO(intadd_23_n11), .S(N4) );
  FA1S intadd_23_U11 ( .A(intadd_23_B_2_), .B(intadd_23_A_2_), .CI(
        intadd_23_n11), .CO(intadd_23_n10), .S(N5) );
  FA1S intadd_23_U10 ( .A(intadd_23_B_3_), .B(intadd_23_A_3_), .CI(
        intadd_23_n10), .CO(intadd_23_n9), .S(N6) );
  FA1S intadd_23_U9 ( .A(intadd_23_B_4_), .B(intadd_23_A_4_), .CI(intadd_23_n9), .CO(intadd_23_n8), .S(N7) );
  FA1S intadd_23_U8 ( .A(intadd_23_B_5_), .B(intadd_23_A_5_), .CI(intadd_23_n8), .CO(intadd_23_n7), .S(N8) );
  FA1S intadd_23_U7 ( .A(intadd_23_B_6_), .B(intadd_23_A_6_), .CI(intadd_23_n7), .CO(intadd_23_n6), .S(N9) );
  FA1S intadd_23_U6 ( .A(intadd_23_B_7_), .B(intadd_23_A_7_), .CI(intadd_23_n6), .CO(intadd_23_n5), .S(N10) );
  FA1S intadd_23_U5 ( .A(intadd_23_B_8_), .B(intadd_23_A_8_), .CI(intadd_23_n5), .CO(intadd_23_n4), .S(N11) );
  FA1S intadd_23_U4 ( .A(intadd_23_B_9_), .B(intadd_23_A_9_), .CI(intadd_23_n4), .CO(intadd_23_n3), .S(N12) );
  FA1S intadd_23_U3 ( .A(intadd_23_B_10_), .B(intadd_23_A_10_), .CI(
        intadd_23_n3), .CO(intadd_23_n2), .S(N13) );
  FA1S intadd_23_U2 ( .A(intadd_23_B_11_), .B(intadd_23_A_11_), .CI(
        intadd_23_n2), .CO(intadd_23_n1), .S(N14) );
  OA12S U3 ( .B1(n83), .B2(n98), .A1(a[5]), .O(n93) );
  ND2S U4 ( .I1(b[0]), .I2(n67), .O(n81) );
  OA12S U5 ( .B1(a[0]), .B2(a[1]), .A1(n401), .O(n58) );
  ND2S U6 ( .I1(n66), .I2(n65), .O(n57) );
  OA12S U7 ( .B1(n39), .B2(n54), .A1(a[7]), .O(n66) );
  AO22S U8 ( .A1(n67), .A2(n37), .B1(n54), .B2(n55), .O(n48) );
  OA12S U9 ( .B1(n52), .B2(n35), .A1(n1301), .O(n500) );
  ND2S U10 ( .I1(b[0]), .I2(n105), .O(n119) );
  ND2S U11 ( .I1(n93), .I2(n92), .O(n88) );
  ND2S U12 ( .I1(a[3]), .I2(n113), .O(n116) );
  MAOI1S U13 ( .A1(a[0]), .A2(n200), .B1(n86), .B2(b[1]), .O(n400) );
  AN2S U14 ( .I1(a[0]), .I2(b[0]), .O(n133) );
  MOAI1S U15 ( .A1(a[5]), .A2(a[6]), .B1(a[5]), .B2(a[6]), .O(n127) );
  MOAI1S U16 ( .A1(b[7]), .A2(a[7]), .B1(b[7]), .B2(a[7]), .O(n125) );
  INV1S U17 ( .I(n127), .O(n67) );
  MOAI1S U18 ( .A1(a[7]), .A2(a[6]), .B1(a[7]), .B2(a[6]), .O(n126) );
  NR2 U19 ( .I1(n67), .I2(n126), .O(n54) );
  INV1S U20 ( .I(a[7]), .O(n36) );
  MOAI1S U21 ( .A1(b[6]), .A2(n36), .B1(b[6]), .B2(n36), .O(n1000) );
  MOAI1S U22 ( .A1(n127), .A2(n125), .B1(n54), .B2(n1000), .O(intadd_23_A_11_)
         );
  INV1S U23 ( .I(b[2]), .O(n94) );
  MOAI1S U24 ( .A1(n94), .A2(a[1]), .B1(n94), .B2(a[1]), .O(n200) );
  INV1S U25 ( .I(a[1]), .O(n128) );
  NR2 U26 ( .I1(a[0]), .I2(n128), .O(n107) );
  INV1S U27 ( .I(n107), .O(n86) );
  INV1S U28 ( .I(b[0]), .O(n52) );
  MOAI1S U29 ( .A1(a[1]), .A2(a[2]), .B1(a[1]), .B2(a[2]), .O(n35) );
  ND2S U30 ( .I1(b[1]), .I2(a[0]), .O(n300) );
  ND3S U31 ( .I1(n300), .I2(n52), .I3(a[1]), .O(n1301) );
  NR2 U32 ( .I1(n400), .I2(n500), .O(intadd_23_B_0_) );
  OAI22S U33 ( .A1(n500), .A2(intadd_23_B_0_), .B1(n400), .B2(intadd_23_B_0_), 
        .O(N2) );
  INV1S U34 ( .I(b[3]), .O(n106) );
  MOAI1S U35 ( .A1(n106), .A2(a[1]), .B1(n106), .B2(a[1]), .O(n600) );
  AOI22S U36 ( .A1(a[0]), .A2(n600), .B1(n107), .B2(n94), .O(n800) );
  INV1S U37 ( .I(n35), .O(n113) );
  INV1S U38 ( .I(a[3]), .O(n115) );
  MOAI1S U39 ( .A1(n115), .A2(b[1]), .B1(n115), .B2(b[1]), .O(n109) );
  MOAI1S U40 ( .A1(a[2]), .A2(a[3]), .B1(a[2]), .B2(a[3]), .O(n25) );
  NR2 U41 ( .I1(n113), .I2(n25), .O(n1101) );
  MOAI1S U42 ( .A1(n115), .A2(b[0]), .B1(n115), .B2(b[0]), .O(n700) );
  AOI22S U43 ( .A1(n113), .A2(n109), .B1(n1101), .B2(n700), .O(n900) );
  NR2 U44 ( .I1(n800), .I2(n900), .O(intadd_23_A_1_) );
  OAI22S U45 ( .A1(n900), .A2(intadd_23_A_1_), .B1(n800), .B2(intadd_23_A_1_), 
        .O(intadd_23_A_0_) );
  INV1S U46 ( .I(intadd_23_A_11_), .O(intadd_23_A_10_) );
  MOAI1S U47 ( .A1(a[3]), .A2(a[4]), .B1(a[3]), .B2(a[4]), .O(n82) );
  MOAI1S U48 ( .A1(a[5]), .A2(b[7]), .B1(a[5]), .B2(b[7]), .O(n1200) );
  INV1S U49 ( .I(n82), .O(n105) );
  MOAI1S U50 ( .A1(a[5]), .A2(a[4]), .B1(a[5]), .B2(a[4]), .O(n1100) );
  NR2 U51 ( .I1(n105), .I2(n1100), .O(n98) );
  INV1S U52 ( .I(a[5]), .O(n96) );
  MOAI1S U53 ( .A1(b[6]), .A2(n96), .B1(b[6]), .B2(n96), .O(n19) );
  MOAI1S U54 ( .A1(n82), .A2(n1200), .B1(n98), .B2(n19), .O(n123) );
  INV1S U55 ( .I(n123), .O(n16) );
  INV1S U56 ( .I(b[5]), .O(n84) );
  MOAI1S U57 ( .A1(n84), .A2(a[7]), .B1(n84), .B2(a[7]), .O(n18) );
  AOI22S U58 ( .A1(n67), .A2(n1000), .B1(n54), .B2(n18), .O(n150) );
  OAI22S U59 ( .A1(n82), .A2(n1200), .B1(n1100), .B2(n1200), .O(n140) );
  INV1S U60 ( .I(n1300), .O(intadd_23_B_10_) );
  FA1S U61 ( .A(n16), .B(n150), .CI(n140), .CO(n1300), .S(n17) );
  INV1S U62 ( .I(n17), .O(intadd_23_A_9_) );
  MOAI1S U63 ( .A1(b[4]), .A2(n36), .B1(b[4]), .B2(n36), .O(n201) );
  AOI22S U64 ( .A1(n67), .A2(n18), .B1(n54), .B2(n201), .O(n122) );
  MOAI1S U65 ( .A1(a[3]), .A2(b[7]), .B1(a[3]), .B2(b[7]), .O(n26) );
  INV1S U66 ( .I(n1101), .O(n114) );
  MOAI1S U67 ( .A1(a[3]), .A2(b[6]), .B1(a[3]), .B2(b[6]), .O(n34) );
  OAI22S U68 ( .A1(n35), .A2(n26), .B1(n114), .B2(n34), .O(n43) );
  INV1S U69 ( .I(n43), .O(n24) );
  MOAI1S U70 ( .A1(n84), .A2(a[5]), .B1(n84), .B2(a[5]), .O(n27) );
  AOI22S U71 ( .A1(n105), .A2(n19), .B1(n98), .B2(n27), .O(n23) );
  MOAI1S U72 ( .A1(n106), .A2(a[7]), .B1(n106), .B2(a[7]), .O(n28) );
  AOI22S U73 ( .A1(n67), .A2(n201), .B1(n54), .B2(n28), .O(n22) );
  INV1S U74 ( .I(n21), .O(intadd_23_B_9_) );
  FA1S U75 ( .A(n24), .B(n23), .CI(n22), .CO(n121), .S(n32) );
  OAI22S U76 ( .A1(n35), .A2(n26), .B1(n25), .B2(n26), .O(n31) );
  MOAI1S U77 ( .A1(b[4]), .A2(n96), .B1(b[4]), .B2(n96), .O(n38) );
  AOI22S U78 ( .A1(n105), .A2(n27), .B1(n98), .B2(n38), .O(n42) );
  AOI22S U79 ( .A1(n94), .A2(n36), .B1(b[2]), .B2(a[7]), .O(n37) );
  AOI22S U80 ( .A1(n67), .A2(n28), .B1(n54), .B2(n37), .O(n41) );
  INV1S U81 ( .I(n29), .O(intadd_23_A_8_) );
  FA1S U82 ( .A(n32), .B(n31), .CI(n301), .CO(n29), .S(n33) );
  INV1S U83 ( .I(n33), .O(intadd_23_A_7_) );
  MOAI1S U84 ( .A1(n84), .A2(a[3]), .B1(n84), .B2(a[3]), .O(n51) );
  MOAI1S U85 ( .A1(n35), .A2(n34), .B1(n1101), .B2(n51), .O(n501) );
  MOAI1S U86 ( .A1(n36), .A2(b[1]), .B1(n36), .B2(b[1]), .O(n55) );
  NR2 U87 ( .I1(n501), .I2(n48), .O(n49) );
  MOAI1S U88 ( .A1(n106), .A2(a[5]), .B1(n106), .B2(a[5]), .O(n56) );
  AOI22S U89 ( .A1(n105), .A2(n38), .B1(n98), .B2(n56), .O(n59) );
  MOAI1S U90 ( .A1(b[7]), .A2(n128), .B1(b[7]), .B2(n128), .O(n401) );
  NR2 U91 ( .I1(n127), .I2(b[0]), .O(n39) );
  MOAI1S U92 ( .A1(b[6]), .A2(n86), .B1(a[0]), .B2(n401), .O(n65) );
  FA1S U93 ( .A(n43), .B(n42), .CI(n41), .CO(n301), .S(n45) );
  INV1S U94 ( .I(n44), .O(intadd_23_B_7_) );
  FA1S U95 ( .A(n49), .B(n46), .CI(n45), .CO(n44), .S(n47) );
  INV1S U96 ( .I(n47), .O(intadd_23_A_6_) );
  OAI22S U97 ( .A1(n501), .A2(n49), .B1(n48), .B2(n49), .O(n63) );
  MOAI1S U98 ( .A1(b[4]), .A2(n115), .B1(b[4]), .B2(n115), .O(n69) );
  AOI22S U99 ( .A1(n113), .A2(n51), .B1(n1101), .B2(n69), .O(n72) );
  MOAI1S U100 ( .A1(n52), .A2(a[7]), .B1(n52), .B2(a[7]), .O(n53) );
  AOI22S U101 ( .A1(n67), .A2(n55), .B1(n54), .B2(n53), .O(n71) );
  MOAI1S U102 ( .A1(n96), .A2(b[2]), .B1(n96), .B2(b[2]), .O(n78) );
  AOI22S U103 ( .A1(n105), .A2(n56), .B1(n98), .B2(n78), .O(n701) );
  FA1S U104 ( .A(n59), .B(n58), .CI(n57), .CO(n46), .S(n61) );
  INV1S U105 ( .I(n601), .O(intadd_23_B_6_) );
  FA1S U106 ( .A(n63), .B(n62), .CI(n61), .CO(n601), .S(n64) );
  INV1S U107 ( .I(n64), .O(intadd_23_A_5_) );
  MOAI1S U108 ( .A1(n66), .A2(n65), .B1(n66), .B2(n65), .O(n76) );
  MOAI1S U109 ( .A1(b[6]), .A2(n128), .B1(b[6]), .B2(n128), .O(n68) );
  AOI22S U110 ( .A1(a[0]), .A2(n68), .B1(n107), .B2(n84), .O(n801) );
  MOAI1S U111 ( .A1(n106), .A2(a[3]), .B1(n106), .B2(a[3]), .O(n95) );
  AOI22S U112 ( .A1(n113), .A2(n69), .B1(n1101), .B2(n95), .O(n79) );
  FA1S U113 ( .A(n72), .B(n71), .CI(n701), .CO(n62), .S(n74) );
  INV1S U114 ( .I(n73), .O(intadd_23_B_5_) );
  FA1S U115 ( .A(n76), .B(n75), .CI(n74), .CO(n73), .S(n77) );
  INV1S U116 ( .I(n77), .O(intadd_23_A_4_) );
  MOAI1S U117 ( .A1(n96), .A2(b[1]), .B1(n96), .B2(b[1]), .O(n99) );
  AOI22S U118 ( .A1(n105), .A2(n78), .B1(n98), .B2(n99), .O(n901) );
  FA1S U119 ( .A(n81), .B(n801), .CI(n79), .CO(n75), .S(n89) );
  NR2 U120 ( .I1(n82), .I2(b[0]), .O(n83) );
  MOAI1S U121 ( .A1(n84), .A2(a[1]), .B1(n84), .B2(a[1]), .O(n85) );
  MOAI1S U122 ( .A1(b[4]), .A2(n86), .B1(a[0]), .B2(n85), .O(n92) );
  INV1S U123 ( .I(n87), .O(intadd_23_B_4_) );
  FA1S U124 ( .A(n901), .B(n89), .CI(n88), .CO(n87), .S(n91) );
  INV1S U125 ( .I(n91), .O(intadd_23_A_3_) );
  MOAI1S U126 ( .A1(n93), .A2(n92), .B1(n93), .B2(n92), .O(n103) );
  MOAI1S U127 ( .A1(n94), .A2(a[3]), .B1(n94), .B2(a[3]), .O(n111) );
  AOI22S U128 ( .A1(n113), .A2(n95), .B1(n1101), .B2(n111), .O(n102) );
  MOAI1S U129 ( .A1(n96), .A2(b[0]), .B1(n96), .B2(b[0]), .O(n97) );
  AOI22S U130 ( .A1(n105), .A2(n99), .B1(n98), .B2(n97), .O(n101) );
  INV1S U131 ( .I(n1001), .O(intadd_23_B_3_) );
  FA1S U132 ( .A(n103), .B(n102), .CI(n101), .CO(n1001), .S(n104) );
  INV1S U133 ( .I(n104), .O(intadd_23_A_2_) );
  MOAI1S U134 ( .A1(b[4]), .A2(n128), .B1(b[4]), .B2(n128), .O(n108) );
  AOI22S U135 ( .A1(a[0]), .A2(n108), .B1(n107), .B2(n106), .O(n118) );
  AOI22S U136 ( .A1(n113), .A2(n111), .B1(n1101), .B2(n109), .O(n117) );
  INV1S U137 ( .I(n112), .O(intadd_23_B_2_) );
  OAI22S U138 ( .A1(n116), .A2(b[0]), .B1(n115), .B2(n114), .O(intadd_23_CI)
         );
  FA1S U139 ( .A(n119), .B(n118), .CI(n117), .CO(n112), .S(n1201) );
  INV1S U140 ( .I(n1201), .O(intadd_23_B_1_) );
  FA1S U141 ( .A(n123), .B(n122), .CI(n121), .CO(n21), .S(n124) );
  INV1S U142 ( .I(n124), .O(intadd_23_B_8_) );
  AO12S U143 ( .B1(n127), .B2(n126), .A1(n125), .O(intadd_23_B_11_) );
  NR2 U144 ( .I1(n133), .I2(n128), .O(n132) );
  MOAI1S U145 ( .A1(b[1]), .A2(n128), .B1(b[1]), .B2(n128), .O(n129) );
  AN2S U146 ( .I1(n129), .I2(a[0]), .O(n131) );
  OA12S U147 ( .B1(n132), .B2(n131), .A1(n1301), .O(N1) );
  INV1S U148 ( .I(intadd_23_n1), .O(N15) );
endmodule


module MULTIPLIER_2 ( clk, rst_n, a, b, o );
  input [7:0] a;
  input [7:0] b;
  output [15:0] o;
  input clk, rst_n;
  wire   N1, N2, N3, N4, N5, N6, N7, N8, N9, N10, N11, N12, N13, N14, N15,
         intadd_22_A_11_, intadd_22_A_10_, intadd_22_A_9_, intadd_22_A_8_,
         intadd_22_A_7_, intadd_22_A_6_, intadd_22_A_5_, intadd_22_A_4_,
         intadd_22_A_3_, intadd_22_A_2_, intadd_22_A_1_, intadd_22_A_0_,
         intadd_22_B_11_, intadd_22_B_10_, intadd_22_B_9_, intadd_22_B_8_,
         intadd_22_B_7_, intadd_22_B_6_, intadd_22_B_5_, intadd_22_B_4_,
         intadd_22_B_3_, intadd_22_B_2_, intadd_22_B_1_, intadd_22_B_0_,
         intadd_22_CI, intadd_22_n12, intadd_22_n11, intadd_22_n10,
         intadd_22_n9, intadd_22_n8, intadd_22_n7, intadd_22_n6, intadd_22_n5,
         intadd_22_n4, intadd_22_n3, intadd_22_n2, intadd_22_n1, n160, n200,
         n300, n400, n500, n600, n700, n800, n900, n1000, n1100, n1200, n1300,
         n140, n150, n161, n17, n18, n19, n201, n21, n22, n23, n24, n25, n26,
         n27, n28, n29, n301, n31, n32, n33, n34, n35, n36, n37, n38, n39,
         n401, n41, n42, n43, n44, n45, n46, n47, n48, n49, n501, n51, n52,
         n53, n54, n55, n56, n57, n58, n59, n601, n61, n62, n63, n64, n65, n66,
         n67, n68, n69, n701, n71, n72, n73, n74, n75, n76, n77, n78, n79,
         n801, n81, n82, n83, n84, n85, n86, n87, n88, n89, n901, n91, n92,
         n93, n94, n95, n96, n97, n98, n99, n1001, n101, n102, n103, n104,
         n105, n106, n107, n108, n109, n1101, n111, n112, n113, n114, n115,
         n116, n117, n118, n119, n1201, n121, n122, n123, n124, n125, n126,
         n127, n128, n129, n1301, n131, n132;

  QDFFS o_reg_15_ ( .D(N15), .CK(clk), .Q(o[15]) );
  QDFFS o_reg_14_ ( .D(N14), .CK(clk), .Q(o[14]) );
  QDFFS o_reg_13_ ( .D(N13), .CK(clk), .Q(o[13]) );
  QDFFS o_reg_12_ ( .D(N12), .CK(clk), .Q(o[12]) );
  QDFFS o_reg_11_ ( .D(N11), .CK(clk), .Q(o[11]) );
  QDFFS o_reg_10_ ( .D(N10), .CK(clk), .Q(o[10]) );
  QDFFS o_reg_9_ ( .D(N9), .CK(clk), .Q(o[9]) );
  QDFFS o_reg_8_ ( .D(N8), .CK(clk), .Q(o[8]) );
  QDFFS o_reg_7_ ( .D(N7), .CK(clk), .Q(o[7]) );
  QDFFS o_reg_6_ ( .D(N6), .CK(clk), .Q(o[6]) );
  QDFFS o_reg_5_ ( .D(N5), .CK(clk), .Q(o[5]) );
  QDFFS o_reg_4_ ( .D(N4), .CK(clk), .Q(o[4]) );
  QDFFS o_reg_3_ ( .D(N3), .CK(clk), .Q(o[3]) );
  QDFFS o_reg_2_ ( .D(N2), .CK(clk), .Q(o[2]) );
  QDFFS o_reg_1_ ( .D(N1), .CK(clk), .Q(o[1]) );
  QDFFS o_reg_0_ ( .D(n132), .CK(clk), .Q(o[0]) );
  FA1S intadd_22_U13 ( .A(intadd_22_B_0_), .B(intadd_22_A_0_), .CI(
        intadd_22_CI), .CO(intadd_22_n12), .S(N3) );
  FA1S intadd_22_U12 ( .A(intadd_22_B_1_), .B(intadd_22_A_1_), .CI(
        intadd_22_n12), .CO(intadd_22_n11), .S(N4) );
  FA1S intadd_22_U11 ( .A(intadd_22_B_2_), .B(intadd_22_A_2_), .CI(
        intadd_22_n11), .CO(intadd_22_n10), .S(N5) );
  FA1S intadd_22_U10 ( .A(intadd_22_B_3_), .B(intadd_22_A_3_), .CI(
        intadd_22_n10), .CO(intadd_22_n9), .S(N6) );
  FA1S intadd_22_U9 ( .A(intadd_22_B_4_), .B(intadd_22_A_4_), .CI(intadd_22_n9), .CO(intadd_22_n8), .S(N7) );
  FA1S intadd_22_U8 ( .A(intadd_22_B_5_), .B(intadd_22_A_5_), .CI(intadd_22_n8), .CO(intadd_22_n7), .S(N8) );
  FA1S intadd_22_U7 ( .A(intadd_22_B_6_), .B(intadd_22_A_6_), .CI(intadd_22_n7), .CO(intadd_22_n6), .S(N9) );
  FA1S intadd_22_U6 ( .A(intadd_22_B_7_), .B(intadd_22_A_7_), .CI(intadd_22_n6), .CO(intadd_22_n5), .S(N10) );
  FA1S intadd_22_U5 ( .A(intadd_22_B_8_), .B(intadd_22_A_8_), .CI(intadd_22_n5), .CO(intadd_22_n4), .S(N11) );
  FA1S intadd_22_U4 ( .A(intadd_22_B_9_), .B(intadd_22_A_9_), .CI(intadd_22_n4), .CO(intadd_22_n3), .S(N12) );
  FA1S intadd_22_U3 ( .A(intadd_22_B_10_), .B(intadd_22_A_10_), .CI(
        intadd_22_n3), .CO(intadd_22_n2), .S(N13) );
  FA1S intadd_22_U2 ( .A(intadd_22_B_11_), .B(intadd_22_A_11_), .CI(
        intadd_22_n2), .CO(intadd_22_n1), .S(N14) );
  OA12S U3 ( .B1(n82), .B2(n97), .A1(a[5]), .O(n92) );
  ND2S U4 ( .I1(b[0]), .I2(n66), .O(n801) );
  OA12S U5 ( .B1(a[0]), .B2(a[1]), .A1(n39), .O(n57) );
  ND2S U6 ( .I1(n65), .I2(n64), .O(n56) );
  OA12S U7 ( .B1(n38), .B2(n53), .A1(a[7]), .O(n65) );
  AO22S U8 ( .A1(n66), .A2(n36), .B1(n53), .B2(n54), .O(n47) );
  OA12S U9 ( .B1(n51), .B2(n34), .A1(n129), .O(n400) );
  MAOI1S U10 ( .A1(a[0]), .A2(n160), .B1(n85), .B2(b[1]), .O(n300) );
  ND2S U11 ( .I1(b[0]), .I2(n104), .O(n118) );
  ND2S U12 ( .I1(n92), .I2(n91), .O(n87) );
  AN2S U13 ( .I1(a[0]), .I2(b[0]), .O(n132) );
  MOAI1S U14 ( .A1(a[5]), .A2(a[6]), .B1(a[5]), .B2(a[6]), .O(n126) );
  MOAI1S U15 ( .A1(b[7]), .A2(a[7]), .B1(b[7]), .B2(a[7]), .O(n124) );
  INV1S U16 ( .I(n126), .O(n66) );
  MOAI1S U17 ( .A1(a[7]), .A2(a[6]), .B1(a[7]), .B2(a[6]), .O(n125) );
  NR2 U18 ( .I1(n66), .I2(n125), .O(n53) );
  INV1S U19 ( .I(a[7]), .O(n35) );
  MOAI1S U20 ( .A1(b[6]), .A2(n35), .B1(b[6]), .B2(n35), .O(n900) );
  MOAI1S U21 ( .A1(n126), .A2(n124), .B1(n53), .B2(n900), .O(intadd_22_A_11_)
         );
  INV1S U22 ( .I(b[2]), .O(n93) );
  MOAI1S U23 ( .A1(n93), .A2(a[1]), .B1(n93), .B2(a[1]), .O(n160) );
  INV1S U24 ( .I(a[1]), .O(n127) );
  NR2 U25 ( .I1(a[0]), .I2(n127), .O(n106) );
  INV1S U26 ( .I(n106), .O(n85) );
  INV1S U27 ( .I(b[0]), .O(n51) );
  MOAI1S U28 ( .A1(a[1]), .A2(a[2]), .B1(a[1]), .B2(a[2]), .O(n34) );
  ND2S U29 ( .I1(b[1]), .I2(a[0]), .O(n200) );
  ND3S U30 ( .I1(n200), .I2(n51), .I3(a[1]), .O(n129) );
  NR2 U31 ( .I1(n300), .I2(n400), .O(intadd_22_B_0_) );
  OAI22S U32 ( .A1(n400), .A2(intadd_22_B_0_), .B1(n300), .B2(intadd_22_B_0_), 
        .O(N2) );
  INV1S U33 ( .I(b[3]), .O(n105) );
  MOAI1S U34 ( .A1(n105), .A2(a[1]), .B1(n105), .B2(a[1]), .O(n500) );
  AOI22S U35 ( .A1(a[0]), .A2(n500), .B1(n106), .B2(n93), .O(n700) );
  INV1S U36 ( .I(n34), .O(n112) );
  INV1S U37 ( .I(a[3]), .O(n114) );
  MOAI1S U38 ( .A1(n114), .A2(b[1]), .B1(n114), .B2(b[1]), .O(n108) );
  MOAI1S U39 ( .A1(a[2]), .A2(a[3]), .B1(a[2]), .B2(a[3]), .O(n24) );
  NR2 U40 ( .I1(n112), .I2(n24), .O(n109) );
  MOAI1S U41 ( .A1(n114), .A2(b[0]), .B1(n114), .B2(b[0]), .O(n600) );
  AOI22S U42 ( .A1(n112), .A2(n108), .B1(n109), .B2(n600), .O(n800) );
  NR2 U43 ( .I1(n700), .I2(n800), .O(intadd_22_A_1_) );
  OAI22S U44 ( .A1(n800), .A2(intadd_22_A_1_), .B1(n700), .B2(intadd_22_A_1_), 
        .O(intadd_22_A_0_) );
  INV1S U45 ( .I(intadd_22_A_11_), .O(intadd_22_A_10_) );
  MOAI1S U46 ( .A1(a[3]), .A2(a[4]), .B1(a[3]), .B2(a[4]), .O(n81) );
  MOAI1S U47 ( .A1(a[5]), .A2(b[7]), .B1(a[5]), .B2(b[7]), .O(n1100) );
  INV1S U48 ( .I(n81), .O(n104) );
  MOAI1S U49 ( .A1(a[5]), .A2(a[4]), .B1(a[5]), .B2(a[4]), .O(n1000) );
  NR2 U50 ( .I1(n104), .I2(n1000), .O(n97) );
  INV1S U51 ( .I(a[5]), .O(n95) );
  MOAI1S U52 ( .A1(b[6]), .A2(n95), .B1(b[6]), .B2(n95), .O(n18) );
  MOAI1S U53 ( .A1(n81), .A2(n1100), .B1(n97), .B2(n18), .O(n122) );
  INV1S U54 ( .I(n122), .O(n150) );
  INV1S U55 ( .I(b[5]), .O(n83) );
  MOAI1S U56 ( .A1(n83), .A2(a[7]), .B1(n83), .B2(a[7]), .O(n17) );
  AOI22S U57 ( .A1(n66), .A2(n900), .B1(n53), .B2(n17), .O(n140) );
  OAI22S U58 ( .A1(n81), .A2(n1100), .B1(n1000), .B2(n1100), .O(n1300) );
  INV1S U59 ( .I(n1200), .O(intadd_22_B_10_) );
  FA1S U60 ( .A(n150), .B(n140), .CI(n1300), .CO(n1200), .S(n161) );
  INV1S U61 ( .I(n161), .O(intadd_22_A_9_) );
  MOAI1S U62 ( .A1(b[4]), .A2(n35), .B1(b[4]), .B2(n35), .O(n19) );
  AOI22S U63 ( .A1(n66), .A2(n17), .B1(n53), .B2(n19), .O(n121) );
  MOAI1S U64 ( .A1(a[3]), .A2(b[7]), .B1(a[3]), .B2(b[7]), .O(n25) );
  INV1S U65 ( .I(n109), .O(n113) );
  MOAI1S U66 ( .A1(a[3]), .A2(b[6]), .B1(a[3]), .B2(b[6]), .O(n33) );
  OAI22S U67 ( .A1(n34), .A2(n25), .B1(n113), .B2(n33), .O(n42) );
  INV1S U68 ( .I(n42), .O(n23) );
  MOAI1S U69 ( .A1(n83), .A2(a[5]), .B1(n83), .B2(a[5]), .O(n26) );
  AOI22S U70 ( .A1(n104), .A2(n18), .B1(n97), .B2(n26), .O(n22) );
  MOAI1S U71 ( .A1(n105), .A2(a[7]), .B1(n105), .B2(a[7]), .O(n27) );
  AOI22S U72 ( .A1(n66), .A2(n19), .B1(n53), .B2(n27), .O(n21) );
  INV1S U73 ( .I(n201), .O(intadd_22_B_9_) );
  FA1S U74 ( .A(n23), .B(n22), .CI(n21), .CO(n1201), .S(n31) );
  OAI22S U75 ( .A1(n34), .A2(n25), .B1(n24), .B2(n25), .O(n301) );
  MOAI1S U76 ( .A1(b[4]), .A2(n95), .B1(b[4]), .B2(n95), .O(n37) );
  AOI22S U77 ( .A1(n104), .A2(n26), .B1(n97), .B2(n37), .O(n41) );
  AOI22S U78 ( .A1(n93), .A2(n35), .B1(b[2]), .B2(a[7]), .O(n36) );
  AOI22S U79 ( .A1(n66), .A2(n27), .B1(n53), .B2(n36), .O(n401) );
  INV1S U80 ( .I(n28), .O(intadd_22_A_8_) );
  FA1S U81 ( .A(n31), .B(n301), .CI(n29), .CO(n28), .S(n32) );
  INV1S U82 ( .I(n32), .O(intadd_22_A_7_) );
  MOAI1S U83 ( .A1(n83), .A2(a[3]), .B1(n83), .B2(a[3]), .O(n501) );
  MOAI1S U84 ( .A1(n34), .A2(n33), .B1(n109), .B2(n501), .O(n49) );
  MOAI1S U85 ( .A1(n35), .A2(b[1]), .B1(n35), .B2(b[1]), .O(n54) );
  NR2 U86 ( .I1(n49), .I2(n47), .O(n48) );
  MOAI1S U87 ( .A1(n105), .A2(a[5]), .B1(n105), .B2(a[5]), .O(n55) );
  AOI22S U88 ( .A1(n104), .A2(n37), .B1(n97), .B2(n55), .O(n58) );
  MOAI1S U89 ( .A1(b[7]), .A2(n127), .B1(b[7]), .B2(n127), .O(n39) );
  NR2 U90 ( .I1(n126), .I2(b[0]), .O(n38) );
  MOAI1S U91 ( .A1(b[6]), .A2(n85), .B1(a[0]), .B2(n39), .O(n64) );
  FA1S U92 ( .A(n42), .B(n41), .CI(n401), .CO(n29), .S(n44) );
  INV1S U93 ( .I(n43), .O(intadd_22_B_7_) );
  FA1S U94 ( .A(n48), .B(n45), .CI(n44), .CO(n43), .S(n46) );
  INV1S U95 ( .I(n46), .O(intadd_22_A_6_) );
  OAI22S U96 ( .A1(n49), .A2(n48), .B1(n47), .B2(n48), .O(n62) );
  MOAI1S U97 ( .A1(b[4]), .A2(n114), .B1(b[4]), .B2(n114), .O(n68) );
  AOI22S U98 ( .A1(n112), .A2(n501), .B1(n109), .B2(n68), .O(n71) );
  MOAI1S U99 ( .A1(n51), .A2(a[7]), .B1(n51), .B2(a[7]), .O(n52) );
  AOI22S U100 ( .A1(n66), .A2(n54), .B1(n53), .B2(n52), .O(n701) );
  MOAI1S U101 ( .A1(n95), .A2(b[2]), .B1(n95), .B2(b[2]), .O(n77) );
  AOI22S U102 ( .A1(n104), .A2(n55), .B1(n97), .B2(n77), .O(n69) );
  FA1S U103 ( .A(n58), .B(n57), .CI(n56), .CO(n45), .S(n601) );
  INV1S U104 ( .I(n59), .O(intadd_22_B_6_) );
  FA1S U105 ( .A(n62), .B(n61), .CI(n601), .CO(n59), .S(n63) );
  INV1S U106 ( .I(n63), .O(intadd_22_A_5_) );
  MOAI1S U107 ( .A1(n65), .A2(n64), .B1(n65), .B2(n64), .O(n75) );
  MOAI1S U108 ( .A1(b[6]), .A2(n127), .B1(b[6]), .B2(n127), .O(n67) );
  AOI22S U109 ( .A1(a[0]), .A2(n67), .B1(n106), .B2(n83), .O(n79) );
  MOAI1S U110 ( .A1(n105), .A2(a[3]), .B1(n105), .B2(a[3]), .O(n94) );
  AOI22S U111 ( .A1(n112), .A2(n68), .B1(n109), .B2(n94), .O(n78) );
  FA1S U112 ( .A(n71), .B(n701), .CI(n69), .CO(n61), .S(n73) );
  INV1S U113 ( .I(n72), .O(intadd_22_B_5_) );
  FA1S U114 ( .A(n75), .B(n74), .CI(n73), .CO(n72), .S(n76) );
  INV1S U115 ( .I(n76), .O(intadd_22_A_4_) );
  MOAI1S U116 ( .A1(n95), .A2(b[1]), .B1(n95), .B2(b[1]), .O(n98) );
  AOI22S U117 ( .A1(n104), .A2(n77), .B1(n97), .B2(n98), .O(n89) );
  FA1S U118 ( .A(n801), .B(n79), .CI(n78), .CO(n74), .S(n88) );
  NR2 U119 ( .I1(n81), .I2(b[0]), .O(n82) );
  MOAI1S U120 ( .A1(n83), .A2(a[1]), .B1(n83), .B2(a[1]), .O(n84) );
  MOAI1S U121 ( .A1(b[4]), .A2(n85), .B1(a[0]), .B2(n84), .O(n91) );
  INV1S U122 ( .I(n86), .O(intadd_22_B_4_) );
  FA1S U123 ( .A(n89), .B(n88), .CI(n87), .CO(n86), .S(n901) );
  INV1S U124 ( .I(n901), .O(intadd_22_A_3_) );
  MOAI1S U125 ( .A1(n92), .A2(n91), .B1(n92), .B2(n91), .O(n102) );
  MOAI1S U126 ( .A1(n93), .A2(a[3]), .B1(n93), .B2(a[3]), .O(n1101) );
  AOI22S U127 ( .A1(n112), .A2(n94), .B1(n109), .B2(n1101), .O(n101) );
  MOAI1S U128 ( .A1(n95), .A2(b[0]), .B1(n95), .B2(b[0]), .O(n96) );
  AOI22S U129 ( .A1(n104), .A2(n98), .B1(n97), .B2(n96), .O(n1001) );
  INV1S U130 ( .I(n99), .O(intadd_22_B_3_) );
  FA1S U131 ( .A(n102), .B(n101), .CI(n1001), .CO(n99), .S(n103) );
  INV1S U132 ( .I(n103), .O(intadd_22_A_2_) );
  MOAI1S U133 ( .A1(b[4]), .A2(n127), .B1(b[4]), .B2(n127), .O(n107) );
  AOI22S U134 ( .A1(a[0]), .A2(n107), .B1(n106), .B2(n105), .O(n117) );
  AOI22S U135 ( .A1(n112), .A2(n1101), .B1(n109), .B2(n108), .O(n116) );
  INV1S U136 ( .I(n111), .O(intadd_22_B_2_) );
  ND2S U137 ( .I1(a[3]), .I2(n112), .O(n115) );
  OAI22S U138 ( .A1(n115), .A2(b[0]), .B1(n114), .B2(n113), .O(intadd_22_CI)
         );
  FA1S U139 ( .A(n118), .B(n117), .CI(n116), .CO(n111), .S(n119) );
  INV1S U140 ( .I(n119), .O(intadd_22_B_1_) );
  FA1S U141 ( .A(n122), .B(n121), .CI(n1201), .CO(n201), .S(n123) );
  INV1S U142 ( .I(n123), .O(intadd_22_B_8_) );
  AO12S U143 ( .B1(n126), .B2(n125), .A1(n124), .O(intadd_22_B_11_) );
  NR2 U144 ( .I1(n132), .I2(n127), .O(n131) );
  MOAI1S U145 ( .A1(b[1]), .A2(n127), .B1(b[1]), .B2(n127), .O(n128) );
  AN2S U146 ( .I1(n128), .I2(a[0]), .O(n1301) );
  OA12S U147 ( .B1(n131), .B2(n1301), .A1(n129), .O(N1) );
  INV1S U148 ( .I(intadd_22_n1), .O(N15) );
endmodule


module MULTIPLIER_1 ( clk, rst_n, a, b, o );
  input [7:0] a;
  input [7:0] b;
  output [15:0] o;
  input clk, rst_n;
  wire   N1, N2, N3, N4, N5, N6, N7, N8, N9, N10, N11, N12, N13, N14, N15,
         intadd_21_A_11_, intadd_21_A_10_, intadd_21_A_9_, intadd_21_A_8_,
         intadd_21_A_7_, intadd_21_A_6_, intadd_21_A_5_, intadd_21_A_4_,
         intadd_21_A_3_, intadd_21_A_2_, intadd_21_A_1_, intadd_21_A_0_,
         intadd_21_B_11_, intadd_21_B_10_, intadd_21_B_9_, intadd_21_B_8_,
         intadd_21_B_7_, intadd_21_B_6_, intadd_21_B_5_, intadd_21_B_4_,
         intadd_21_B_3_, intadd_21_B_2_, intadd_21_B_1_, intadd_21_B_0_,
         intadd_21_CI, intadd_21_n12, intadd_21_n11, intadd_21_n10,
         intadd_21_n9, intadd_21_n8, intadd_21_n7, intadd_21_n6, intadd_21_n5,
         intadd_21_n4, intadd_21_n3, intadd_21_n2, intadd_21_n1, n200, n300,
         n400, n500, n600, n700, n800, n900, n1000, n1100, n1200, n1300, n140,
         n150, n16, n17, n18, n19, n201, n21, n22, n23, n24, n25, n26, n27,
         n28, n29, n301, n31, n32, n33, n34, n35, n36, n37, n38, n39, n401,
         n41, n42, n43, n44, n45, n46, n47, n48, n49, n501, n51, n52, n53, n54,
         n55, n56, n57, n58, n59, n601, n61, n62, n63, n64, n65, n66, n67, n68,
         n69, n701, n71, n72, n73, n74, n75, n76, n77, n78, n79, n801, n81,
         n82, n83, n84, n85, n86, n87, n88, n89, n901, n91, n92, n93, n94, n95,
         n96, n97, n98, n99, n1001, n101, n102, n103, n104, n105, n106, n107,
         n108, n109, n1101, n111, n112, n113, n114, n115, n116, n117, n118,
         n119, n1201, n121, n122, n123, n124, n125, n126, n127, n128, n129,
         n1301, n131, n132, n133;

  QDFFS o_reg_15_ ( .D(N15), .CK(clk), .Q(o[15]) );
  QDFFS o_reg_14_ ( .D(N14), .CK(clk), .Q(o[14]) );
  QDFFS o_reg_13_ ( .D(N13), .CK(clk), .Q(o[13]) );
  QDFFS o_reg_12_ ( .D(N12), .CK(clk), .Q(o[12]) );
  QDFFS o_reg_11_ ( .D(N11), .CK(clk), .Q(o[11]) );
  QDFFS o_reg_10_ ( .D(N10), .CK(clk), .Q(o[10]) );
  QDFFS o_reg_9_ ( .D(N9), .CK(clk), .Q(o[9]) );
  QDFFS o_reg_8_ ( .D(N8), .CK(clk), .Q(o[8]) );
  QDFFS o_reg_7_ ( .D(N7), .CK(clk), .Q(o[7]) );
  QDFFS o_reg_6_ ( .D(N6), .CK(clk), .Q(o[6]) );
  QDFFS o_reg_5_ ( .D(N5), .CK(clk), .Q(o[5]) );
  QDFFS o_reg_4_ ( .D(N4), .CK(clk), .Q(o[4]) );
  QDFFS o_reg_3_ ( .D(N3), .CK(clk), .Q(o[3]) );
  QDFFS o_reg_2_ ( .D(N2), .CK(clk), .Q(o[2]) );
  QDFFS o_reg_1_ ( .D(N1), .CK(clk), .Q(o[1]) );
  QDFFS o_reg_0_ ( .D(n133), .CK(clk), .Q(o[0]) );
  FA1S intadd_21_U13 ( .A(intadd_21_B_0_), .B(intadd_21_A_0_), .CI(
        intadd_21_CI), .CO(intadd_21_n12), .S(N3) );
  FA1S intadd_21_U12 ( .A(intadd_21_B_1_), .B(intadd_21_A_1_), .CI(
        intadd_21_n12), .CO(intadd_21_n11), .S(N4) );
  FA1S intadd_21_U11 ( .A(intadd_21_B_2_), .B(intadd_21_A_2_), .CI(
        intadd_21_n11), .CO(intadd_21_n10), .S(N5) );
  FA1S intadd_21_U10 ( .A(intadd_21_B_3_), .B(intadd_21_A_3_), .CI(
        intadd_21_n10), .CO(intadd_21_n9), .S(N6) );
  FA1S intadd_21_U9 ( .A(intadd_21_B_4_), .B(intadd_21_A_4_), .CI(intadd_21_n9), .CO(intadd_21_n8), .S(N7) );
  FA1S intadd_21_U8 ( .A(intadd_21_B_5_), .B(intadd_21_A_5_), .CI(intadd_21_n8), .CO(intadd_21_n7), .S(N8) );
  FA1S intadd_21_U7 ( .A(intadd_21_B_6_), .B(intadd_21_A_6_), .CI(intadd_21_n7), .CO(intadd_21_n6), .S(N9) );
  FA1S intadd_21_U6 ( .A(intadd_21_B_7_), .B(intadd_21_A_7_), .CI(intadd_21_n6), .CO(intadd_21_n5), .S(N10) );
  FA1S intadd_21_U5 ( .A(intadd_21_B_8_), .B(intadd_21_A_8_), .CI(intadd_21_n5), .CO(intadd_21_n4), .S(N11) );
  FA1S intadd_21_U4 ( .A(intadd_21_B_9_), .B(intadd_21_A_9_), .CI(intadd_21_n4), .CO(intadd_21_n3), .S(N12) );
  FA1S intadd_21_U3 ( .A(intadd_21_B_10_), .B(intadd_21_A_10_), .CI(
        intadd_21_n3), .CO(intadd_21_n2), .S(N13) );
  FA1S intadd_21_U2 ( .A(intadd_21_B_11_), .B(intadd_21_A_11_), .CI(
        intadd_21_n2), .CO(intadd_21_n1), .S(N14) );
  OA12S U3 ( .B1(n83), .B2(n98), .A1(a[5]), .O(n93) );
  OA12S U4 ( .B1(n39), .B2(n54), .A1(a[7]), .O(n66) );
  ND2S U5 ( .I1(b[0]), .I2(n67), .O(n81) );
  AO22S U6 ( .A1(n67), .A2(n37), .B1(n54), .B2(n55), .O(n48) );
  OA12S U7 ( .B1(a[0]), .B2(a[1]), .A1(n401), .O(n58) );
  ND2S U8 ( .I1(n66), .I2(n65), .O(n57) );
  OA12S U9 ( .B1(n52), .B2(n35), .A1(n1301), .O(n500) );
  MAOI1S U10 ( .A1(a[0]), .A2(n200), .B1(n86), .B2(b[1]), .O(n400) );
  ND2S U11 ( .I1(b[0]), .I2(n105), .O(n119) );
  ND2S U12 ( .I1(n93), .I2(n92), .O(n88) );
  ND2S U13 ( .I1(a[3]), .I2(n113), .O(n116) );
  AN2S U14 ( .I1(a[0]), .I2(b[0]), .O(n133) );
  MOAI1S U15 ( .A1(a[5]), .A2(a[6]), .B1(a[5]), .B2(a[6]), .O(n127) );
  MOAI1S U16 ( .A1(b[7]), .A2(a[7]), .B1(b[7]), .B2(a[7]), .O(n125) );
  INV1S U17 ( .I(n127), .O(n67) );
  MOAI1S U18 ( .A1(a[7]), .A2(a[6]), .B1(a[7]), .B2(a[6]), .O(n126) );
  NR2 U19 ( .I1(n67), .I2(n126), .O(n54) );
  INV1S U20 ( .I(a[7]), .O(n36) );
  MOAI1S U21 ( .A1(b[6]), .A2(n36), .B1(b[6]), .B2(n36), .O(n1000) );
  MOAI1S U22 ( .A1(n127), .A2(n125), .B1(n54), .B2(n1000), .O(intadd_21_A_11_)
         );
  INV1S U23 ( .I(b[2]), .O(n94) );
  MOAI1S U24 ( .A1(n94), .A2(a[1]), .B1(n94), .B2(a[1]), .O(n200) );
  INV1S U25 ( .I(a[1]), .O(n128) );
  NR2 U26 ( .I1(a[0]), .I2(n128), .O(n107) );
  INV1S U27 ( .I(n107), .O(n86) );
  INV1S U28 ( .I(b[0]), .O(n52) );
  MOAI1S U29 ( .A1(a[1]), .A2(a[2]), .B1(a[1]), .B2(a[2]), .O(n35) );
  ND2S U30 ( .I1(b[1]), .I2(a[0]), .O(n300) );
  ND3S U31 ( .I1(n300), .I2(n52), .I3(a[1]), .O(n1301) );
  NR2 U32 ( .I1(n400), .I2(n500), .O(intadd_21_B_0_) );
  OAI22S U33 ( .A1(n500), .A2(intadd_21_B_0_), .B1(n400), .B2(intadd_21_B_0_), 
        .O(N2) );
  INV1S U34 ( .I(b[3]), .O(n106) );
  MOAI1S U35 ( .A1(n106), .A2(a[1]), .B1(n106), .B2(a[1]), .O(n600) );
  AOI22S U36 ( .A1(a[0]), .A2(n600), .B1(n107), .B2(n94), .O(n800) );
  INV1S U37 ( .I(n35), .O(n113) );
  INV1S U38 ( .I(a[3]), .O(n115) );
  MOAI1S U39 ( .A1(n115), .A2(b[1]), .B1(n115), .B2(b[1]), .O(n109) );
  MOAI1S U40 ( .A1(a[2]), .A2(a[3]), .B1(a[2]), .B2(a[3]), .O(n25) );
  NR2 U41 ( .I1(n113), .I2(n25), .O(n1101) );
  MOAI1S U42 ( .A1(n115), .A2(b[0]), .B1(n115), .B2(b[0]), .O(n700) );
  AOI22S U43 ( .A1(n113), .A2(n109), .B1(n1101), .B2(n700), .O(n900) );
  NR2 U44 ( .I1(n800), .I2(n900), .O(intadd_21_A_1_) );
  OAI22S U45 ( .A1(n900), .A2(intadd_21_A_1_), .B1(n800), .B2(intadd_21_A_1_), 
        .O(intadd_21_A_0_) );
  INV1S U46 ( .I(intadd_21_A_11_), .O(intadd_21_A_10_) );
  MOAI1S U47 ( .A1(a[3]), .A2(a[4]), .B1(a[3]), .B2(a[4]), .O(n82) );
  MOAI1S U48 ( .A1(a[5]), .A2(b[7]), .B1(a[5]), .B2(b[7]), .O(n1200) );
  INV1S U49 ( .I(n82), .O(n105) );
  MOAI1S U50 ( .A1(a[5]), .A2(a[4]), .B1(a[5]), .B2(a[4]), .O(n1100) );
  NR2 U51 ( .I1(n105), .I2(n1100), .O(n98) );
  INV1S U52 ( .I(a[5]), .O(n96) );
  MOAI1S U53 ( .A1(b[6]), .A2(n96), .B1(b[6]), .B2(n96), .O(n19) );
  MOAI1S U54 ( .A1(n82), .A2(n1200), .B1(n98), .B2(n19), .O(n123) );
  INV1S U55 ( .I(n123), .O(n16) );
  INV1S U56 ( .I(b[5]), .O(n84) );
  MOAI1S U57 ( .A1(n84), .A2(a[7]), .B1(n84), .B2(a[7]), .O(n18) );
  AOI22S U58 ( .A1(n67), .A2(n1000), .B1(n54), .B2(n18), .O(n150) );
  OAI22S U59 ( .A1(n82), .A2(n1200), .B1(n1100), .B2(n1200), .O(n140) );
  INV1S U60 ( .I(n1300), .O(intadd_21_B_10_) );
  FA1S U61 ( .A(n16), .B(n150), .CI(n140), .CO(n1300), .S(n17) );
  INV1S U62 ( .I(n17), .O(intadd_21_A_9_) );
  MOAI1S U63 ( .A1(b[4]), .A2(n36), .B1(b[4]), .B2(n36), .O(n201) );
  AOI22S U64 ( .A1(n67), .A2(n18), .B1(n54), .B2(n201), .O(n122) );
  MOAI1S U65 ( .A1(a[3]), .A2(b[7]), .B1(a[3]), .B2(b[7]), .O(n26) );
  INV1S U66 ( .I(n1101), .O(n114) );
  MOAI1S U67 ( .A1(a[3]), .A2(b[6]), .B1(a[3]), .B2(b[6]), .O(n34) );
  OAI22S U68 ( .A1(n35), .A2(n26), .B1(n114), .B2(n34), .O(n43) );
  INV1S U69 ( .I(n43), .O(n24) );
  MOAI1S U70 ( .A1(n84), .A2(a[5]), .B1(n84), .B2(a[5]), .O(n27) );
  AOI22S U71 ( .A1(n105), .A2(n19), .B1(n98), .B2(n27), .O(n23) );
  MOAI1S U72 ( .A1(n106), .A2(a[7]), .B1(n106), .B2(a[7]), .O(n28) );
  AOI22S U73 ( .A1(n67), .A2(n201), .B1(n54), .B2(n28), .O(n22) );
  INV1S U74 ( .I(n21), .O(intadd_21_B_9_) );
  FA1S U75 ( .A(n24), .B(n23), .CI(n22), .CO(n121), .S(n32) );
  OAI22S U76 ( .A1(n35), .A2(n26), .B1(n25), .B2(n26), .O(n31) );
  MOAI1S U77 ( .A1(b[4]), .A2(n96), .B1(b[4]), .B2(n96), .O(n38) );
  AOI22S U78 ( .A1(n105), .A2(n27), .B1(n98), .B2(n38), .O(n42) );
  AOI22S U79 ( .A1(n94), .A2(n36), .B1(b[2]), .B2(a[7]), .O(n37) );
  AOI22S U80 ( .A1(n67), .A2(n28), .B1(n54), .B2(n37), .O(n41) );
  INV1S U81 ( .I(n29), .O(intadd_21_A_8_) );
  FA1S U82 ( .A(n32), .B(n31), .CI(n301), .CO(n29), .S(n33) );
  INV1S U83 ( .I(n33), .O(intadd_21_A_7_) );
  MOAI1S U84 ( .A1(n84), .A2(a[3]), .B1(n84), .B2(a[3]), .O(n51) );
  MOAI1S U85 ( .A1(n35), .A2(n34), .B1(n1101), .B2(n51), .O(n501) );
  MOAI1S U86 ( .A1(n36), .A2(b[1]), .B1(n36), .B2(b[1]), .O(n55) );
  NR2 U87 ( .I1(n501), .I2(n48), .O(n49) );
  MOAI1S U88 ( .A1(n106), .A2(a[5]), .B1(n106), .B2(a[5]), .O(n56) );
  AOI22S U89 ( .A1(n105), .A2(n38), .B1(n98), .B2(n56), .O(n59) );
  MOAI1S U90 ( .A1(b[7]), .A2(n128), .B1(b[7]), .B2(n128), .O(n401) );
  NR2 U91 ( .I1(n127), .I2(b[0]), .O(n39) );
  MOAI1S U92 ( .A1(b[6]), .A2(n86), .B1(a[0]), .B2(n401), .O(n65) );
  FA1S U93 ( .A(n43), .B(n42), .CI(n41), .CO(n301), .S(n45) );
  INV1S U94 ( .I(n44), .O(intadd_21_B_7_) );
  FA1S U95 ( .A(n49), .B(n46), .CI(n45), .CO(n44), .S(n47) );
  INV1S U96 ( .I(n47), .O(intadd_21_A_6_) );
  OAI22S U97 ( .A1(n501), .A2(n49), .B1(n48), .B2(n49), .O(n63) );
  MOAI1S U98 ( .A1(b[4]), .A2(n115), .B1(b[4]), .B2(n115), .O(n69) );
  AOI22S U99 ( .A1(n113), .A2(n51), .B1(n1101), .B2(n69), .O(n72) );
  MOAI1S U100 ( .A1(n52), .A2(a[7]), .B1(n52), .B2(a[7]), .O(n53) );
  AOI22S U101 ( .A1(n67), .A2(n55), .B1(n54), .B2(n53), .O(n71) );
  MOAI1S U102 ( .A1(n96), .A2(b[2]), .B1(n96), .B2(b[2]), .O(n78) );
  AOI22S U103 ( .A1(n105), .A2(n56), .B1(n98), .B2(n78), .O(n701) );
  FA1S U104 ( .A(n59), .B(n58), .CI(n57), .CO(n46), .S(n61) );
  INV1S U105 ( .I(n601), .O(intadd_21_B_6_) );
  FA1S U106 ( .A(n63), .B(n62), .CI(n61), .CO(n601), .S(n64) );
  INV1S U107 ( .I(n64), .O(intadd_21_A_5_) );
  MOAI1S U108 ( .A1(n66), .A2(n65), .B1(n66), .B2(n65), .O(n76) );
  MOAI1S U109 ( .A1(b[6]), .A2(n128), .B1(b[6]), .B2(n128), .O(n68) );
  AOI22S U110 ( .A1(a[0]), .A2(n68), .B1(n107), .B2(n84), .O(n801) );
  MOAI1S U111 ( .A1(n106), .A2(a[3]), .B1(n106), .B2(a[3]), .O(n95) );
  AOI22S U112 ( .A1(n113), .A2(n69), .B1(n1101), .B2(n95), .O(n79) );
  FA1S U113 ( .A(n72), .B(n71), .CI(n701), .CO(n62), .S(n74) );
  INV1S U114 ( .I(n73), .O(intadd_21_B_5_) );
  FA1S U115 ( .A(n76), .B(n75), .CI(n74), .CO(n73), .S(n77) );
  INV1S U116 ( .I(n77), .O(intadd_21_A_4_) );
  MOAI1S U117 ( .A1(n96), .A2(b[1]), .B1(n96), .B2(b[1]), .O(n99) );
  AOI22S U118 ( .A1(n105), .A2(n78), .B1(n98), .B2(n99), .O(n901) );
  FA1S U119 ( .A(n81), .B(n801), .CI(n79), .CO(n75), .S(n89) );
  NR2 U120 ( .I1(n82), .I2(b[0]), .O(n83) );
  MOAI1S U121 ( .A1(n84), .A2(a[1]), .B1(n84), .B2(a[1]), .O(n85) );
  MOAI1S U122 ( .A1(b[4]), .A2(n86), .B1(a[0]), .B2(n85), .O(n92) );
  INV1S U123 ( .I(n87), .O(intadd_21_B_4_) );
  FA1S U124 ( .A(n901), .B(n89), .CI(n88), .CO(n87), .S(n91) );
  INV1S U125 ( .I(n91), .O(intadd_21_A_3_) );
  MOAI1S U126 ( .A1(n93), .A2(n92), .B1(n93), .B2(n92), .O(n103) );
  MOAI1S U127 ( .A1(n94), .A2(a[3]), .B1(n94), .B2(a[3]), .O(n111) );
  AOI22S U128 ( .A1(n113), .A2(n95), .B1(n1101), .B2(n111), .O(n102) );
  MOAI1S U129 ( .A1(n96), .A2(b[0]), .B1(n96), .B2(b[0]), .O(n97) );
  AOI22S U130 ( .A1(n105), .A2(n99), .B1(n98), .B2(n97), .O(n101) );
  INV1S U131 ( .I(n1001), .O(intadd_21_B_3_) );
  FA1S U132 ( .A(n103), .B(n102), .CI(n101), .CO(n1001), .S(n104) );
  INV1S U133 ( .I(n104), .O(intadd_21_A_2_) );
  MOAI1S U134 ( .A1(b[4]), .A2(n128), .B1(b[4]), .B2(n128), .O(n108) );
  AOI22S U135 ( .A1(a[0]), .A2(n108), .B1(n107), .B2(n106), .O(n118) );
  AOI22S U136 ( .A1(n113), .A2(n111), .B1(n1101), .B2(n109), .O(n117) );
  INV1S U137 ( .I(n112), .O(intadd_21_B_2_) );
  OAI22S U138 ( .A1(n116), .A2(b[0]), .B1(n115), .B2(n114), .O(intadd_21_CI)
         );
  FA1S U139 ( .A(n119), .B(n118), .CI(n117), .CO(n112), .S(n1201) );
  INV1S U140 ( .I(n1201), .O(intadd_21_B_1_) );
  FA1S U141 ( .A(n123), .B(n122), .CI(n121), .CO(n21), .S(n124) );
  INV1S U142 ( .I(n124), .O(intadd_21_B_8_) );
  AO12S U143 ( .B1(n127), .B2(n126), .A1(n125), .O(intadd_21_B_11_) );
  NR2 U144 ( .I1(n133), .I2(n128), .O(n132) );
  MOAI1S U145 ( .A1(b[1]), .A2(n128), .B1(b[1]), .B2(n128), .O(n129) );
  AN2S U146 ( .I1(n129), .I2(a[0]), .O(n131) );
  OA12S U147 ( .B1(n132), .B2(n131), .A1(n1301), .O(N1) );
  INV1S U148 ( .I(intadd_21_n1), .O(N15) );
endmodule


module MULTIPLIER_0 ( clk, rst_n, a, b, o );
  input [7:0] a;
  input [7:0] b;
  output [15:0] o;
  input clk, rst_n;
  wire   N1, N2, N3, N4, N5, N6, N7, N8, N9, N10, N11, N12, N13, N14, N15,
         intadd_20_A_11_, intadd_20_A_10_, intadd_20_A_9_, intadd_20_A_8_,
         intadd_20_A_7_, intadd_20_A_6_, intadd_20_A_5_, intadd_20_A_4_,
         intadd_20_A_3_, intadd_20_A_2_, intadd_20_A_1_, intadd_20_A_0_,
         intadd_20_B_11_, intadd_20_B_10_, intadd_20_B_9_, intadd_20_B_8_,
         intadd_20_B_7_, intadd_20_B_6_, intadd_20_B_5_, intadd_20_B_4_,
         intadd_20_B_3_, intadd_20_B_2_, intadd_20_B_1_, intadd_20_B_0_,
         intadd_20_CI, intadd_20_n12, intadd_20_n11, intadd_20_n10,
         intadd_20_n9, intadd_20_n8, intadd_20_n7, intadd_20_n6, intadd_20_n5,
         intadd_20_n4, intadd_20_n3, intadd_20_n2, intadd_20_n1, n160, n200,
         n300, n400, n500, n600, n700, n800, n900, n1000, n1100, n1200, n1300,
         n140, n150, n161, n17, n18, n19, n201, n21, n22, n23, n24, n25, n26,
         n27, n28, n29, n301, n31, n32, n33, n34, n35, n36, n37, n38, n39,
         n401, n41, n42, n43, n44, n45, n46, n47, n48, n49, n501, n51, n52,
         n53, n54, n55, n56, n57, n58, n59, n601, n61, n62, n63, n64, n65, n66,
         n67, n68, n69, n701, n71, n72, n73, n74, n75, n76, n77, n78, n79,
         n801, n81, n82, n83, n84, n85, n86, n87, n88, n89, n901, n91, n92,
         n93, n94, n95, n96, n97, n98, n99, n1001, n101, n102, n103, n104,
         n105, n106, n107, n108, n109, n1101, n111, n112, n113, n114, n115,
         n116, n117, n118, n119, n1201, n121, n122, n123, n124, n125, n126,
         n127, n128, n129, n1301, n131, n132, n133;

  QDFFS o_reg_15_ ( .D(N15), .CK(clk), .Q(o[15]) );
  QDFFS o_reg_14_ ( .D(N14), .CK(clk), .Q(o[14]) );
  QDFFS o_reg_13_ ( .D(N13), .CK(clk), .Q(o[13]) );
  QDFFS o_reg_12_ ( .D(N12), .CK(clk), .Q(o[12]) );
  QDFFS o_reg_11_ ( .D(N11), .CK(clk), .Q(o[11]) );
  QDFFS o_reg_10_ ( .D(N10), .CK(clk), .Q(o[10]) );
  QDFFS o_reg_9_ ( .D(N9), .CK(clk), .Q(o[9]) );
  QDFFS o_reg_8_ ( .D(N8), .CK(clk), .Q(o[8]) );
  QDFFS o_reg_7_ ( .D(N7), .CK(clk), .Q(o[7]) );
  QDFFS o_reg_6_ ( .D(N6), .CK(clk), .Q(o[6]) );
  QDFFS o_reg_5_ ( .D(N5), .CK(clk), .Q(o[5]) );
  QDFFS o_reg_4_ ( .D(N4), .CK(clk), .Q(o[4]) );
  QDFFS o_reg_3_ ( .D(N3), .CK(clk), .Q(o[3]) );
  QDFFS o_reg_2_ ( .D(N2), .CK(clk), .Q(o[2]) );
  QDFFS o_reg_1_ ( .D(N1), .CK(clk), .Q(o[1]) );
  QDFFS o_reg_0_ ( .D(n133), .CK(clk), .Q(o[0]) );
  FA1S intadd_20_U13 ( .A(intadd_20_B_0_), .B(intadd_20_A_0_), .CI(
        intadd_20_CI), .CO(intadd_20_n12), .S(N3) );
  FA1S intadd_20_U12 ( .A(intadd_20_B_1_), .B(intadd_20_A_1_), .CI(
        intadd_20_n12), .CO(intadd_20_n11), .S(N4) );
  FA1S intadd_20_U11 ( .A(intadd_20_B_2_), .B(intadd_20_A_2_), .CI(
        intadd_20_n11), .CO(intadd_20_n10), .S(N5) );
  FA1S intadd_20_U10 ( .A(intadd_20_B_3_), .B(intadd_20_A_3_), .CI(
        intadd_20_n10), .CO(intadd_20_n9), .S(N6) );
  FA1S intadd_20_U9 ( .A(intadd_20_B_4_), .B(intadd_20_A_4_), .CI(intadd_20_n9), .CO(intadd_20_n8), .S(N7) );
  FA1S intadd_20_U8 ( .A(intadd_20_B_5_), .B(intadd_20_A_5_), .CI(intadd_20_n8), .CO(intadd_20_n7), .S(N8) );
  FA1S intadd_20_U7 ( .A(intadd_20_B_6_), .B(intadd_20_A_6_), .CI(intadd_20_n7), .CO(intadd_20_n6), .S(N9) );
  FA1S intadd_20_U6 ( .A(intadd_20_B_7_), .B(intadd_20_A_7_), .CI(intadd_20_n6), .CO(intadd_20_n5), .S(N10) );
  FA1S intadd_20_U5 ( .A(intadd_20_B_8_), .B(intadd_20_A_8_), .CI(intadd_20_n5), .CO(intadd_20_n4), .S(N11) );
  FA1S intadd_20_U4 ( .A(intadd_20_B_9_), .B(intadd_20_A_9_), .CI(intadd_20_n4), .CO(intadd_20_n3), .S(N12) );
  FA1S intadd_20_U3 ( .A(intadd_20_B_10_), .B(intadd_20_A_10_), .CI(
        intadd_20_n3), .CO(intadd_20_n2), .S(N13) );
  FA1S intadd_20_U2 ( .A(intadd_20_B_11_), .B(intadd_20_A_11_), .CI(
        intadd_20_n2), .CO(intadd_20_n1), .S(N14) );
  ND2S U3 ( .I1(b[0]), .I2(n66), .O(n801) );
  OA12S U4 ( .B1(n82), .B2(n97), .A1(a[5]), .O(n92) );
  OA12S U5 ( .B1(n38), .B2(n53), .A1(a[7]), .O(n65) );
  BUF1S U6 ( .I(a[3]), .O(n113) );
  AO22S U7 ( .A1(n66), .A2(n36), .B1(n53), .B2(n54), .O(n47) );
  OA12S U8 ( .B1(a[0]), .B2(a[1]), .A1(n39), .O(n57) );
  ND2S U9 ( .I1(n65), .I2(n64), .O(n56) );
  ND3S U10 ( .I1(n200), .I2(n51), .I3(a[1]), .O(n1301) );
  OA12S U11 ( .B1(n51), .B2(n34), .A1(n1301), .O(n400) );
  MAOI1S U12 ( .A1(a[0]), .A2(n160), .B1(n85), .B2(b[1]), .O(n300) );
  ND2S U13 ( .I1(b[0]), .I2(n104), .O(n119) );
  ND2S U14 ( .I1(n92), .I2(n91), .O(n87) );
  ND2S U15 ( .I1(n113), .I2(n112), .O(n116) );
  AO12S U16 ( .B1(n127), .B2(n126), .A1(n125), .O(intadd_20_B_11_) );
  AN2S U17 ( .I1(a[0]), .I2(b[0]), .O(n133) );
  MOAI1S U18 ( .A1(a[5]), .A2(a[6]), .B1(a[5]), .B2(a[6]), .O(n127) );
  MOAI1S U19 ( .A1(b[7]), .A2(a[7]), .B1(b[7]), .B2(a[7]), .O(n125) );
  INV1S U20 ( .I(n127), .O(n66) );
  MOAI1S U21 ( .A1(a[7]), .A2(a[6]), .B1(a[7]), .B2(a[6]), .O(n126) );
  NR2 U22 ( .I1(n66), .I2(n126), .O(n53) );
  INV1S U23 ( .I(a[7]), .O(n35) );
  MOAI1S U24 ( .A1(b[6]), .A2(n35), .B1(b[6]), .B2(n35), .O(n900) );
  MOAI1S U25 ( .A1(n127), .A2(n125), .B1(n53), .B2(n900), .O(intadd_20_A_11_)
         );
  INV1S U26 ( .I(b[2]), .O(n93) );
  MOAI1S U27 ( .A1(n93), .A2(a[1]), .B1(n93), .B2(a[1]), .O(n160) );
  INV1S U28 ( .I(a[1]), .O(n128) );
  NR2 U29 ( .I1(a[0]), .I2(n128), .O(n106) );
  INV1S U30 ( .I(n106), .O(n85) );
  INV1S U31 ( .I(b[0]), .O(n51) );
  MOAI1S U32 ( .A1(a[1]), .A2(a[2]), .B1(a[1]), .B2(a[2]), .O(n34) );
  ND2S U33 ( .I1(b[1]), .I2(a[0]), .O(n200) );
  NR2 U34 ( .I1(n300), .I2(n400), .O(intadd_20_B_0_) );
  OAI22S U35 ( .A1(n400), .A2(intadd_20_B_0_), .B1(n300), .B2(intadd_20_B_0_), 
        .O(N2) );
  INV1S U36 ( .I(b[3]), .O(n105) );
  MOAI1S U37 ( .A1(n105), .A2(a[1]), .B1(n105), .B2(a[1]), .O(n500) );
  AOI22S U38 ( .A1(a[0]), .A2(n500), .B1(n106), .B2(n93), .O(n700) );
  INV1S U39 ( .I(n34), .O(n112) );
  INV1S U40 ( .I(n113), .O(n115) );
  MOAI1S U41 ( .A1(n115), .A2(b[1]), .B1(n115), .B2(b[1]), .O(n108) );
  MOAI1S U42 ( .A1(a[2]), .A2(n113), .B1(a[2]), .B2(n113), .O(n24) );
  NR2 U43 ( .I1(n112), .I2(n24), .O(n109) );
  MOAI1S U44 ( .A1(n115), .A2(b[0]), .B1(n115), .B2(b[0]), .O(n600) );
  AOI22S U45 ( .A1(n112), .A2(n108), .B1(n109), .B2(n600), .O(n800) );
  NR2 U46 ( .I1(n700), .I2(n800), .O(intadd_20_A_1_) );
  OAI22S U47 ( .A1(n800), .A2(intadd_20_A_1_), .B1(n700), .B2(intadd_20_A_1_), 
        .O(intadd_20_A_0_) );
  INV1S U48 ( .I(intadd_20_A_11_), .O(intadd_20_A_10_) );
  MOAI1S U49 ( .A1(n113), .A2(a[4]), .B1(n113), .B2(a[4]), .O(n81) );
  MOAI1S U50 ( .A1(a[5]), .A2(b[7]), .B1(a[5]), .B2(b[7]), .O(n1100) );
  INV1S U51 ( .I(n81), .O(n104) );
  MOAI1S U52 ( .A1(a[5]), .A2(a[4]), .B1(a[5]), .B2(a[4]), .O(n1000) );
  NR2 U53 ( .I1(n104), .I2(n1000), .O(n97) );
  INV1S U54 ( .I(a[5]), .O(n95) );
  MOAI1S U55 ( .A1(b[6]), .A2(n95), .B1(b[6]), .B2(n95), .O(n18) );
  MOAI1S U56 ( .A1(n81), .A2(n1100), .B1(n97), .B2(n18), .O(n123) );
  INV1S U57 ( .I(n123), .O(n150) );
  INV1S U58 ( .I(b[5]), .O(n83) );
  MOAI1S U59 ( .A1(n83), .A2(a[7]), .B1(n83), .B2(a[7]), .O(n17) );
  AOI22S U60 ( .A1(n66), .A2(n900), .B1(n53), .B2(n17), .O(n140) );
  OAI22S U61 ( .A1(n81), .A2(n1100), .B1(n1000), .B2(n1100), .O(n1300) );
  INV1S U62 ( .I(n1200), .O(intadd_20_B_10_) );
  FA1S U63 ( .A(n150), .B(n140), .CI(n1300), .CO(n1200), .S(n161) );
  INV1S U64 ( .I(n161), .O(intadd_20_A_9_) );
  MOAI1S U65 ( .A1(b[4]), .A2(n35), .B1(b[4]), .B2(n35), .O(n19) );
  AOI22S U66 ( .A1(n66), .A2(n17), .B1(n53), .B2(n19), .O(n122) );
  MOAI1S U67 ( .A1(n113), .A2(b[7]), .B1(n113), .B2(b[7]), .O(n25) );
  INV1S U68 ( .I(n109), .O(n114) );
  MOAI1S U69 ( .A1(n113), .A2(b[6]), .B1(n113), .B2(b[6]), .O(n33) );
  OAI22S U70 ( .A1(n34), .A2(n25), .B1(n114), .B2(n33), .O(n42) );
  INV1S U71 ( .I(n42), .O(n23) );
  MOAI1S U72 ( .A1(n83), .A2(a[5]), .B1(n83), .B2(a[5]), .O(n26) );
  AOI22S U73 ( .A1(n104), .A2(n18), .B1(n97), .B2(n26), .O(n22) );
  MOAI1S U74 ( .A1(n105), .A2(a[7]), .B1(n105), .B2(a[7]), .O(n27) );
  AOI22S U75 ( .A1(n66), .A2(n19), .B1(n53), .B2(n27), .O(n21) );
  INV1S U76 ( .I(n201), .O(intadd_20_B_9_) );
  FA1S U77 ( .A(n23), .B(n22), .CI(n21), .CO(n121), .S(n31) );
  OAI22S U78 ( .A1(n34), .A2(n25), .B1(n24), .B2(n25), .O(n301) );
  MOAI1S U79 ( .A1(b[4]), .A2(n95), .B1(b[4]), .B2(n95), .O(n37) );
  AOI22S U80 ( .A1(n104), .A2(n26), .B1(n97), .B2(n37), .O(n41) );
  AOI22S U81 ( .A1(n93), .A2(n35), .B1(b[2]), .B2(a[7]), .O(n36) );
  AOI22S U82 ( .A1(n66), .A2(n27), .B1(n53), .B2(n36), .O(n401) );
  INV1S U83 ( .I(n28), .O(intadd_20_A_8_) );
  FA1S U84 ( .A(n31), .B(n301), .CI(n29), .CO(n28), .S(n32) );
  INV1S U85 ( .I(n32), .O(intadd_20_A_7_) );
  MOAI1S U86 ( .A1(n83), .A2(n113), .B1(n83), .B2(n113), .O(n501) );
  MOAI1S U87 ( .A1(n34), .A2(n33), .B1(n109), .B2(n501), .O(n49) );
  MOAI1S U88 ( .A1(n35), .A2(b[1]), .B1(n35), .B2(b[1]), .O(n54) );
  NR2 U89 ( .I1(n49), .I2(n47), .O(n48) );
  MOAI1S U90 ( .A1(n105), .A2(a[5]), .B1(n105), .B2(a[5]), .O(n55) );
  AOI22S U91 ( .A1(n104), .A2(n37), .B1(n97), .B2(n55), .O(n58) );
  MOAI1S U92 ( .A1(b[7]), .A2(n128), .B1(b[7]), .B2(n128), .O(n39) );
  NR2 U93 ( .I1(n127), .I2(b[0]), .O(n38) );
  MOAI1S U94 ( .A1(b[6]), .A2(n85), .B1(a[0]), .B2(n39), .O(n64) );
  FA1S U95 ( .A(n42), .B(n41), .CI(n401), .CO(n29), .S(n44) );
  INV1S U96 ( .I(n43), .O(intadd_20_B_7_) );
  FA1S U97 ( .A(n48), .B(n45), .CI(n44), .CO(n43), .S(n46) );
  INV1S U98 ( .I(n46), .O(intadd_20_A_6_) );
  OAI22S U99 ( .A1(n49), .A2(n48), .B1(n47), .B2(n48), .O(n62) );
  MOAI1S U100 ( .A1(b[4]), .A2(n115), .B1(b[4]), .B2(n115), .O(n68) );
  AOI22S U101 ( .A1(n112), .A2(n501), .B1(n109), .B2(n68), .O(n71) );
  MOAI1S U102 ( .A1(n51), .A2(a[7]), .B1(n51), .B2(a[7]), .O(n52) );
  AOI22S U103 ( .A1(n66), .A2(n54), .B1(n53), .B2(n52), .O(n701) );
  MOAI1S U104 ( .A1(n95), .A2(b[2]), .B1(n95), .B2(b[2]), .O(n77) );
  AOI22S U105 ( .A1(n104), .A2(n55), .B1(n97), .B2(n77), .O(n69) );
  FA1S U106 ( .A(n58), .B(n57), .CI(n56), .CO(n45), .S(n601) );
  INV1S U107 ( .I(n59), .O(intadd_20_B_6_) );
  FA1S U108 ( .A(n62), .B(n61), .CI(n601), .CO(n59), .S(n63) );
  INV1S U109 ( .I(n63), .O(intadd_20_A_5_) );
  MOAI1S U110 ( .A1(n65), .A2(n64), .B1(n65), .B2(n64), .O(n75) );
  MOAI1S U111 ( .A1(b[6]), .A2(n128), .B1(b[6]), .B2(n128), .O(n67) );
  AOI22S U112 ( .A1(a[0]), .A2(n67), .B1(n106), .B2(n83), .O(n79) );
  MOAI1S U113 ( .A1(n105), .A2(n113), .B1(n105), .B2(n113), .O(n94) );
  AOI22S U114 ( .A1(n112), .A2(n68), .B1(n109), .B2(n94), .O(n78) );
  FA1S U115 ( .A(n71), .B(n701), .CI(n69), .CO(n61), .S(n73) );
  INV1S U116 ( .I(n72), .O(intadd_20_B_5_) );
  FA1S U117 ( .A(n75), .B(n74), .CI(n73), .CO(n72), .S(n76) );
  INV1S U118 ( .I(n76), .O(intadd_20_A_4_) );
  MOAI1S U119 ( .A1(n95), .A2(b[1]), .B1(n95), .B2(b[1]), .O(n98) );
  AOI22S U120 ( .A1(n104), .A2(n77), .B1(n97), .B2(n98), .O(n89) );
  FA1S U121 ( .A(n801), .B(n79), .CI(n78), .CO(n74), .S(n88) );
  NR2 U122 ( .I1(n81), .I2(b[0]), .O(n82) );
  MOAI1S U123 ( .A1(n83), .A2(a[1]), .B1(n83), .B2(a[1]), .O(n84) );
  MOAI1S U124 ( .A1(b[4]), .A2(n85), .B1(a[0]), .B2(n84), .O(n91) );
  INV1S U125 ( .I(n86), .O(intadd_20_B_4_) );
  FA1S U126 ( .A(n89), .B(n88), .CI(n87), .CO(n86), .S(n901) );
  INV1S U127 ( .I(n901), .O(intadd_20_A_3_) );
  MOAI1S U128 ( .A1(n92), .A2(n91), .B1(n92), .B2(n91), .O(n102) );
  MOAI1S U129 ( .A1(n93), .A2(n113), .B1(n93), .B2(n113), .O(n1101) );
  AOI22S U130 ( .A1(n112), .A2(n94), .B1(n109), .B2(n1101), .O(n101) );
  MOAI1S U131 ( .A1(n95), .A2(b[0]), .B1(n95), .B2(b[0]), .O(n96) );
  AOI22S U132 ( .A1(n104), .A2(n98), .B1(n97), .B2(n96), .O(n1001) );
  INV1S U133 ( .I(n99), .O(intadd_20_B_3_) );
  FA1S U134 ( .A(n102), .B(n101), .CI(n1001), .CO(n99), .S(n103) );
  INV1S U135 ( .I(n103), .O(intadd_20_A_2_) );
  MOAI1S U136 ( .A1(b[4]), .A2(n128), .B1(b[4]), .B2(n128), .O(n107) );
  AOI22S U137 ( .A1(a[0]), .A2(n107), .B1(n106), .B2(n105), .O(n118) );
  AOI22S U138 ( .A1(n112), .A2(n1101), .B1(n109), .B2(n108), .O(n117) );
  INV1S U139 ( .I(n111), .O(intadd_20_B_2_) );
  OAI22S U140 ( .A1(n116), .A2(b[0]), .B1(n115), .B2(n114), .O(intadd_20_CI)
         );
  FA1S U141 ( .A(n119), .B(n118), .CI(n117), .CO(n111), .S(n1201) );
  INV1S U142 ( .I(n1201), .O(intadd_20_B_1_) );
  FA1S U143 ( .A(n123), .B(n122), .CI(n121), .CO(n201), .S(n124) );
  INV1S U144 ( .I(n124), .O(intadd_20_B_8_) );
  NR2 U145 ( .I1(n133), .I2(n128), .O(n132) );
  MOAI1S U146 ( .A1(b[1]), .A2(n128), .B1(b[1]), .B2(n128), .O(n129) );
  AN2S U147 ( .I1(n129), .I2(a[0]), .O(n131) );
  OA12S U148 ( .B1(n132), .B2(n131), .A1(n1301), .O(N1) );
  INV1S U149 ( .I(intadd_20_n1), .O(N15) );
endmodule


module ADDR_ADDSUB_0 ( a, b, op, o );
  input [11:0] a;
  input [11:0] b;
  output [11:0] o;
  input op;
  wire   intadd_19_A_8_, intadd_19_A_7_, intadd_19_A_6_, intadd_19_A_5_,
         intadd_19_A_4_, intadd_19_A_3_, intadd_19_A_2_, intadd_19_A_1_,
         intadd_19_A_0_, intadd_19_B_4_, intadd_19_B_3_, intadd_19_B_2_,
         intadd_19_B_1_, intadd_19_B_0_, intadd_19_CI, intadd_19_SUM_8_,
         intadd_19_SUM_7_, intadd_19_SUM_6_, intadd_19_SUM_5_,
         intadd_19_SUM_4_, intadd_19_SUM_3_, intadd_19_SUM_2_,
         intadd_19_SUM_1_, intadd_19_SUM_0_, intadd_19_n9, intadd_19_n8,
         intadd_19_n7, intadd_19_n6, intadd_19_n5, intadd_19_n4, intadd_19_n3,
         intadd_19_n2, intadd_19_n1, n8, n9, n10;

  FA1S intadd_19_U10 ( .A(intadd_19_B_0_), .B(intadd_19_A_0_), .CI(
        intadd_19_CI), .CO(intadd_19_n9), .S(intadd_19_SUM_0_) );
  FA1S intadd_19_U9 ( .A(intadd_19_B_1_), .B(intadd_19_A_1_), .CI(intadd_19_n9), .CO(intadd_19_n8), .S(intadd_19_SUM_1_) );
  FA1S intadd_19_U8 ( .A(intadd_19_B_2_), .B(intadd_19_A_2_), .CI(intadd_19_n8), .CO(intadd_19_n7), .S(intadd_19_SUM_2_) );
  FA1S intadd_19_U7 ( .A(intadd_19_B_3_), .B(intadd_19_A_3_), .CI(intadd_19_n7), .CO(intadd_19_n6), .S(intadd_19_SUM_3_) );
  FA1S intadd_19_U6 ( .A(intadd_19_A_4_), .B(intadd_19_B_4_), .CI(intadd_19_n6), .CO(intadd_19_n5), .S(intadd_19_SUM_4_) );
  FA1S intadd_19_U5 ( .A(intadd_19_A_5_), .B(intadd_19_B_4_), .CI(intadd_19_n5), .CO(intadd_19_n4), .S(intadd_19_SUM_5_) );
  FA1S intadd_19_U4 ( .A(intadd_19_A_6_), .B(intadd_19_B_4_), .CI(intadd_19_n4), .CO(intadd_19_n3), .S(intadd_19_SUM_6_) );
  FA1S intadd_19_U3 ( .A(intadd_19_A_7_), .B(intadd_19_B_4_), .CI(intadd_19_n3), .CO(intadd_19_n2), .S(intadd_19_SUM_7_) );
  FA1S intadd_19_U2 ( .A(intadd_19_A_8_), .B(intadd_19_B_4_), .CI(intadd_19_n2), .CO(intadd_19_n1), .S(intadd_19_SUM_8_) );
  BUF1S U1 ( .I(op), .O(n8) );
  INV1S U2 ( .I(n8), .O(intadd_19_B_4_) );
  INV1S U3 ( .I(a[9]), .O(intadd_19_A_8_) );
  INV1S U4 ( .I(a[8]), .O(intadd_19_A_7_) );
  INV1S U5 ( .I(a[7]), .O(intadd_19_A_6_) );
  INV1S U6 ( .I(a[6]), .O(intadd_19_A_5_) );
  INV1S U7 ( .I(a[5]), .O(intadd_19_A_4_) );
  INV1S U8 ( .I(a[4]), .O(intadd_19_A_3_) );
  MOAI1S U9 ( .A1(n8), .A2(b[4]), .B1(n8), .B2(b[4]), .O(intadd_19_B_3_) );
  INV1S U10 ( .I(a[3]), .O(intadd_19_A_2_) );
  MOAI1S U11 ( .A1(n8), .A2(b[3]), .B1(n8), .B2(b[3]), .O(intadd_19_B_2_) );
  INV1S U12 ( .I(a[2]), .O(intadd_19_A_1_) );
  MOAI1S U13 ( .A1(n8), .A2(b[2]), .B1(n8), .B2(b[2]), .O(intadd_19_B_1_) );
  INV1S U14 ( .I(a[1]), .O(intadd_19_A_0_) );
  INV1S U15 ( .I(b[0]), .O(n10) );
  MOAI1S U16 ( .A1(n10), .A2(a[0]), .B1(n10), .B2(intadd_19_B_4_), .O(
        intadd_19_B_0_) );
  MOAI1S U17 ( .A1(n8), .A2(b[1]), .B1(n8), .B2(b[1]), .O(intadd_19_CI) );
  MOAI1S U18 ( .A1(a[10]), .A2(intadd_19_n1), .B1(a[10]), .B2(intadd_19_n1), 
        .O(n9) );
  MOAI1S U19 ( .A1(intadd_19_B_4_), .A2(n9), .B1(intadd_19_B_4_), .B2(n9), .O(
        o[10]) );
  INV1S U20 ( .I(intadd_19_SUM_8_), .O(o[9]) );
  INV1S U21 ( .I(intadd_19_SUM_7_), .O(o[8]) );
  INV1S U22 ( .I(intadd_19_SUM_6_), .O(o[7]) );
  INV1S U23 ( .I(intadd_19_SUM_5_), .O(o[6]) );
  INV1S U24 ( .I(intadd_19_SUM_4_), .O(o[5]) );
  INV1S U25 ( .I(intadd_19_SUM_3_), .O(o[4]) );
  MOAI1S U26 ( .A1(a[0]), .A2(n10), .B1(a[0]), .B2(n10), .O(o[0]) );
  INV1S U27 ( .I(intadd_19_SUM_2_), .O(o[3]) );
  INV1S U28 ( .I(intadd_19_SUM_1_), .O(o[2]) );
  INV1S U29 ( .I(intadd_19_SUM_0_), .O(o[1]) );
endmodule


module INPUT_CNT_ADDER ( cnt, matrix_size, flag, cnt_next, cout );
  input [13:0] cnt;
  input [1:0] matrix_size;
  output [13:0] cnt_next;
  input flag;
  output cout;
  wire   n1, n2, n3, n4, n5, n6, n7, n8, n9, n10, n11, n12, n13, n14, n15, n16,
         n17, n18, n19, n20, n21, n22, n23;

  ND3S U3 ( .I1(cnt[0]), .I2(cnt[1]), .I3(cnt[2]), .O(n3) );
  NR2 U4 ( .I1(flag), .I2(matrix_size[1]), .O(n9) );
  INV1S U5 ( .I(n9), .O(n11) );
  NR2 U6 ( .I1(matrix_size[0]), .I2(n11), .O(n8) );
  OAI22S U7 ( .A1(cnt[3]), .A2(n8), .B1(n9), .B2(cnt[4]), .O(n1) );
  NR2 U8 ( .I1(n3), .I2(n1), .O(n21) );
  ND2S U9 ( .I1(n21), .I2(cnt[5]), .O(n20) );
  AN2B1S U10 ( .I1(cnt[6]), .B1(n20), .O(n19) );
  ND2S U11 ( .I1(n19), .I2(cnt[7]), .O(n18) );
  INV1S U12 ( .I(n18), .O(n6) );
  INV1S U13 ( .I(n8), .O(n4) );
  ND2S U14 ( .I1(n6), .I2(n4), .O(n2) );
  MOAI1S U15 ( .A1(cnt[8]), .A2(n2), .B1(cnt[8]), .B2(n2), .O(cnt_next[8]) );
  INV1S U16 ( .I(n3), .O(n12) );
  ND2S U17 ( .I1(n12), .I2(n4), .O(n5) );
  MOAI1S U18 ( .A1(cnt[3]), .A2(n5), .B1(cnt[3]), .B2(n5), .O(cnt_next[3]) );
  ND3S U19 ( .I1(n6), .I2(cnt[8]), .I3(n11), .O(n7) );
  MOAI1S U20 ( .A1(cnt[9]), .A2(n7), .B1(cnt[9]), .B2(n7), .O(cnt_next[9]) );
  OAI22S U21 ( .A1(n9), .A2(cnt[9]), .B1(n8), .B2(cnt[8]), .O(n10) );
  NR2 U22 ( .I1(n18), .I2(n10), .O(n17) );
  ND2S U23 ( .I1(n17), .I2(cnt[10]), .O(n16) );
  AN2B1S U24 ( .I1(cnt[11]), .B1(n16), .O(n15) );
  ND2S U25 ( .I1(n15), .I2(cnt[12]), .O(n14) );
  AN2B1S U26 ( .I1(cnt[13]), .B1(n14), .O(cout) );
  ND3S U27 ( .I1(cnt[3]), .I2(n12), .I3(n11), .O(n13) );
  MOAI1S U28 ( .A1(cnt[4]), .A2(n13), .B1(cnt[4]), .B2(n13), .O(cnt_next[4])
         );
  MOAI1S U29 ( .A1(cnt[6]), .A2(n20), .B1(cnt[6]), .B2(n20), .O(cnt_next[6])
         );
  MOAI1S U30 ( .A1(cnt[13]), .A2(n14), .B1(cnt[13]), .B2(n14), .O(cnt_next[13]) );
  MOAI1S U31 ( .A1(cnt[11]), .A2(n16), .B1(cnt[11]), .B2(n16), .O(cnt_next[11]) );
  OA12S U32 ( .B1(n15), .B2(cnt[12]), .A1(n14), .O(cnt_next[12]) );
  OA12S U33 ( .B1(n17), .B2(cnt[10]), .A1(n16), .O(cnt_next[10]) );
  OA12S U34 ( .B1(n19), .B2(cnt[7]), .A1(n18), .O(cnt_next[7]) );
  OA12S U35 ( .B1(n21), .B2(cnt[5]), .A1(n20), .O(cnt_next[5]) );
  ND2S U36 ( .I1(cnt[0]), .I2(cnt[1]), .O(n22) );
  MOAI1S U37 ( .A1(cnt[2]), .A2(n22), .B1(cnt[2]), .B2(n22), .O(cnt_next[2])
         );
  INV1S U38 ( .I(cnt[0]), .O(n23) );
  MOAI1S U39 ( .A1(cnt[1]), .A2(n23), .B1(cnt[1]), .B2(n23), .O(cnt_next[1])
         );
endmodule


module ADDR_ADDSUB_1 ( a, b, op, o );
  input [11:0] a;
  input [11:0] b;
  output [11:0] o;
  input op;
  wire   intadd_18_A_8_, intadd_18_A_7_, intadd_18_A_6_, intadd_18_A_5_,
         intadd_18_A_4_, intadd_18_A_3_, intadd_18_A_2_, intadd_18_A_1_,
         intadd_18_A_0_, intadd_18_B_4_, intadd_18_B_3_, intadd_18_B_2_,
         intadd_18_B_1_, intadd_18_B_0_, intadd_18_CI, intadd_18_SUM_8_,
         intadd_18_SUM_7_, intadd_18_SUM_6_, intadd_18_SUM_5_,
         intadd_18_SUM_4_, intadd_18_SUM_3_, intadd_18_SUM_2_,
         intadd_18_SUM_1_, intadd_18_SUM_0_, intadd_18_n9, intadd_18_n8,
         intadd_18_n7, intadd_18_n6, intadd_18_n5, intadd_18_n4, intadd_18_n3,
         intadd_18_n2, intadd_18_n1, n8, n9;

  FA1S intadd_18_U10 ( .A(intadd_18_B_0_), .B(intadd_18_A_0_), .CI(
        intadd_18_CI), .CO(intadd_18_n9), .S(intadd_18_SUM_0_) );
  FA1S intadd_18_U9 ( .A(intadd_18_B_1_), .B(intadd_18_A_1_), .CI(intadd_18_n9), .CO(intadd_18_n8), .S(intadd_18_SUM_1_) );
  FA1S intadd_18_U8 ( .A(intadd_18_B_2_), .B(intadd_18_A_2_), .CI(intadd_18_n8), .CO(intadd_18_n7), .S(intadd_18_SUM_2_) );
  FA1S intadd_18_U7 ( .A(intadd_18_B_3_), .B(intadd_18_A_3_), .CI(intadd_18_n7), .CO(intadd_18_n6), .S(intadd_18_SUM_3_) );
  FA1S intadd_18_U6 ( .A(intadd_18_A_4_), .B(intadd_18_B_4_), .CI(intadd_18_n6), .CO(intadd_18_n5), .S(intadd_18_SUM_4_) );
  FA1S intadd_18_U5 ( .A(intadd_18_A_5_), .B(intadd_18_B_4_), .CI(intadd_18_n5), .CO(intadd_18_n4), .S(intadd_18_SUM_5_) );
  FA1S intadd_18_U4 ( .A(intadd_18_A_6_), .B(intadd_18_B_4_), .CI(intadd_18_n4), .CO(intadd_18_n3), .S(intadd_18_SUM_6_) );
  FA1S intadd_18_U3 ( .A(intadd_18_A_7_), .B(intadd_18_B_4_), .CI(intadd_18_n3), .CO(intadd_18_n2), .S(intadd_18_SUM_7_) );
  FA1S intadd_18_U2 ( .A(intadd_18_A_8_), .B(intadd_18_B_4_), .CI(intadd_18_n2), .CO(intadd_18_n1), .S(intadd_18_SUM_8_) );
  INV1S U1 ( .I(op), .O(intadd_18_B_4_) );
  INV1S U2 ( .I(a[9]), .O(intadd_18_A_8_) );
  INV1S U3 ( .I(a[8]), .O(intadd_18_A_7_) );
  INV1S U4 ( .I(a[7]), .O(intadd_18_A_6_) );
  INV1S U5 ( .I(a[6]), .O(intadd_18_A_5_) );
  INV1S U6 ( .I(a[5]), .O(intadd_18_A_4_) );
  INV1S U7 ( .I(a[4]), .O(intadd_18_A_3_) );
  MOAI1S U8 ( .A1(op), .A2(b[4]), .B1(op), .B2(b[4]), .O(intadd_18_B_3_) );
  INV1S U9 ( .I(a[3]), .O(intadd_18_A_2_) );
  MOAI1S U10 ( .A1(op), .A2(b[3]), .B1(op), .B2(b[3]), .O(intadd_18_B_2_) );
  INV1S U11 ( .I(a[2]), .O(intadd_18_A_1_) );
  MOAI1S U12 ( .A1(op), .A2(b[2]), .B1(op), .B2(b[2]), .O(intadd_18_B_1_) );
  INV1S U13 ( .I(a[1]), .O(intadd_18_A_0_) );
  INV1S U14 ( .I(b[0]), .O(n9) );
  MOAI1S U15 ( .A1(n9), .A2(a[0]), .B1(n9), .B2(intadd_18_B_4_), .O(
        intadd_18_B_0_) );
  MOAI1S U16 ( .A1(op), .A2(b[1]), .B1(op), .B2(b[1]), .O(intadd_18_CI) );
  MOAI1S U17 ( .A1(a[10]), .A2(intadd_18_n1), .B1(a[10]), .B2(intadd_18_n1), 
        .O(n8) );
  MOAI1S U18 ( .A1(intadd_18_B_4_), .A2(n8), .B1(intadd_18_B_4_), .B2(n8), .O(
        o[10]) );
  INV1S U19 ( .I(intadd_18_SUM_8_), .O(o[9]) );
  INV1S U20 ( .I(intadd_18_SUM_7_), .O(o[8]) );
  INV1S U21 ( .I(intadd_18_SUM_6_), .O(o[7]) );
  INV1S U22 ( .I(intadd_18_SUM_5_), .O(o[6]) );
  INV1S U23 ( .I(intadd_18_SUM_4_), .O(o[5]) );
  INV1S U24 ( .I(intadd_18_SUM_3_), .O(o[4]) );
  MOAI1S U25 ( .A1(a[0]), .A2(n9), .B1(a[0]), .B2(n9), .O(o[0]) );
  INV1S U26 ( .I(intadd_18_SUM_2_), .O(o[3]) );
  INV1S U27 ( .I(intadd_18_SUM_1_), .O(o[2]) );
  INV1S U28 ( .I(intadd_18_SUM_0_), .O(o[1]) );
endmodule


module SUM6 ( clk, rst_n, a, b, c, d, e, f, o );
  input [19:0] a;
  input [19:0] b;
  input [19:0] c;
  input [19:0] d;
  input [19:0] e;
  input [19:0] f;
  output [19:0] o;
  input clk, rst_n;
  wire   intadd_2_A_18_, intadd_2_A_17_, intadd_2_A_16_, intadd_2_A_15_,
         intadd_2_A_14_, intadd_2_A_13_, intadd_2_A_12_, intadd_2_A_11_,
         intadd_2_A_10_, intadd_2_A_9_, intadd_2_A_8_, intadd_2_A_7_,
         intadd_2_A_6_, intadd_2_A_5_, intadd_2_A_4_, intadd_2_A_3_,
         intadd_2_A_2_, intadd_2_A_1_, intadd_2_B_18_, intadd_2_B_2_,
         intadd_2_B_1_, intadd_2_B_0_, intadd_2_CI, intadd_2_n19, intadd_2_n18,
         intadd_2_n17, intadd_2_n16, intadd_2_n15, intadd_2_n14, intadd_2_n13,
         intadd_2_n12, intadd_2_n11, intadd_2_n10, intadd_2_n9, intadd_2_n8,
         intadd_2_n7, intadd_2_n6, intadd_2_n5, intadd_2_n4, intadd_2_n3,
         intadd_2_n2, intadd_2_n1, intadd_3_A_2_, intadd_3_A_1_, intadd_3_B_2_,
         intadd_3_B_1_, intadd_3_SUM_1_, intadd_3_SUM_0_, intadd_3_n3,
         intadd_3_n2, intadd_3_n1, intadd_4_A_1_, intadd_4_B_1_,
         intadd_4_SUM_1_, intadd_4_SUM_0_, intadd_4_n3, intadd_4_n2,
         intadd_4_n1, intadd_5_A_1_, intadd_5_B_1_, intadd_5_SUM_1_,
         intadd_5_SUM_0_, intadd_5_n3, intadd_5_n2, intadd_5_n1, intadd_6_A_1_,
         intadd_6_B_1_, intadd_6_SUM_1_, intadd_6_SUM_0_, intadd_6_n3,
         intadd_6_n2, intadd_6_n1, intadd_7_A_1_, intadd_7_B_1_,
         intadd_7_SUM_1_, intadd_7_SUM_0_, intadd_7_n3, intadd_7_n2,
         intadd_7_n1, intadd_8_A_1_, intadd_8_B_1_, intadd_8_SUM_1_,
         intadd_8_SUM_0_, intadd_8_n3, intadd_8_n2, intadd_8_n1, intadd_9_A_1_,
         intadd_9_B_1_, intadd_9_SUM_1_, intadd_9_SUM_0_, intadd_9_n3,
         intadd_9_n2, intadd_9_n1, intadd_10_A_1_, intadd_10_B_1_,
         intadd_10_SUM_1_, intadd_10_SUM_0_, intadd_10_n3, intadd_10_n2,
         intadd_10_n1, intadd_11_A_1_, intadd_11_B_1_, intadd_11_SUM_1_,
         intadd_11_SUM_0_, intadd_11_n3, intadd_11_n2, intadd_11_n1,
         intadd_12_A_1_, intadd_12_B_1_, intadd_12_SUM_1_, intadd_12_SUM_0_,
         intadd_12_n3, intadd_12_n2, intadd_12_n1, intadd_13_A_1_,
         intadd_13_B_1_, intadd_13_SUM_1_, intadd_13_SUM_0_, intadd_13_n3,
         intadd_13_n2, intadd_13_n1, intadd_14_A_1_, intadd_14_B_1_,
         intadd_14_SUM_1_, intadd_14_SUM_0_, intadd_14_n3, intadd_14_n2,
         intadd_14_n1, intadd_15_A_1_, intadd_15_B_1_, intadd_15_SUM_1_,
         intadd_15_SUM_0_, intadd_15_n3, intadd_15_n2, intadd_15_n1,
         intadd_16_B_1_, intadd_16_SUM_0_, intadd_16_n3, intadd_16_n2,
         intadd_16_n1, intadd_17_A_2_, intadd_17_A_1_, intadd_17_n3,
         intadd_17_n2, intadd_17_n1, n1, n2, n3, n4, n5, n6, n7, n8, n9, n10,
         n11, n12, n13, n14, n15, n16, n17, n18, n19, n20, n21, n22, n23, n24,
         n25, n26, n27, n28, n29, n30, n31, n32;

  FA1S intadd_2_U20 ( .A(intadd_2_B_0_), .B(e[0]), .CI(intadd_2_CI), .CO(
        intadd_2_n19), .S(o[0]) );
  FA1S intadd_2_U19 ( .A(intadd_2_B_1_), .B(intadd_2_A_1_), .CI(intadd_2_n19), 
        .CO(intadd_2_n18), .S(o[1]) );
  FA1S intadd_2_U18 ( .A(intadd_2_B_2_), .B(intadd_2_A_2_), .CI(intadd_2_n18), 
        .CO(intadd_2_n17), .S(o[2]) );
  FA1S intadd_2_U17 ( .A(intadd_17_n1), .B(intadd_2_A_3_), .CI(intadd_2_n17), 
        .CO(intadd_2_n16), .S(o[3]) );
  FA1S intadd_2_U16 ( .A(intadd_16_n1), .B(intadd_2_A_4_), .CI(intadd_2_n16), 
        .CO(intadd_2_n15), .S(o[4]) );
  FA1S intadd_2_U15 ( .A(intadd_15_n1), .B(intadd_2_A_5_), .CI(intadd_2_n15), 
        .CO(intadd_2_n14), .S(o[5]) );
  FA1S intadd_2_U14 ( .A(intadd_14_n1), .B(intadd_2_A_6_), .CI(intadd_2_n14), 
        .CO(intadd_2_n13), .S(o[6]) );
  FA1S intadd_3_U4 ( .A(f[14]), .B(b[14]), .CI(d[14]), .CO(intadd_3_n3), .S(
        intadd_3_SUM_0_) );
  FA1S intadd_3_U3 ( .A(intadd_3_B_1_), .B(intadd_3_A_1_), .CI(intadd_3_n3), 
        .CO(intadd_3_n2), .S(intadd_3_SUM_1_) );
  FA1S intadd_3_U2 ( .A(intadd_3_B_2_), .B(intadd_3_A_2_), .CI(intadd_3_n2), 
        .CO(intadd_3_n1), .S(intadd_2_A_16_) );
  FA1S intadd_4_U4 ( .A(f[13]), .B(b[13]), .CI(d[13]), .CO(intadd_4_n3), .S(
        intadd_4_SUM_0_) );
  FA1S intadd_4_U3 ( .A(intadd_4_B_1_), .B(intadd_4_A_1_), .CI(intadd_4_n3), 
        .CO(intadd_4_n2), .S(intadd_4_SUM_1_) );
  FA1S intadd_4_U2 ( .A(intadd_3_SUM_1_), .B(intadd_3_A_2_), .CI(intadd_4_n2), 
        .CO(intadd_4_n1), .S(intadd_2_A_15_) );
  FA1S intadd_5_U4 ( .A(f[12]), .B(b[12]), .CI(d[12]), .CO(intadd_5_n3), .S(
        intadd_5_SUM_0_) );
  FA1S intadd_5_U3 ( .A(intadd_5_B_1_), .B(intadd_5_A_1_), .CI(intadd_5_n3), 
        .CO(intadd_5_n2), .S(intadd_5_SUM_1_) );
  FA1S intadd_5_U2 ( .A(intadd_3_SUM_0_), .B(intadd_4_SUM_1_), .CI(intadd_5_n2), .CO(intadd_5_n1), .S(intadd_2_A_14_) );
  FA1S intadd_6_U4 ( .A(f[11]), .B(b[11]), .CI(d[11]), .CO(intadd_6_n3), .S(
        intadd_6_SUM_0_) );
  FA1S intadd_6_U3 ( .A(intadd_6_B_1_), .B(intadd_6_A_1_), .CI(intadd_6_n3), 
        .CO(intadd_6_n2), .S(intadd_6_SUM_1_) );
  FA1S intadd_6_U2 ( .A(intadd_4_SUM_0_), .B(intadd_5_SUM_1_), .CI(intadd_6_n2), .CO(intadd_6_n1), .S(intadd_2_A_13_) );
  FA1S intadd_7_U4 ( .A(f[10]), .B(b[10]), .CI(d[10]), .CO(intadd_7_n3), .S(
        intadd_7_SUM_0_) );
  FA1S intadd_7_U3 ( .A(intadd_7_B_1_), .B(intadd_7_A_1_), .CI(intadd_7_n3), 
        .CO(intadd_7_n2), .S(intadd_7_SUM_1_) );
  FA1S intadd_7_U2 ( .A(intadd_5_SUM_0_), .B(intadd_6_SUM_1_), .CI(intadd_7_n2), .CO(intadd_7_n1), .S(intadd_2_A_12_) );
  FA1S intadd_8_U4 ( .A(f[9]), .B(b[9]), .CI(d[9]), .CO(intadd_8_n3), .S(
        intadd_8_SUM_0_) );
  FA1S intadd_8_U3 ( .A(intadd_8_B_1_), .B(intadd_8_A_1_), .CI(intadd_8_n3), 
        .CO(intadd_8_n2), .S(intadd_8_SUM_1_) );
  FA1S intadd_8_U2 ( .A(intadd_6_SUM_0_), .B(intadd_7_SUM_1_), .CI(intadd_8_n2), .CO(intadd_8_n1), .S(intadd_2_A_11_) );
  FA1S intadd_9_U4 ( .A(f[8]), .B(b[8]), .CI(d[8]), .CO(intadd_9_n3), .S(
        intadd_9_SUM_0_) );
  FA1S intadd_9_U3 ( .A(intadd_9_B_1_), .B(intadd_9_A_1_), .CI(intadd_9_n3), 
        .CO(intadd_9_n2), .S(intadd_9_SUM_1_) );
  FA1S intadd_9_U2 ( .A(intadd_7_SUM_0_), .B(intadd_8_SUM_1_), .CI(intadd_9_n2), .CO(intadd_9_n1), .S(intadd_2_A_10_) );
  FA1S intadd_10_U4 ( .A(f[7]), .B(b[7]), .CI(d[7]), .CO(intadd_10_n3), .S(
        intadd_10_SUM_0_) );
  FA1S intadd_10_U3 ( .A(intadd_10_B_1_), .B(intadd_10_A_1_), .CI(intadd_10_n3), .CO(intadd_10_n2), .S(intadd_10_SUM_1_) );
  FA1S intadd_10_U2 ( .A(intadd_8_SUM_0_), .B(intadd_9_SUM_1_), .CI(
        intadd_10_n2), .CO(intadd_10_n1), .S(intadd_2_A_9_) );
  FA1S intadd_11_U4 ( .A(f[6]), .B(b[6]), .CI(d[6]), .CO(intadd_11_n3), .S(
        intadd_11_SUM_0_) );
  FA1S intadd_11_U3 ( .A(intadd_11_B_1_), .B(intadd_11_A_1_), .CI(intadd_11_n3), .CO(intadd_11_n2), .S(intadd_11_SUM_1_) );
  FA1S intadd_11_U2 ( .A(intadd_9_SUM_0_), .B(intadd_10_SUM_1_), .CI(
        intadd_11_n2), .CO(intadd_11_n1), .S(intadd_2_A_8_) );
  FA1S intadd_12_U4 ( .A(f[5]), .B(b[5]), .CI(d[5]), .CO(intadd_12_n3), .S(
        intadd_12_SUM_0_) );
  FA1S intadd_12_U3 ( .A(intadd_12_B_1_), .B(intadd_12_A_1_), .CI(intadd_12_n3), .CO(intadd_12_n2), .S(intadd_12_SUM_1_) );
  FA1S intadd_12_U2 ( .A(intadd_10_SUM_0_), .B(intadd_11_SUM_1_), .CI(
        intadd_12_n2), .CO(intadd_12_n1), .S(intadd_2_A_7_) );
  FA1S intadd_13_U4 ( .A(f[4]), .B(b[4]), .CI(d[4]), .CO(intadd_13_n3), .S(
        intadd_13_SUM_0_) );
  FA1S intadd_13_U3 ( .A(intadd_13_B_1_), .B(intadd_13_A_1_), .CI(intadd_13_n3), .CO(intadd_13_n2), .S(intadd_13_SUM_1_) );
  FA1S intadd_13_U2 ( .A(intadd_11_SUM_0_), .B(intadd_12_SUM_1_), .CI(
        intadd_13_n2), .CO(intadd_13_n1), .S(intadd_2_A_6_) );
  FA1S intadd_14_U4 ( .A(f[3]), .B(b[3]), .CI(d[3]), .CO(intadd_14_n3), .S(
        intadd_14_SUM_0_) );
  FA1S intadd_14_U3 ( .A(intadd_14_B_1_), .B(intadd_14_A_1_), .CI(intadd_14_n3), .CO(intadd_14_n2), .S(intadd_14_SUM_1_) );
  FA1S intadd_14_U2 ( .A(intadd_12_SUM_0_), .B(intadd_13_SUM_1_), .CI(
        intadd_14_n2), .CO(intadd_14_n1), .S(intadd_2_A_5_) );
  FA1S intadd_15_U4 ( .A(b[2]), .B(c[2]), .CI(a[2]), .CO(intadd_15_n3), .S(
        intadd_15_SUM_0_) );
  FA1S intadd_15_U3 ( .A(intadd_15_B_1_), .B(intadd_15_A_1_), .CI(intadd_15_n3), .CO(intadd_15_n2), .S(intadd_15_SUM_1_) );
  FA1S intadd_15_U2 ( .A(intadd_13_SUM_0_), .B(intadd_14_SUM_1_), .CI(
        intadd_15_n2), .CO(intadd_15_n1), .S(intadd_2_A_4_) );
  FA1S intadd_16_U4 ( .A(f[1]), .B(b[1]), .CI(d[1]), .CO(intadd_16_n3), .S(
        intadd_16_SUM_0_) );
  FA1S intadd_16_U3 ( .A(intadd_16_B_1_), .B(e[2]), .CI(intadd_16_n3), .CO(
        intadd_16_n2), .S(intadd_2_A_2_) );
  FA1S intadd_16_U2 ( .A(intadd_14_SUM_0_), .B(intadd_15_SUM_1_), .CI(
        intadd_16_n2), .CO(intadd_16_n1), .S(intadd_2_A_3_) );
  FA1S intadd_17_U4 ( .A(f[0]), .B(c[0]), .CI(a[0]), .CO(intadd_17_n3), .S(
        intadd_2_B_0_) );
  FA1S intadd_17_U3 ( .A(intadd_16_SUM_0_), .B(intadd_17_A_1_), .CI(
        intadd_17_n3), .CO(intadd_17_n2), .S(intadd_2_A_1_) );
  FA1S intadd_17_U2 ( .A(intadd_15_SUM_0_), .B(intadd_17_A_2_), .CI(
        intadd_17_n2), .CO(intadd_17_n1), .S(intadd_2_B_2_) );
  FA1S intadd_2_U3 ( .A(intadd_3_n1), .B(intadd_2_A_17_), .CI(intadd_2_n3), 
        .CO(intadd_2_n2), .S(o[17]) );
  FA1S intadd_2_U2 ( .A(intadd_2_B_18_), .B(intadd_2_A_18_), .CI(intadd_2_n2), 
        .CO(intadd_2_n1), .S(o[18]) );
  FA1S intadd_2_U5 ( .A(intadd_5_n1), .B(intadd_2_A_15_), .CI(intadd_2_n5), 
        .CO(intadd_2_n4), .S(o[15]) );
  FA1S intadd_2_U6 ( .A(intadd_6_n1), .B(intadd_2_A_14_), .CI(intadd_2_n6), 
        .CO(intadd_2_n5), .S(o[14]) );
  FA1S intadd_2_U9 ( .A(intadd_9_n1), .B(intadd_2_A_11_), .CI(intadd_2_n9), 
        .CO(intadd_2_n8), .S(o[11]) );
  FA1S intadd_2_U11 ( .A(intadd_11_n1), .B(intadd_2_A_9_), .CI(intadd_2_n11), 
        .CO(intadd_2_n10), .S(o[9]) );
  FA1S intadd_2_U13 ( .A(intadd_13_n1), .B(intadd_2_A_7_), .CI(intadd_2_n13), 
        .CO(intadd_2_n12), .S(o[7]) );
  FA1S intadd_2_U12 ( .A(intadd_12_n1), .B(intadd_2_A_8_), .CI(intadd_2_n12), 
        .CO(intadd_2_n11), .S(o[8]) );
  FA1S intadd_2_U10 ( .A(intadd_10_n1), .B(intadd_2_A_10_), .CI(intadd_2_n10), 
        .CO(intadd_2_n9), .S(o[10]) );
  FA1S intadd_2_U8 ( .A(intadd_8_n1), .B(intadd_2_A_12_), .CI(intadd_2_n8), 
        .CO(intadd_2_n7), .S(o[12]) );
  FA1S intadd_2_U7 ( .A(intadd_7_n1), .B(intadd_2_A_13_), .CI(intadd_2_n7), 
        .CO(intadd_2_n6), .S(o[13]) );
  FA1S intadd_2_U4 ( .A(intadd_4_n1), .B(intadd_2_A_16_), .CI(intadd_2_n4), 
        .CO(intadd_2_n3), .S(o[16]) );
  MOAI1S U1 ( .A1(n17), .A2(n16), .B1(n17), .B2(n16), .O(o[19]) );
  AN2S U2 ( .I1(d[2]), .I2(f[2]), .O(intadd_15_A_1_) );
  OR2S U3 ( .I1(c[18]), .I2(e[18]), .O(n18) );
  ND2S U4 ( .I1(n19), .I2(n18), .O(n21) );
  ND2S U5 ( .I1(c[18]), .I2(e[18]), .O(n19) );
  AN2S U6 ( .I1(d[0]), .I2(b[0]), .O(intadd_17_A_1_) );
  FA1S U7 ( .A(b[18]), .B(f[18]), .CI(d[18]), .CO(n28), .S(intadd_3_A_2_) );
  MOAI1S U8 ( .A1(a[18]), .A2(n21), .B1(a[18]), .B2(n21), .O(n5) );
  ND2S U9 ( .I1(a[17]), .I2(n18), .O(n1) );
  ND2S U10 ( .I1(n1), .I2(n19), .O(n4) );
  MOAI1S U11 ( .A1(n2), .A2(intadd_2_n1), .B1(n2), .B2(intadd_2_n1), .O(n17)
         );
  ND2S U12 ( .I1(a[16]), .I2(n18), .O(n3) );
  ND2S U13 ( .I1(n3), .I2(n19), .O(n23) );
  MOAI1S U14 ( .A1(a[17]), .A2(n21), .B1(a[17]), .B2(n21), .O(n22) );
  FA1S U15 ( .A(n28), .B(n5), .CI(n4), .CO(n2), .S(n31) );
  INV1S U16 ( .I(n28), .O(n6) );
  MOAI1S U17 ( .A1(n7), .A2(n6), .B1(n7), .B2(n6), .O(n8) );
  MOAI1S U18 ( .A1(d[18]), .A2(n8), .B1(d[18]), .B2(n8), .O(n9) );
  MOAI1S U19 ( .A1(f[18]), .A2(n9), .B1(f[18]), .B2(n9), .O(n15) );
  INV1S U20 ( .I(b[18]), .O(n10) );
  MOAI1S U21 ( .A1(a[19]), .A2(n10), .B1(a[19]), .B2(n10), .O(n13) );
  INV1S U22 ( .I(a[18]), .O(n11) );
  MAO222S U23 ( .A1(e[18]), .B1(c[18]), .C1(n11), .O(n12) );
  XNR2HS U24 ( .I1(n13), .I2(n12), .O(n14) );
  MOAI1S U25 ( .A1(n15), .A2(n14), .B1(n15), .B2(n14), .O(n16) );
  MOAI1S U26 ( .A1(a[15]), .A2(n21), .B1(a[15]), .B2(n21), .O(intadd_3_A_1_)
         );
  ND2S U27 ( .I1(a[15]), .I2(n18), .O(n20) );
  ND2S U28 ( .I1(n20), .I2(n19), .O(n27) );
  MOAI1S U29 ( .A1(a[16]), .A2(n21), .B1(a[16]), .B2(n21), .O(n26) );
  FA1S U30 ( .A(n28), .B(n23), .CI(n22), .CO(n32), .S(n24) );
  FA1S U31 ( .A(intadd_3_A_2_), .B(n25), .CI(n24), .CO(intadd_2_A_18_), .S(
        intadd_2_A_17_) );
  FA1S U32 ( .A(n28), .B(n27), .CI(n26), .CO(n25), .S(intadd_3_B_2_) );
  FA1S U33 ( .A(c[14]), .B(a[14]), .CI(e[14]), .CO(intadd_3_B_1_), .S(
        intadd_4_B_1_) );
  FA1S U34 ( .A(c[13]), .B(a[13]), .CI(e[13]), .CO(intadd_4_A_1_), .S(
        intadd_5_B_1_) );
  FA1S U35 ( .A(c[12]), .B(a[12]), .CI(e[12]), .CO(intadd_5_A_1_), .S(
        intadd_6_B_1_) );
  FA1S U36 ( .A(c[11]), .B(a[11]), .CI(e[11]), .CO(intadd_6_A_1_), .S(
        intadd_7_B_1_) );
  FA1S U37 ( .A(c[10]), .B(a[10]), .CI(e[10]), .CO(intadd_7_A_1_), .S(
        intadd_8_B_1_) );
  FA1S U38 ( .A(c[9]), .B(a[9]), .CI(e[9]), .CO(intadd_8_A_1_), .S(
        intadd_9_B_1_) );
  FA1S U39 ( .A(c[8]), .B(a[8]), .CI(e[8]), .CO(intadd_9_A_1_), .S(
        intadd_10_B_1_) );
  FA1S U40 ( .A(c[7]), .B(a[7]), .CI(e[7]), .CO(intadd_10_A_1_), .S(
        intadd_11_B_1_) );
  FA1S U41 ( .A(c[6]), .B(a[6]), .CI(e[6]), .CO(intadd_11_A_1_), .S(
        intadd_12_B_1_) );
  FA1S U42 ( .A(c[5]), .B(a[5]), .CI(e[5]), .CO(intadd_12_A_1_), .S(
        intadd_13_B_1_) );
  FA1S U43 ( .A(c[4]), .B(a[4]), .CI(e[4]), .CO(intadd_13_A_1_), .S(
        intadd_14_B_1_) );
  FA1S U44 ( .A(c[3]), .B(a[3]), .CI(e[3]), .CO(intadd_14_A_1_), .S(
        intadd_15_B_1_) );
  NR2 U45 ( .I1(d[2]), .I2(f[2]), .O(n29) );
  NR2 U46 ( .I1(intadd_15_A_1_), .I2(n29), .O(intadd_16_B_1_) );
  NR2 U47 ( .I1(d[0]), .I2(b[0]), .O(n30) );
  NR2 U48 ( .I1(intadd_17_A_1_), .I2(n30), .O(intadd_2_CI) );
  FA1S U49 ( .A(c[1]), .B(a[1]), .CI(e[1]), .CO(intadd_17_A_2_), .S(
        intadd_2_B_1_) );
  FA1S U50 ( .A(n32), .B(intadd_3_A_2_), .CI(n31), .CO(n7), .S(intadd_2_B_18_)
         );
endmodule


module MULTIPLIER_4 ( clk, rst_n, a, b, o );
  input [7:0] a;
  input [7:0] b;
  output [15:0] o;
  input clk, rst_n;
  wire   N1, N2, N3, N4, N5, N6, N7, N8, N9, N10, N11, N12, N13, N14, N15,
         intadd_1_A_11_, intadd_1_A_10_, intadd_1_A_9_, intadd_1_A_8_,
         intadd_1_A_7_, intadd_1_A_6_, intadd_1_A_5_, intadd_1_A_4_,
         intadd_1_A_3_, intadd_1_A_2_, intadd_1_A_1_, intadd_1_A_0_,
         intadd_1_B_11_, intadd_1_B_10_, intadd_1_B_9_, intadd_1_B_8_,
         intadd_1_B_7_, intadd_1_B_6_, intadd_1_B_5_, intadd_1_B_4_,
         intadd_1_B_3_, intadd_1_B_2_, intadd_1_B_1_, intadd_1_B_0_,
         intadd_1_CI, intadd_1_n12, intadd_1_n11, intadd_1_n10, intadd_1_n9,
         intadd_1_n8, intadd_1_n7, intadd_1_n6, intadd_1_n5, intadd_1_n4,
         intadd_1_n3, intadd_1_n2, intadd_1_n1, n160, n200, n300, n400, n500,
         n600, n700, n800, n900, n1000, n1100, n1200, n1300, n140, n150, n161,
         n17, n18, n19, n201, n21, n22, n23, n24, n25, n26, n27, n28, n29,
         n301, n31, n32, n33, n34, n35, n36, n37, n38, n39, n401, n41, n42,
         n43, n44, n45, n46, n47, n48, n49, n501, n51, n52, n53, n54, n55, n56,
         n57, n58, n59, n601, n61, n62, n63, n64, n65, n66, n67, n68, n69,
         n701, n71, n72, n73, n74, n75, n76, n77, n78, n79, n801, n81, n82,
         n83, n84, n85, n86, n87, n88, n89, n901, n91, n92, n93, n94, n95, n96,
         n97, n98, n99, n1001, n101, n102, n103, n104, n105, n106, n107, n108,
         n109, n1101, n111, n112, n113, n114, n115, n116, n117, n118, n119,
         n1201, n121, n122, n123, n124, n125, n126, n127, n128, n129, n1301,
         n131, n132;

  QDFFS o_reg_15_ ( .D(N15), .CK(clk), .Q(o[15]) );
  QDFFS o_reg_14_ ( .D(N14), .CK(clk), .Q(o[14]) );
  QDFFS o_reg_13_ ( .D(N13), .CK(clk), .Q(o[13]) );
  QDFFS o_reg_12_ ( .D(N12), .CK(clk), .Q(o[12]) );
  QDFFS o_reg_11_ ( .D(N11), .CK(clk), .Q(o[11]) );
  QDFFS o_reg_10_ ( .D(N10), .CK(clk), .Q(o[10]) );
  QDFFS o_reg_9_ ( .D(N9), .CK(clk), .Q(o[9]) );
  QDFFS o_reg_8_ ( .D(N8), .CK(clk), .Q(o[8]) );
  QDFFS o_reg_7_ ( .D(N7), .CK(clk), .Q(o[7]) );
  QDFFS o_reg_6_ ( .D(N6), .CK(clk), .Q(o[6]) );
  QDFFS o_reg_5_ ( .D(N5), .CK(clk), .Q(o[5]) );
  QDFFS o_reg_4_ ( .D(N4), .CK(clk), .Q(o[4]) );
  QDFFS o_reg_3_ ( .D(N3), .CK(clk), .Q(o[3]) );
  QDFFS o_reg_2_ ( .D(N2), .CK(clk), .Q(o[2]) );
  QDFFS o_reg_1_ ( .D(N1), .CK(clk), .Q(o[1]) );
  QDFFS o_reg_0_ ( .D(n132), .CK(clk), .Q(o[0]) );
  FA1S intadd_1_U13 ( .A(intadd_1_B_0_), .B(intadd_1_A_0_), .CI(intadd_1_CI), 
        .CO(intadd_1_n12), .S(N3) );
  FA1S intadd_1_U12 ( .A(intadd_1_B_1_), .B(intadd_1_A_1_), .CI(intadd_1_n12), 
        .CO(intadd_1_n11), .S(N4) );
  FA1S intadd_1_U11 ( .A(intadd_1_B_2_), .B(intadd_1_A_2_), .CI(intadd_1_n11), 
        .CO(intadd_1_n10), .S(N5) );
  FA1S intadd_1_U10 ( .A(intadd_1_B_3_), .B(intadd_1_A_3_), .CI(intadd_1_n10), 
        .CO(intadd_1_n9), .S(N6) );
  FA1S intadd_1_U9 ( .A(intadd_1_B_4_), .B(intadd_1_A_4_), .CI(intadd_1_n9), 
        .CO(intadd_1_n8), .S(N7) );
  FA1S intadd_1_U8 ( .A(intadd_1_B_5_), .B(intadd_1_A_5_), .CI(intadd_1_n8), 
        .CO(intadd_1_n7), .S(N8) );
  FA1S intadd_1_U7 ( .A(intadd_1_B_6_), .B(intadd_1_A_6_), .CI(intadd_1_n7), 
        .CO(intadd_1_n6), .S(N9) );
  FA1S intadd_1_U6 ( .A(intadd_1_B_7_), .B(intadd_1_A_7_), .CI(intadd_1_n6), 
        .CO(intadd_1_n5), .S(N10) );
  FA1S intadd_1_U5 ( .A(intadd_1_B_8_), .B(intadd_1_A_8_), .CI(intadd_1_n5), 
        .CO(intadd_1_n4), .S(N11) );
  FA1S intadd_1_U4 ( .A(intadd_1_B_9_), .B(intadd_1_A_9_), .CI(intadd_1_n4), 
        .CO(intadd_1_n3), .S(N12) );
  FA1S intadd_1_U3 ( .A(intadd_1_B_10_), .B(intadd_1_A_10_), .CI(intadd_1_n3), 
        .CO(intadd_1_n2), .S(N13) );
  FA1S intadd_1_U2 ( .A(intadd_1_B_11_), .B(intadd_1_A_11_), .CI(intadd_1_n2), 
        .CO(intadd_1_n1), .S(N14) );
  OA12S U3 ( .B1(n82), .B2(n97), .A1(a[5]), .O(n92) );
  OA12S U4 ( .B1(n38), .B2(n53), .A1(a[7]), .O(n65) );
  ND2S U5 ( .I1(b[0]), .I2(n66), .O(n801) );
  AO22S U6 ( .A1(n66), .A2(n36), .B1(n53), .B2(n54), .O(n47) );
  OA12S U7 ( .B1(a[0]), .B2(a[1]), .A1(n39), .O(n57) );
  ND2S U8 ( .I1(n65), .I2(n64), .O(n56) );
  ND3S U9 ( .I1(n200), .I2(n51), .I3(a[1]), .O(n129) );
  OA12S U10 ( .B1(n51), .B2(n34), .A1(n129), .O(n400) );
  MAOI1S U11 ( .A1(a[0]), .A2(n160), .B1(n85), .B2(b[1]), .O(n300) );
  ND2S U12 ( .I1(b[0]), .I2(n104), .O(n118) );
  ND2S U13 ( .I1(n92), .I2(n91), .O(n87) );
  AN2S U14 ( .I1(a[0]), .I2(b[0]), .O(n132) );
  MOAI1S U15 ( .A1(a[5]), .A2(a[6]), .B1(a[5]), .B2(a[6]), .O(n126) );
  MOAI1S U16 ( .A1(b[7]), .A2(a[7]), .B1(b[7]), .B2(a[7]), .O(n124) );
  INV1S U17 ( .I(n126), .O(n66) );
  MOAI1S U18 ( .A1(a[7]), .A2(a[6]), .B1(a[7]), .B2(a[6]), .O(n125) );
  NR2 U19 ( .I1(n66), .I2(n125), .O(n53) );
  INV1S U20 ( .I(a[7]), .O(n35) );
  MOAI1S U21 ( .A1(b[6]), .A2(n35), .B1(b[6]), .B2(n35), .O(n900) );
  MOAI1S U22 ( .A1(n126), .A2(n124), .B1(n53), .B2(n900), .O(intadd_1_A_11_)
         );
  INV1S U23 ( .I(b[2]), .O(n93) );
  MOAI1S U24 ( .A1(n93), .A2(a[1]), .B1(n93), .B2(a[1]), .O(n160) );
  INV1S U25 ( .I(a[1]), .O(n127) );
  NR2 U26 ( .I1(a[0]), .I2(n127), .O(n106) );
  INV1S U27 ( .I(n106), .O(n85) );
  INV1S U28 ( .I(b[0]), .O(n51) );
  MOAI1S U29 ( .A1(a[1]), .A2(a[2]), .B1(a[1]), .B2(a[2]), .O(n34) );
  ND2S U30 ( .I1(b[1]), .I2(a[0]), .O(n200) );
  NR2 U31 ( .I1(n300), .I2(n400), .O(intadd_1_B_0_) );
  OAI22S U32 ( .A1(n400), .A2(intadd_1_B_0_), .B1(n300), .B2(intadd_1_B_0_), 
        .O(N2) );
  INV1S U33 ( .I(b[3]), .O(n105) );
  MOAI1S U34 ( .A1(n105), .A2(a[1]), .B1(n105), .B2(a[1]), .O(n500) );
  AOI22S U35 ( .A1(a[0]), .A2(n500), .B1(n106), .B2(n93), .O(n700) );
  INV1S U36 ( .I(n34), .O(n112) );
  INV1S U37 ( .I(a[3]), .O(n114) );
  MOAI1S U38 ( .A1(n114), .A2(b[1]), .B1(n114), .B2(b[1]), .O(n108) );
  MOAI1S U39 ( .A1(a[2]), .A2(a[3]), .B1(a[2]), .B2(a[3]), .O(n24) );
  NR2 U40 ( .I1(n112), .I2(n24), .O(n109) );
  MOAI1S U41 ( .A1(n114), .A2(b[0]), .B1(n114), .B2(b[0]), .O(n600) );
  AOI22S U42 ( .A1(n112), .A2(n108), .B1(n109), .B2(n600), .O(n800) );
  NR2 U43 ( .I1(n700), .I2(n800), .O(intadd_1_A_1_) );
  OAI22S U44 ( .A1(n800), .A2(intadd_1_A_1_), .B1(n700), .B2(intadd_1_A_1_), 
        .O(intadd_1_A_0_) );
  INV1S U45 ( .I(intadd_1_A_11_), .O(intadd_1_A_10_) );
  MOAI1S U46 ( .A1(a[3]), .A2(a[4]), .B1(a[3]), .B2(a[4]), .O(n81) );
  MOAI1S U47 ( .A1(a[5]), .A2(b[7]), .B1(a[5]), .B2(b[7]), .O(n1100) );
  INV1S U48 ( .I(n81), .O(n104) );
  MOAI1S U49 ( .A1(a[5]), .A2(a[4]), .B1(a[5]), .B2(a[4]), .O(n1000) );
  NR2 U50 ( .I1(n104), .I2(n1000), .O(n97) );
  INV1S U51 ( .I(a[5]), .O(n95) );
  MOAI1S U52 ( .A1(b[6]), .A2(n95), .B1(b[6]), .B2(n95), .O(n18) );
  MOAI1S U53 ( .A1(n81), .A2(n1100), .B1(n97), .B2(n18), .O(n122) );
  INV1S U54 ( .I(n122), .O(n150) );
  INV1S U55 ( .I(b[5]), .O(n83) );
  MOAI1S U56 ( .A1(n83), .A2(a[7]), .B1(n83), .B2(a[7]), .O(n17) );
  AOI22S U57 ( .A1(n66), .A2(n900), .B1(n53), .B2(n17), .O(n140) );
  OAI22S U58 ( .A1(n81), .A2(n1100), .B1(n1000), .B2(n1100), .O(n1300) );
  INV1S U59 ( .I(n1200), .O(intadd_1_B_10_) );
  FA1S U60 ( .A(n150), .B(n140), .CI(n1300), .CO(n1200), .S(n161) );
  INV1S U61 ( .I(n161), .O(intadd_1_A_9_) );
  MOAI1S U62 ( .A1(b[4]), .A2(n35), .B1(b[4]), .B2(n35), .O(n19) );
  AOI22S U63 ( .A1(n66), .A2(n17), .B1(n53), .B2(n19), .O(n121) );
  MOAI1S U64 ( .A1(a[3]), .A2(b[7]), .B1(a[3]), .B2(b[7]), .O(n25) );
  INV1S U65 ( .I(n109), .O(n113) );
  MOAI1S U66 ( .A1(a[3]), .A2(b[6]), .B1(a[3]), .B2(b[6]), .O(n33) );
  OAI22S U67 ( .A1(n34), .A2(n25), .B1(n113), .B2(n33), .O(n42) );
  INV1S U68 ( .I(n42), .O(n23) );
  MOAI1S U69 ( .A1(n83), .A2(a[5]), .B1(n83), .B2(a[5]), .O(n26) );
  AOI22S U70 ( .A1(n104), .A2(n18), .B1(n97), .B2(n26), .O(n22) );
  MOAI1S U71 ( .A1(n105), .A2(a[7]), .B1(n105), .B2(a[7]), .O(n27) );
  AOI22S U72 ( .A1(n66), .A2(n19), .B1(n53), .B2(n27), .O(n21) );
  INV1S U73 ( .I(n201), .O(intadd_1_B_9_) );
  FA1S U74 ( .A(n23), .B(n22), .CI(n21), .CO(n1201), .S(n31) );
  OAI22S U75 ( .A1(n34), .A2(n25), .B1(n24), .B2(n25), .O(n301) );
  MOAI1S U76 ( .A1(b[4]), .A2(n95), .B1(b[4]), .B2(n95), .O(n37) );
  AOI22S U77 ( .A1(n104), .A2(n26), .B1(n97), .B2(n37), .O(n41) );
  AOI22S U78 ( .A1(n93), .A2(n35), .B1(b[2]), .B2(a[7]), .O(n36) );
  AOI22S U79 ( .A1(n66), .A2(n27), .B1(n53), .B2(n36), .O(n401) );
  INV1S U80 ( .I(n28), .O(intadd_1_A_8_) );
  FA1S U81 ( .A(n31), .B(n301), .CI(n29), .CO(n28), .S(n32) );
  INV1S U82 ( .I(n32), .O(intadd_1_A_7_) );
  MOAI1S U83 ( .A1(n83), .A2(a[3]), .B1(n83), .B2(a[3]), .O(n501) );
  MOAI1S U84 ( .A1(n34), .A2(n33), .B1(n109), .B2(n501), .O(n49) );
  MOAI1S U85 ( .A1(n35), .A2(b[1]), .B1(n35), .B2(b[1]), .O(n54) );
  NR2 U86 ( .I1(n49), .I2(n47), .O(n48) );
  MOAI1S U87 ( .A1(n105), .A2(a[5]), .B1(n105), .B2(a[5]), .O(n55) );
  AOI22S U88 ( .A1(n104), .A2(n37), .B1(n97), .B2(n55), .O(n58) );
  MOAI1S U89 ( .A1(b[7]), .A2(n127), .B1(b[7]), .B2(n127), .O(n39) );
  NR2 U90 ( .I1(n126), .I2(b[0]), .O(n38) );
  MOAI1S U91 ( .A1(b[6]), .A2(n85), .B1(a[0]), .B2(n39), .O(n64) );
  FA1S U92 ( .A(n42), .B(n41), .CI(n401), .CO(n29), .S(n44) );
  INV1S U93 ( .I(n43), .O(intadd_1_B_7_) );
  FA1S U94 ( .A(n48), .B(n45), .CI(n44), .CO(n43), .S(n46) );
  INV1S U95 ( .I(n46), .O(intadd_1_A_6_) );
  OAI22S U96 ( .A1(n49), .A2(n48), .B1(n47), .B2(n48), .O(n62) );
  MOAI1S U97 ( .A1(b[4]), .A2(n114), .B1(b[4]), .B2(n114), .O(n68) );
  AOI22S U98 ( .A1(n112), .A2(n501), .B1(n109), .B2(n68), .O(n71) );
  MOAI1S U99 ( .A1(n51), .A2(a[7]), .B1(n51), .B2(a[7]), .O(n52) );
  AOI22S U100 ( .A1(n66), .A2(n54), .B1(n53), .B2(n52), .O(n701) );
  MOAI1S U101 ( .A1(n95), .A2(b[2]), .B1(n95), .B2(b[2]), .O(n77) );
  AOI22S U102 ( .A1(n104), .A2(n55), .B1(n97), .B2(n77), .O(n69) );
  FA1S U103 ( .A(n58), .B(n57), .CI(n56), .CO(n45), .S(n601) );
  INV1S U104 ( .I(n59), .O(intadd_1_B_6_) );
  FA1S U105 ( .A(n62), .B(n61), .CI(n601), .CO(n59), .S(n63) );
  INV1S U106 ( .I(n63), .O(intadd_1_A_5_) );
  MOAI1S U107 ( .A1(n65), .A2(n64), .B1(n65), .B2(n64), .O(n75) );
  MOAI1S U108 ( .A1(b[6]), .A2(n127), .B1(b[6]), .B2(n127), .O(n67) );
  AOI22S U109 ( .A1(a[0]), .A2(n67), .B1(n106), .B2(n83), .O(n79) );
  MOAI1S U110 ( .A1(n105), .A2(a[3]), .B1(n105), .B2(a[3]), .O(n94) );
  AOI22S U111 ( .A1(n112), .A2(n68), .B1(n109), .B2(n94), .O(n78) );
  FA1S U112 ( .A(n71), .B(n701), .CI(n69), .CO(n61), .S(n73) );
  INV1S U113 ( .I(n72), .O(intadd_1_B_5_) );
  FA1S U114 ( .A(n75), .B(n74), .CI(n73), .CO(n72), .S(n76) );
  INV1S U115 ( .I(n76), .O(intadd_1_A_4_) );
  MOAI1S U116 ( .A1(n95), .A2(b[1]), .B1(n95), .B2(b[1]), .O(n98) );
  AOI22S U117 ( .A1(n104), .A2(n77), .B1(n97), .B2(n98), .O(n89) );
  FA1S U118 ( .A(n801), .B(n79), .CI(n78), .CO(n74), .S(n88) );
  NR2 U119 ( .I1(n81), .I2(b[0]), .O(n82) );
  MOAI1S U120 ( .A1(n83), .A2(a[1]), .B1(n83), .B2(a[1]), .O(n84) );
  MOAI1S U121 ( .A1(b[4]), .A2(n85), .B1(a[0]), .B2(n84), .O(n91) );
  INV1S U122 ( .I(n86), .O(intadd_1_B_4_) );
  FA1S U123 ( .A(n89), .B(n88), .CI(n87), .CO(n86), .S(n901) );
  INV1S U124 ( .I(n901), .O(intadd_1_A_3_) );
  MOAI1S U125 ( .A1(n92), .A2(n91), .B1(n92), .B2(n91), .O(n102) );
  MOAI1S U126 ( .A1(n93), .A2(a[3]), .B1(n93), .B2(a[3]), .O(n1101) );
  AOI22S U127 ( .A1(n112), .A2(n94), .B1(n109), .B2(n1101), .O(n101) );
  MOAI1S U128 ( .A1(n95), .A2(b[0]), .B1(n95), .B2(b[0]), .O(n96) );
  AOI22S U129 ( .A1(n104), .A2(n98), .B1(n97), .B2(n96), .O(n1001) );
  INV1S U130 ( .I(n99), .O(intadd_1_B_3_) );
  FA1S U131 ( .A(n102), .B(n101), .CI(n1001), .CO(n99), .S(n103) );
  INV1S U132 ( .I(n103), .O(intadd_1_A_2_) );
  MOAI1S U133 ( .A1(b[4]), .A2(n127), .B1(b[4]), .B2(n127), .O(n107) );
  AOI22S U134 ( .A1(a[0]), .A2(n107), .B1(n106), .B2(n105), .O(n117) );
  AOI22S U135 ( .A1(n112), .A2(n1101), .B1(n109), .B2(n108), .O(n116) );
  INV1S U136 ( .I(n111), .O(intadd_1_B_2_) );
  ND2S U137 ( .I1(a[3]), .I2(n112), .O(n115) );
  OAI22S U138 ( .A1(n115), .A2(b[0]), .B1(n114), .B2(n113), .O(intadd_1_CI) );
  FA1S U139 ( .A(n118), .B(n117), .CI(n116), .CO(n111), .S(n119) );
  INV1S U140 ( .I(n119), .O(intadd_1_B_1_) );
  FA1S U141 ( .A(n122), .B(n121), .CI(n1201), .CO(n201), .S(n123) );
  INV1S U142 ( .I(n123), .O(intadd_1_B_8_) );
  AO12S U143 ( .B1(n126), .B2(n125), .A1(n124), .O(intadd_1_B_11_) );
  NR2 U144 ( .I1(n132), .I2(n127), .O(n131) );
  MOAI1S U145 ( .A1(b[1]), .A2(n127), .B1(b[1]), .B2(n127), .O(n128) );
  AN2S U146 ( .I1(n128), .I2(a[0]), .O(n1301) );
  OA12S U147 ( .B1(n131), .B2(n1301), .A1(n129), .O(N1) );
  INV1S U148 ( .I(intadd_1_n1), .O(N15) );
endmodule

