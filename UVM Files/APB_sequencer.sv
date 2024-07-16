package APB_sequencer_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import APB_seq_item_pkg::*;

	class APB_sequencer extends uvm_sequencer #(APB_seq_item);
		`uvm_component_utils(APB_sequencer)

		function new(string name = "APB_sequencer", uvm_component parent = null);
			super.new(name,parent);
		endfunction

	endclass

endpackage