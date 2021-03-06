`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:44:21 04/22/2015 
// Design Name: 
// Module Name:    Blastn_Unit
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
module Blastn_Unit(offset,array_clk, query_enable, sub_enable, enable, reset, read_HSP,
						Q_address_F, S_address_F, Q_context_F, S_context_F,
						Q_address_R, S_address_R, Q_context_R, S_context_R,
						query_datastream_in, sub_datastream_in, query_datastream_out, sub_datastream_out,
						hit_add_inQ_UnGap, hit_add_inS_UnGap, hit_length_UnGap, hit_add_score,_debug_, query_debug, subject_debug,num_HSP_out);
localparam
A = 3'b001,        //nucleotide "A"
G = 3'b010,        //nucleotide "G"
T = 3'b011,        //nucleotide "T"
C = 3'b100;        //nucleotide "C"
parameter LENGTH_CHAR = 3;
parameter LENGTH_2BYTES = 8;
parameter LENGTH_COUNTER = 8;
parameter LENGTH = 32;
parameter LENGTH_ADDRESS = 16;
parameter LENGTH_HIT_INFO = 22;
parameter NUMBER_ARRAY = 4;

input [LENGTH_COUNTER-1:0] offset;
input array_clk, query_enable, sub_enable, enable;
input reset, read_HSP;
input [LENGTH_CHAR-1:0] query_datastream_in, sub_datastream_in;
input [LENGTH_CHAR-1:0] Q_context_F, S_context_F;
input [LENGTH_CHAR-1:0] Q_context_R, S_context_R;
output [LENGTH_COUNTER-1:0] hit_add_inQ_UnGap, hit_add_inS_UnGap, hit_length_UnGap;
output [LENGTH_COUNTER-1:0] Q_address_F, S_address_F;
output [LENGTH_COUNTER-1:0] Q_address_R, S_address_R;
output [LENGTH_COUNTER-1:0] hit_add_score;
output reg [LENGTH_COUNTER-1:0] num_HSP_out=0;
output [LENGTH_CHAR-1:0] query_datastream_out, sub_datastream_out;

//debug
output reg [LENGTH_HIT_INFO-1:0] _debug_;

wire [LENGTH_HIT_INFO-1:0] hits_vector_1;
wire  [LENGTH_COUNTER*LENGTH_HIT_INFO-1:0] hit_add_inQ, hit_add_inS;
wire [LENGTH_COUNTER-1:0] address_of_hits;
wire [LENGTH_HIT_INFO-1:0] enable_Hit_Extrac_1, enable_Hit_Extrac_2;
wire [LENGTH_COUNTER*LENGTH_HIT_INFO-1:0] hit_length;
wire [LENGTH_COUNTER-1:0] hit_add_inQ_out, hit_add_inS_out, hit_length_out;
wire [LENGTH_COUNTER-1:0] hit_add_inQ_HSP, hit_add_inS_HSP, hit_length_HSP;
reg fifo_Sum_wr = 1;
wire fifo_Sum_empty, fifo_Sum_full;
wire [LENGTH_COUNTER-1 :0] fifo_Sum_counter;
output wire [LENGTH_CHAR*LENGTH-1:0] query_debug,subject_debug;


// Multi hits detection
systoic_array systoic_U(query_datastream_in, query_datastream_out, sub_datastream_in, sub_datastream_out, 
		array_clk, query_enable, sub_enable, enable, 
		hits_vector_1, reset, query_debug,subject_debug);

// Get all Hits info from hit detection
Hit_Info_Extrac Hit_Info_Extrac_U(array_clk,offset,query_enable, sub_enable,hits_vector_1,   hit_add_inQ, hit_add_inS,enable_Hit_Extrac_1,hit_length, reset);


// Take all Hits info out to an FIFO
Hit_To_FIFO Hit_To_FIFO(array_clk, hit_add_inQ, hit_add_inS, hit_length, enable_Hit_Extrac_1, hit_add_inQ_out,hit_add_inS_out, hit_length_out, reset);

// Summary fifo which store all Hits
//Fifo_B fifo_Sum(array_clk, reset, hit_add_inS_out, hit_add_inQ_out+(NUMBER_ARRAY-1-offset)*LENGTH, hit_length_out, hit_add_inS_UnGap, hit_add_inQ_UnGap, hit_length_UnGap,
	//		fifo_Sum_wr, read_HSP, fifo_Sum_empty, fifo_Sum_full, fifo_Sum_counter );

Fifo_B fifo_Sum(array_clk, reset, hit_add_inS_out, hit_add_inQ_out+(NUMBER_ARRAY-1-offset)*LENGTH, hit_length_out, hit_add_inS_UnGap, hit_add_inQ_UnGap, hit_length_UnGap,
			fifo_Sum_wr, read_HSP, fifo_Sum_empty, fifo_Sum_full, fifo_Sum_counter );

// Take Hits to Ungap extention block, output is HSPs (Info and Score of Hits)
//Ungapped_Extension UnGap(array_clk,reset, read_HSP, Q_address_F, S_address_F, Q_context_F, S_context_F,
//								Q_address_R, S_address_R, Q_context_R, S_context_R,
//								hit_add_inQ_HSP,hit_add_inS_HSP, hit_length_HSP, hit_add_inQ_UnGap,hit_add_inS_UnGap, hit_length_UnGap,hit_add_score);
always @(posedge array_clk) 
		if (hit_length_out!=0)
			begin
				$display("NO.: ", offset, ". Hit in Query: ", hit_add_inQ_out+(NUMBER_ARRAY-1-offset)*LENGTH, ". Hit in Subject: ",hit_add_inS_out, ". Length of Hit", hit_length_out + 1);
				num_HSP_out = num_HSP_out + 1;
			end

always @(posedge array_clk) 	
		if (hits_vector_1!=0) _debug_ = hits_vector_1;

endmodule
