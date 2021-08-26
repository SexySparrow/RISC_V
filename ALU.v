`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/21/2020 03:44:15 PM
// Design Name: 
// Module Name: ALU
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


module ALU(input [3:0] ALUop,
           input [31:0] ina,inb,
           output zero,
           output reg [31:0] out
);
    always@(ALUop, ina, inb)
    begin
        case(ALUop)
            4'b0000: out = ina & inb; // and
            4'b0001: out = ina | inb; // or
            4'b0010: out = ina + inb; // add, lw, sw
            4'b0011: out = ina ^ inb; // xor
            4'b0100: out = ina << inb; // sll, slli
            4'b0101: out = ina >> inb; // srl, srli
            4'b0110: out = ina - inb; // sub, beq, bne
            4'b0111: out = (ina < inb) ? 1 : 0; // sltu, bltu, bgeu
            4'b1000: out = ($signed(ina) < $signed(inb)) ? 1 : 0; // slt, blt, bge
            4'b1001: out = ina >>> inb; // sra, srai
            default: out = 32'b0;
        endcase
    end
    
    assign zero = (out == 32'b0) ? 1 : 0;
endmodule
