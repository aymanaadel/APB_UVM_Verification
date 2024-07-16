package APB_scoreboard_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import APB_seq_item_pkg::*;

	class APB_scoreboard extends uvm_scoreboard;
		`uvm_component_utils(APB_scoreboard)

		uvm_analysis_export #(APB_seq_item) sb_export;
		uvm_tlm_analysis_fifo #(APB_seq_item) sb_apb;

		APB_seq_item seq_item_sb;

		// golden/reference outputs
		logic [7:0] apb_read_data_out_ref;
		/* associative arrays acts as a reference model for the RAM */
		logic [7:0] ram1 [ logic [7:0] ]; /* RAM 1 Model */
		logic [7:0] ram2 [ logic [7:0] ]; /* RAM 2 Model */
		typedef enum bit {SLAVE1=0, SLAVE2=1} slave_e;
		typedef enum bit {READ=0, WRITE=1} rw_e;

		int error_count=0, correct_count=0;
		
		function new(string name = "APB_scoreboard", uvm_component parent = null);
			super.new(name,parent);
		endfunction

		function void build_phase(uvm_phase phase);
			super.build_phase(phase);
			sb_export=new("sb_export",this);
			sb_apb=new("sb_apb",this);
		endfunction

		function void connect_phase(uvm_phase phase);
			super.connect_phase(phase);
			sb_export.connect(sb_apb.analysis_export);
		endfunction

		task run_phase(uvm_phase phase);
			super.run_phase(phase);
			forever begin
				sb_apb.get(seq_item_sb);
				check_data(seq_item_sb);
			end
		endtask

		function void report_phase(uvm_phase phase);
			super.report_phase(phase);
			`uvm_info("report_phase", $sformatf("At time %0t: Simulation Ends and Error Count= %0d, Correct Count= %0d",
			 $time, error_count, correct_count), UVM_MEDIUM);
		endfunction

		function void check_data(APB_seq_item F_cd);
			if (F_cd.PREADY) /* There's data written in or read from the RAM(Slave) */ begin
				if (F_cd.READ_WRITE==WRITE) /* write */ begin
					if (F_cd.apb_write_paddr[8]==SLAVE1) /* SLAVE 1 */ begin
						ram1[ F_cd.apb_write_paddr[7:0] ] = F_cd.apb_write_data;
					end
					else /* SLAVE 2 */ begin
						ram2[ F_cd.apb_write_paddr[7:0] ] = F_cd.apb_write_data;
					end
				end
				else /* read */ begin
					if (F_cd.apb_read_paddr[8]==SLAVE1) /* SLAVE 1 */ begin
						apb_read_data_out_ref = ram1[ F_cd.apb_read_paddr[7:0] ];
					end
					else /* SLAVE 2 */ begin
						apb_read_data_out_ref = ram2[ F_cd.apb_read_paddr[7:0] ];
					end

					output_assert: assert(apb_read_data_out_ref===F_cd.apb_read_data_out) begin
						correct_count++;
					end
					else begin
						error_count++; `uvm_error("run_phase", "Comparison Error");
					end
					output_cover: cover(apb_read_data_out_ref===F_cd.apb_read_data_out);
				end
			end

		endfunction

	endclass

endpackage