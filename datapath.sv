module datapath (
    input  logic        clock,             
    input  logic        reset          
);

 
    logic [31:0] pc , ALU_out, extended_immediate, instruction;
    logic [31:0] rdata1, rdata2, alu_result, read_data, write_data;
    logic [4:0]  source_reg_1, source_reg_2, destination_reg;
    logic [6:0]  opcode;
    logic [3:0]  alu_control;
    logic [2:0]  branch_type;
    logic [1:0]  writeback_select;
    logic        register_write, read_enable, write_enable, branch_taken;
    logic        alu_src_A, alu_src_B;

    pc pc_module (
        clock,reset,branch_taken ? alu_result : ALU_out,pc
    );

    Instruction_Memory inst_mem_0 (
        pc,instruction
    );

    Register_File reg_file_0 (
        clock,register_write,source_reg_1,source_reg_2,destination_reg,write_data,rdata1,rdata2
    );

    ALU alu_module (
        alu_control,alu_src_A ? rdata1 : pc,alu_src_B ? extended_immediate : rdata2,alu_result
    );

    Data_Memory data_mem_0 (
        clock,write_enable,read_enable,alu_result,rdata2,read_data
    );

    Branch_Condition branch_condition_0(
                 branch_type,rdata1,rdata2,branch_taken
    );

    Controller control_unit_0(
        instruction,register_write,read_enable,write_enable,alu_src_A,alu_src_B,writeback_select,alu_control,branch_type
    );

    Immediate_Generator immediate_generator_0 (
       instruction,extended_immediate
    );

    // Assignments
    assign opcode = instruction[6:0];
    assign source_reg_1 = instruction[19:15];
    assign source_reg_2 = instruction[24:20];
    assign destination_reg = instruction[11:7];
    assign ALU_out = branch_taken ? alu_result : pc + 4;

    // Writeback logic
    always_comb begin
        case (writeback_select)
            2'b00: write_data = pc + 4; 
            2'b01: write_data = alu_result;          // ALU result
            2'b10: write_data = read_data;    // Memory read data
            default: write_data = 32'b0;             // Default case
        endcase
    end

endmodule