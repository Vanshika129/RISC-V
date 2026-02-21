`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/18/2026 05:03:56 PM
// Design Name: 
// Module Name: instruction_memory
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


module instruction_memory(
        input [31:0] pc , 
        output [31:0] instruction_code
    );
    
    reg[31:0] mem [0:1023];
    
   initial begin
   $readmemh("program.mem",mem);
   end
   
    assign instruction_code = mem[pc[31:2]]; //Pc div by 4
    
endmodule
