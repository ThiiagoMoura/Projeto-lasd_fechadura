module Parallel_OUT(RegData, DataOut, Address, clk, wren, we);

input we, clk;
input [7:0] Address, RegData;

output wren;
output reg [7:0]DataOut;



wire fioA, fioB;

assign fioB = we & fioA;
assign wren = ~fioA & we;


assign fioA = (Address == 8'hFF) ? 1:0;

always @ (posedge clk) begin  
	if ((fioB == 1))begin
		DataOut = RegData;
	end
end
endmodule
