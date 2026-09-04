module data_mem (
    input clk, rst_n,
    input [31:0] addr,
    input [31:0] WriteData,
    input MemWrite, MemRead,

    output [31:0] ReadData
);

    // 32 words x 32 bits
    reg [31:0] memory [0:31];

    // Read
    assign ReadData = MemRead ? memory[addr[5:0]] : 32'b0; // or 32'bX??

    // Write
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < 32; i = i + 1)
                memory[i] <= 32'b0;
        end else if (MemWrite) begin
            memory[addr[5:0]] <= WriteData;
        end
    end

endmodule

