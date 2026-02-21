`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.02.2026 19:52:33
// Design Name: 
// Module Name: instruction_fetch_unit
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


module instruction_fetch_unit(
        input clk, 
    input reset, 
    input beq, bneq, bge, blt, jump,
    input [31:0] imm_address,
    input [31:0] imm_address_jump,
    output reg [31:0] pc,         // Added [31:0]
    output reg [31:0] current_pc  // Added [31:0]
);

    // PC Update Logic
    always @(posedge clk) begin
        if (reset) begin
            pc <= 32'b0;
        end else if (jump) begin
            pc <= pc + imm_address_jump;
        end else if (beq || bneq || bge || blt) begin
            pc <= pc + imm_address;
        end else begin
            pc <= pc + 4;
        end
    end

    // Current PC Logic (Registers the value of PC to memory)
    always @(posedge clk) begin
        if (reset)
            current_pc <= 32'b0;
        else
            current_pc <= pc; // Updates to show the address we are currently fetching
    end

endmodule
