module reg_file (
    input clk, rst_n,
    input [4:0] ReadReg1, ReadReg2, WriteReg, // rs, rt, rd for R-Type respectively
    input RegWrite,
    input [31:0] WriteData, // word size = 32 bits

    output [31:0] ReadData1, ReadData2
);

    reg [31:0] registers [0:31]; // 32 registers of 32-bits
    integer i;

    // Combinational reads
    assign ReadData1 = (ReadReg1 == 0) ? 32'b0 : registers[ReadReg1]; // reg $0 stores constant value zero
    assign ReadData2 = (ReadReg2 == 0) ? 32'b0 : registers[ReadReg2];

    // Asynchronous reset, synchronous write
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < 32; i = i + 1)
                registers[i] <= 0; // initialize registers
        end else if (RegWrite && (WriteReg != 5'd0)) begin
            registers[WriteReg] <= WriteData;
        end
    end

endmodule