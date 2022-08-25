`default_nettype none //Comando para desabilitar declaração automática de wires

module Mod_Teste (

		 //////////////////// Fonte de Clock ////////////////////
		 CLOCK_27,    // 27 MHz
		 CLOCK_50,    // 50 MHz
		 //////////////////// Push Button    ////////////////////
		 KEY,         // Pushbutton (botoes) [3:0]
		 //////////////////// Chaves DPDT
		 SW,         // Toggle Switch (chaves) [17:0]
		 /////////////////// Display de 7-SEG ///////////////////
		 HEX0,       // Display 0
		 HEX1,       // Display 1
		 HEX2,       // Display 2
		 HEX3,       // Display 3
		 HEX4,       // Display 4
		 HEX5,       // Display 5
		 HEX6,       // Display 6
		 HEX7,       // Display 7
		 /////////////////// LED //////////////////
		 LEDG,       // LED Green (verde) [8:0]
		 LEDR,       // LED Red (vermelho) [17:0]
		 ////////////////////	LCD Module 16X2		////////////////
		 LCD_ON,							//	LCD Power ON/OFF
		 LCD_BLON,						//	LCD Back Light ON/OFF
		 LCD_RW,							//	LCD Read/Write Select, 0 = Write, 1 = Read
		 LCD_EN,							//	LCD Enable
		 LCD_RS,							//	LCD Command/Data Select, 0 = Command, 1 = Data
		 LCD_DATA,						//	LCD Data bus 8 bits
		 GPIO_0,							// GPIO
		 GPIO_1,			

	
	);

wire [7:0] w_d0x0, w_d0x1, w_d0x2, w_d0x3, w_d0x4, w_d0x5,
w_d1x0, w_d1x1, w_d1x2, w_d1x3, w_d1x4, w_d1x5;

   input CLOCK_27;
   input CLOCK_50;

   input [3:0] KEY;
   input [17:0] SW;

   output [6:0] HEX0;
   output [6:0] HEX1;
   output [6:0] HEX2;
   output [6:0] HEX3;
   output [6:0] HEX4;
   output [6:0] HEX5;
	output [6:0] HEX6;
	output [6:0] HEX7;
	
	output [8:0] LEDG;
	output [17:0] LEDR;
	
	
	////////////////////	LCD Module 16X2	////////////////////////////
	inout	[7:0]		LCD_DATA;	
	output			LCD_ON;					//	LCD Power ON/OFF
	output			LCD_BLON;				//	LCD Back Light ON/OFF
	output			LCD_RW;	
	output			LCD_EN;		
	output			LCD_RS;					//	LCD Command/Data Select, 0 = Command, 1 = Data
////////////////////////	GPIO	////////////////////////////////
	inout	[35:0]	GPIO_0;					//	GPIO Connection 0
	inout	[35:0]	GPIO_1;					//	GPIO Connection 1
////////////////////////////////////////////////////////////////////

//	All inout port turn to tri-state	
	assign	GPIO_1		=	36'hzzzzzzzzz;
assign	GPIO_0		=	36'hzzzzzzzzz;	
	
	//	LCD 
assign	LCD_ON		=	1'b1;
assign	LCD_BLON		=	1'b1;


//---------- modifique a partir daqui --------


wire [7:0] w0, w1, w2, w3, w4, w5, w6, w7, w8;
wire w_ULASrc, w_RegWrite, w_RegDst, w_We;
wire [2:0] w_ULAControl, w_wa3;
wire [7:0] w_PCp1, w_PC, w_rd1SrcA, w_rd2, w_SrcB, w_ULAResultWd3, w_RData, w_wd3, w_DataOut;
wire [31:0] w_Inst;
wire w_MemWrite, w_MemtoReg;
wire w_PCSrc, w_Jump, w_Branch, w_Z;
wire [7:0] w_m1, w_nPC, w_PCBranch, w_DataIn, w_RegData;


wire clk_1hz;



wire [6:0]entrada;
wire verif;
wire enter;
wire x;

wire [16:0]number1;
wire [16:0]number2;


assign w_d0x0 = w0;
assign w_d0x1 = w1;
assign w_d0x2 = w2;
assign w_d0x3 = w3;

assign w_d1x0 = w5;
assign w_d1x1 = w6;
assign w_d1x2 = w7;
assign w_d1x3 = w8;

assign LEDR[6:4] = w_ULAControl[2:0];
assign LEDR[7] = w_ULASrc;
assign LEDR[8] = w_RegDst;
assign LEDR[9] = w_RegWrite;

assign w_d0x4 = w_PC;



assign LEDR[1] = w_DataOut[0];

//assign w_DataOut = w_d1x4;
assign w_DataIn  = SW[7:0];

assign entrada[6:0]= w_DataOut[6:0];
assign enter = clk_1hz;

LCD_TEST u5 (.iCLK  	( CLOCK_50 ),.iRST_N	( clk_1hz ),.d0 (number1),.d1 (number2),.LCD_DATA( LCD_DATA ),.LCD_RW  ( LCD_RW ),.LCD_EN	( LCD_EN ),.LCD_RS  ( LCD_RS ));

verificador(verif,entrada,enter);
	
teste(number1,number2,verif);

porta_and(x,~verif,~clk_1hz);	

assign LEDR[0] = x;
assign LEDG[0] = verif;





Parallel_IN para_in(.MemData(w_RData), .DataIn(w_DataIn), .Address(w_ULAResultWd3), .RegData(w_RegData));
Parallel_OUT para_out(.RegData(w_rd2), .DataOut(w_DataOut), .Address(w_ULAResultWd3), .clk(clk_1hz), .wren(w_We), .we(w_MemWrite));

Adder somador (.in_data1(w_PC), .in_data2(1'b1), .out_data(w_PCp1));
Adder Branch (.in_data1(w_PCp1), .in_data2(w_Inst[7:0]), .out_data(w_PCBranch));

Control_Unit unidade_controle (.OP(w_Inst[31:26]), .Funct(w_Inst[5:0]), .Jump(w_Jump), .MemToReg(w_MemtoReg), .MemWrite(w_MemWrite), .Branch(w_Branch), .ULAControl(w_ULAControl), .ULASrc(w_ULASrc), .RegDst(w_RegDst), .RegWrite(w_RegWrite));

pc pc_controle (.clk(clk_1hz), .pc_in(w_nPC), .pc_out(w_PC));
RomInstMem Mem_Inst_ROM (.address(w_PC), .clock(CLOCK_50), .q(w_Inst));
RamDataMem Mem_Data_RAM (.address(w_ULAResultWd3), .clock(CLOCK_50), .data(w_rd2), .wren(w_We), .q(w_RData));
ULA unidadeLA (.scra(w_rd1SrcA), .scrb(w_SrcB), .ula_control(w_ULAControl), .ula_result(w_ULAResultWd3), .flagz(w_Z));
mux2_1 multip2_1_1 (.in_1(w_rd2), .in_2(w_Inst[7:0]), .set(w_ULASrc), .out(w_SrcB));
mux2_1 multip2_1_2 (.in_1(w_Inst[20:16]), .in_2(w_Inst[15:11]), .set(w_RegDst), .out(w_wa3));
mux2_1 MuxDDest (.in_1(w_ULAResultWd3), .in_2(w_RegData), .set(w_MemtoReg), .out(w_wd3));
mux2_1 MuxJump(.in_1(w_m1), .in_2(w_Inst[7:0]), .set(w_Jump), .out(w_nPC));
mux2_1 MuxPCSrc (.in_1(w_PCp1), .in_2(w_PCBranch), .set(w_PCSrc), .out(w_m1));
assign w_PCSrc = w_Branch & w_Z;

assign LEDG[8] = !KEY[1];
banco_registradores base_dados (.we3(w_RegWrite), .clk(clk_1hz), .wa3(w_wa3), .ra1(w_Inst[25:21]), .ra2(w_Inst[20:16]), .rd1(w_rd1SrcA), .rd2(w_rd2), .wd3(w_wd3), .S0(w0), .S1(w1), .S2(w2), .S3(w3), .S4(w5), .S5(w6), .S6(w7), .S7(w8));

divClock clock_1hz (.clk_in(CLOCK_50), .clk_out(clk_1hz));


endmodule
