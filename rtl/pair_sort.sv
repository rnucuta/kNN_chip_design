`include "./datatypes.sv"
//import datatypes_p::*;

module pair_sort #(parameter Bit = 12) (
    input clk, rst,
    input datatypes_p::coupled_dist_t first,
    input datatypes_p::coupled_dist_t second,
    output datatypes_p::coupled_dist_t smaller,
    output datatypes_p::coupled_dist_t larger
);

datatypes_p::coupled_dist_t s;
datatypes_p::coupled_dist_t l;

always_comb begin
    case ({first.d > second.d, first.d < second.d})
        2'b10: begin
            s = second;
            l = first;
        end
        // 3'b00: begin
        //     // smaller = first;
        //     // larger = second;
        //     // can case always be output a0?
        //     case ({second.addr > first.addr})
        //         1'b1: begin
        //             s = first;
        //             l = second;
        //         end
        //         1'b0: begin
        //             s = second;
        //             l = first;
        //         end
        //     endcase
        // end
        2'b01: begin 
            s = first;
            l = second;
        end
        default: begin
            case ({second.addr > first.addr})
                1'b1: begin
                    s = first;
                    l = second;
                end
                default: begin
                    s = second;
                    l = first;
                end
            endcase
        end
    endcase

end
// assign smaller = s;
// assign larger = l;

dff #(.Bit(Bit + 3)) dff_pair_smaller(.clk(clk), .rst(rst), .d(s), .q(smaller));
dff #(.Bit(Bit + 3)) dff_pair_larger(.clk(clk), .rst(rst), .d(l), .q(larger));
endmodule

module pair_sort_two #(parameter Bit = 12) (
    input datatypes_p::coupled_dist_t first,
    input datatypes_p::coupled_dist_t second,
    output datatypes_p::coupled_dist_t smaller,
    output datatypes_p::coupled_dist_t larger
);

datatypes_p::coupled_dist_t s;
datatypes_p::coupled_dist_t l;

always_comb begin
    case ({first.d > second.d, first.d < second.d})
        2'b10: begin
            s = second;
            l = first;
        end
        2'b01: begin 
            s = first;
            l = second;
        end
        default: begin
            case ({second.addr > first.addr})
                1'b1: begin
                    s = first;
                    l = second;
                end
                default: begin
                    s = second;
                    l = first;
                end
            endcase
        end
    endcase

end
assign smaller = s;
assign larger = l;

// dff #(.Bit(Bit + 3)) dff_pair_smaller(.clk(clk), .rst(rst), .d(s), .q(smaller));
// dff #(.Bit(Bit + 3)) dff_pair_larger(.clk(clk), .rst(rst), .d(l), .q(larger));
endmodule

module pair_sort_three #(parameter Bit = 12) (
    input datatypes_p::coupled_dist_t first,
    input datatypes_p::coupled_dist_t second,
    output datatypes_p::coupled_dist_t smaller
);

datatypes_p::coupled_dist_t s;

always_comb begin
    case ({first.d > second.d, first.d < second.d})
        2'b10: begin
            s = second;
        end
        2'b01: begin 
            s = first;
        end
        default: begin
            case ({second.addr > first.addr})
                1'b1: begin
                    s = first;
                end
                default: begin
                    s = second;
                end
            endcase
        end
    endcase

end
assign smaller = s;

// dff #(.Bit(Bit + 3)) dff_pair_smaller(.clk(clk), .rst(rst), .d(s), .q(smaller));
// dff #(.Bit(Bit + 3)) dff_pair_larger(.clk(clk), .rst(rst), .d(l), .q(larger));
endmodule

module pair_sort_four #(parameter Bit = 12) (
    input clk, rst,
    input datatypes_p::coupled_dist_t first,
    input datatypes_p::coupled_dist_t second,
    output datatypes_p::coupled_dist_t smaller
);

datatypes_p::coupled_dist_t s;

always_comb begin
    case ({first.d > second.d, first.d < second.d})
        2'b10: begin
            s = second;
        end
        2'b01: begin 
            s = first;
        end
        default: begin
            case ({second.addr > first.addr})
                1'b1: begin
                    s = first;
                end
                default: begin
                    s = second;
                end
            endcase
        end
    endcase

end

dff #(.Bit(Bit + 3)) dff_pair_smaller(.clk(clk), .rst(rst), .d(s), .q(smaller));
endmodule