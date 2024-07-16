interface APB_if (input bit clk);
 	// inputs
 	logic PRESETn, READ_WRITE, transfer;
	logic [8:0] apb_write_paddr;
	logic [8:0] apb_read_paddr;
	logic [7:0] apb_write_data;         

	// outputs
	logic [7:0] apb_read_data_out;
	// internal signals
	logic PREADY;

	// DUT modport
	modport DUT(
		input clk, PRESETn, READ_WRITE, transfer, apb_write_paddr, apb_read_paddr, apb_write_data,
		output apb_read_data_out, PREADY
	);
	
endinterface