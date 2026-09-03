module next_pc (
    input [31:0] addr,
    input [31:0] extended_imm,
    input Branch,
    input Zero,
    output [31:0] next_addr
);

    wire [31:0] pc_plus_4;
    wire [31:0] branch_target;
    wire        take_branch;

    assign pc_plus_4 = pc + 32'd4; // byte addressing

    assign branch_target = pc_plus_4 + (sign_extended_imm << 2);

    assign take_branch = Branch && Zero; // the AND gate

    assign pc_next = take_branch ? branch_target : pc_plus_4;

endmodule