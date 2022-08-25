module mux2_1 (in_1, in_2, set, out);

//////////////////////////////////
input [7:0] in_1, in_2;
input set;


output reg [7:0] out;
///////////////////////////////////


always@(*)begin
	case(set)
		1'b0: out = in_1;
		1'b1: out = in_2;
	
	endcase

end



endmodule
