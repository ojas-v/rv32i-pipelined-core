
`timescale 1ns / 1ps

module tb_regfile;

    logic clk, rst, wr_en;
    logic [4:0] rd_addr, rs1_addr, rs2_addr;
    logic [31:0] wr_data, rs1_data, rs2_data;

    regfile dut (
        .clk(clk),
        .rst(rst),
        .wr_en(wr_en),
        .rd_addr(rd_addr),
        .wr_data(wr_data),
        .rs1_addr(rs1_addr),
        .rs2_addr(rs2_addr),
        .rs1_data(rs1_data),
        .rs2_data(rs2_data)
    );

    initial clk = 1'b0;
    always #5 clk = ~clk;

    initial begin
        rst = 1'b1;
        wr_en = 1'b0;
        rd_addr = 5'd0;
        wr_data = 32'd0;
        rs1_addr = 5'd0;
        rs2_addr = 5'd0;

        // Reset x0 on a rising clock edge
        repeat (2) @(posedge clk);
        #1;
        if (rs1_data !== 32'd0)
            $fatal(1, "FAIL: x0 is not zero after reset");

        rst = 1'b0;

        // Write 42 to x5
        @(negedge clk);
        wr_en = 1'b1;
        rd_addr = 5'd5;
        wr_data = 32'd42;

        @(posedge clk);
        #1;
        wr_en = 1'b0;

        // Verify asynchronous read
        rs1_addr = 5'd5;
        #1;
        if (rs1_data !== 32'd42)
            $fatal(1, "FAIL: x5 readback incorrect");

        // Write 99 to x6
        @(negedge clk);
        wr_en = 1'b1;
        rd_addr = 5'd6;
        wr_data = 32'd99;

        @(posedge clk);
        #1;
        wr_en = 1'b0;

        // Read x5 and x6 simultaneously
        rs1_addr = 5'd5;
        rs2_addr = 5'd6;
        #1;
        if (rs1_data !== 32'd42 || rs2_data !== 32'd99)
            $fatal(1, "FAIL: simultaneous reads incorrect");

        // Attempt to overwrite x0
        @(negedge clk);
        wr_en = 1'b1;
        rd_addr = 5'd0;
        wr_data = 32'hDEADBEEF;

        @(posedge clk);
        #1;
        wr_en = 1'b0;

        rs1_addr = 5'd0;
        #1;
        if (rs1_data !== 32'd0)
            $fatal(1, "FAIL: x0 was overwritten");

        $display("PASS: all register-file tests passed");
        $finish;
    end

endmodule
