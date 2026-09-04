module alu_control (
    input [1:0] ALUOp,
    input [31:0] inst,

    output reg [3:0] ALUCtrl
);

    // Funct (R_type)
    wire [5:0] funct = inst[5:0];

    localparam add_r = 6'h20;
    localparam sub_r = 6'h22;
    localparam and_r = 6'h24;
    localparam or_r = 6'h25;

    always @(*) begin
        case (ALUOp)
            2'b10: case (funct)
                add_r: ALUCtrl = 4'b0010;
                sub_r: ALUCtrl = 4'b0110;
                and_r: ALUCtrl = 4'b0000;
                or_r:  ALUCtrl = 4'b0001;
            endcase
            2'b00: ALUCtrl = 4'b0010; // lw & sw
            2'b01: ALUCtrl = 4'b0110; // beq
            default: ALUCtrl = 4'd0;
        endcase
    end
endmodule