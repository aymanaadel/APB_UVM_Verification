import uvm_pkg::*;
`include "uvm_macros.svh"
import APB_test_pkg::*;

module top;
	// clock generation
	bit clk;
	initial begin
		clk=0;
		forever #1 clk=~clk;
	end
	// interface
	APB_if apb_if(clk);
	// DUT
	APB_wrapper dut(apb_if);

	initial begin
		uvm_config_db#(virtual APB_if)::set(null, "uvm_test_top", "APB_IF", apb_if);
		run_test("APB_test");
	end

endmodule