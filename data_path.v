module data_path(
    input clk, rst,
    input [4:0] read_reg_num1, read_reg_num2, write_reg_num1,
    input [5:0] alu_control,
    input jump, beq_control, bne_control,
    input [31:0] imm_val,
    input [3:0] sh_amt, 
    input alu_src, 
    input lb, sw,
    input bgeq_control, blt_control,
    input lui_control,
    input [31:0] imm_val_lui,
    output [4:0] read_data_addr_dm,
    output beq, bneq, bge, blt 
);
    wire [31:0] read_data1, read_data2;
    wire [31:0] write_data_alu; 
    wire [31:0] data_out_mem;   
    wire [31:0] final_write_back_data; 
    wire [31:0] alu_input_2;

    // --- MUXES ---
    assign final_write_back_data = (lb) ? data_out_mem : write_data_alu;
    assign alu_input_2 = (alu_src) ? imm_val : read_data2;

    register_file rfu (
        .clk(clk), .reset(rst),
        .read_reg_num1(read_reg_num1), .read_reg_num2(read_reg_num2), .write_reg_num1(write_reg_num1),
        .write_data_dm(final_write_back_data), 
        .lb(lb), .lui_control(lui_control), .lui_imm_val(imm_val_lui), .jump(jump),
        .read_data1(read_data1), .read_data2(read_data2),
        .sw(sw)
        // Note: read_data_addr_dm removed from here, assigned at bottom
    );

    alu alu_unit(
        .src1(read_data1), 
        .src2(alu_input_2), 
        .alu_control(alu_control), 
        .imm_val_r(imm_val), .sh_amt(sh_amt), 
        .result(write_data_alu)
    );

    data_memory dmu(
        .clk(clk), .rst(rst),
        .wr_addr(write_data_alu[6:2]), // Shift right by 2 to get word index
        .wr_data(read_data2),          // Use the register data directly
        .sw(sw),
        .rd_addr(write_data_alu[6:2]), 
        .data_out(data_out_mem)
    );

    // Final Output Assignments
    assign read_data_addr_dm = write_data_alu[6:2];
    assign beq  = (write_data_alu == 1 && beq_control == 1);
    assign bneq = (write_data_alu == 1 && bne_control == 1);
    
endmodule
