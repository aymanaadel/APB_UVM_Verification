package APB_env_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import APB_agent_pkg::*;
import APB_scoreboard_pkg::*;
import APB_coverage_pkg::*;

	class APB_env extends uvm_env;
		`uvm_component_utils(APB_env)

		APB_agent agt;
		APB_scoreboard sb;
		APB_coverage cov;

		function new(string name = "APB_env", uvm_component parent = null);
			super.new(name,parent);
		endfunction

		function void build_phase(uvm_phase phase);
			super.build_phase(phase);
			agt=APB_agent::type_id::create("agt",this);
			sb=APB_scoreboard::type_id::create("sb",this);
			cov=APB_coverage::type_id::create("cov",this);
		endfunction

		function void connect_phase(uvm_phase phase);
			// super.connect_phase(phase); 
			agt.agt_ap.connect(sb.sb_export); 
			agt.agt_ap.connect(cov.cov_export);
		endfunction
	endclass

endpackage