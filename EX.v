`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/21/2020 03:45:18 PM
// Design Name: 
// Module Name: EX
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module EX(
    input [31:0] IMM_EX,         
    input [31:0] REG_DATA1_EX,
    input [31:0] REG_DATA2_EX,
    input [31:0] PC_EX,
    input [2:0] FUNCT3_EX,
    input [6:0] FUNCT7_EX,
    input [4:0] RD_EX,
    input [4:0] RS1_EX,
    input [4:0] RS2_EX,
    input RegWrite_EX,
    input MemtoReg_EX,
    input MemRead_EX,
    input MemWrite_EX,
    input [1:0] ALUop_EX,
    input ALUSrc_EX,
    input Branch_EX,
    input [1:0] forwardA, forwardB,
          
    input [31:0] ALU_DATA_WB,
    input [31:0] ALU_OUT_MEM,
      
    output ZERO_EX,
    output [31:0] ALU_OUT_EX,
    output [31:0] PC_Branch_EX,
    output [31:0] REG_DATA2_EX_FINAL
);
    wire [3:0] ALU_control_wire;
    wire [31:0] mux_4_1_a_out, mux_4_1_b_out, mux21_out;
    
    ALUcontrol aluControl(ALUop_EX, FUNCT7_EX, FUNCT3_EX, ALU_control_wire);
    
    mux_4_1 mux_4_1_a(REG_DATA1_EX, ALU_DATA_WB, ALU_OUT_MEM, 32'b0, forwardA, mux_4_1_a_out);                  
    mux_4_1 mux_4_1_b(REG_DATA2_EX, ALU_DATA_WB, ALU_OUT_MEM, 32'b0, forwardB, mux_4_1_b_out);
    
    mux2_1 mux_2_1(mux_4_1_b_out, IMM_EX, ALUSrc_EX, mux21_out);
    
    adder adder_u(PC_EX, IMM_EX, PC_Branch_EX);
    
    ALU alu_u(ALU_control_wire, mux_4_1_a_out, mux21_out, ZERO_EX, ALU_OUT_EX);
    
    assign REG_DATA2_EX_FINAL = mux_4_1_b_out;
endmodule
