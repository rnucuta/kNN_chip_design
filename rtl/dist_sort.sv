module dist_sort (
	input logic clk, rst,
	input logic [63:0] query, // 4-bit per element, 16 dimensions
	input logic [63:0] search_0,
	input logic [63:0] search_1,
	input logic [63:0] search_2,
	input logic [63:0] search_3,
	input logic [63:0] search_4,
	input logic [63:0] search_5,
	input logic [63:0] search_6,
	input logic [63:0] search_7,
	input logic in_valid,
	output logic [2:0] addr_1st,
	output logic [2:0] addr_2nd,
	output logic out_valid
);
	// Notes:
	// 16 dimensions, 4 bits per dimension
	// each 4 bit value is unsigned
	// only when in-valid is high, start the distance
	// and sorting operation

	// when the 1st, 2nd, or 3rd bits are identical
	// return addr1st and addr2nd in ascending order
	// and set out_valid to be 1 in this clock cycle

	// flop all inputs and outputs like mult module
	// rst will reset all output ports on next clock cycle
	// (synchronous)

`include "./params.vh"
//`include "./datatypes.sv"
//import datatypes_p::addr_t;
//parameter pipes = 10; // 2 for inp/out, 3 in dist_mod, 5 in sort
//parameter DSIZE = 15;


// post input flop wires
logic [63:0] query_r;
logic [63:0] search_r [7:0];

// flop all inputs	
dff #(.Bit(64)) dff_s0(.clk(clk), .rst(rst), .d(search_0), .q(search_r[0]));
dff #(.Bit(64)) dff_s1(.clk(clk), .rst(rst), .d(search_1), .q(search_r[1]));
dff #(.Bit(64)) dff_s2(.clk(clk), .rst(rst), .d(search_2), .q(search_r[2]));
dff #(.Bit(64)) dff_s3(.clk(clk), .rst(rst), .d(search_3), .q(search_r[3]));
dff #(.Bit(64)) dff_s4(.clk(clk), .rst(rst), .d(search_4), .q(search_r[4]));
dff #(.Bit(64)) dff_s5(.clk(clk), .rst(rst), .d(search_5), .q(search_r[5]));
dff #(.Bit(64)) dff_s6(.clk(clk), .rst(rst), .d(search_6), .q(search_r[6]));
dff #(.Bit(64)) dff_s7(.clk(clk), .rst(rst), .d(search_7), .q(search_r[7]));
dff #(.Bit(64)) dff_qry(.clk(clk), .rst(rst), .d(query), .q(query_r));


// post mult + accumulate flop q wires
// set size of distance
logic [DSIZE-1:0] D_r [7:0];
genvar i;
generate
    for (i = 0; i < 8; i = i + 1) begin : dist_mod_instances
        dist_mod #(.Bit(DSIZE)) d_num(.clk(clk), .rst(rst), .query(query_r), 
        	.neighbor(search_r[i]), .distance(D_r[i]));
    end
endgenerate


// sort the distances
//logic [2:0] addr1_b, addr2_b;
sort_tree #(.Bit(DSIZE)) sort_tree_instance(.D(D_r), .clk(clk), .rst(rst),
	.smallest_addr1(addr_1st), .smallest_addr2(addr_2nd));

// TODO: check in_valid bit? (prob unnecssary)
// set out_valid bit pipelined stages
logic [PIPE_STAGES:0] valid_pipe;
assign valid_pipe[0] = in_valid;
genvar j;
generate
    for (j = 0; j < PIPE_STAGES; j = j + 1) begin : invalid_dff_instances
        dff #(.Bit(1)) dff_valid(.clk(clk), .rst(rst), .d(valid_pipe[j]), .q(valid_pipe[j+1]));
    end
endgenerate

// assign out_valid to output of last pipe dff
assign out_valid = valid_pipe[PIPE_STAGES];

//assign rst = out_valid;

endmodule
