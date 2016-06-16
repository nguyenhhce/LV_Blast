`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:44:21 04/22/2015 
// Design Name: 
// Module Name:    array_component
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module array_component(query_char_in, query_char_out, sub_char_in, sub_char_out, com_clk, query_enable, sub_enable, match, query_id, sub_id, reset);
localparam
A = 3'b001,        //nucleotide "A"
G = 3'b010,        //nucleotide "G"
T = 3'b011,        //nucleotide "T"
C = 3'b100,        //nucleotide "C"
N = 3'b101;        //nucleotide "N"

parameter LENGTH_CHAR = 3;
parameter LENGTH_COUNTER =8;
parameter LENGTH = 6;
parameter LENGTH_ADDRESS = 16;
input com_clk, query_enable, sub_enable;
input [LENGTH_CHAR-1:0] query_char_in, sub_char_in;
input reset;
output reg match;
output reg [LENGTH_CHAR-1:0] query_char_out, sub_char_out;
output reg [LENGTH_COUNTER-1:0] query_id, sub_id;
reg [LENGTH_COUNTER-1:0] q_id = 8'b11111111, s_id = 8'b11111111;




always @(posedge com_clk)
begin
	if (reset == 1)
		begin
			match = 0;
			sub_char_out = 0;
			sub_id = 0;
			s_id = 8'b11111111;
		end
		
	match =0;		
	if (query_enable == 1)
			if ((3'b000<query_char_in) && (query_char_in<3'b101))
			begin
				query_char_out=query_char_in;
				q_id=q_id+1;
				query_id=q_id;
			end
			
	if (sub_enable == 1)
		begin
			if ((sub_char_in<3'b101))
				begin					
					sub_char_out=sub_char_in;
					s_id=s_id+1;
					sub_id=s_id;
				end
			if ((sub_char_in == query_char_out)) match =1;
			else match =0;
		end
end
	 
endmodule