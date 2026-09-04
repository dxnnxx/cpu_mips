`timescale 1ns/1ps

module tb_control;

    reg [31:0] inst;

    wire       RegDst;
    wire       ALUSrc;
    wire       MemtoReg;
    wire       RegWrite;
    wire       MemRead;
    wire       MemWrite;
    wire       Branch;
    wire [1:0] ALUOp;

    control uut (
        .inst(inst),
        .RegDst(RegDst),
        .ALUSrc(ALUSrc),
        .MemtoReg(MemtoReg),
        .RegWrite(RegWrite),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .Branch(Branch),
        .ALUOp(ALUOp)
    );

    initial begin

        // R-type: opcode = 000000
        inst = {6'h00,5'd0,5'd1,5'd5,5'h0,6'h20};
        #10;

        if (RegDst !== 1'b1 ||
            ALUSrc !== 1'b0 ||
            MemtoReg !== 1'b0 ||
            RegWrite !== 1'b1 ||
            MemRead !== 1'b0 ||
            MemWrite !== 1'b0 ||
            Branch !== 1'b0 ||
            ALUOp !== 2'b10)

            $display("R-TYPE FAIL");
        else
            $display("R-TYPE PASS");


        // LW: opcode = 100011
        inst = {6'h23,5'd0,5'd9 ,16'd1};
        #10;

        if (RegDst !== 1'b0 ||
            ALUSrc !== 1'b1 ||
            MemtoReg !== 1'b1 ||
            RegWrite !== 1'b1 ||
            MemRead !== 1'b1 ||
            MemWrite !== 1'b0 ||
            Branch !== 1'b0 ||
            ALUOp !== 2'b00)

            $display("LW FAIL");
        else
            $display("LW PASS");


        // SW: opcode = 101011
        inst = {6'h2B,5'd0,5'd5,16'd1};
        #10;

        if (ALUSrc !== 1'b1 ||
            RegWrite !== 1'b0 ||
            MemRead !== 1'b0 ||
            MemWrite !== 1'b1 ||
            Branch !== 1'b0 ||
            ALUOp !== 2'b00)

            $display("SW FAIL");
        else
            $display("SW PASS");


        // BEQ: opcode = 000100
        inst = {6'h04,5'd5,5'd9,-16'd18};
        #10;

        if (ALUSrc !== 1'b0 ||
            RegWrite !== 1'b0 ||
            MemRead !== 1'b0 ||
            MemWrite !== 1'b0 ||
            Branch !== 1'b1 ||
            ALUOp !== 2'b01)

            $display("BEQ FAIL");
        else
            $display("BEQ PASS");

        $finish;
    end

endmodule