module Branch_Condition (
    input logic [2:0] branch_type,
    input logic [31:0] rdata1, rdata2,
    output logic branch_taken
);

    always_comb begin
        case (branch_type)
            3'b000: branch_taken = 0;
            3'b001: branch_taken = (rdata1 == rdata2);  // BEQ
            3'b010: branch_taken = (rdata1 != rdata2);  // BNE
            3'b011: branch_taken = ($signed(rdata1) < $signed(rdata2));  // BLT
            3'b100: branch_taken = ($signed(rdata1) >= $signed(rdata2)); // BGE
            3'b101: branch_taken = (rdata1 < rdata2);   // BLTU
            3'b110: branch_taken = (rdata1 >= rdata2);  // BGEU
            3'b111: branch_taken = 1;                   // Unconditional Jump
            default: branch_taken = 0;                  // Default case
        endcase
    end

endmodule