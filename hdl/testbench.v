`timescale 1ns / 1ps


module testbench;
     
     //Inputs
     reg mips_clk;
     reg mips_rst;
                  
     //Outputs
     wire        mem_instr_read;
     wire [31:0] mem_instr_addr_bus, mem_instr_read_bus;
                                     
     wire        mem_data_write, mem_data_read;
     wire [31:0] mem_data_addr_bus, mem_data_read_bus, mem_data_write_bus;

     //Instantiate the Unit Under Test (UUT)
     mips_system uut (
          .clk(mips_clk), 
          .rst(mips_rst), 
		    
          .mem_instr_read(mem_instr_read),
          .mem_instr_addr_bus(mem_instr_addr_bus), 
          .mem_instr_read_bus(mem_instr_read_bus),
                                     
          .mem_data_write(mem_data_write),
          .mem_data_read(mem_data_read),                     
          .mem_data_addr_bus(mem_data_addr_bus),
          .mem_data_read_bus(mem_data_read_bus),
          .mem_data_write_bus(mem_data_write_bus));

     initial begin
          mips_rst = 1;

          // Wait 100 ns for global reset to finish
          #100;
          mips_rst = 0;
      
     end // initial begin

     initial begin
          mips_clk = 0;
          forever
               #10 mips_clk = !mips_clk;      
     end
     
	integer i;
     
     initial begin
          for (i = 0; i < 1000; i=i+1)
               @(posedge mips_clk);

          $stop();      
     end

     initial begin
          $display("Trace register $t0");
          
          @(negedge mips_rst);

          forever begin
               @(posedge mips_clk);

               $display("%d ns: $t0 (REG8) = %x", $time, uut.pipeline_inst.idecode_inst.regfile_inst.rf[8]);           
          end
     end
   
endmodule

