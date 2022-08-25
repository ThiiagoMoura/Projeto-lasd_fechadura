module divClock(input clk_in, output reg clk_out);

reg [24:0] contador;
initial begin
	contador = 0;
end

always @(posedge clk_in)begin

	if(contador == 25'd2500 )begin
		clk_out = !clk_out;
		contador = 5'b0;
	end
	else
		contador = contador + 1;
end

endmodule