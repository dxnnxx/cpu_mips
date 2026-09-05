`timescale 1ns/1ps

module tb_sign_extend;

    reg [15:0] imm;
    wire [31:0] extended_imm;

    sign_extend uut(
        .imm(imm),
        .extended_imm(extended_imm)
    );

    initial begin
        $dumpfile("waveform/tb_sign_extend.vcd");
        $dumpvars(0, tb_sign_extend);

        // 1 - positive immediate value
        // inst = {6'h08,5'd0,5'd1,16'd1};
        imm = 16'd1;
        #10;

        $display("Test 1: immediate=%h extended immediate=%h", imm, extended_imm);

        if (extended_imm !== 32'h00000001)
            $display("ERROR: Test 1 failed");
        else
            $display("Test 1 PASS");

        // 2 - negative immediate value
        // inst = {6'h04,5'd5,5'd9,-16'd18}; // -18 = FFEE
        imm = -16'd18;
        #10;

        $display("Test 2: immediate=%h extended immediate=%h", imm, extended_imm);

        if (extended_imm !== 32'hFFFFFFEE)
            $display("ERROR: Test 2 failed");
        else
            $display("Test 2 PASS");

        $finish;
    end
endmodule