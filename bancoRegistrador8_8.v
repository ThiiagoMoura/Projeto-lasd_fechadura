module banco_registradores(we3, clk, wa3, ra1, ra2, rd1, rd2, wd3, S0, S1, S2, S3, S4, S5, S6, S7);

////////////////////////////////

input we3;

input clk;

input [2:0] wa3;

input [2:0] ra1;
input [2:0] ra2;

input [7:0] wd3;

output [7:0] rd1;
output [7:0] rd2;
output [7:0] S0, S1, S2, S3, S4, S5, S6, S7;

////////////////////////////////

reg [7:0] registrador [7:0];

///////////////////////////////

initial begin
	registrador[0] = 8'b0;
end


//////////////////////////////////


always @ (posedge clk) begin

	if((we3 == 1)&(wa3 != 0)) begin
		registrador [wa3] = wd3;
	
	end

end

/////////////////////////////////

assign rd1 = registrador[ra1];

assign rd2 = registrador[ra2];

assign S0 = registrador[0];
assign S1 = registrador[1];
assign S2 = registrador[2];
assign S3 = registrador[3];
assign S4 = registrador[4];
assign S5 = registrador[5];
assign S6 = registrador[6];
assign S7 = registrador[7];



endmodule
