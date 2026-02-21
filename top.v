`timescale 1ns / 1ps
`include "defines.vh"

module top(
    input clk,
    input reset
);

    // --- Internal Wires ---
    wire [31:0] pc;
    wire [31:0] current_pc;
    wire [31:0] instruction_out;
    wire [31:0] imm_val_r;
    
    // Control Signals
    wire [5:0] alu_control;
    wire lb, mem_to_reg, bneq_control, beq_control, bgeq_control, blt_control;
    wire jump, sw, lui_control;
    wire alu_src; // <--- NEW WIRE ADDED HERE
    
    // Status Signals from Datapath to IFU
    wire beq, bneq, bge, blt;
    wire [4:0] read_data_addr_dm; 

    // --- 1. Instruction Fetch Unit ---
    instruction_fetch_unit ifu (
        .clk(clk),
        .reset(reset),
        .beq(beq),
        .bneq(bneq),
        .bge(bge),
        .blt(blt),
        .jump(jump),
        .imm_address(imm_val_r),
        .imm_address_jump(imm_val_r),
        .pc(pc),
        .current_pc(current_pc)
    );

    // --- 2. Instruction Memory ---
    instruction_memory imu (
        .pc(pc),
        .instruction_code(instruction_out)
    );

    // --- 3. Immediate Generator ---
    imm_gen ig (
        .instr_memory(instruction_out),
        .imm_val_r(imm_val_r)
    );

    // --- 4. Control Unit ---
    control_unit cu (
        .reset(reset),
        .funct7(instruction_out[31:25]),
        .funct3(instruction_out[14:12]),
        .opcode(instruction_out[6:0]),
        .alu_control(alu_control),
        .lb(lb),
        .mem_to_reg(mem_to_reg),
        .bneq_control(bneq_control),
        .beq_control(beq_control),
        .bgeq_control(bgeq_control),
        .blt_control(blt_control),
        .jump(jump),
        .sw(sw),
        .lui_control(lui_control),
        .alu_src(alu_src) // <--- CONNECTED OUTPUT FROM CU
    );

    // --- 5. Data Path ---
    data_path dpu (
        .clk(clk),
        .rst(reset),
        .read_reg_num1(instruction_out[19:15]),
        .read_reg_num2(instruction_out[24:20]),
        .write_reg_num1(instruction_out[11:7]),
        .alu_control(alu_control),
        .alu_src(alu_src), // <--- CONNECTED INPUT TO DATAPATH
        .jump(jump),
        .beq_control(beq_control),
        .bne_control(bneq_control),
        .imm_val(imm_val_r),
        .sh_amt(instruction_out[24:21]),
        .lb(lb),
        .sw(sw),
        .bgeq_control(bgeq_control),
        .blt_control(blt_control),
        .lui_control(lui_control),
        .imm_val_lui(imm_val_r),
        .read_data_addr_dm(read_data_addr_dm),
        .beq(beq),
        .bneq(bneq),
        .bge(bge),
        .blt(blt)
    );

endmodule
