module ALU (
    input  logic [3:0]  operation,
    input  logic [31:0] operand_A,operand_B,  
    output logic [31:0] result,  
    output logic        zero,  overflow  
);

    logic [31:0] add_result, sub_result;

    always_comb begin
        case (operation)
            4'b0000: result = operand_A + operand_B; // ADD
            4'b0001: result = operand_A - operand_B; // SUB
            4'b0010: result = operand_A << operand_B[4:0]; // SLL
            4'b0011: result = operand_A >> operand_B[4:0]; // SRL
            4'b0100: result = $signed(operand_A) >>> operand_B[4:0]; // SRA
            4'b0101: result = ($signed(operand_A) < $signed(operand_B)) ? 1 : 0; // SLT
            4'b0110: result = (operand_A < operand_B) ? 1 : 0; // SLTU
            4'b0111: result = operand_A ^ operand_B; // XOR
            4'b1000: result = operand_A | operand_B; // OR
            4'b1001: result = operand_A & operand_B; // AND
            4'b1010: result = operand_B; // Just Pass B
            default: result = 32'b0; // Default case
        endcase

        // Zero flag
        zero = (result == 32'b0);

        // Overflow detection for ADD and SUB
        add_result = operand_A + operand_B;
        sub_result = operand_A - operand_B;
        case (operation)
            4'b0000: overflow = (operand_A[31] == operand_B[31]) && (add_result[31] != operand_A[31]);
            4'b0001: overflow = (operand_A[31] != operand_B[31]) && (sub_result[31] != operand_A[31]);
            default: overflow = 1'b0;
        endcase
    end

endmodule