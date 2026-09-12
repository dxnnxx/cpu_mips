module mips_pipeline (
    input clk, rst_n

    // output wire [31:0] alu_out
);
    // assign alu_out = ALUresult;

    // =====================================
    // Pipeline registers declaration
    // =====================================

    // IF/ID
    reg [31:0] IF_ID_inst;
    reg [31:0] IF_ID_pc_plus_4;


    // ID/EX
    reg [31:0] ID_EX_pc_plus_4;

    reg [4:0] ID_EX_rs;
    reg [4:0] ID_EX_rt;
    reg [4:0] ID_EX_rd; 
    reg [5:0] ID_EX_funct;

    reg [31:0] ID_EX_extended_imm;

    reg ID_EX_RegDst;
    reg ID_EX_ALUSrc;
    reg ID_EX_MemtoReg;
    reg ID_EX_RegWrite;
    reg ID_EX_MemRead;
    reg ID_EX_MemWrite;
    reg ID_EX_Branch;
    reg [1:0] ID_EX_ALUOp;

    reg [31:0] ID_EX_ReadData1, ID_EX_ReadData2;

    reg [31:0] ID_EX_inst;

    // EX
    wire branch_taken;

    // EX/MEM
    reg [31:0] EX_MEM_ALUresult;

    reg [4:0] EX_MEM_rt;
    reg [4:0] EX_MEM_rd; 

    reg EX_MEM_RegDst;
    reg EX_MEM_MemtoReg;
    reg EX_MEM_MemRead;
    reg EX_MEM_MemWrite;
    reg EX_MEM_RegWrite;

    reg [31:0] EX_MEM_ReadData2;

    reg [31:0] EX_MEM_inst;


    // MEM/WB
    reg [31:0] MEM_WB_MemoryReadData;
    reg [31:0] MEM_WB_ALUresult;
    
    reg MEM_WB_RegDst;
    reg MEM_WB_MemtoReg;

    reg [4:0] MEM_WB_rt;
    reg [4:0] MEM_WB_rd;

    reg [31:0] MEM_WB_inst;


    // === Control signals associated with hazard handling logic ===
    wire [1:0] ForwardA, ForwardB;
    wire PCWrite;
    wire IF_ID_Write;
    wire ControlStall;

    // =====================================
    // IF - Instruction Fetch Stage
    // =====================================

    wire [31:0] addr;
    wire [31:0] next_addr;
    wire [31:0] inst;
    wire [31:0] pc_plus_4;

    pc pc(
        .clk(clk),
        .rst_n(rst_n),
        .PCWrite(PCWrite),
        .next_addr(next_addr),
        .addr(addr)
    );

    inst_mem inst_mem(
        .addr(addr),
        .inst(inst)
    );

    assign pc_plus_4 = addr + 32'd4;

    // =====================================
    // IF/ID flipflops
    // =====================================

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n || branch_taken) begin
            IF_ID_inst <= 32'b0;
            IF_ID_pc_plus_4 <= 32'b0;
        end else if (IF_ID_Write) begin
            IF_ID_inst <= inst;
            IF_ID_pc_plus_4 <= pc_plus_4;
        end
    end

    // =====================================
    // ID - Instruction Decode Stage
    // =====================================

    wire [5:0] opcode = IF_ID_inst[31:26];
    wire [4:0] rs = IF_ID_inst[25:21];
    wire [4:0] rt = IF_ID_inst[20:16];
    wire [4:0] rd = IF_ID_inst[15:11]; 
    wire [5:0] funct = IF_ID_inst[5:0]; 

    wire [15:0] imm = IF_ID_inst[15:0];

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
        .opcode(opcode),
        .RegDst(RegDst),
        .Branch(Branch),
        .MemRead(MemRead),
        .MemtoReg(MemtoReg),
        .MemWrite(MemWrite),
        .ALUSrc(ALUSrc),
        .RegWrite(RegWrite),
        .ALUOp(ALUOp)
    );

    wire [31:0] ReadData1, ReadData2;
    wire [31:0] WriteData;

    wire [4:0] WriteReg;
    
    reg MEM_WB_RegWrite;

    reg_file reg_file(
        .clk(clk),
        .rst_n(rst_n),
        .ReadReg1(rs),
        .ReadReg2(rt),
        .WriteReg(WriteReg),
        .RegWrite(MEM_WB_RegWrite),
        .WriteData(WriteData),
        .ReadData1(ReadData1),
        .ReadData2(ReadData2)
    );

    wire [31:0] extended_imm;

    sign_extend sign_extend(
        .imm(imm),
        .extended_imm(extended_imm)
    );

    hazard_detection hazard_detection(
        .ID_EX_MemRead(ID_EX_MemRead),
        .ID_EX_rt(ID_EX_rt),
        .IF_ID_rs(rs), 
        .IF_ID_rt(rt),
        .PCWrite(PCWrite),
        .IF_ID_Write(IF_ID_Write),
        .ControlStall(ControlStall)
    );

    // =====================================
    // ID/EX flipflops
    // =====================================
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            ID_EX_pc_plus_4 <= 32'b0;

            ID_EX_rs <= 5'b0;
            ID_EX_rt <= 5'b0;
            ID_EX_rd <= 5'b0; 
            ID_EX_funct <= 6'b0;  
            ID_EX_extended_imm <= 32'b0;
            
            ID_EX_RegDst <= 0;
            ID_EX_ALUSrc <= 0;
            ID_EX_MemtoReg <= 0;
            ID_EX_RegWrite <= 0;
            ID_EX_MemRead <= 0;
            ID_EX_MemWrite <= 0;
            ID_EX_Branch <= 0;
            ID_EX_ALUOp <= 2'b0;

            ID_EX_ReadData1 <= 32'b0;
            ID_EX_ReadData2 <= 32'b0;

            ID_EX_inst <= 32'b0;

        end else if (ControlStall || branch_taken) begin
            ID_EX_RegDst   <= 1'b0;
            ID_EX_ALUSrc   <= 1'b0;
            ID_EX_MemtoReg <= 1'b0;
            ID_EX_RegWrite <= 1'b0;
            ID_EX_MemRead  <= 1'b0;
            ID_EX_MemWrite <= 1'b0;
            ID_EX_Branch   <= 1'b0;
            ID_EX_ALUOp    <= 2'b00;

            ID_EX_inst <= 32'b0; // to make the stall more visible in the output
        
        end else begin
            ID_EX_pc_plus_4 <= IF_ID_pc_plus_4;
            
            ID_EX_rs <= rs;
            ID_EX_rt <= rt;
            ID_EX_rd <= rd; 
            ID_EX_funct <= funct;  
            ID_EX_extended_imm <= extended_imm;

            ID_EX_RegDst <= RegDst;
            ID_EX_ALUSrc <= ALUSrc;
            ID_EX_MemtoReg <= MemtoReg;
            ID_EX_RegWrite <= RegWrite;
            ID_EX_MemRead <= MemRead;
            ID_EX_MemWrite <= MemWrite;
            ID_EX_Branch <= Branch;
            ID_EX_ALUOp <= ALUOp;
            
            ID_EX_ReadData1 <= (MEM_WB_RegWrite && (WriteReg != 5'd0) && rs == WriteReg) ? WriteData : ReadData1;
            ID_EX_ReadData2 <= (MEM_WB_RegWrite && (WriteReg != 5'd0) && rt == WriteReg) ? WriteData : ReadData2;

            ID_EX_inst <= IF_ID_inst;
        end
    end

    // =====================================
    // EX - Execution Stage
    // =====================================

    wire [3:0] ALUCtrl;
    wire [31:0] ALUsrc2;
    wire [31:0] ALUresult;
    wire zero;

    alu_control alu_control(
        .ALUOp(ID_EX_ALUOp),
        .funct(ID_EX_funct),
        .ALUCtrl(ALUCtrl)
    );

    forwarding forwarding(
        .EX_MEM_RegWrite(EX_MEM_RegWrite),
        .MEM_WB_RegWrite(MEM_WB_RegWrite),
        .rs(ID_EX_rs),
        .rt(ID_EX_rt),
        .EX_MEM_rd(EX_MEM_rd),
        .MEM_WB_rd(WriteReg),
        .ForwardA(ForwardA),
        .ForwardB(ForwardB)
    );


    // === Forwarding MUXes === --> when we are selecting register values (rs, rt)
    reg [31:0] ALU_input_A, ALU_input_B;
    always @(*) begin
        case (ForwardA)
            2'b00: ALU_input_A = ID_EX_ReadData1;
            2'b10: ALU_input_A = EX_MEM_ALUresult;
            2'b01: ALU_input_A = WriteData;
            default: ALU_input_A = ID_EX_ReadData1;
        endcase

        case (ForwardB)
            2'b00: ALU_input_B = ID_EX_ReadData2;
            2'b10: ALU_input_B = EX_MEM_ALUresult;
            2'b01: ALU_input_B = WriteData;
            default: ALU_input_B = ID_EX_ReadData2;
        endcase
    end


    // Another MUX for B to select immediate value or register value
    assign ALUsrc2 = ID_EX_ALUSrc ? ID_EX_extended_imm : ALU_input_B;
    
    alu alu(
        .a(ALU_input_A),
        .b(ALUsrc2),
        .ALUCtrl(ALUCtrl),
        .result(ALUresult),
        .zero(zero)
    );

    wire [31:0] branch_target;

    assign branch_target = ID_EX_pc_plus_4 + (ID_EX_extended_imm << 2);
    assign branch_taken = ID_EX_Branch && zero;
    assign next_addr = branch_taken ? branch_target : pc_plus_4;

    
    // =====================================
    // EX/MEM flipflops
    // =====================================

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            EX_MEM_ALUresult <= 32'b0;

            EX_MEM_rt <= 5'b0;
            EX_MEM_rd <= 5'b0; 

            EX_MEM_RegDst <= 0;
            EX_MEM_MemtoReg <= 0;
            EX_MEM_MemRead <= 0;
            EX_MEM_MemWrite <= 0;
            EX_MEM_RegWrite <= 0;

            EX_MEM_ReadData2 <= 32'b0;

            EX_MEM_inst <= 32'b0;

        end else begin
            EX_MEM_ALUresult <= ALUresult;

            EX_MEM_rt <= ID_EX_rt;
            EX_MEM_rd <= ID_EX_rd; 

            EX_MEM_RegDst <= ID_EX_RegDst;
            EX_MEM_MemtoReg <= ID_EX_MemtoReg;
            EX_MEM_MemRead <= ID_EX_MemRead;
            EX_MEM_MemWrite <= ID_EX_MemWrite;
            EX_MEM_RegWrite <= ID_EX_RegWrite;

            EX_MEM_ReadData2 <= ID_EX_ReadData2;

            EX_MEM_inst <= ID_EX_inst;
        end
    end

    // =====================================
    // MEM - Memory Access Stage
    // =====================================
    
    wire [31:0] MemoryReadData;

    data_mem data_mem(
        .clk(clk),
        .addr(EX_MEM_ALUresult),
        .WriteData(EX_MEM_ReadData2),
        .MemWrite(EX_MEM_MemWrite),
        .MemRead(EX_MEM_MemRead),
        .ReadData(MemoryReadData)
    );

    // =====================================
    // MEM/WB flipflops
    // =====================================

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            MEM_WB_MemoryReadData <= 0;
            MEM_WB_ALUresult <= 32'b0;

            MEM_WB_RegDst <= 0;
            MEM_WB_MemtoReg <= 0;
            MEM_WB_RegWrite <= 0;
            MEM_WB_rt <= 5'b0;
            MEM_WB_rd <= 5'b0;

            MEM_WB_inst <= 32'b0;

        end else begin
            MEM_WB_MemoryReadData <= MemoryReadData;
            MEM_WB_ALUresult <= EX_MEM_ALUresult;

            MEM_WB_RegDst <= EX_MEM_RegDst;
            MEM_WB_MemtoReg <= EX_MEM_MemtoReg;
            MEM_WB_RegWrite <= EX_MEM_RegWrite;
            MEM_WB_rt <= EX_MEM_rt;
            MEM_WB_rd <= EX_MEM_rd;

            MEM_WB_inst <= EX_MEM_inst;
        end
    end

    // =====================================
    // WB - Write Back Stage
    // =====================================

    assign WriteData = MEM_WB_MemtoReg ? MEM_WB_MemoryReadData : MEM_WB_ALUresult;
    assign WriteReg = MEM_WB_RegDst ? MEM_WB_rd : MEM_WB_rt;

    
endmodule