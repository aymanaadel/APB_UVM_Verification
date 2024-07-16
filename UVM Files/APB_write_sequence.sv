package APB_write_sequence_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import APB_seq_item_pkg::*;

	class APB_write_sequence extends uvm_sequence #(APB_seq_item);
		`uvm_object_utils(APB_write_sequence)

		APB_seq_item seq_item;

		bit slave_select;
		typedef enum bit {READ=0, WRITE=1} rw_e;

		function new(string name = "APB_write_sequence");
			super.new(name);
		endfunction

		task body;
			seq_item=APB_seq_item::type_id::create("seq_item");

			/* Write random data in all the 256 locations of the RAM */
			for (int i = 0; i < 256; i++) begin			
				start_item(seq_item);
				assert(seq_item.randomize());
				seq_item.PRESETn=1;
				seq_item.READ_WRITE=WRITE;
				seq_item.apb_write_paddr[7:0]=i;
				seq_item.apb_write_paddr[8]=slave_select;
				// seq_item.apb_write_data=write_data; /* randomized already */
				seq_item.apb_read_paddr=9'b0; /* not important in write */
				finish_item(seq_item);
			end		


		endtask
		
	endclass

endpackage


