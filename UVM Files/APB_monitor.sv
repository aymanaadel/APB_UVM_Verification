package APB_monitor_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import APB_seq_item_pkg::*;

	class APB_monitor extends uvm_monitor;
		`uvm_component_utils(APB_monitor)

		virtual APB_if APB_vif;
		APB_seq_item rsp_seq_item;

		uvm_analysis_port #(APB_seq_item) mon_ap;

		function new(string name = "APB_monitor", uvm_component parent = null);
			super.new(name,parent);
		endfunction

		function void build_phase(uvm_phase phase);
			super.build_phase(phase);
			mon_ap=new("mon_ap",this);
		endfunction

		task run_phase(uvm_phase phase);
			super.run_phase(phase);
			forever begin
				rsp_seq_item=APB_seq_item::type_id::create("rsp_seq_item");

				@(negedge APB_vif.clk);
				// Design outputs
				rsp_seq_item.apb_read_data_out=APB_vif.apb_read_data_out;
				// Design inputs
				rsp_seq_item.PRESETn=APB_vif.PRESETn;
				rsp_seq_item.apb_write_paddr=APB_vif.apb_write_paddr;
				rsp_seq_item.apb_read_paddr=APB_vif.apb_read_paddr;
				rsp_seq_item.apb_write_data=APB_vif.apb_write_data;
				rsp_seq_item.READ_WRITE=APB_vif.READ_WRITE;
				rsp_seq_item.transfer=APB_vif.transfer;
				// internal signal
				rsp_seq_item.PREADY=APB_vif.PREADY;

				mon_ap.write(rsp_seq_item);				
				`uvm_info("run_phase", rsp_seq_item.convert2string(), UVM_HIGH);
			end
		endtask

	endclass
endpackage