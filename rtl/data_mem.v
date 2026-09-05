module data_mem (
    input clk,
    input [31:0] addr,
    input [31:0] WriteData,
    input MemWrite, MemRead,

    output [31:0] ReadData
);

    // 32 words x 32 bits
    reg [31:0] memory [0:31];
    integer i;

    // Read
    assign ReadData = MemRead ? memory[addr[5:0] >> 2] : 32'b0; // or 32'bX??

    // Write
    always @(posedge clk) begin // No data reset
        if (MemWrite) begin
            memory[addr[5:0] >> 2] <= WriteData;
        end
    end

endmodule

