//////////////////////////////////////////////RISC-V_MODULE///////////////////////////////////////////////////
module RISC_V(input clk,
              input reset,
              
              output [31:0] PC_EX,
              output [31:0] ALU_OUT_EX,
              output [31:0] PC_MEM,
              output PCSrc,
              output [31:0] DATA_MEMORY_MEM,
              output [31:0] ALU_DATA_WB,
              output [1:0] forwardA, forwardB,
              output pipeline_stall
);

//////////////////////////////////////////IF signals////////////////////////////////////////////////////////
    wire [31:0] PC_IF;               //current PC
    wire [31:0] INSTRUCTION_IF;
    wire PCSrc_wire;
    wire [31:0] PC_Branch;
    wire PC_write;
    wire IF_ID_write;
    
    wire [31:0] PC_ID, INSTRUCTION_ID;
    wire [31:0] IMM_ID;
    wire [31:0] REG_DATA1_ID, REG_DATA2_ID;
    wire [2:0] FUNCT3_ID;
    wire [6:0] FUNCT7_ID;
    wire [6:0] OPCODE_ID;
    wire [4:0] RD_ID;
    wire [4:0] RS1_ID;
    wire [4:0] RS2_ID;
    wire [1:0] ALUop_ID;
    wire MemRead_ID, MemtoReg_ID, MemWrite_ID, RegWrite_ID, Branch_ID, ALUSrc_ID;
        
    wire [31:0] PC_EX_wire;
    wire [31:0] IMM_EX;
    wire [31:0] REG_DATA1_EX, REG_DATA2_EX;
    wire RegWrite_EX, MemtoReg_EX, MemRead_EX, MemWrite_EX;
    wire Branch_EX;
    wire [1:0] ALUop_EX;
    wire ALUSrc_EX;
    wire [2:0] FUNCT3_EX;
    wire [6:0] FUNCT7_EX;
    wire [4:0] RD_EX;
    wire [4:0] RS1_EX;
    wire [4:0] RS2_EX;
    wire [31:0] ALU_OUT_EX_wire;
    wire ZERO_EX;
    wire [31:0] PC_Branch_EX;
    wire [31:0] REG_DATA2_EX_FINAL;
    
    wire RegWrite_MEM, MemRead_MEM, MemtoReg_MEM, MemWrite_MEM, Branch_MEM;
    wire [31:0] ALU_OUT_MEM;
    wire ZERO_MEM;
    wire [31:0] REG_DATA2_MEM_FINAL;
    wire [4:0] RD_MEM;
    wire [31:0] DATA_MEMORY_MEM_wire;
    
    wire MemtoReg_WB;
    wire RegWrite_WB;
    wire [31:0] DATA_MEMORY_WB;
    wire [31:0] ALU_OUT_WB;
    wire [4:0] RD_WB;
    wire [31:0] ALU_DATA_WB_wire;
    
    wire [1:0] forwardA_wire, forwardB_wire;
    wire pipeline_stall_wire;
/////////////////////////////////////IF Module/////////////////////////////////////
    IF instruction_fetch(clk, reset, 
                      PCSrc_wire, PC_write,
                      PC_Branch,
                      PC_IF,INSTRUCTION_IF);

  
//////////////////////////////////////pipeline registers////////////////////////////////////////////////////
    IF_ID_reg IF_ID_REGISTER(clk,reset,
                          IF_ID_write,
                          PC_IF,INSTRUCTION_IF,
                          PC_ID,INSTRUCTION_ID);
                      
    ID_EX_reg ID_EX_register(
        clk, 1'b1, reset,
        RegWrite_ID, MemtoReg_ID, MemRead_ID, MemWrite_ID, Branch_ID, ALUop_ID,
        ALUSrc_ID,
        PC_ID, REG_DATA1_ID, REG_DATA2_ID, IMM_ID,
        RS1_ID, RS2_ID, RD_ID,
        FUNCT3_ID, FUNCT7_ID,
        
        RegWrite_EX, MemtoReg_EX, MemRead_EX, MemWrite_EX, Branch_EX, ALUop_EX,
        ALUSrc_EX,
        PC_EX_wire, REG_DATA1_EX, REG_DATA2_EX, IMM_EX,
        RS1_EX, RS2_EX, RD_EX,
        FUNCT3_EX, FUNCT7_EX        
    );
    
    EX_MEM_reg EX_MEM_register(
        clk, 1'b1, reset,
        RegWrite_EX, MemRead_EX, MemtoReg_EX, MemWrite_EX, Branch_EX,
        ALU_OUT_EX_wire,
        ZERO_EX,
        PC_Branch_EX,
        REG_DATA2_EX_FINAL,
        RD_EX,
        RegWrite_MEM, MemRead_MEM, MemtoReg_MEM, MemWrite_MEM, Branch_MEM,
        ALU_OUT_MEM,
        ZERO_MEM,
        PC_Branch,
        REG_DATA2_MEM_FINAL,
        RD_MEM
    );
    
    MEM_WB_reg MEM_WB_register(
        clk, 1'b1, reset,
        RegWrite_MEM, MemtoReg_MEM,
        DATA_MEMORY_MEM_wire,
        ALU_OUT_MEM,
        RD_MEM,
        RegWrite_WB, MemtoReg_WB,
        DATA_MEMORY_WB,
        ALU_OUT_WB,
        RD_WB
    );
  
