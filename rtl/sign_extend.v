module sign_extend (
    input [31:0] inst,
    output [31:0] extended_imm
);

    wire [15:0] imm = inst[15:0];
    assign extended_imm = {{16{imm[15]}}, imm};

endmodule

