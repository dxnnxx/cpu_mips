`timescale 1ns/1ps

module tb_reg_file;

    reg        clk, rst_n;
    reg  [4:0] ReadReg1, ReadReg2;
    reg  [4:0] WriteReg;
    reg  [31:0] WriteData;
    reg        RegWrite;

    wire [31:0] ReadData1, ReadData2;

    reg_file uut (
        .clk(clk),
        .rst_n(rst_n),
        .ReadReg1(ReadReg1),
        .ReadReg2(ReadReg2),
        .WriteReg(WriteReg),
        .WriteData(WriteData),
        .RegWrite(RegWrite),
        .ReadData1(ReadData1),
        .ReadData2(ReadData2)
    );

    // Clock
    always #5 clk = ~clk;

    initial begin

        clk = 0;
        rst_n = 0;
        RegWrite = 0;
        ReadReg1 = 0;
        ReadReg2 = 0;
        WriteReg = 0;
        WriteData = 0;

        #10;

        rst_n = 1;

        // Write 123 to register 5
        WriteReg = 5'd5;
        WriteData = 32'd123;
        RegWrite = 1;

        #10;

        // Stop writing
        RegWrite = 0;

        // Read register 5
        ReadReg1 = 5'd5;

        #1;

        if (ReadData1 !== 32'd123)
            $display("REGISTER WRITE/READ FAIL");
        else
            $display("REGISTER WRITE/READ PASS");


        // Test second read port
        ReadReg2 = 5'd5;

        #1;

        if (ReadData2 !== 32'd123)
            $display("SECOND READ PORT FAIL");
        else
            $display("SECOND READ PORT PASS");


        // Test $zero
        ReadReg1 = 0;

        #1;

        if (ReadData1 !== 32'd0)
            $display("$ZERO FAIL");
        else
            $display("$ZERO PASS");


        // Attempt to write to $zero
        WriteReg = 5'd0;
        WriteData = 32'hFFFFFFFF;
        RegWrite = 1;

        #10;

        RegWrite = 0;
        ReadReg1 = 0;

        #1;

        if (ReadData1 !== 32'd0)
            $display("$ZERO WRITE PROTECTION FAIL");
        else
            $display("$ZERO WRITE PROTECTION PASS");


        $finish;
    end

endmodule