////////////////////////////////////////ID Module//////////////////////////////////
    ID instruction_decode(clk,
                           PC_ID,INSTRUCTION_ID,
                           RegWrite_WB, 
                           ALU_DATA_WB_wire,
                           RD_WB,
                           IMM_ID,
                           REG_DATA1_ID,REG_DATA2_ID,
                           FUNCT3_ID,
                           FUNCT7_ID,
                           OPCODE_ID,
                           RD_ID,
                           RS1_ID,
                           RS2_ID);
    
    hazard_detection hazard_detection_unit(
        RD_EX,
        RS1_ID,
        RS2_ID,
        MemRead_EX,
        PC_write,
        IF_ID_write,
        pipeline_stall_wire
    );
    
    control_path control_path_unit(
        OPCODE_ID,
        pipeline_stall_wire,
        MemRead_ID, MemtoReg_ID, MemWrite_ID, RegWrite_ID, Branch_ID, ALUSrc_ID,
        ALUop_ID
    );
    
/////////////////////////// EX Module //////////////////////////////////////////////////////
    EX ex_unit(
        IMM_EX,
        REG_DATA1_EX,
        REG_DATA2_EX,
        PC_EX_wire,
        FUNCT3_EX,
        FUNCT7_EX,
        RD_EX,
        RS1_EX,
        RS2_EX,
        RegWrite_EX,
        MemtoReg_EX,
        MemRead_EX,
        MemWrite_EX,
        ALUop_EX,
        ALUSrc_EX,
        Branch_EX,
        forwardA_wire, forwardB_wire,
        ALU_DATA_WB_wire, ALU_OUT_MEM,
        ZERO_EX,
        ALU_OUT_EX_wire,
        PC_Branch_EX,
        REG_DATA2_EX_FINAL
    );
    
    forwarding forwarding_unit(
        RS1_EX,
        RS2_EX,
        RD_MEM,
        RD_WB,
        RegWrite_MEM,
        RegWrite_WB,
        forwardA_wire, forwardB_wire
    );
    
////////////////////////// MEM Module ////////////////////////////////////////////////////////
    data_memory data_memory_unit(
        clk,
        MemRead_MEM,
        MemWrite_MEM,
        ALU_OUT_MEM >> 2,
        REG_DATA2_MEM_FINAL,
        DATA_MEMORY_MEM_wire
    );
    
    and(PCSrc_wire, Branch_MEM, ZERO_MEM);
    
/////////////////////////// WB Module ////////////////////////////////////////////////////////
    mux2_1 mux21_WB(
        ALU_OUT_WB,
        DATA_MEMORY_WB,
        MemtoReg_WB,
        ALU_DATA_WB_wire
    );
    
    assign PC_EX = PC_EX_wire;
    assign ALU_OUT_EX = ALU_OUT_EX_wire;
    assign PC_MEM = PC_Branch;
    assign PCSrc = PCSrc_wire;
    assign DATA_MEMORY_MEM = DATA_MEMORY_MEM_wire;
    assign ALU_DATA_WB = ALU_DATA_WB_wire;
    assign forwardA = forwardA_wire;
    assign forwardB = forwardB_wire;
    assign pipeline_stall = pipeline_stall_wire;
endmodule
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
