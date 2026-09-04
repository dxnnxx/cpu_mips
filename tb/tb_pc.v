`timescale 1ns/1ps

module tb_pc;

    reg clk, rst_n;
    reg [31:0] next_addr;

    wire [31:0] addr;

    pc uut (
        .clk(clk),
        .rst_n(rst_n),
        .next_addr(next_addr),
        .addr(addr)
    );

    always #5 clk = ~clk;

    initial begin

        clk = 0;
        rst_n = 0;
        next_addr = 0;

        // Reset
        @(posedge clk);
        if (addr !== 32'd0)
            $display("RESET FAIL");
        else
            $display("RESET PASS");

        // Release reset
        rst_n = 1;

        // PC should become 4
        next_addr = 32'd4;

        @(posedge clk);
        if (addr !== 32'd4)
            $display("PC UPDATE FAIL");
        else
            $display("PC UPDATE PASS");

        // PC should become 8
        next_addr = 32'd8;

        @(posedge clk);
        if (addr !== 32'd8)
            $display("SECOND PC UPDATE FAIL");
        else
            $display("SECOND PC UPDATE PASS");

        $finish;
    end

endmodule