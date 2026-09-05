module sign_extend (
    input [15:0] imm,
    output [31:0] extended_imm
);

    assign extended_imm = {{16{imm[15]}}, imm};

endmodule

