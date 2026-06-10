module Unit_Control
#(
    parameter MICRO_ADDR_WIDTH = 8
)
(
    input wire clk,
    input wire rst,

    input wire Z,
    input wire C,
    input wire N,
    input wire P,
    input wire int,

    input wire [4:0] opcode,

    // ============================
    // Señales de control
    // ============================

    output wire bank_wr_en,
    output wire mar_en,
    output wire ir_en,
    output wire ir_clr,

    output wire mdr_en,
    output wire mdr_alu_n,

    output wire ram_wr_rdn,

    output wire enaf,

    output wire [2:0] selop,
    output wire [1:0] shamt,

    output wire [2:0] BusC_addr,
    output wire [2:0] BusB_addr,

    output wire pc_inc,
    output wire pc_load
);

    // ======================================================
    // INTERNOS
    // ======================================================

    reg Load;

    wire [2:0] jcond;
    wire [2:0] upcplus;
    wire [2:0] offset;
    wire [2:0] upc_next;

    wire en_uPc;
    wire clr_upc;

    wire [2:0] upc;

    wire [7:0] address;
    wire [28:0] uinst;

    // Bits reservados/no utilizados
    wire int_clr_unused;
    wire iom_unused;

    // ======================================================
    // ROM ADDRESS
    // ======================================================

    assign address = {opcode, upc};

    // ======================================================
    // CAMPOS MICROINSTRUCCIÓN
    // ======================================================

    assign enaf       = uinst[28];

    assign selop      = uinst[27:25];
    assign shamt      = uinst[24:23];

    assign BusB_addr  = uinst[22:20];
    assign BusC_addr  = uinst[19:17];

    assign bank_wr_en = uinst[16];

    assign mar_en     = uinst[15];

    assign mdr_en     = uinst[14];

    assign mdr_alu_n  = uinst[13];

    assign int_clr_unused = uinst[12];
    assign iom_unused     = uinst[11];

    assign ram_wr_rdn = uinst[10];

    assign ir_en      = uinst[9];

    assign ir_clr     = uinst[8];

    assign en_uPc     = uinst[7];

    assign clr_upc    = uinst[6];

    assign jcond      = uinst[5:3];

    assign offset     = uinst[2:0];

    // ======================================================
    // Señales PC (no utilizadas en esta arquitectura)
    // ======================================================

    assign pc_inc  = 1'b0;
    assign pc_load = 1'b0;

    // ======================================================
    // uPC REGISTER
    // ======================================================

    paralregisterSclear #(
        .DATA_WIDTH(3)
    ) upcreg (
        .clk    (clk),
        .rst    (rst),
        .sclr   (clr_upc),
        .enable (en_uPc),
        .d      (upc_next),
        .q      (upc)
    );

    // ======================================================
    // uPC + 1
    // ======================================================

    add_sub #(
        .N(3)
    ) upcadder (
        .a        (upc),
        .b        (3'b001),
        .addn_sub (1'b0),
        .s        (upcplus),
        .cout     ()
    );

    // ======================================================
    // CONTROL STORE
    // ======================================================

    ROM firmware (
        .addr      (address),
        .microinst (uinst)
    );

    // ======================================================
    // JCOND DECODER
    // ======================================================

    always @(*) begin
        case (jcond)

            3'b000: Load = 1'b0; // secuencial

            3'b001: Load = 1'b1; // salto incondicional

            3'b010: Load = Z;

            3'b011: Load = N;

            3'b100: Load = C;

            3'b101: Load = P;

            3'b110: Load = int;

            default: Load = 1'b0;

        endcase
    end

    // ======================================================
    // NEXT ADDRESS LOGIC
    // ======================================================

    assign upc_next = (Load) ? offset : upcplus;

endmodule