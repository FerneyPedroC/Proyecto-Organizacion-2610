module banco_registros #(
    parameter DATA_WIDTH = 8,    // Ancho de cada registro
    parameter ADDR_WIDTH = 3     // Bits para direccionar 8 registros (2^3=8)
)(
    input  wire                   clk,         // Reloj del sistema
    input  wire                   rst,         // Reset asíncrono activo en alto
    input  wire                   bank_wr_en,  // Habilitación de escritura
    input  wire [ADDR_WIDTH-1:0]  BusC_addr,   // Dirección del registro a escribir
    input  wire [DATA_WIDTH-1:0]  BusC_data,   // Dato a escribir (viene de BusC/ALU)
    input  wire [ADDR_WIDTH-1:0]  BusA_addr,   // Dirección para leer por Bus_A
    input  wire [ADDR_WIDTH-1:0]  BusB_addr,   // Dirección para leer por Bus_B
    output wire [DATA_WIDTH-1:0]  Bus_A,        // Salida de lectura puerto A
    output wire [DATA_WIDTH-1:0]  Bus_B         // Salida de lectura puerto B
);
 
    // ---- Declaración del arreglo de registros ----
    reg [DATA_WIDTH-1:0] reg_bank [0:(2**ADDR_WIDTH)-1];
 
    // ---- Inicialización de registros al encendido ----
    // Constante -1 en complemento a dos = 0xFF (posición 6)
    integer i;

    // ---- Escritura sincrónica con reset asíncrono ----
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Reset: todos los registros a 0, excepto Cte1
				reg_bank[0] <= 8'h00;    // Restaurar constante -1 tras reset PC PROGRAM COUNTER
				reg_bank[1] <= 8'h00;	 // SP
				reg_bank[2] <= 8'hF1;    // DPTR
				reg_bank[3] <= 8'h55;    // A
				reg_bank[4] <= 8'h00;    // AVI
				reg_bank[5] <= 8'hFF;    // TEMP
				reg_bank[6] <= 8'h00;    // Cte1
				reg_bank[7] <= 8'h0f;    // ACC

					 
        end else if (bank_wr_en) begin
            reg_bank[BusC_addr] <= BusC_data;   // Escritura en el registro indicado
        end
    end
    // ---- Lectura combinacional (asíncrona) ----
    // Dos puertos de lectura independientes: Bus_A y Bus_B
    assign Bus_A = reg_bank[7];
    assign Bus_B = reg_bank[BusB_addr];
 
endmodule
