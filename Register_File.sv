module Register_File (
    input  logic        clock, reg_write,           
    input  logic [4:0]  source_reg_1,source_reg_2,destination_reg,        
    input  logic [31:0] write_data,     
    output logic [31:0] rdata1, rdata2    
);
    logic [31:0] registers[0:31];

    always_ff @(negedge clock) begin
        registers[0] <= 32'b0; 

        if (reg_write )
            registers[destination_reg] <= write_data;
    end

    
    assign rdata1 = (source_reg_1 ==destination_reg && reg_write) ? write_data : registers[source_reg_1];
    assign rdata2= (source_reg_2 ==destination_reg && reg_write) ? write_data : registers[source_reg_2];

endmodule