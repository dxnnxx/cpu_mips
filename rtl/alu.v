module alu (
    input [31:0] a, b,
    input [3:0] ALUCtrl,

    output reg [31:0] result,
    output zero
);

    always @(*) begin
        case (ALUCtrl)
            4'b0000: result = a & b; // AND
            4'b0001: result = a | b; // OR
            4'b0010: result = a + b; // ADD
            4'b0110: result = a - b; // SUB
            default: result = 32'd0;
        endcase
    end

    assign zero = (result == 0);

endmodule