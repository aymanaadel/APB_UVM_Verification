package APB_agent_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import APB_sequencer_pkg::*;
import APB_driver_pkg::*;
import APB_monitor_pkg::*;
import APB_config_pkg::*;
import APB_seq_item_pkg::*;

	class APB_agent extends uvm_agent;
		`uvm_component_utils(APB_agent)

		APB_sequencer sqr;
		APB_driver drv;
		APB_monitor mon;
		// config object to get the IF
		APB_config APB_cfg;
		uvm_analysis_port #(APB_seq_item) agt_ap;

		function new(string name = "APB_agent", uvm_component parent = null);
			super.new(name,parent);
		endfunction
		
		function void build_phase(uvm_phase phase);
			super.build_phase(phase);
			sqr=APB_sequencer::type_id::create("sqr",this);
			drv=APB_driver::type_id::create("drv",this);
			mon=APB_monitor::type_id::create("mon",this);
			agt_ap=new("agt_ap",this);

			if ( !uvm_config_db#(APB_config)::get(this, "", "CFG", APB_cfg) ) begin
				`uvm_fatal("build_phase", "AGENT - unable to get the IF");
			end

		endfunction

		function void connect_phase(uvm_phase phase);
			super.connect_phase(phase);
			drv.APB_vif=APB_cfg.APB_vif;
			mon.APB_vif=APB_cfg.APB_vif;
			drv.seq_item_port.connect(sqr.seq_item_export);
			mon.mon_ap.connect(agt_ap);
		endfunction
	endclass

endpackage