package APB_reset_sequence_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import APB_seq_item_pkg::*;

	class APB_reset_sequence extends uvm_sequence #(APB_seq_item);
		`uvm_object_utils(APB_reset_sequence)

		APB_seq_item seq_item;

		function new(string name = "APB_reset_sequence");
			super.new(name);
		endfunction

		task body;
			seq_item=APB_seq_item::type_id::create("seq_item");
			start_item(seq_item);
			seq_item.PRESETn=0;
			seq_item.transfer=0;
			seq_item.READ_WRITE=0;
			finish_item(seq_item);
		endtask
		
	endclass

endpackage