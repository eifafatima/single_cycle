module Immediate_Generator (
    input  logic [31:0] instruction, 
    output logic [31:0] extended_imm 
);

    logic [6:0] opcode;
    assign opcode = instruction[6:0]; 

    always_comb begin
        case (opcode)
            // S-Type (Store instructions)
            7'b0100011: extended_imm = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};

            // B-Type (Branch instructions)
            7'b1100011: extended_imm = {{19{instruction[31]}}, instruction[31], instruction[7], instruction[30:25], instruction[11:8], 1'b0};

            // U-Type (Upper immediate instructions)
            7'b0110111, 7'b0010111: extended_imm = {instruction[31:12], 12'b0};

            // J-Type (Jump instructions)
            7'b1101111: extended_imm = {{11{instruction[31]}}, instruction[31], instruction[19:12], instruction[20], instruction[30:21], 1'b0};

            // Default: I-Type (Immediate instructions)
            default: extended_imm = {{20{instruction[31]}}, instruction[31:20]};
        endcase
    end

endmodule