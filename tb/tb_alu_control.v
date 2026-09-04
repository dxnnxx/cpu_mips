`timescale 1ns/1ps

module tb_alu_control;
    reg [1:0] ALUOp;
    reg [31:0] inst;
    wire [3:0] ALUCtrl;

    alu_control uut(
        .ALUOp(ALUOp),
        .inst(inst),
        .ALUCtrl(ALUCtrl)
    );

    initial begin
        // R-type add
        ALUOp = 2'b10; // R-type
        inst = {6'h00,5'd0,5'd1,5'd5,5'h0,6'h20}; // the least significant 6 bits are the funct field
        #10;

        if (ALUCtrl !== 4'b0010)
            $display("ADD FAIL\n");
        else
            $display("ADD PASS\n");

        // R-type sub
        ALUOp = 2'b10; // R-type
        inst = {6'h00,5'd0,5'd1,5'd5,5'h0,6'h22}; // the least significant 6 bits are the funct field
        #10;

        if (ALUCtrl !== 4'b0110)
            $display("SUB FAIL\n");
        else
            $display("SUB PASS\n");

        // R-type and
        ALUOp = 2'b10; // R-type
        inst = {6'h00,5'd0,5'd1,5'd5,5'h0,6'h24}; // the least significant 6 bits are the funct field
        #10;

        if (ALUCtrl !== 4'b0000)
            $display("AND FAIL\n");
        else
            $display("AND PASS\n");

        // R-type or
        ALUOp = 2'b10; // R-type
        inst = {6'h00,5'd0,5'd1,5'd5,5'h0,6'h25}; // the least significant 6 bits are the funct field
        #10;

        if (ALUCtrl !== 4'b0001)
            $display("OR FAIL\n");
        else
            $display("OR PASS\n");

        $finish;
    end

endmodule