module Datapath(
    input logic clk, reset
);
    logic [31:0] Pc_f, Pc_e, Pc_w, ALU_out, extended_immediate;
    logic [31:0] instruction_f, instruction_f_DFF, instruction_e, instruction_w, ALU_result_e, ALU_result_w;
    logic [31:0] rdata1_register, rdata2_register, rdata1, rdata2, readdata, writedata, writedata_dm;
    logic [4:0] rsource1, rsource2, rdestination;
    logic [6:0] opcode;
    logic [3:0] alu_operation;
    logic [2:0] branch_type;
    logic [1:0] writeback_sel_w, writeback_sel;
    logic reg_write, read_enable, write_enable, branch_taken, select_A, select_B;
    logic reg_write_w, read_enable_w, write_enable_w, xo1, xo2, Flush;

    assign opcode = instruction_e[6:0];
    assign rsource1 = instruction_e[19:15];
    assign rsource2 = instruction_e[24:20];
    assign rdestination = instruction_w[11:7];
    assign ALU_out = branch_taken ? ALU_result_e : Pc_f + 4;
    assign Flush = branch_taken ? 1'b1 : 1'b0; 
    assign rdata1 = xo1 ? writedata : rdata1_register;
    assign rdata2 = xo2 ? writedata : rdata2_register;
    assign instruction_f = Flush ? 32'h00000013 : instruction_f_DFF;

    always_comb begin

        case (writeback_sel_w)
            2'b00: writedata = Pc_w + 4;
            2'b01: writedata = ALU_result_w;
            2'b10: writedata = readdata;
        endcase
        
    end

    // Instantiation
    
    Pc pc_0 (
        clk, 
        reset, 
        ALU_out, 
        Pc_f
        );

    Instruction_Memory inst_mem_0 (
        Pc_f, 
        instruction_f_DFF
        );

    Register_File reg_file_0 (
        clk, 
        reg_write_w, 
        rsource1, 
        rsource2, 
        rdestination, 
        writedata, 
        rdata1_register, 
        rdata2_register
        );

    ALU alu_0 (
        alu_operation, 
        select_A ? rdata1 : Pc_e, 
        select_B ? extended_immediate : rdata2, 
        ALU_result_e
        );

    Data_Memory data_mem_0 (
        clk, 
        write_enable_w, 
        read_enable_w, 
        ALU_result_w, 
        writedata_dm, 
        readdata
        );

    Branch_Condition branch_condition_0 (
        branch_type, 
        rdata1, 
        rdata2, 
        branch_taken
        );

    FWD_UNIT forwarding_unit_0 ( 
        reg_write_w, 
        instruction_e, 
        instruction_w, 
        xo1, 
        xo2
        );

    Immediate_Generator immediate_generator_0 (
        instruction_e, 
        extended_immediate
        );

    Controller controller_0 (
        instruction_e, 
        reg_write, 
        read_enable, 
        write_enable, 
        select_A, 
        select_B, 
        writeback_sel, 
        alu_operation, 
        branch_type
        );

    ControlUnit control_unit_0 (
        clk, 
        reset, 
        reg_write, 
        write_enable, 
        read_enable, 
        writeback_sel, 
        reg_write_w, 
        write_enable_w, 
        read_enable_w, 
        writeback_sel_w
        );

    DFF dff_00 (
        clk, 
        reset, 
        Pc_f, 
        Pc_e
        );

    DFF dff_01 (
        clk, 
        reset, 
        instruction_f, 
        instruction_e
        );

    DFF dff_02 (
        clk, 
        reset, 
        Pc_e, 
        Pc_w
        );

    DFF dff_03 (
        clk, 
        reset, 
        ALU_result_e, 
        ALU_result_w
        );

    DFF dff_04 (
        clk, 
        reset, 
        rdata2, 
        writedata_dm
        );

    DFF dff_05 (
        clk, 
        reset, 
        instruction_e, 
        instruction_w
        );


endmodule
