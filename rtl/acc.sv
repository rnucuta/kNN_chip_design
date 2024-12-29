module acc #(parameter Bit = 1) ( // **Bit is 
    input logic clk, rst,
    input logic unsigned [Bit - 3:0] first_l2,
    input logic unsigned [Bit - 3:0] second_l2,
    input logic unsigned [Bit - 3:0] third_l2,
    input logic unsigned [Bit - 3:0] fourth_l2,
    output logic unsigned [Bit - 1:0] sub_euclidian
);

logic unsigned [Bit - 1:0] distance_b;

assign distance_b = first_l2 + second_l2 + third_l2 + fourth_l2;

dff #(.Bit(Bit)) dff_acc(.clk(clk), .rst(rst), .d(distance_b), .q(sub_euclidian));

endmodule