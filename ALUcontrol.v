`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/21/2020 03:42:36 PM
// Design Name: 
// Module Name: ALUcontrol
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


module ALUcontrol(input [1:0] ALUop,
                  input [6:0] funct7,
                  input [2:0] funct3,
                  output reg [3:0] ALUinput
);
    always@(ALUop, funct7, funct3)
    begin
        casex({ALUop, funct7, funct3})
            12'b00xxxxxxx010: ALUinput = 4'b0010; // lw, sw
            12'b100000000000: ALUinput = 4'b0010; // add
            12'b100100000000: ALUinput = 4'b0110; // sub
            12'b100000000111: ALUinput = 4'b0000; // and
            12'b100000000110: ALUinput = 4'b0001; // or
            12'b100000000100: ALUinput = 4'b0011; // xor
            12'b100000000101: ALUinput = 4'b0101; // srl, srli
            12'b100000000001: ALUinput = 4'b0100; // sll, slli
            12'b100100000101: ALUinput = 4'b1001; // sra, srai
            12'b100000000011: ALUinput = 4'b0111; // sltu
            12'b100000000010: ALUinput = 4'b1000; // slt
            12'b01xxxxxxx000: ALUinput = 4'b0110; // beq
            12'b01xxxxxxx001: ALUinput = 4'b0110; // bne
            12'b01xxxxxxx100: ALUinput = 4'b1000; // blt
            12'b01xxxxxxx101: ALUinput = 4'b1000; // bge
            12'b01xxxxxxx110: ALUinput = 4'b0111; // bltu
            12'b01xxxxxxx111: ALUinput = 4'b0111; // bgeu
        endcase
    end
endmodule
