package APB_config_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"

	class APB_config extends  uvm_object;
		`uvm_object_utils(APB_config)

		virtual APB_if APB_vif;

		function new(string name = "APB_config");
			super.new(name);
		endfunction

	endclass

endpackage