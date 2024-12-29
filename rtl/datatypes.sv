package datatypes_p;
    typedef enum logic [2:0] { 
	A0 = 3'b000, 
	A1 = 3'b001, 
	A2 = 3'b010, 
	A3 = 3'b011, 
	A4 = 3'b100, 
	A5 = 3'b101, 
	A6 = 3'b110, 
	A7 = 3'b111 
    } addr_t;

    typedef struct packed {
        logic [11:0] d;
        logic[2:0] addr;
    } coupled_dist_t;

endpackage
