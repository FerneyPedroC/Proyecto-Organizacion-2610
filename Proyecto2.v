module Proyecto2
#(parameter MAX_WIDTH = 8)
(
    input wire clk,
    input wire rst,

    output wire [7:0] Bus_A,
    output wire [7:0] Bus_B,
    output wire [7:0] busC,

    output wire [7:0] ir_q,
    output wire [7:0] mar_q,

    output wire [7:0] ram_r_data,

    output wire [7:0] BUS_DATA_IN,
    output wire [7:0] BUS_DATA_OUT,
    output wire [7:0] ADDRESS_BUS,

    output wire C,
    output wire N,
    output wire P,
    output wire Z
);

    // ======================================================
    // CABLES INTERNOS
    // ======================================================

    // Salida de la ALU hacia el MDR
    wire [7:0] bus_alu;

    // Bus C interno del sistema
    wire [7:0] bus_C_internal;

    // Dato leído desde RAM
    wire [7:0] ram_data_internal;

    // Bus de entrada y salida de datos
    wire [7:0] bus_data_in_internal;
    wire [7:0] bus_data_out_internal;
	 
	 wire bank_wr_en_uc;
	 wire mar_en_uc;
	 wire ir_en_uc;
	 wire ir_clr_uc;
	 

	 wire mdr_en_uc;
	 wire mdr_alu_n_uc;

	 wire ram_wr_rdn_uc;

	 wire enaf_uc;

	 wire [2:0] selop_uc;
	 wire [1:0] shamt_uc;

	 wire [2:0] BusC_addr_uc;
	 wire [2:0] BusB_addr_uc;

	 wire pc_inc_uc;
	 wire pc_load_uc;
	 
	 
	 

    // ======================================================
    // MICROCONTROLADOR
    // ======================================================

    

	 Unit_Control u_control (
    .clk        (clk),
    .rst        (rst),

    .Z          (Z),
    .C          (C),
    .N          (N),
    .P          (P),

    .int        (1'b0),

    .opcode     (ir_q[7:3]),

    .bank_wr_en (bank_wr_en_uc),
    .mar_en     (mar_en_uc),
    .ir_en      (ir_en_uc),
	 .ir_clr(ir_clr_uc),

    .mdr_en     (mdr_en_uc),
    .mdr_alu_n  (mdr_alu_n_uc),

    .ram_wr_rdn (ram_wr_rdn_uc),

    .enaf       (enaf_uc),

    .selop      (selop_uc),
    .shamt      (shamt_uc),

    .BusC_addr  (BusC_addr_uc),
    .BusB_addr  (BusB_addr_uc),

    .pc_inc     (pc_inc_uc),
    .pc_load    (pc_load_uc)
);

    // ======================================================
    // BANCO DE REGISTROS
    // ======================================================

    banco_registros #(
        .DATA_WIDTH(8),
        .ADDR_WIDTH(3)
    ) u_banco (
        .clk        (clk),
        .rst        (rst),

        // control desde microinstruction
        .bank_wr_en (bank_wr_en_uc),

        .BusC_addr  (BusC_addr_uc),

        .BusC_data  (bus_C_internal),

        // ACC fijo en BusA
        .BusA_addr  (3'b111),

        .BusB_addr  (BusB_addr_uc),

        .Bus_A      (Bus_A),
        .Bus_B      (Bus_B)
    );

    // ======================================================
    // BLOQUE ALU
    // ======================================================

    bloque_alu #(
        .MAX_WIDTH(MAX_WIDTH)
    ) u_alu (
        .clk   (clk),
        .rst   (rst),

        .busA  (Bus_A),
        .busB  (Bus_B),

		  .selop (selop_uc),
		  .shamt (shamt_uc),
		  .enaf  (enaf_uc),

        .busC  (bus_alu),

        .C     (C),
        .N     (N),
        .P     (P),
        .Z     (Z)
    );

    // ======================================================
    // REGISTRO IR
    // ======================================================

    paralregisterSclear #(
    .DATA_WIDTH(8)
) u_ir (
    .clk    (clk),
    .rst    (rst),

    .sclr   (ir_clr_uc),

    .enable (ir_en_uc),

    .d      (bus_C_internal),

    .q      (ir_q)
);

    // ======================================================
    // REGISTRO MAR
    // ======================================================

    Paralregister #(
        .DATA_WIDTH(8)
    ) u_mar (
        .clk    (clk),
        .rst    (rst),

        .enable (mar_en_uc),

        .d      (bus_C_internal),

        .q      (mar_q)
    );

    // ======================================================
    // RAM
    // ======================================================

    memoria_ram #(
        .DATA_WIDTH(8),
        .ADDR_WIDTH(8)
    ) u_ram (
        .clk    (clk),

        .wr_rdn (ram_wr_rdn_uc),

        .addr   (mar_q),

        .w_data (bus_data_out_internal),

        .r_data (ram_data_internal)
    );

    // ======================================================
    // BUS_DATA_IN viene SOLO de la RAM
    // ======================================================

    assign bus_data_in_internal = ram_data_internal;

    // ======================================================
    // REGISTRO MDR
    // ======================================================

    registro_mdr u_mdr (
        .clk          (clk),
        .rst          (rst),

		  .mdr_en    (mdr_en_uc),
		  .mdr_alu_n (mdr_alu_n_uc),

        .bus_alu      (bus_alu),

        .DATA_EX_in   (bus_data_in_internal),

        .bus_C        (bus_C_internal),

        .BUS_DATA_OUT (bus_data_out_internal)
    );

    // ======================================================
    // SALIDAS DE OBSERVACIÓN
    // ======================================================

    assign busC         = bus_C_internal;

    assign ram_r_data   = ram_data_internal;

    assign BUS_DATA_IN  = bus_data_in_internal;

    assign BUS_DATA_OUT = bus_data_out_internal;

    assign ADDRESS_BUS  = mar_q;

endmodule
