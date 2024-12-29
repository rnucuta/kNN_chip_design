module dff #(parameter Bit = 1) (input logic [Bit-1:0] d,
				input logic clk, rst,
				output logic [Bit-1:0] q);

always_ff @(posedge clk) begin
	priority case(1'b1) 
		rst: q <= 'b0;
	default: begin
		q <= d;
	end
	endcase
	// if (rst) begin
	// 	q <= 'b0;
	// end else begin
	// 	q <= d;
	// end
end

endmodule
 
