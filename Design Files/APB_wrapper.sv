module APB_wrapper(APB_if.DUT apb_if);

// internal wires
logic PSEL1, PSEL2;
logic PENABLE;
logic [8:0] PADDR;
logic PWRITE;
logic [7:0] PWDATA;
logic PSLVERR;
logic [7:0] PRDATA, PRDATA1, PRDATA2;
logic PREADY, PREADY1, PREADY2;

assign apb_if.PREADY=PREADY; 

// APB Master
APB m1(
 	.PCLK(apb_if.clk), .PRESETn(apb_if.PRESETn), .PREADY(PREADY),
	.apb_write_paddr(apb_if.apb_write_paddr),
	.apb_read_paddr(apb_if.apb_read_paddr),
	.apb_write_data(apb_if.apb_write_data),         
	.PRDATA(PRDATA),
	.READ_WRITE(apb_if.READ_WRITE), .transfer(apb_if.transfer),
	// outputs
	.PSEL1(PSEL1), .PSEL2(PSEL2),
	.PENABLE(PENABLE),
	.PADDR(PADDR),
	.PWRITE(PWRITE),
	.PWDATA(PWDATA),
	.PSLVERR(PSLVERR),
	.apb_read_data_out(apb_if.apb_read_data_out)
);
// slave 1 (RAM 1)
ram m2(
  	.PCLK(apb_if.clk), .PRESETn(apb_if.PRESETn), .PSEL(PSEL1), .PWRITE(PWRITE), .PENABLE(PENABLE),
 	.PWDATA(PWDATA),
 	.PADDR(PADDR[7:0]),
  	.PREADY(PREADY1),
	.PRDATA(PRDATA1)
);
// slave 2 (RAM 2)
ram m3(
  	.PCLK(apb_if.clk), .PRESETn(apb_if.PRESETn), .PSEL(PSEL2), .PWRITE(PWRITE), .PENABLE(PENABLE),
 	.PWDATA(PWDATA),
 	.PADDR(PADDR[7:0]),
  	.PREADY(PREADY2),
	.PRDATA(PRDATA2)
);
// Mux
slave_mux m4(
 	.PREADY1(PREADY1), .PREADY2(PREADY2), .slave_select(PADDR[8]),         
	.PRDATA1(PRDATA1), .PRDATA2(PRDATA2),
	.PRDATA(PRDATA),
	.PREADY(PREADY)
);

/* *********************** Some Assertions ****************************** */
// Async. reset assertion
always_comb begin
	if (!apb_if.PRESETn) begin
		reset_assert: assert final(apb_if.apb_read_data_out==0);
		reset_cover:  cover  final(apb_if.apb_read_data_out==0);
	end
end

// When there is a transfer, PSEL1 or PSEL2 should be High to select a specific slave
PSEL_assert: assert property (@(posedge apb_if.clk) $rose(apb_if.transfer) |=> (PSEL1 || PSEL2));
PSEL_cover:  cover  property (@(posedge apb_if.clk) $rose(apb_if.transfer) |=> (PSEL1 || PSEL2));

// When there is a transfer, PEANBLE should be High after 2 cycles (High in the ACCESS state)
PENABLE_assert: assert property (@(posedge apb_if.clk) $rose(apb_if.transfer) |-> ##2 PENABLE);
PENABLE_cover:  cover  property (@(posedge apb_if.clk) $rose(apb_if.transfer) |-> ##2 PENABLE);

// When READ_WRITE is High/Low (WRITE/READ), PWRITE should be High/Low
PWRITE_assert: assert property (@(posedge apb_if.clk) apb_if.READ_WRITE == PWRITE);
PWRITE_cover:  cover  property (@(posedge apb_if.clk) apb_if.READ_WRITE == PWRITE);

// Add more assertions here...

/* ********************************************************************* */

endmodule 