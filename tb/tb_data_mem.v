`timescale 1ns/1ps

module tb_data_mem;

    reg        clk;
    reg        rst_n;
    reg        MemRead;
    reg        MemWrite;
    reg [31:0] addr;
    reg [31:0] WriteData;

    wire [31:0] ReadData;

    data_mem uut (
        .clk(clk),
        .rst_n(rst_n),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .addr(addr),
        .WriteData(WriteData),
        .ReadData(ReadData)
    );

    always #5 clk = ~clk;

    initial begin

        clk = 0;
        rst_n = 0;
        MemRead = 0;
        MemWrite = 0;
        addr = 0;
        WriteData = 0;

        #2;
        rst_n = 1;

        // Store 123 at address 4
        addr = 32'd4;
        WriteData = 32'd123;
        MemWrite = 1;

        #10;

        MemWrite = 0;

        // Load from address 4
        addr = 32'd4;
        MemRead = 1;

        #1;

        if (ReadData !== 32'd123)
            $display("LW FAIL");
        else
            $display("LW PASS");

        MemRead = 0;

        $finish;
    end

endmodule