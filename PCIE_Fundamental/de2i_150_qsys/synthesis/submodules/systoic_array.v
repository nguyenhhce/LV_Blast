`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:44:21 04/22/2015 
// Design Name: 
// Module Name:    systoic_array
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
module systoic_array(query_datastream_in, query_datastream_out, sub_datastream_in, sub_datastream_out, 
		array_clk, query_enable, sub_enable, enable, hits_vector_1, reset, query_debug, subject_debug);
//		hit_query_location_1, hit_query_location_2, hit_sub_location_1, hit_sub_location_2);
parameter LENGTH_CHAR = 3;
parameter LENGTH_COUNTER =8;
parameter LENGTH = 32;
parameter LENGTH_HIT_INFO = 22;
input array_clk, query_enable, sub_enable, enable;
input [LENGTH_CHAR-1:0] query_datastream_in, sub_datastream_in;
input reset;
output wire [LENGTH_CHAR-1:0] query_datastream_out, sub_datastream_out;
output wire [LENGTH_CHAR*LENGTH-1:0] query_debug, subject_debug;
output wire [LENGTH_HIT_INFO-1:0] hits_vector_1;

wire [LENGTH_CHAR-1:0]  query_temp_1[0:LENGTH-1], sub_temp_1[0:LENGTH-1];
								
wire [LENGTH_COUNTER-1:0] query_loc_holder_1[0:LENGTH-1],sub_loc_holder_1[0:LENGTH-1];
								
wire match_holder_1[0:LENGTH-1];

genvar x;
generate
for (x=0; x < LENGTH-1; x = x + 1) begin: Debug_Q
	assign query_debug[x*LENGTH_CHAR+LENGTH_CHAR-1:x*LENGTH_CHAR] = query_temp_1[x];
	end
endgenerate	

assign query_debug[(LENGTH-1)*LENGTH_CHAR+LENGTH_CHAR-1:(LENGTH-1)*LENGTH_CHAR] = query_datastream_out;

genvar y;
generate
for (y=0; y < LENGTH-1; y = y + 1) begin: Debug_S
	assign subject_debug[y*LENGTH_CHAR+LENGTH_CHAR-1:y*LENGTH_CHAR] = sub_temp_1[y];
	end
endgenerate	

assign subject_debug[(LENGTH-1)*LENGTH_CHAR+LENGTH_CHAR-1:(LENGTH-1)*LENGTH_CHAR] = sub_datastream_out;
	
genvar i;
generate
for (i=0; i < LENGTH; i = i + 1)
  begin: pe_block
      if (i == 0)                       //first processing element in auto-generated chain
		begin: pe_block0
         array_component pe0(.query_char_in(query_datastream_in),
             .com_clk(array_clk),
				 .query_char_out(query_temp_1[i]),
             .sub_char_in(sub_datastream_in),
             .sub_char_out(sub_temp_1[i]),
				 .match(match_holder_1[i]),
				 .query_enable(query_enable),
             .sub_enable(sub_enable),
             .query_id(query_loc_holder_1[i]),
				 .sub_id(sub_loc_holder_1[i]), 
				 .reset(reset));		 
		end
		else if ((i>0) && (i<31))       //processing elements other than first one
		begin: pe_block1_30
          array_component pe1_30(.query_char_in(query_temp_1[i-1]),
              .com_clk(array_clk),
				 .query_char_out(query_temp_1[i]),
             .sub_char_in(sub_temp_1[i-1]),
             .sub_char_out(sub_temp_1[i]),
				 .match(match_holder_1[i]),
				 .query_enable(query_enable),
             .sub_enable(sub_enable),
             .query_id(query_loc_holder_1[i]),
				 .sub_id(sub_loc_holder_1[i]), 
				 .reset(reset));		 
		end
		
		else if (i==31)       //processing elements other than first one
		begin: pe_block31
          array_component pe31(.query_char_in(query_temp_1[i-1]),
             .com_clk(array_clk),
				 .query_char_out(query_datastream_out),
             .sub_char_in(sub_temp_1[i-1]),
             .sub_char_out(sub_datastream_out),
				 .match(match_holder_1[i]),
				 .query_enable(query_enable),
             .sub_enable(sub_enable),
             .query_id(query_loc_holder_1[i]),
				 .sub_id(sub_loc_holder_1[i]), 
				 .reset(reset));		 
		end
   end
endgenerate

generate
for (i=0; i < LENGTH_HIT_INFO; i = i + 1)
   begin: andn
			begin
				AND_gate_11 and0(match_holder_1[i],
             match_holder_1[i+1],
				 match_holder_1[i+2],
				 match_holder_1[i+3],
				 match_holder_1[i+4],
				 match_holder_1[i+5],
				 match_holder_1[i+6],
				 match_holder_1[i+7],
				 match_holder_1[i+8],
				 match_holder_1[i+9],
				 match_holder_1[i+10],
             hits_vector_1[i]);
			end
	end

endgenerate
							
	
	 
endmodule