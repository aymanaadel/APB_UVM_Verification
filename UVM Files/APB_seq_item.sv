package APB_seq_item_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"

	class APB_seq_item extends uvm_sequence_item;
		`uvm_object_utils(APB_seq_item)

	 	// inputs
	 	rand bit PRESETn, READ_WRITE, transfer;
		rand logic [8:0] apb_write_paddr;
		rand logic [8:0] apb_read_paddr;
		rand logic [7:0] apb_write_data;         

		// outputs
		logic [7:0] apb_read_data_out;
		// internal signal
		logic PREADY;

		bit [7:0] specific_patterns[] = '{8'hFF, 8'h00, 8'b1010_1010, 8'b0101_0101};
		rand bit [7:0] specific_patterns_t, specific_patterns_f;

		int RST_ACTIVE= 2;
		int RST_NOT_ACITVE= 98;

		// Assert reset less often
		constraint rst_c { PRESETn dist {0:=RST_ACTIVE, 1:=RST_NOT_ACITVE}; }

		// constraint on data written to take specific values (FF, 00, alternating) more often 
		constraint data_patterns_c { 
		specific_patterns_t inside {specific_patterns}; // the specific values
		!(specific_patterns_f inside {specific_patterns}); // the rest of values
		apb_write_data dist {specific_patterns_t:=20, specific_patterns_f:=80};
		}

		function new(string name = "APB_seq_item");
			super.new(name);
		endfunction
		
		function string convert2string();
			return $sformatf("%s PRESETn=0b%0b, READ_WRITE=0b%0b, transfer=0b%0b, apb_write_paddr=0x%0x, apb_read_paddr=0x%0x, apb_write_data=0x%0x, apb_read_data_out=0x%0x", 
				super.convert2string(), PRESETn, READ_WRITE, transfer, apb_write_paddr, apb_read_paddr, apb_write_data, apb_read_data_out);
		endfunction

	endclass

endpackage