module Datapath(
    input logic clk, reset
);
// inc
    logic [31:0] Pc, ALU_out, extended_immediate, instruction, rdata1, rdata2, ALU_result, readdata, writedata;
    logic [31:0] PC_f, PC_e, PC_w, PCplus4, sign_extended;
    logic [31:0] instruction_f, instruction_f_DFF, instruction_e, instruction_w, ALU_result_e, ALU_result_w;
    logic [31:0] rdata1_reg, rdata2_reg, rdata1, rdata2, rdata, wdata, wdata_dm;
    logic [31:0] sel_input_A, sel_input_B;

// c
    logic [4:0] rsource1, rsource2, rdestination;
    logic [6:0] opcode;
    logic [3:0] alu_operation;
    logic [2:0] branch_type;
    logic [1:0] wb_select, writeback_sel_out;
    logic reg_write, read_enable, write_enable, branch_taken, select_A, select_B;
// inc

    logic register_write_w, read_enable_out, write_enable_out, xo_1, xo_2, Flush;

    always_comb begin

        opcode = instruction_e[6:0];
        raddr1 = instruction_e[19:15];
        raddr2 = instruction_e[24:20];
        waddr  = instruction_w[11:7];
        Flush = br_taken ? 1'b1 : 1'b0; 

        rdata1 = xo_1 ? wdata : rdata1_reg;
        rdata2 = xo_2 ? wdata : rdata2_reg;

        sel_input_A = sel_A ? rdata1 : PC_e;
        sel_input_B = sel_B ? sign_extended : rdata2;

        instruction_f = Flush ? 32'h00000013 : instruction_f_DFF;
    end
// c
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
    
    FWD_UNIT fwd_unit_0 (
         reg_wr_w,
         inst_e, 
         inst_w, 
         xo_1, 
         xo_2
         );

    WB_Mux write_back_mux_0 (
        writeback_sel_w, 
        ALU_res_w, 
        rdata, 
        pc_w, 
        wdata
        );

    ControlUnit controlunit_0 (
        clk, 
        rst, 
        register_write_in, 
        write_enable_in, 
        read_enable_in, 
        writeback_sel_in, 
        register_write_out, 
        write_enable_out, 
        read_enable_out, 
        writeback_sel_out
        );
// inc
    DFF dff_0 (clk, rst, PC_f, PC_e);
    DFF dff_1 (clk, rst, instruction_f, instruction_e);
    DFF dff_2 (clk, rst, PC_e, PC_w);
    DFF dff_3 (clk, rst, ALU_result_e, ALU_result_w);
    DFF dff_4 (clk, rst, rdata2, wdata_dm);
    DFF dff_5 (clk, rst, instruction_e, instruction_w);


endmodule
