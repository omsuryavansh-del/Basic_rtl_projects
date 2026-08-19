
`timescale 1ns/1ns
module tb;
reg clk,rst_n,w_en,r_en;
reg [7:0] data_in; 

wire [7:0] data_out;
wire full,empty;

fifo dut (
    .clk(clk),
    .rst_n(rst_n),
    .write_en(w_en),
    .read_en(r_en),
    .data_in(data_in),
    .data_out(data_out),
    .full(full),
    .empty(empty)
);

always #5 clk = ~clk;

initial begin
    clk = 0;
    rst_n = 0;
    #10 rst_n = 1;
end


initial begin 
    $monitor("rst_n = %0d || w_en = %0d || r_en = %0d || data_in = %0h || data_out =%0h || full = %0b || empty = %0b", 
    rst_n, w_en, r_en, data_in , data_out, full, empty);

    
    // write(8);
    @ (negedge clk);
    @ (negedge clk);
    repeat (8) begin
        @ (negedge clk);
        w_en = 1'b1;
        data_in = $random; 
    end
    @(negedge clk);
    w_en = 1'b0;
    if (full) $display("TEST 1: fifo write test passed");
    else $display("TEST 1: fifo write test failed");

    @(negedge clk);

    r_en = 1'b1;
    repeat (8) @(negedge clk);
    r_en = 1'b0;
    if (empty) $display("TEST 2: fifo read test passed");
    else $display("TEST 2: fifo read test failed");

    @(negedge clk);

    @ (negedge clk);
    repeat (8) begin
        @ (negedge clk);
        data_in = $random; 
        w_en = 1'b1;
    end
    @(negedge clk);
    w_en = 1'b0;
    @(negedge clk);
    r_en = 1'b1;
    repeat (8) @(negedge clk);
    r_en = 1'b0;
    if (empty) $display("TEST 3: fifo read after write test passed");
    else $display("TEST 3: fifo read after write test failed");

    @(negedge clk);

    fork
        begin
            repeat (16) begin
                @ (negedge clk);
                data_in = $random; 
                w_en = 1'b1;
            end
            @(negedge clk);
            w_en = 1'b0;
        end
        begin            
            @(negedge clk);
            r_en = 1'b1;
            repeat (9) @(negedge clk);
            r_en = 1'b0;
        end
    join
    if (full) $display("TEST 4: fifo 2 write and 1 read test passed");
    else $display("TEST 4: fifo 2 write and 1 read test failed");


    #10 $finish;

end

initial begin
    $dumpfile ("tb_fifo.vcd");
    $dumpvars(0,tb);
end

endmodule