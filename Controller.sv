module Controller (
    input  logic [31:0] instruction, 
    output logic        register_write, read_enable,  write_enable, alu_src_A,  alu_src_B,     
    output logic [1:0]  wb_sel,    
    output logic [3:0]  alu_op,      
    output logic [2:0]  branch_type  
);

    // Instruction fields
    logic [4:0]  rs1, rs2, rd;
    logic [6:0]  opcode, func7;
    logic [2:0]  func3;

    // Extract instruction fields
    assign opcode = instruction[6:0];
    assign rd     = instruction[11:7];
    assign func3  = instruction[14:12];
    assign rs1    = instruction[19:15];
    assign rs2    = instruction[24:20];
    assign func7  = instruction[31:25];

    always_comb begin
        // Default values
        register_write   = 0;
        read_enable    = 0;
        write_enable   = 0;
        alu_src_A   = 0;
        alu_src_B   = 0;
        wb_sel      = 2'b00;
        alu_op      = 4'b0000;
        branch_type = 3'b000;

        case (opcode)
            // R-Type Instructions
            7'b0110011: begin
                register_write = 1;
                alu_src_A = 1;
                wb_sel    = 2'b01; // Writeback from ALU result

                case ({func7, func3})
                    {7'b0000000, 3'b000}: alu_op = 4'b0000; // ADD
                    {7'b0100000, 3'b000}: alu_op = 4'b0001; // SUB
                    {7'b0000000, 3'b001}: alu_op = 4'b0010; // SLL
                    {7'b0000000, 3'b101}: alu_op = 4'b0011; // SRL
                    {7'b0100000, 3'b101}: alu_op = 4'b0100; // SRA
                    {7'b0000000, 3'b010}: alu_op = 4'b0101; // SLT
                    {7'b0000000, 3'b011}: alu_op = 4'b0110; // SLTU
                    {7'b0000000, 3'b100}: alu_op = 4'b0111; // XOR
                    {7'b0000000, 3'b110}: alu_op = 4'b1000; // OR
                    {7'b0000000, 3'b111}: alu_op = 4'b1001; // AND
                    default: alu_op = 4'b0000; // Default to ADD
                endcase
            end

            // I-Type Instructions (ALU operations)
            7'b0010011: begin
                register_write = 1;
                alu_src_A = 1;
                alu_src_B = 1; // Use immediate value
                wb_sel    = 2'b01; // Writeback from ALU result

                case (func3)
                    3'b000: alu_op = 4'b0000; // ADDI
                    3'b001: alu_op = 4'b0010; // SLLI
                    3'b101: alu_op = (func7 == 7'b0100000) ? 4'b0100 : 4'b0011; // SRAI or SRLI
                    3'b010: alu_op = 4'b0101; // SLTI
                    3'b011: alu_op = 4'b0110; // SLTIU
                    3'b100: alu_op = 4'b0111; // XORI
                    3'b110: alu_op = 4'b1000; // ORI
                    3'b111: alu_op = 4'b1001; // ANDI
                    default: alu_op = 4'b0000; // Default to ADDI
                endcase
            end

            // I-Type Instructions (Load)
            7'b0000011: begin
                register_write = 1;
                read_enable  = 1;
                alu_src_A = 1;
                alu_src_B = 1; // Use immediate value
                wb_sel    = 2'b10; // Writeback from memory
                alu_op    = 4'b0000; // ADD (for address calculation)
            end

            // S-Type Instructions (Store)
            7'b0100011: begin
                write_enable = 1;
                alu_src_A = 1;
                alu_src_B = 1; // Use immediate value
                alu_op    = 4'b0000; // ADD (for address calculation)
            end

            // B-Type Instructions (Branch)
            7'b1100011: begin
                alu_src_A = 0; // Use PC for branch calculations
                alu_src_B = 1; // Use immediate value
                alu_op    = 4'b0000; // ADD (for address calculation)

                case (func3)
                    3'b000: branch_type = 3'b001; // BEQ
                    3'b001: branch_type = 3'b010; // BNE
                    3'b100: branch_type = 3'b011; // BLT
                    3'b101: branch_type = 3'b100; // BGE
                    3'b110: branch_type = 3'b101; // BLTU
                    3'b111: branch_type = 3'b110; // BGEU
                    default: branch_type = 3'b000; // Default to no branch
                endcase
            end

            // U-Type Instructions (LUI)
            7'b0110111: begin
                register_write = 1;
                alu_src_B = 1; // Use immediate value
                wb_sel    = 2'b01; // Writeback from ALU result
                alu_op    = 4'b1010; // Pass immediate value
            end

            // U-Type Instructions (AUIPC)
            7'b0010111: begin
                register_write = 1;
                alu_src_A = 0; // Use PC
                alu_src_B = 1; // Use immediate value
                wb_sel    = 2'b01; // Writeback from ALU result
                alu_op    = 4'b0000; // ADD (for address calculation)
            end

            // J-Type Instructions (JAL)
            7'b1101111: begin
                register_write = 1;
                alu_src_A = 0; // Use PC
                alu_src_B = 1; // Use immediate value
                wb_sel    = 2'b00; // Writeback from PC + 4
                branch_type = 3'b111; // Unconditional jump
                alu_op    = 4'b0000; // ADD (for address calculation)
            end

            // J-Type Instructions (JALR)
            7'b1100111: begin
                register_write = 1;
                alu_src_A = 1; // Use register value
                alu_src_B = 1; // Use immediate value
                wb_sel    = 2'b00; // Writeback from PC + 4
                branch_type = 3'b111; // Unconditional jump
                alu_op    = 4'b0000; // ADD (for address calculation)
            end


            default: begin
                
            end
        endcase
    end

endmodule