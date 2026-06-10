module memoria_ram #(
    parameter DATA_WIDTH = 8,
    parameter ADDR_WIDTH = 8
)(
    input  wire                        clk,
    input  wire                        wr_rdn,   // 0 = lectura, 1 = escritura
    input  wire [ADDR_WIDTH-1:0]       addr,
    input  wire [DATA_WIDTH-1:0]       w_data,
    output wire [DATA_WIDTH-1:0]       r_data
);

    reg [DATA_WIDTH-1:0] ram [0:(1<<ADDR_WIDTH)-1];
    reg [ADDR_WIDTH-1:0] addr_reg;

    initial begin
        $readmemh("ram_contents.txt", ram);
    end

    always @(posedge clk) begin
        if (wr_rdn == 1'b1) begin
            ram[addr] <= w_data;
        end

        addr_reg <= addr;
    end

    assign r_data = ram[addr_reg];

endmodule