module mips_single_cycle (
    input clk, rst_n // synchronize the reset signal?
);

    // =========================================
    // Program Counter
    // =========================================

    wire [31:0] addr;
    wire [31:0] next_addr;

    pc pc(
        .clk(clk), 
        .rst_n(rst_n),
        .next_addr(next_addr),
        .addr(addr)
    );


    // =========================================
    // Instruction Memory
    // =========================================

    wire [31:0] inst;

    inst_mem inst_mem(
        .addr(addr), .inst(inst)
    );


    // =========================================
    // Main Control
    // =========================================

    // R-format instruction
    wire [5:0] opcode = inst[31:26]; // 6 bits
    wire [4:0] rs = inst[25:21]; // 5 bits
    wire [4:0] rt = inst[20:16]; // 5 bits
    wire [4:0] rd = inst[15:11]; // 5 bits
    wire [5:0] funct = inst[5:0]; // 6 bits

    // I-format instruction
    wire [15:0] imm = inst[15:0]; // 16 bits

    // Control signals
    wire RegDst;
    wire ALUSrc;
    wire MemtoReg;
    wire RegWrite;
    wire MemRead;
    wire MemWrite;
    wire Branch;
    wire [1:0] ALUOp;

    control control(
        .inst(inst),
        .RegDst(RegDst),
        .Branch(Branch),
        .MemRead(MemRead),
        .MemtoReg(MemtoReg),
        .MemWrite(MemWrite),
        .ALUSrc(ALUSrc),
        .RegWrite(RegWrite),
        .ALUOp(ALUOp)
    );

    // =========================================
    // ALU Control
    // =========================================

    wire [3:0] ALUCtrl;

    alu_control alu_control(
        .ALUOp(ALUOp),
        .inst(inst),
        .ALUCtrl(ALUCtrl)
    );

    // =========================================
    // Register file
    // =========================================
    
    wire [31:0] ReadData1, ReadData2;
    wire [31:0] WriteData;

    wire [4:0] WriteReg;

    // MUX A: Choose destination register
    //        - R-type: rd
    //        - I-type: rt
    assign WriteReg = RegDst ? rd : rt;

    reg_file reg_file(
        .clk(clk),
        .rst_n(rst_n),
        .ReadReg1(inst[25:21]),
        .ReadReg2(inst[20:16]),
        .WriteReg(WriteReg),
        .RegWrite(RegWrite),
        .WriteData(WriteData),
        .ReadData1(ReadData1),
        .ReadData2(ReadData2)
    );


    // =========================================
    // Sign Extension
    // =========================================
    
    wire [31:0] extended_imm;

    sign_extend sign_extend(
        .inst(inst),
        .extended_imm(extended_imm)
    );

    // =========================================
    // ALU
    // =========================================

    wire [31:0] ALUsrc2;
    wire [31:0] ALUresult;
    wire zero;

    // MUX B: Choose ALU second input
    //        - R-type: ReadData2
    //        - beq: extended_imm
    assign ALUsrc2 = ALUSrc ? extended_imm : ReadData2;

    alu alu(
        .a(ReadData1),
        .b(ALUsrc2),
        .ALUCtrl(ALUCtrl),
        .result(ALUresult),
        .zero(zero)
    );

    // =========================================
    // Data Memory
    // =========================================

    wire [31:0] MemoryReadData;

    data_mem data_mem(
        .clk(clk),
        .addr(ALUresult),
        .WriteData(ReadData2),
        .MemWrite(MemWrite),
        .MemRead(MemRead),
        .ReadData(MemoryReadData)
    );

    // =========================================
    // WriteBack MUX
    // =========================================

    assign WriteData = MemtoReg ? MemoryReadData : ALUresult;

    // =========================================
    // Branch / Next PC
    // =========================================

    wire [31:0] branch_target;

    assign branch_target = addr + 32'd4 + (extended_imm << 2);
    assign next_addr = (Branch && zero) ? branch_target : addr + 32'd4; 

endmodule
