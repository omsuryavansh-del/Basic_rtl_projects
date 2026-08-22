import f_pkg::*;

class driver;

    virtual fifo_if f_if;
    mailbox driver_mbx;

    function new();
    
    endfunction

    task drive();
    if (f_if == null) begin
      $fatal(1, "DRIVER ERROR: Virtual interface f_if is NULL at time 0ns!");
    end
    if (driver_mbx == null) begin
      $fatal(1, "DRIVER ERROR: Mailbox drv_mbx is NULL at time 0ns!");
    end

    forever begin
    transaction tr;
    driver_mbx.get(tr);

    @(posedge f_if.clk);
    if(f_if.rst_n)begin
    f_if.write_en = tr.write_en;
    f_if.read_en = tr.read_en;
    f_if.data_in = tr.data_in;  
    $display("transaction sent to dut rst_n = %0b || w_en = %0b || rd_en = %0b || data_in = %0b || data_out = %0b",
                    f_if.rst_n,tr.write_en,tr.read_en,tr.data_in,tr.data_out);
    end
    end
    endtask

endclass