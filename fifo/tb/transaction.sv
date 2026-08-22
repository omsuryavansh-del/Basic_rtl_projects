
class transaction;
logic rst_n;
rand logic write_en;
rand logic read_en;
rand logic [7:0] data_in;
logic [7:0] data_out;
logic full;
logic empty;


constraint rw_op {
    write_en  dist {1 := 50 , 0 := 50};
    read_en dist {1 := 50 , 0 := 50};

    write_en != read_en;
 }
endclass