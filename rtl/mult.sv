module mult #(parameter Bit = 1) ( 
	input logic signed [Bit - 1:0] inp_a,
	input logic signed [Bit - 1:0] inp_b,
	// input logic clk, rst,
	output logic unsigned [Bit*2 - 3:0] prod
	);

// assign prod = inp_a * inp_b;

// logic signed [Bit - 1:0] inp_ar;
// logic signed [Bit - 1:0] inp_br;
// chop off extra unneeded bits since square removes 2 extra bits
// for sign
// logic unsigned [Bit * 2 - 3:0] mult_b;
// assign mult_b = inp_a * inp_b;

assign prod = inp_a * inp_b;

// TODO: understand benefit of when we would want synchronous vs 
// non-synchronous for mult module, how much it matters....

// flop inputs
// dff #(.Bit(Bit)) inp_a_dff(.clk(clk), .rst(rst), .d(inp_a), .q(inp_ar));
// dff #(.Bit(Bit)) inp_b_dff(.clk(clk), .rst(rst), .d(inp_b), .q(inp_br));

// comb logic
//assign mult_b = inp_ar * inp_br;

// flop output prod
// dff #(.Bit(Bit * 2 - 2)) out_dff(.clk(clk), .rst(rst), .d(mult_b), .q(prod));

endmodule



// OLD MULT MODULE: 
// sequential logic for resetting state and updating currentState
// use non-blocking assignment
// input d flip flops
// active high asyncrhonous reset
// always_ff @(posedge clk or posedge rst) begin
//     if (rst) begin
// 	inp_ar <= 'b0;
// 	inp_br <= 'b0;
// 	//prod_reg <= 0;
//     end
//     else begin
// 	inp_ar <= inp_a;
// 	inp_br <= inp_b;
//     end
// end



// output d flip flop
// active high asynchronous reset
// always_ff @(posedge clk or posedge rst) begin
//     if (rst) begin
// 	prod <= 32'b0;
//     end
//     else begin
// 	prod <= mult_b;
//     end
// end



