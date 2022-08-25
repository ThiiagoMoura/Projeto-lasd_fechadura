module contadorM10(input reset, input clk_in, output reg[3:0]contagem);

initial begin
	contagem = 4'b0001;
end


always @(posedge clk_in)begin

	if(contagem == 4'b1001)begin
		contagem = 4'b0000;
	end
	else begin
		contagem = contagem + 4'b0001;
	end
	
	if(reset == 4'b0000)begin
		contagem = 4'b0000;
	end

end


endmodule
