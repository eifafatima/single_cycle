module Branch_Condition (
    input  logic [2:0]  branch_type, 
    input  logic [31:0] rdata1, rdata2, 
    output logic        branch_taken 
);

    always_comb begin
        case (branch_type)
            // No branch (default case)
            3'b000: branch_taken = 1'b0;

            // Branch if Equal (BEQ)
            3'b001: branch_taken = (rdata1 == rdata2);

            // Branch if Not Equal (BNE)
            3'b010: branch_taken = (rdata1 != rdata2);

            // Branch if Less Than (BLT) - Signed comparison
            3'b011: branch_taken = ($signed(rdata1) < $signed(rdata2));

            // Branch if Greater Than or Equal (BGE) - Signed comparison
            3'b100: branch_taken = ($signed(rdata1) >= $signed(rdata2));

            // Branch if Less Than Unsigned (BLTU) - Unsigned comparison
            3'b101: branch_taken = (rdata1 < rdata2);

            // Branch if Greater Than or Equal Unsigned (BGEU) - Unsigned comparison
            3'b110: branch_taken = (rdata1 >= rdata2);

            // Unconditional Jump (always taken)
            3'b111: branch_taken = 1'b1;

            // Default case (no branch)
            default: branch_taken = 1'b0;
        endcase
    end

endmodule