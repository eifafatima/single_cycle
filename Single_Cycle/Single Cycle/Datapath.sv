module Datapath(
    input logic clk, reset
);
    logic [31:0] Pc, ALU_out, extended_immediate, instruction, rdata1, rdata2, ALU_result, readdata, writedata;
    logic [4:0] rsource1, rsource2, rdestination;
    logic [6:0] opcode;
    logic [3:0] alu_operation;
    logic [2:0] branch_type;
    logic [1:0] wb_select;
    logic reg_write, read_enable, write_enable, branch_taken, select_A, select_B;


    assign opcode = instruction[6:0];
    assign rsource1 = instruction[19:15];
    assign rsource2 = instruction[24:20];
    assign rdestination = instruction[11:7];
    assign ALU_out = branch_taken ? ALU_result : Pc + 4;

    always_comb begin
         case (wb_select)
            2'b00: writedata = Pc + 4;
            2'b01: writedata = ALU_result;
            2'b10: writedata = readdata;
        endcase
    end

    // Instantiation
    Pc pc_0 (
        clk,
        reset,
        branch_taken ? ALU_result : ALU_out,
        Pc
        );

    Instruction_Memory inst_mem_0 (
        Pc,
        instruction
        );

    Register_File reg_file_0 (
        clk, 
        reg_write, 
        rsource1, 
        rsource2, 
        rdestination, 
        writedata, 
        rdata1, 
        rdata2
        );
        
    ALU alu_0 (
        alu_operation,
        select_A ? rdata1 : Pc, 
        select_B ? extended_immediate : rdata2, 
        ALU_result
        );

    Data_Memory data_mem_0 (
        clk, 
        write_enable, 
        read_enable, 
        ALU_result, 
        rdata2, 
        readdata
        );

    Branch_Condition branch_cond_0 (
        branch_type, 
        rdata1, 
        rdata2, 
        branch_taken
        );

    Controller controller_0 (
        instruction, 
        reg_write, 
        read_enable, 
        write_enable,   
        select_A, 
        select_B, 
        wb_select, 
        alu_operation, 
        branch_type
        );

    Immediate_Generator imd_generator_0 (
        instruction, 
        extended_immediate
        );

endmodule
