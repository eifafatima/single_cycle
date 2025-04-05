module tb_processor;

logic clk;
logic reset;

// Instantiate the Processor
datapath dut (
    .clk(clk),
    .reset(reset)
);

// Clock Generation
always begin
    #5 clk = ~clk; // 10ns clock period
end

always_ff @(negedge clk) begin
	$display("REG[1] = %h", dut.reg_file_0.registers[1]);
end

// Testbench
initial begin
    // Initialize signals
    clk = 0;
    reset = 1;

    // Instruction Memory
    dut.reg_file_0.registers[1] = 32'd2;
    dut.reg_file_0.registers[2] = 32'd4;
    dut.reg_file_0.registers[3] = 32'd6;
    dut.reg_file_0.registers[4] = 32'd8;
	dut.reg_file_0.registers[5] = 32'd10;
    dut.reg_file_0.registers[6] = 32'd12;
    dut.reg_file_0.registers[7] = 32'd14;
    dut.reg_file_0.registers[8] = 32'd16;
    dut.reg_file_0.registers[9] = 32'd18;
    dut.reg_file_0.registers[10] = 32'd20;

    // Data Memory
    dut.data_mem_0.memory[0] = 32'd5;
    dut.data_mem_0.memory[1] = 32'd10;
    dut.data_mem_0.memory[2] = 32'd20;
    dut.data_mem_0.memory[3] = 32'd30;
    dut.data_mem_0.memory[4] = 32'd40;


    // R-Type
    dut.inst_mem_0.memory[0] = 32'h003100B3; // ADD x1, x2, x3 (0000000 00011 00010 000 00001 0110011)    
    dut.inst_mem_0.memory[1] = 32'h40628233; // SUB x4, x5, x6 (0100000 00110 00101 000 00100 0110011)
    dut.inst_mem_0.memory[2] = 32'h00A4E0B3; // OR x1, x9, x10 (0000000 01010 01001 110 00001 0110011)
    dut.inst_mem_0.memory[3] = 32'h007310B3; // SLL x1, x6, x7 (0000000 00111 00110 001 00001 0110011)
    dut.inst_mem_0.memory[4] = 32'h409450B3; // SRA x1, x8, x9 (0100000 01001 01000 101 00001 0110011)
    dut.inst_mem_0.memory[5] = 32'h0062A0B3; // SLT x1, x5, x6 (0000000 00110 00101 010 00001 0110011)

    // I-Type
    dut.inst_mem_0.memory[6] = 32'h06410093; // ADDI x1, x2, 100 (0000000001100100 00010 000 00001 0010011)
    dut.inst_mem_0.memory[7] = 32'h0051A093; // SLTI x1, x3, 5 (0000000000000101 00011 010 00001 0010011)
    dut.inst_mem_0.memory[8] = 32'h0FF2F093; // ANDI x1, x5, 255 (0000000011111111 00101 111 00001 0010011)
    dut.inst_mem_0.memory[9] = 32'h40245093; // SRAI x1, x8, 2 (010000000010 01000 101 00001 0010011)
    dut.inst_mem_0.memory[10] = 32'h00302083; // LW x1, 3(x0) (000000000011 00000 010 00001 0000011)

    // S-Type
    dut.inst_mem_0.memory[11] = 32'h00602123; // SW x6, 2(x0) (0000000 00110 00000 010 00010 0100011)

    // B-Type
    dut.inst_mem_0.memory[12] = 32'h00730463; // BEQ x6, x7, label (0000000 00111 00110 000 01000 1100011)
    dut.inst_mem_0.memory[13] = 32'h00731463; // BNE x6, x7, label (0000000 00111 00110 001 01000 1100011)
    dut.inst_mem_0.memory[14] = 32'h003100B3; // ADD x1, x2, x3 (0000000 00011 00010 000 00001 0110011)

    // U-Type
    dut.inst_mem_0.memory[15] = 32'h123450B7; // lui x1, 0x12345 (0001 0010 0011 0100 0101 00001 0110111)
    dut.inst_mem_0.memory[16] = 32'h12345097; // auipc x1, 0x12345 (0001 0010 0011 0100 0101 00001 0010111)

    // J-Type
    dut.inst_mem_0.memory[17] = 32'h0080056F; // jal x10, 0x04 (0 0000000100 0 00000000 01010 1101111)
    dut.inst_mem_0.memory[18] = 32'h00C000EF; // jal x1, 0x06 (0 0000000110 0 00000000 00001 1101111)
    dut.inst_mem_0.memory[19] = 32'h003100B3; // ADD x1, x2, x3 (0000000 00011 00010 000 00001 0110011)
    dut.inst_mem_0.memory[20] = 32'h000500E7; // jalr x1, 0x0(x10) (0000 0000 0000 01010 000 00001 1100111)

    // Deassert reset
    #10 reset = 0;

    // Display
    #125 $display("MEM[2] = %h", dut.data_mem_0.memory[2]);

    // Run simulation for a set number of clock cycles
    #220;
    $finish;
end

endmodule