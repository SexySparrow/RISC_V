`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/23/2020 05:04:45 PM
// Design Name: 
// Module Name: MEM_WB_reg
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


module MEM_WB_reg(
    input clk, write, reset,
    input RegWrite_in, MemtoReg_in,
    input [31:0] read_data_in,
    input [31:0] address_in,
    input [4:0] rd_in,
    
    output reg RegWrite_out, MemtoReg_out,
    output reg [31:0] read_data_out,
    output reg [31:0] address_out,
    output reg [4:0] rd_out
);
    always@(posedge clk)
    begin
        if (reset)
        begin
            MemtoReg_out <= 1'b0;
            read_data_out <= 32'b0;
            address_out <= 32'b0;
            rd_out <= 5'b0;
            RegWrite_out <= 1'b0;
        end
        else
        begin
            if (write)
            begin
                MemtoReg_out <= MemtoReg_in;
                read_data_out <= read_data_in;
                address_out <= address_in;
                rd_out <= rd_in;
                RegWrite_out <= RegWrite_in;
            end
        end
    end
endmodule
