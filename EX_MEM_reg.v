`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/23/2020 02:27:47 PM
// Design Name: 
// Module Name: EX_MEM_reg
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


module EX_MEM_reg(
    input clk, write, reset,
    input RegWrite_in, MemRead_in, MemtoReg_in, MemWrite_in, Branch_in,
    input [31:0] ALU_OUT_EX_in,
    input ZERO_EX_in,
    input [31:0] PC_Branch_EX_in,
    input [31:0] REG_DATA2_EX_FINAL_in,
    input [4:0] rd_in,
    
    output reg RegWrite_out, MemRead_out, MemtoReg_out, MemWrite_out, Branch_out,
    output reg [31:0] ALU_OUT_EX_out,
    output reg ZERO_EX_out,
    output reg [31:0] PC_Branch_EX_out,
    output reg [31:0] REG_DATA2_EX_FINAL_out,
    output reg [4:0] rd_out
);
    always@(posedge clk)
    begin
        if (reset)
        begin
            RegWrite_out <= 1'b0;
            MemRead_out <= 1'b0;
            MemtoReg_out <= 1'b0;
            MemWrite_out <= 1'b0;
            Branch_out <= 1'b0;
            ALU_OUT_EX_out <= 32'b0;
            ZERO_EX_out <= 1'b0;
            PC_Branch_EX_out <= 32'b0;
            REG_DATA2_EX_FINAL_out <= 32'b0;
            rd_out <= 5'b0;
        end
        else
        begin
            if (write)
            begin
                RegWrite_out <= RegWrite_in;
                MemRead_out <= MemRead_in;
                MemtoReg_out <= MemtoReg_in;
                MemWrite_out <= MemWrite_in;
                Branch_out <= Branch_in;
                ALU_OUT_EX_out <= ALU_OUT_EX_in;
                ZERO_EX_out <= ZERO_EX_in;
                PC_Branch_EX_out <= PC_Branch_EX_in;
                REG_DATA2_EX_FINAL_out <= REG_DATA2_EX_FINAL_in;
                rd_out <= rd_in;
            end
        end
    end
endmodule
