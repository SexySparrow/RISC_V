`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/21/2020 03:41:16 PM
// Design Name: 
// Module Name: control_path
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


module control_path(
    input [6:0] opcode,
    input control_sel, // semnal provenit din unitatea de detectie a hazardurilor
    output reg MemRead, MemtoReg, MemWrite, RegWrite, Branch, ALUSrc,
    output reg [1:0] ALUop // semnal de control pentru ALU
);

    always@(opcode, control_sel)
    begin
        if (control_sel == 1)
        begin
            ALUSrc = 1'b0;
            MemtoReg = 1'b0;
            RegWrite = 1'b0;
            MemRead = 1'b0;
            MemWrite = 1'b0;
            Branch = 1'b0;
            ALUop = 2'b00;
        end
        else
        begin
            casex(opcode)
                7'b0000011: // lw
                    begin
                        ALUSrc = 1'b1;
                        MemtoReg = 1'b1;
                        RegWrite = 1'b1;
                        MemRead = 1'b1;
                        MemWrite = 1'b0;
                        Branch = 1'b0;
                        ALUop = 2'b00;
                    end
                    
                7'b0100011: // sw
                    begin
                        ALUSrc = 1'b1;
                        MemtoReg = 1'b0;
                        RegWrite = 1'b0;
                        MemRead = 1'b0;
                        MemWrite = 1'b1;
                        Branch = 1'b0;
                        ALUop = 2'b00;
                    end
                
                7'b1100011: // beq
                    begin
                        ALUSrc = 1'b0;
                        MemtoReg = 1'b0;
                        RegWrite = 1'b0;
                        MemRead = 1'b0;
                        MemWrite = 1'b0;
                        Branch = 1'b1;
                        ALUop = 2'b01;
                    end
                
                7'b0110011: // R-format
                    begin
                        ALUSrc = 1'b0;
                        MemtoReg = 1'b0;
                        RegWrite = 1'b1;
                        MemRead = 1'b0;
                        MemWrite = 1'b0;
                        Branch = 1'b0;
                        ALUop = 2'b10;
                    end
                    
                7'b0010011: // R-format (srli, slli, srai)
                    begin
                        ALUSrc = 1'b1;
                        MemtoReg = 1'b0;
                        RegWrite = 1'b1;
                        MemRead = 1'b0;
                        MemWrite = 1'b0;
                        Branch = 1'b0;
                        ALUop = 2'b10;
                    end
                    
                default:
                    begin
                        ALUSrc = 1'b0;
                        MemtoReg = 1'b0;
                        RegWrite = 1'b0;
                        MemRead = 1'b0;
                        MemWrite = 1'b0;
                        Branch = 1'b0;
                        ALUop = 2'b00;
                    end
            endcase
        end
    end
    
endmodule
