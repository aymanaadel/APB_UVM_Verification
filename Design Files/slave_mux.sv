module slave_mux(
 	// inputs
 	input PREADY1, PREADY2, slave_select,         
	input [7:0] PRDATA1, PRDATA2,
	// outputs
	output logic [7:0] PRDATA,
	output logic PREADY
);
   
	assign PRDATA = slave_select ? PRDATA2 : PRDATA1;
	assign PREADY = slave_select ? PREADY2 : PREADY1;

endmodule
