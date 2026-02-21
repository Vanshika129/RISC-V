`timescale 1ns / 1ps

module tb_top_riscv();

    // Inputs
    reg clk;
    reg reset;

    // Instantiate the Unit Under Test (UUT)
    top uut (
        .clk(clk), 
        .reset(reset)
    );

    // Clock generation: 100MHz (10ns period)
    always #5 clk = ~clk;

    initial begin
        // Initialize Inputs
        clk = 0;
        reset = 1;

        // Wait for global reset to propagate
        #20;
        reset = 0;
        
        $display("---------------------------------------------------");
        $display("Simulation Started: Monitoring PC and Instructions");
        $display("---------------------------------------------------");

        // Run simulation for 200ns
        #1000;

        $display("---------------------------------------------------");
        $display("Simulation Finished.");
        $finish;
    end

    // Monitor internal signals for debugging
    initial begin
        $monitor("Time: %0t | PC: %h | Instr: %h | ALU_Ctrl: %b | beq: %b", 
                 $time, uut.pc, uut.instruction_out, uut.alu_control, uut.beq);
    end
    
    // Optional: Log Register X1 and X2 to see if math is happening
    // Note: These paths must match your module hierarchy exactly
    always @(posedge clk) begin
        if (!reset) begin
            $display("Reg[1]: %h | Reg[2]: %h | Imm: %h", 
                     uut.dpu.rfu.reg_mem[1], 
                     uut.dpu.rfu.reg_mem[2], 
                     uut.imm_val_r);
        end
    end

endmodule
