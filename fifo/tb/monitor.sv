
import f_pkg::*;

class monitor;
    transaction tr;
    mailbox mon_to_scb;
    virtual fifo_if f_if;

    function new;
    endfunction

    task monitor();
        forever begin
        tr = new;
        @(posedge f_if.clk);
        #1
        tr.rst_n = f_if.rst_n;
        if(f_if.rst_n) begin
        tr.write_en = f_if.write_en;
        tr.read_en = f_if.read_en ;
        tr.data_in = f_if.data_in ;
        tr.data_out = f_if.data_out;
        tr.full = f_if.full;
        tr.empty = f_if.empty;
        mon_to_scb.put(tr);
        $display("transaction sent to scoreboard rst_n = %0b || w_en = %0b || rd_en = %0b || data_in = %0b || data_out = %0b",
                    tr.rst_n,tr.write_en,tr.read_en,tr.data_in,tr.data_out);
        end
        end
    endtask

endclass