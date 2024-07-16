package APB_test_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import APB_env_pkg::*;

import APB_reset_sequence_pkg::*;
import APB_write_sequence_pkg::*;
import APB_read_sequence_pkg::*;
import APB_write_with_wait_sequence_pkg::*;
import APB_read_with_wait_sequence_pkg::*;

import APB_config_pkg::*;

	class APB_test extends uvm_component;
		`uvm_component_utils(APB_test)

		// env
		APB_env env;
		// sequences
		APB_reset_sequence reset_sequence;
		APB_write_sequence write_sequence;
		APB_read_sequence read_sequence;
		APB_write_with_wait_sequence write_with_wait_sequence;
		APB_read_with_wait_sequence read_with_wait_sequence;
		// config object to get the if
		APB_config APB_cfg;

		typedef enum bit {SLAVE1=0, SLAVE2=1} slave_e;

		function new(string name = "APB_test", uvm_component parent = null);
			super.new(name,parent);
		endfunction

		function void build_phase(uvm_phase phase);
			super.build_phase(phase);
			env=APB_env::type_id::create("env",this);
			reset_sequence=APB_reset_sequence::type_id::create("reset_sequence");
			write_sequence=APB_write_sequence::type_id::create("write_sequence");
			read_sequence=APB_read_sequence::type_id::create("read_sequence");
			write_with_wait_sequence=APB_write_with_wait_sequence::type_id::create("write_with_wait_sequence");
			read_with_wait_sequence=APB_read_with_wait_sequence::type_id::create("read_with_wait_sequence");
			APB_cfg=APB_config::type_id::create("APB_cfg");
			// get the IF
			if (!uvm_config_db#(virtual APB_if)::get(this, "", "APB_IF", APB_cfg.APB_vif)) begin
				`uvm_fatal("build_phase", "TEST - unable to get the IF");
			end
			// set the config object (which containing the IF)
			uvm_config_db#(APB_config)::set(this, "*", "CFG", APB_cfg);
		endfunction

		task run_phase(uvm_phase phase);
			super.run_phase(phase);
			phase.raise_objection(this);

			// start the sequences
			`uvm_info("run_phase", "Reset Asserted", UVM_LOW);
			reset_sequence.start(env.agt.sqr);
			`uvm_info("run_phase", "Reset De-asserted", UVM_LOW);

			/* Write random data in all the 256 locations of RAM 1 */
			`uvm_info("run_phase", "Slave 1 Write Sequence Starts", UVM_LOW);
			write_sequence.slave_select=SLAVE1;
			write_sequence.start(env.agt.sqr);
			`uvm_info("run_phase", "Slave 1 Write Sequence Ends", UVM_LOW);

			/* Write random data in all the 256 locations of RAM 2 */
			`uvm_info("run_phase", "Slave 2 Write Sequence Starts", UVM_LOW);
			write_sequence.slave_select=SLAVE2;
			write_sequence.start(env.agt.sqr);
			`uvm_info("run_phase", "Slave 2 Write Sequence Ends", UVM_LOW);

			/* Read all the 256 locations of RAM 1 */
			`uvm_info("run_phase", "Slave 1 Read Sequence Starts", UVM_LOW);
			read_sequence.slave_select=SLAVE1;
			read_sequence.start(env.agt.sqr);	
			`uvm_info("run_phase", "Slave 1 Read Sequence Ends", UVM_LOW);

			/* Read all the 256 locations of RAM 2 */
			`uvm_info("run_phase", "Slave 2 Read Sequence Starts", UVM_LOW);
			read_sequence.slave_select=SLAVE2;
			read_sequence.start(env.agt.sqr);			
			`uvm_info("run_phase", "Slave 2 Read Sequence Ends", UVM_LOW);

			phase.drop_objection(this);
		endtask

	endclass

endpackage