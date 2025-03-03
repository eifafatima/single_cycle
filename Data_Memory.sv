module Data_Memory (
    input  logic        clock,  write_enable,read_enable,             
    input  logic [31:0] address,  write_data,        
    output logic [31:0] read_data       
);

    logic [31:0] memory[0:1023];

    always_ff @(posedge clock) begin
        if (write_enable && address[31:12] == 20'b0) begin  
            memory[address[11:2]] <= write_data;
        end
    end

    always_ff @(posedge clock) begin
        if (read_enable && address[31:12] == 20'b0) begin 

            read_data <= memory[address[11:2]]; 
        end else begin
            read_data <= 32'b0;  
        end
    end

endmodule