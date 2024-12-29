module dist_mod #(parameter Bit = 1) ( // **Bit is 
    input logic clk, rst,
    input logic unsigned [63:0] query,
    input logic unsigned [63:0] neighbor,
    output logic unsigned [Bit - 1:0] distance
);



// init subvector wires
logic unsigned [3:0] query_sub [15:0];
logic unsigned [3:0] neighbor_sub [15:0];

// init subdist wires
logic unsigned [4:0] dist_l1 [15:0]; 
logic unsigned [7:0] dist_l2 [15:0];

// init dist buff
logic unsigned [Bit - 1:0] distance_b;

// Assign subvectors
genvar j;
generate
    for (j = 0; j < 16; j = j + 1) begin : qn_sub_instances
        assign query_sub[j] = query[4*j + 3 : 4*j];
	    assign neighbor_sub[j] = neighbor[4*j + 3 : 4*j];
    end
endgenerate


// Calculate subdistances
genvar k;
generate
    for (k = 0; k < 16; k = k + 1) begin : l1_instances
    	assign dist_l1[k] = query_sub[k] - neighbor_sub[k];
    end
endgenerate


// may need to add mult module here to flop intermediate results
// but want to optimize latency, not throughput

genvar i;
generate
    for (i = 0; i < 16; i = i + 1) begin : l2_instances
        mult #(.Bit(5)) sqr (.inp_a(dist_l1[i]), .inp_b(dist_l1[i]), .prod(dist_l2[i]));
    end
endgenerate

// 16 additions (acc) is critical path 1 (~500 ps)
// need to break up into pipelines to increase total latency of all 1000
// assign distance_b = dist_l2[0] + dist_l2[1] + dist_l2[2] + dist_l2[3] 
// 	+ dist_l2[4] + dist_l2[5] + dist_l2[6] + dist_l2[7] + dist_l2[8] 
// 	+ dist_l2[9] + dist_l2[10] + dist_l2[11] + dist_l2[12] 
// 	+ dist_l2[13] + dist_l2[14] + dist_l2[15];
// dff #(.Bit(Bit)) dff_distanceSum(.clk(clk), .rst(rst), .d(distance_b), .q(distance));

logic unsigned [Bit - 3:0] distance_a1, distance_a2, distance_a3, distance_a4;

// 1 extra pipeline stages
acc #(.Bit(Bit - 2)) sqr_a1 (.clk(clk), .rst(rst), .first_l2(dist_l2[0]), .second_l2(dist_l2[1]), .third_l2(dist_l2[2]), .fourth_l2(dist_l2[3]), .sub_euclidian(distance_a1));
acc #(.Bit(Bit - 2)) sqr_a2 (.clk(clk), .rst(rst), .first_l2(dist_l2[4]), .second_l2(dist_l2[5]), .third_l2(dist_l2[6]), .fourth_l2(dist_l2[7]), .sub_euclidian(distance_a2));
acc #(.Bit(Bit - 2)) sqr_a3 (.clk(clk), .rst(rst), .first_l2(dist_l2[8]), .second_l2(dist_l2[9]), .third_l2(dist_l2[10]), .fourth_l2(dist_l2[11]), .sub_euclidian(distance_a3));
acc #(.Bit(Bit - 2)) sqr_a4 (.clk(clk), .rst(rst), .first_l2(dist_l2[12]), .second_l2(dist_l2[13]), .third_l2(dist_l2[14]), .fourth_l2(dist_l2[15]), .sub_euclidian(distance_a4));
acc #(.Bit(Bit)) sqr_out (.clk(clk), .rst(rst), .first_l2(distance_a1), .second_l2(distance_a2), .third_l2(distance_a3), .fourth_l2(distance_a4), .sub_euclidian(distance));

endmodule
