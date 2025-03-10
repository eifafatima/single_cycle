module ALU(
	input logic [3:0] alu_operation,
	input logic [31:0] X, Y,
	output logic [31:0] Z
);

	always_comb begin
        case (alu_operation)
            4'b0000: Z = X + Y; // ADD
            4'b0001: Z = X - Y; // SUB
            4'b0010: Z = X << Y[4:0]; // SLL
            4'b0011: Z = X >> Y[4:0]; // SRL
            4'b0100: Z = $signed(X) >>> Y[4:0]; // SRA
            4'b0101: Z = ($signed(X) < $signed(Y)) ? 1 : 0; // SLT
            4'b0110: Z = (X < Y) ? 1 : 0; // SLTU
            4'b0111: Z = X ^ Y; // XOR
            4'b1000: Z = X | Y; // OR
            4'b1001: Z = X & Y; // AND
            4'b1010: Z = Y; // Just Pass Y
        
            default: Z = 32'b0;
        endcase
    end

endmodule
