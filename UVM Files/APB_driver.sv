package APB_driver_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import APB_seq_item_pkg::*;

	class APB_driver extends uvm_driver #(APB_seq_item);
		`uvm_component_utils(APB_driver)

		virtual APB_if APB_vif;
		APB_seq_item stim_seq_item;

		function new(string name = "APB_driver", uvm_component parent = null);
			super.new(name,parent);
		endfunction
		
		task run_phase(uvm_phase phase);
			super.run_phase(phase);
			forever begin
				stim_seq_item=APB_seq_item::type_id::create("stim_seq_item");
				seq_item_port.get_next_item(stim_seq_item);

				/* reset sequence case */
				if (!stim_seq_item.PRESETn) begin
					APB_vif.PRESETn=stim_seq_item.PRESETn;
					APB_vif.transfer=stim_seq_item.transfer;
					APB_vif.READ_WRITE=stim_seq_item.READ_WRITE;
					@(negedge APB_vif.clk);
				end
				else /* normal sequence (write/read) case */ begin 
					APB_vif.PRESETn=1;
					APB_vif.transfer=1;
					APB_vif.READ_WRITE=stim_seq_item.READ_WRITE;
					APB_vif.apb_write_paddr=stim_seq_item.apb_write_paddr;
					APB_vif.apb_write_data=stim_seq_item.apb_write_data;
					APB_vif.apb_read_paddr=stim_seq_item.apb_read_paddr;
					@(negedge APB_vif.clk);

					// setup state (keep driving values)
					@(negedge APB_vif.clk);

					APB_vif.transfer=0;
					@(negedge APB_vif.clk);
				end
				seq_item_port.item_done();
			end
		endtask
	endclass
endpackage