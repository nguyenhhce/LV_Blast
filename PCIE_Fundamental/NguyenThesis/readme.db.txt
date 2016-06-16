nc1130 is the full database containing 5217 sequences
nc1130b is the "lite" version containing only the first 380 sequences of the 
full version

files with suffix... 
_flat           Is the GenBank flat file (nucleotide sequences have degenerate 
                base symbols).
_fsa_ncbi		Contains the same sequences as in the flat file, but in FASTA 
                format (also contains degenerate base symbols).
_fsa_common     Contains sequences in FASTA format, but has randomly substituted
                bases for the degenerate symbols. This file should be used for
                the NCBI-BLAST database and to load the tables for BLAST in 
                Oracle. This ensures that both implementations access identical
                databases.
