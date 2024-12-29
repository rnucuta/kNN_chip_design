`include "./datatypes.sv"

module sort_tree  #(parameter Bit = 1) (
	input logic [Bit - 1:0] D [7:0],
	input logic clk, rst,
	output logic [2:0] smallest_addr1,
	output logic [2:0] smallest_addr2
);
// sort tree is critical path 2 (~500 ps) (with no intermediate flops)

//import datatypes_p::*;

// TODO: Optimize/pipeline

// first level
datatypes_p::coupled_dist_t S1, S2, S3, S4;
datatypes_p::coupled_dist_t L1, L2, L3, L4;
pair_sort #(.Bit(Bit)) CA0(.clk(clk), .rst(rst), .first(datatypes_p::coupled_dist_t'({D[0], datatypes_p::A0})), .second(datatypes_p::coupled_dist_t'({D[1], datatypes_p::A1})), .smaller(S1), .larger(L1));

pair_sort #(.Bit(Bit)) CA1(.clk(clk), .rst(rst), .first(datatypes_p::coupled_dist_t'({D[2], datatypes_p::A2})), .second(datatypes_p::coupled_dist_t'({D[3], datatypes_p::A3})), .smaller(S2), .larger(L2));

pair_sort #(.Bit(Bit)) CA2(.clk(clk), .rst(rst), .first(datatypes_p::coupled_dist_t'({D[4], datatypes_p::A4})), .second(datatypes_p::coupled_dist_t'({D[5], datatypes_p::A5})), .smaller(S3), .larger(L3));

pair_sort #(.Bit(Bit)) CA3(.clk(clk), .rst(rst), .first(datatypes_p::coupled_dist_t'({D[6], datatypes_p::A6})), .second(datatypes_p::coupled_dist_t'({D[7], datatypes_p::A7})), .smaller(S4), .larger(L4));

// second level
datatypes_p::coupled_dist_t S12, S34, L12, L34;
datatypes_p::coupled_dist_t SL12, SL34; //, LL12, LL34;
pair_sort_two #(.Bit(Bit)) CB0(.first(S1), .second(S2), .smaller(S12), .larger(L12));
pair_sort_two #(.Bit(Bit)) CB1(.first(S3), .second(S4), .smaller(S34), .larger(L34));
pair_sort_three #(.Bit(Bit)) CB3(.first(L1), .second(L2), .smaller(SL12));
pair_sort_three #(.Bit(Bit)) CB4(.first(L3), .second(L4), .smaller(SL34));

// third level
datatypes_p::coupled_dist_t min1, min1_r1, min1_r2, min2, min2_r;
datatypes_p::coupled_dist_t SLP12, SLP34; //LLP12, LLP34; // finding runner up from previous levels
// to ensure that we get min 2 addresses
pair_sort #(.Bit(Bit)) CC0(.clk(clk), .rst(rst),.first(S12), .second(S34), .smaller(min1), .larger(min2));
pair_sort_four #(.Bit(Bit)) CC1(.clk(clk), .rst(rst),.first(SL12), .second(L12), .smaller(SLP12));
pair_sort_four #(.Bit(Bit)) CC2(.clk(clk), .rst(rst),.first(SL34), .second(L34), .smaller(SLP34));

// assign min2_r = min2;
// assign min1_r1 = min1;
// assign min1_r2 = min1_r1;

// TODO: can this be accomplished with latches instead?????
// dff #(.Bit(Bit + 3)) dff_1(.clk(clk), .rst(rst), .d(min2), .q(min2_r));
// dff #(.Bit(Bit + 3)) dff_2(.clk(clk), .rst(rst), .d(min1), .q(min1_r1));
// dff #(.Bit(Bit + 3)) dff_3(.clk(clk), .rst(rst), .d(min1_r1), .q(min1_r2));

// fourth and fifth level for tiebreaking
datatypes_p::coupled_dist_t minL;
datatypes_p::coupled_dist_t min23;
// pair_sort #(.Bit(Bit)) CD0(.clk(clk), .rst(rst),.first(SLP12), .second(SLP34), .smaller(minL), .larger(fourthL));
// pair_sort #(.Bit(Bit)) CE0(.clk(clk), .rst(rst),.first(min2_r), .second(minL), .smaller(min23), .larger(fifthL));
pair_sort_three #(.Bit(Bit)) CD0(.first(SLP12), .second(SLP34), .smaller(minL));
pair_sort_three #(.Bit(Bit)) CE0(.first(min2), .second(minL), .smaller(min23));


dff #(.Bit(3)) dff_final_addr1(.clk(clk), .rst(rst), .d(min23.addr), .q(smallest_addr2));
dff #(.Bit(3)) dff_final_addr2(.clk(clk), .rst(rst), .d(min1.addr), .q(smallest_addr1));
// assign smallest_addr1 = min1_r2.addr;
// assign smallest_addr2 = min23.addr;

endmodule
