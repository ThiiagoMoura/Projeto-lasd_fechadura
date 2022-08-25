module Parallel_IN(MemData, DataIn, Address, RegData);


input [7:0] Address, MemData, DataIn;

output reg [7:0]RegData;


wire sel;

assign sel = (Address == 8'hFF) ? 1:0;


	always@(sel)
	begin
	case(sel)
	2'b00:RegData = MemData;
	2'b01:RegData = DataIn;
	endcase
	
	
	end
endmodule
