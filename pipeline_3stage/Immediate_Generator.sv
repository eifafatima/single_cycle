module Immediate_Generator (
    input logic [31:0] instruction,
    output logic [31:0] extended_immediate
);
    logic [6:0] opcode;
    assign opcode = instruction[6:0];

    always_comb begin
        case(opcode)
            7'b0010011: extended_immediate = {{20{instruction[31]}}, instruction[31:20]}; // I-Type 
            7'b0000011: extended_immediate = {{20{instruction[31]}},instruction[31:20]}; // I-Type (Load)
            7'b0100011: extended_immediate = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};  // S-Type
            7'b1100011: extended_immediate = {{19{instruction[31]}}, instruction[31], instruction[7], instruction[30:25], instruction[11:8], 1'b0};  // B-Type
            7'b0110111: extended_immediate = {instruction[31:12], 12'b0}; // LUI
            7'b0010111: extended_immediate = {instruction[31:12], 12'b0}; // AUIPC
            7'b1101111: extended_immediate = {{11{instruction[31]}}, instruction[31], instruction[19:12], instruction[20], instruction[30:21], 1'b0}; // J-Type
            7'b1100111: extended_immediate = {{20{instruction[31]}},instruction[31:20]}; // JALR
            default: extended_immediate = 32'b0;  
        endcase
    end

endmodule