`timescale 1ns/1ps

module tb_next_pc;

    reg [31:0] addr;
    reg [31:0] extended_imm; // sign extended
    reg Branch;
    reg zero;

    wire [31:0] next_addr;

    next_pc uut (
        .addr(addr),
        .extended_imm(extended_imm),
        .Branch(Branch),
        .zero(zero),
        .next_addr(next_addr)
    );

    initial begin

        // -------------------------
        // Normal instruction
        // PC = 8
        // Expected PC+4 = 12
        // -------------------------
        addr = 32'd8;
        extended_imm = 32'd0;
        Branch = 0;
        zero = 0;

        #10;

        if (next_addr !== 32'd12)
            $display("NORMAL PC FAIL");
        else
            $display("NORMAL PC PASS");


        // -------------------------
        // Branch taken
        //
        // PC = 8
        // PC+4 = 12
        // immediate = 2
        // 2 << 2 = 8
        // target = 20
        // -------------------------
        addr = 32'd8;
        extended_imm = 32'd2;
        Branch = 1;
        zero = 1;

        #10;

        if (next_addr !== 32'd20)
            $display("BRANCH TAKEN FAIL");
        else
            $display("BRANCH TAKEN PASS");


        // -------------------------
        // Branch not taken
        // -------------------------
        addr = 32'd8;
        extended_imm = 32'd2;
        Branch = 1;
        zero = 0;

        #10;

        if (next_addr !== 32'd12)
            $display("BRANCH NOT TAKEN FAIL");
        else
            $display("BRANCH NOT TAKEN PASS");


        // -------------------------
        // Negative branch
        //
        // PC = 68
        // PC+4 = 72
        // immediate = -18
        // -18 << 2 = -72
        // target = 0
        // -------------------------
        addr = 32'd68;
        extended_imm = -32'sd18;
        Branch = 1;
        zero = 1;

        #10;

        if (next_addr !== 32'd0)
            $display("NEGATIVE BRANCH FAIL");
        else
            $display("NEGATIVE BRANCH PASS");


        $finish;
    end

endmodule