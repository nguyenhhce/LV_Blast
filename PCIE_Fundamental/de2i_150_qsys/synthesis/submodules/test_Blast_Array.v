`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:43:08 05/08/2015 
// Design Name: 
// Module Name:    test_Blast_Array
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
module test_Blast_Array(
    );
localparam
A = 3'b001,        //nucleotide "A"
G = 3'b010,        //nucleotide "G"
T = 3'b011,        //nucleotide "T"
C = 3'b100,        //nucleotide "C"
N = 3'b101;        //nucleotide "C"
parameter LENGTH_CHAR = 3;
parameter LENGTH_2BYTES = 8;
parameter LENGTH_COUNTER = 8;
parameter LENGTH = 32;
parameter LENGTH_ARRAY = 4;
parameter LENGTH_ADDRESS = 16;
parameter LENGTH_HIT_INFO = 22;
parameter LENGTH_ADN = 128;
parameter TIME = 100;
reg array_clk, query_enable, sub_enable, enable;
reg reset, read_HSP;
reg [LENGTH_CHAR-1:0] query_datastream_in, sub_datastream_in;
reg [LENGTH_CHAR*LENGTH_ARRAY-1:0] Q_context_F, S_context_F;
reg [LENGTH_CHAR*LENGTH_ARRAY-1:0] Q_context_R, S_context_R;
wire [LENGTH_COUNTER-1:0] hit_add_inQ_UnGap, hit_add_inS_UnGap, hit_length_UnGap;
wire [LENGTH_COUNTER*LENGTH_ARRAY-1:0] Q_address_F, S_address_F;
wire [LENGTH_COUNTER*LENGTH_ARRAY-1:0] Q_address_R, S_address_R;
wire [LENGTH_COUNTER-1:0] hit_add_score;
wire [LENGTH_CHAR-1:0] query_datastream_out, sub_datastream_out;
wire [87:0] _debug_;
wire  FIFO_empty;

integer i,j;

// Variable of query and subject
	wire [8*LENGTH_ADN-1:0] stringvar_q, stringvar_s;
	assign stringvar_q = "ATAAGTGCTTTTAAAAACTGAACCAAATCAATAGGCAATTGTAACAAAGTGCTTTTATCTGCATAAGTGCTTAAAAACTGAACCAAATCTGCAAAAGTGCTTTTAACAAAGTGCTTTTATCTGCAGTA";
	assign stringvar_s = "GGATACCGTAGACGAGGAGGAAGATCCGGGGGCAGCTGCTCCATTATTACCAAAAACTGAACCAAATTAATAGGCAATTGAACTGAACCAAATTAATAGGCAATTGAACTGAACCAAATTAATAAGTA";
	
	Blastn_Array Blast_A(array_clk, query_enable, sub_enable, enable, reset, read_HSP,
						Q_address_F, S_address_F, Q_context_F, S_context_F,
						Q_address_R, S_address_R, Q_context_R, S_context_R,
						query_datastream_in, sub_datastream_in, query_datastream_out, sub_datastream_out,
						hit_add_inQ_UnGap, hit_add_inS_UnGap, hit_length_UnGap, hit_add_score,FIFO_empty, _debug_);
						
						
	always #50 array_clk =~array_clk ;
	
   always @(posedge array_clk)
  begin
	for (j=0; j<LENGTH_ARRAY; j=j+1)
		begin
			case (stringvar_q[(Q_address_F[LENGTH_COUNTER*j+:LENGTH_COUNTER])*LENGTH_2BYTES+:LENGTH_2BYTES]) 
				"A": Q_context_F[LENGTH_CHAR*j+:LENGTH_CHAR] = A;
				"G": Q_context_F[LENGTH_CHAR*j+:LENGTH_CHAR] = G;
				"T": Q_context_F[LENGTH_CHAR*j+:LENGTH_CHAR] = T;
				"C": Q_context_F[LENGTH_CHAR*j+:LENGTH_CHAR] = C;	
				"N": Q_context_F[LENGTH_CHAR*j+:LENGTH_CHAR] = N;			
			endcase
			
			case (stringvar_q[(Q_address_R[LENGTH_COUNTER*j+:LENGTH_COUNTER])*LENGTH_2BYTES+:LENGTH_2BYTES]) 
				"A": Q_context_R[LENGTH_CHAR*j+:LENGTH_CHAR] = A;
				"G": Q_context_R[LENGTH_CHAR*j+:LENGTH_CHAR] = G;
				"T": Q_context_R[LENGTH_CHAR*j+:LENGTH_CHAR] = T;
				"C": Q_context_R[LENGTH_CHAR*j+:LENGTH_CHAR] = C;		
				"N": Q_context_R[LENGTH_CHAR*j+:LENGTH_CHAR] = N;
			endcase
			case (stringvar_s[(S_address_F[LENGTH_COUNTER*j+:LENGTH_COUNTER])*LENGTH_2BYTES+:LENGTH_2BYTES]) 
				"A": S_context_F[LENGTH_CHAR*j+:LENGTH_CHAR] = A;
				"G": S_context_F[LENGTH_CHAR*j+:LENGTH_CHAR] = G;
				"T": S_context_F[LENGTH_CHAR*j+:LENGTH_CHAR] = T;
				"C": S_context_F[LENGTH_CHAR*j+:LENGTH_CHAR] = C;
				"N": S_context_F[LENGTH_CHAR*j+:LENGTH_CHAR] = N;
			endcase
			case (stringvar_s[(S_address_R[LENGTH_COUNTER*j+:LENGTH_COUNTER])*LENGTH_2BYTES+:LENGTH_2BYTES]) 
				"A": S_context_R[LENGTH_CHAR*j+:LENGTH_CHAR] = A;
				"G": S_context_R[LENGTH_CHAR*j+:LENGTH_CHAR] = G;
				"T": S_context_R[LENGTH_CHAR*j+:LENGTH_CHAR] = T;
				"C": S_context_R[LENGTH_CHAR*j+:LENGTH_CHAR] = C;	
				"N": S_context_R[LENGTH_CHAR*j+:LENGTH_CHAR] = N;	
			endcase
		
		if (Q_address_F[LENGTH_COUNTER*i+:LENGTH_COUNTER] == 255) Q_context_F = 0;
		if (Q_address_R[LENGTH_COUNTER*i+:LENGTH_COUNTER] == 255) Q_context_R = 0;
		if (S_address_F[LENGTH_COUNTER*i+:LENGTH_COUNTER] == 255) S_context_F = 0;
		if (S_address_R[LENGTH_COUNTER*i+:LENGTH_COUNTER] == 255) S_context_R = 0;
	end
  end



	always @(posedge array_clk) 
		if (hit_length_UnGap!=0)
			begin
				$display("UnGap, Hit in Query: ", hit_add_inQ_UnGap + 1, ". Hit in Subject: ",hit_add_inS_UnGap + 1, ". Length of Hit", hit_length_UnGap + 1, ".Score: ", hit_add_score);
			end
 
 initial begin
    // Initialize Inputs
	 array_clk = 0;
	 //enable = 1;
		reset = 1;
	 
	 sub_enable = 0;
	 query_enable = 1;
	 
	 sub_datastream_in = 0;
	 query_datastream_in = 0;
	 #TIME;
	 reset = 0;
	 for (i=0; i<LENGTH_ADN; i=i+1)
	 begin	
			case (stringvar_q[i*LENGTH_2BYTES+:LENGTH_2BYTES]) 
			"A": begin query_datastream_in = A; $display("query_datastream_in: A. stringvar_q: ", stringvar_q[i*LENGTH_2BYTES+:LENGTH_2BYTES]); end
			"G": begin query_datastream_in = G; $display("query_datastream_in: G. stringvar_q: ", stringvar_q[i*LENGTH_2BYTES+:LENGTH_2BYTES]); end
			"T": begin query_datastream_in = T; $display("query_datastream_in: T. stringvar_q: ", stringvar_q[i*LENGTH_2BYTES+:LENGTH_2BYTES]); end
			"C": begin query_datastream_in = C;	 $display("query_datastream_in: C. stringvar_q: ", stringvar_q[i*LENGTH_2BYTES+:LENGTH_2BYTES]); end
			"N": begin query_datastream_in = N;		 $display("query_datastream_in: N. stringvar_q: ", stringvar_q[i*LENGTH_2BYTES+:LENGTH_2BYTES]); end	
			endcase
			 
			#TIME;
	 end
	query_enable = 0;
	sub_enable = 1;
	 for (i=0; i<LENGTH_ADN; i=i+1)
	 begin	
			case (stringvar_s[i*LENGTH_2BYTES+:LENGTH_2BYTES]) 
			"A": begin sub_datastream_in = A; $display("sub_datastream_in: A. stringvar_s: ", stringvar_s[i*LENGTH_2BYTES+:LENGTH_2BYTES]); end
			"G": begin sub_datastream_in = G; $display("sub_datastream_in: G. stringvar_s: ", stringvar_s[i*LENGTH_2BYTES+:LENGTH_2BYTES]); end
			"T": begin sub_datastream_in = T; $display("sub_datastream_in: T. stringvar_s: ", stringvar_s[i*LENGTH_2BYTES+:LENGTH_2BYTES]); end
			"C": begin sub_datastream_in = C;	 $display("sub_datastream_in: C. stringvar_s: ", stringvar_s[i*LENGTH_2BYTES+:LENGTH_2BYTES]); end
			"N": begin sub_datastream_in = N;		 $display("sub_datastream_in: N. stringvar_s: ", stringvar_s[i*LENGTH_2BYTES+:LENGTH_2BYTES]); end	
			endcase
			//$display("sub_datastream_in: ",sub_datastream_in, , "stringvar_s: ", stringvar_s[i*LENGTH_2BYTES+:LENGTH_2BYTES]);
			#TIME;
	 end
	 sub_datastream_in = 0;
	//#10000;
	//read_HSP = 1;
	sub_enable = 0;
	#10000;
	read_HSP = 1;
	#10000;
	array_clk = 0;
	// enable = 1;
		reset = 1;
	 
	 sub_datastream_in = 0;
	 query_datastream_in = 0;
	#10000;
	read_HSP = 0;
	 #TIME;
	 reset = 0;
	 
	query_enable = 0;
	sub_enable = 1;
	 for (i=0; i<LENGTH_ADN; i=i+1)
	 begin	
			case (stringvar_s[i*LENGTH_2BYTES+:LENGTH_2BYTES]) 
			"A": begin sub_datastream_in = A; $display("sub_datastream_in: A. stringvar_s: ", stringvar_s[i*LENGTH_2BYTES+:LENGTH_2BYTES]); end
			"G": begin sub_datastream_in = G; $display("sub_datastream_in: G. stringvar_s: ", stringvar_s[i*LENGTH_2BYTES+:LENGTH_2BYTES]); end
			"T": begin sub_datastream_in = T; $display("sub_datastream_in: T. stringvar_s: ", stringvar_s[i*LENGTH_2BYTES+:LENGTH_2BYTES]); end
			"C": begin sub_datastream_in = C;	 $display("sub_datastream_in: C. stringvar_s: ", stringvar_s[i*LENGTH_2BYTES+:LENGTH_2BYTES]); end
			"N": begin sub_datastream_in = N;		 $display("sub_datastream_in: N. stringvar_s: ", stringvar_s[i*LENGTH_2BYTES+:LENGTH_2BYTES]); end	
			endcase
			//$display("sub_datastream_in: ",sub_datastream_in, , "stringvar_s: ", stringvar_s[i*LENGTH_2BYTES+:LENGTH_2BYTES]);
			#TIME;
	 end
	 sub_datastream_in = 0;
	//#10000;
	//read_HSP = 1;
	sub_enable = 0;
	#10000;
	read_HSP = 1;
	//fifo_Sum_rd = 1;
end

endmodule
