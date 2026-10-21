
module regfile (
    input  logic        clk,
    input  logic        rst,

    // Write port
    input  logic        wr_en,
    input  logic [4:0]  rd_addr,
    input  logic [31:0] wr_data,

    // Asynchronous read ports
    input  logic [4:0]  rs1_addr,
    input  logic [4:0]  rs2_addr,
    output logic [31:0] rs1_data,
    output logic [31:0] rs2_data
);

    // 32 registers, each 32 bits wide
    logic [31:0] rf [0:31];

    // Synchronous write and reset of x0 storage
    always_ff @(posedge clk) begin
        if (rst) begin
            rf[0] <= 32'b0;
        end
        else if (wr_en && (rd_addr != 5'd0)) begin
            rf[rd_addr] <= wr_data;
        end
    end

    // Asynchronous read port 1
    always_comb begin
        rs1_data = rf[rs1_addr];
    end

    // Asynchronous read port 2
    always_comb begin
        rs2_data = rf[rs2_addr];
    end

endmodule
