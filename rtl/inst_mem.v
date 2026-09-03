module inst_mem (
    input [31:0] addr,
    output [31:0] inst
);

    reg [31:0] memory [0:31];

    initial begin 
		// Write instructions
    end

    assign inst = memory[addr >> 2];

endmodule