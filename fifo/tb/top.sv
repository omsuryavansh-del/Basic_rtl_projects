`timescale 1ns/1ns
`include "../rtl/fifo.v"
`include "fifo_if.sv"
import f_pkg::*;

module top;

    reg clk;
    environment env;

    fifo_if f_if(clk);

    fifo dut(
            .clk(clk),
            .rst_n(f_if.rst_n),
            .write_en(f_if.write_en),
            .read_en(f_if.read_en),
            .data_in(f_if.data_in),
            .data_out(f_if.data_out),
            .full(f_if.full),
            .empty(f_if.empty)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        f_if.rst_n = 0;
        f_if.write_en = 0;
        f_if.read_en = 0;
        f_if.data_in = 0;
  
        env = new;
        env.f_if = f_if;    
        #10 f_if.rst_n = 1;
        env.run(5);
        $display("Simulation finished successfully!");
        #500 $finish;
    end

    initial begin 
        $dumpfile("fiftb.vcd");
        $dumpvars;   
    end
endmodule