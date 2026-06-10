module alu 
#(parameter MAX_WIDTH = 8)
(
    input wire clk,
    input wire rst,
    input wire [MAX_WIDTH-1:0] busA,
    input wire [MAX_WIDTH-1:0] busB,
    input wire [2:0] selop,
    input wire [1:0] shamt,
    input wire enaf,
    output wire [MAX_WIDTH-1:0] busC,
    output wire C,
    output wire N,
    output wire P,
    output wire Z
);
 endmodule
 
 