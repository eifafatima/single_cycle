module Controller (
    input logic [31:0] inst,
    output logic register_write, read_enable, write_enable, select_A, select_B,
    output logic [1:0] wb_select,
    output logic [3:0] alu_operation,
    output logic [2:0] branch_type
);
    logic [4:0] rsource1, rsource2, rdestination;
    logic [6:0] opcode, func7;
    logic [2:0] func3;

    assign opcode = inst[6:0];
    assign rdestination = inst[11:7];
    assign func3 = inst[14:12];
    assign rsource1 = inst[19:15];
    assign rsource2 = inst[24:20];
    assign func7 = inst[31:25];


    always_comb begin
        case (opcode)
            7'b0110011: begin   // R-Type 
                register_write = 1;
                read_enable = 0;
                write_enable = 0;
                select_A = 1;
                select_B = 0;
                wb_select = 2'b01;
                branch_type = 3'b000;

                case ({func7, func3})
                    {7'b0000000, 3'b000}: alu_operation = 4'b0000; // ADD
                    {7'b0100000, 3'b000}: alu_operation = 4'b0001; // SUB
                    {7'b0000000, 3'b001}: alu_operation = 4'b0010; // SLL
                    {7'b0000000, 3'b101}: alu_operation = 4'b0011; // SRL
                    {7'b0100000, 3'b101}: alu_operation = 4'b0100; // SRA
                    {7'b0000000, 3'b010}: alu_operation = 4'b0101; // SLT
                    {7'b0000000, 3'b011}: alu_operation = 4'b0110; // SLTU
                    {7'b0000000, 3'b100}: alu_operation = 4'b0111; // XOR
                    {7'b0000000, 3'b110}: alu_operation = 4'b1000; // OR
                    {7'b0000000, 3'b111}: alu_operation = 4'b1001; // AND
                    default: alu_operation = 4'b0000;
                endcase
            end

            7'b0010011: begin   // I-Type
                register_write = 1;
                read_enable = 0;
                write_enable = 0;
                select_A = 1;
                select_B = 1;
                wb_select = 2'b01;
                branch_type = 3'b000;

                case (func3)
                    3'b000: alu_operation = 4'b0000; // ADDI
                    3'b001: alu_operation = 4'b0010; // SLLI
                    3'b101: alu_operation = (func7 == 7'b0100000) ? 4'b0100 : 4'b0011; // SRAI or SRLI
                    3'b010: alu_operation = 4'b0101; // SLTI
                    3'b011: alu_operation = 4'b0110; // SLTIU
                    3'b100: alu_operation = 4'b0111; // XORI
                    3'b110: alu_operation = 4'b1000; // ORI
                    3'b111: alu_operation = 4'b1001; // ANDI
                    default: alu_operation = 4'b0000;
                endcase
            end

            7'b0000011: begin       // I-Type (Load)
                register_write = 1;
                read_enable = 1;
                write_enable = 0;
                select_A = 1;
                select_B = 1;
                wb_select = 2'b10;
                branch_type = 3'b000;
                alu_operation = 4'b0000;
            end

            7'b0100011: begin       // S-Type 
                register_write = 0;
                read_enable = 0;
                write_enable = 1;
                select_A = 1;
                select_B = 1;
                wb_select = 2'b01;
                branch_type = 3'b000;
                alu_operation = 4'b0000;
            end

            7'b1100011: begin       // B-Type   
                register_write = 0;
                read_enable = 0;
                write_enable = 0;
                select_A = 0;
                select_B = 1;
                wb_select = 2'b01;
                alu_operation = 4'b0000;

            case (func3)
                3'b000: branch_type = 3'b001; // BEQ
                3'b001: branch_type = 3'b010; // BNE
                3'b100: branch_type = 3'b011; // BLT
                3'b101: branch_type = 3'b100; // BGE
                3'b110: branch_type = 3'b101; // BLTU
                3'b111: branch_type = 3'b110; // BGEU
            endcase
        
            end

            7'b0110111: begin // LUI
                register_write = 1;
                read_enable = 0;
                write_enable = 0;
                select_A = 0;
                select_B = 1;
                wb_select = 2'b01;
                branch_type = 3'b000;
                alu_operation = 4'b1010;
            end

            7'b0010111: begin // AUIPC
                register_write = 1;
                read_enable = 0;
                write_enable = 0;
                select_A = 0;
                select_B = 1;
                wb_select = 2'b01;
                branch_type = 3'b000;
                alu_operation = 4'b0000;
            end

            7'b1101111: begin // JAL
                register_write = 1;
                read_enable = 0;
                write_enable = 0;
                select_A = 0;
                select_B = 1;
                wb_select = 2'b00;
                branch_type = 3'b111;
                alu_operation = 4'b0000;
            end

            7'b1100111: begin // JALR
                register_write = 1;
                read_enable = 0;
                write_enable = 0;
                select_A = 1;
                select_B = 1;
                wb_select = 2'b00;
                branch_type = 3'b111;
                alu_operation = 4'b0000;
            end
        endcase
    end
endmodule
