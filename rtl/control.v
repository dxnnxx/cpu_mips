module control (
    input [31:0] inst,
    
    output reg RegDst, Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite,
    output reg [1:0] ALUOp
);

    // Opcode
    wire [5:0] opcode = inst[31:26];

    localparam RType = 6'h00;
    localparam lw = 6'h23;
    localparam sw = 6'h2B;
    localparam beq = 6'h04;


    always @(*) begin
        // initialize control signals to 0 (deactivated)
        ALUOp=2'b00;
		RegDst=1'b0;
        Branch=1'b0;
        MemRead=1'b0;
        MemtoReg=1'b0;
		MemWrite=1'b0;
		ALUSrc=1'b0;
        RegWrite=1'b0;

        if (inst != 0) begin
            case(opcode)
                RType: begin
                    ALUOp = 2'b10;
                    RegDst = 1'b1;
                    RegWrite = 1'b1;
                end
                lw: begin
                    ALUOp = 2'b00;
                    MemRead = 1'b1;
                    ALUSrc = 1'b1;
                    MemtoReg = 1'b1;
                    RegWrite = 1'b1;
                end
                sw: begin
                    ALUOp = 2'b00;
                    MemWrite = 1'b1;
                    ALUSrc = 1'b1;
                end
                beq: begin
                    ALUOp = 2'b01;
                    Branch = 1'b1;
                end
            endcase
        end
		
    end
    


endmodule