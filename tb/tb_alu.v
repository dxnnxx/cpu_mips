`timescale 1ns/1ps

module tb_alu;

    reg  [31:0] a;
    reg  [31:0] b;
    reg  [3:0]  ALUCtrl;

    wire [31:0] result;
    wire        zero;

    alu uut (
        .a(a),
        .b(b),
        .ALUCtrl(ALUCtrl),
        .result(result),
        .zero(zero)
    );

    initial begin

        $dumpfile("waveform/tb_alu.vcd");
        $dumpvars(0, tb_alu);

        // === ADD ===
        a = 32'd10;
        b = 32'd5;
        ALUCtrl = 4'b0010;

        #10;

        $display("ADD: a=%d b=%d result=%d zero=%b",
                 a, b, result, zero);
        
        if (result == 32'd15) begin
            $display("ADD PASSED\n");
        end else begin
            $display("ADD FAILED\n");
        end

        // === SUB ===
        a = 32'd10;
        b = 32'd5;
        ALUCtrl = 4'b0110;

        #10;

        $display("SUB: a=%d b=%d result=%d zero=%b",
                 a, b, result, zero);
        
        if (result == 32'd5) begin
            $display("SUB PASSED\n");
        end else begin
            $display("SUB FAILED\n");
        end

        // === SUB producing zero ===
        a = 32'd10;
        b = 32'd10;
        ALUCtrl = 4'b0110;

        #10;

        $display("SUB: a=%d b=%d result=%d zero=%b",
                 a, b, result, zero);
        
        if (result == 32'd0) begin
            $display("SUB producing zero PASSED\n");
        end else begin
            $display("SUB producing zero FAILED\n");
        end      


        // --------------------------------
        // AND
        // --------------------------------
        a = 32'hFFFF0000;
        b = 32'h0F0F0F0F;
        ALUCtrl = 4'b0000;

        #10;

        $display("AND: A=%h B=%h result=%h Zero=%b",
                 a, b, result, zero);


        // --------------------------------
        // OR
        // --------------------------------
        a = 32'hFFFF0000;
        b = 32'h0000FFFF;
        ALUCtrl = 4'b0001;

        #10;

        $display("OR: A=%h B=%h result=%h Zero=%b",
                 a, b, result, zero);


        // --------------------------------
        // Finish simulation
        // --------------------------------
        $finish;

    end

endmodule