module bloque_alu #(parameter MAX_WIDTH = 8)
(
    input  wire clk,
    input  wire rst,

    input  wire [MAX_WIDTH-1:0] busA,
    input  wire [MAX_WIDTH-1:0] busB,
    input  wire [2:0] selop,
    input  wire [1:0] shamt,
    input  wire enaf,

    output wire [MAX_WIDTH-1:0] busC,
    output wire C,
    output wire N,
    output wire P,
    output wire Z
);

    wire [MAX_WIDTH-1:0] proc_result;
    wire [MAX_WIDTH-1:0] shift_result;
    wire carry_out;

    // Processing unit
    processing_unit #(
        .N(MAX_WIDTH)
    ) u_processing_unit (
        .dataa  (busA),
        .datab  (busB),
        .selop  (selop),
        .result (proc_result),
        .cout   (carry_out)
    );

    // Shift unit
    shift_unit #(
        .N(MAX_WIDTH)
    ) u_shift_unit (
        .shamt   (shamt),
        .dataa   (proc_result),
        .dataout (shift_result)
    );

    // Flag register
    flag_register #(
        .MAX_WIDTH(MAX_WIDTH)
    ) u_flag_register (
        .clk   (clk),
        .rst   (rst),
        .enaf  (enaf),
        .dataa (shift_result),
        .carry (carry_out),
        .C     (C),
        .N     (N),
        .P     (P),
        .Z     (Z)
    );

    assign busC = shift_result;

endmodule
