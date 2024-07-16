package APB_coverage_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import APB_seq_item_pkg::*;

	class APB_coverage extends uvm_component;
		`uvm_component_utils(APB_coverage)

		uvm_analysis_export #(APB_seq_item) cov_export;
		uvm_tlm_analysis_fifo #(APB_seq_item) cov_apb;

		APB_seq_item seq_item_cov;

		typedef enum bit {READ=0, WRITE=1} rw_e;

		covergroup cvr_grp;
			WR_address_cp: // cp on the WR address to see if we write in all locations of the RAM or not
			coverpoint seq_item_cov.apb_write_paddr[7:0] iff(seq_item_cov.READ_WRITE==WRITE&&seq_item_cov.PREADY) {
				bins wr_addr1 = {[0:31]};
				bins wr_addr2 = {[32:63]};
				bins wr_addr3 = {[64:95]};
				bins wr_addr4 = {[96:127]};
				bins wr_addr5 = {[128:159]};
				bins wr_addr6 = {[160:191]};
				bins wr_addr7 = {[192:223]};
				bins wr_addr8 = {[224:255]};
			}
			RD_address_cp: // cp on the RD address to see if we read all locations of the RAM or not
			coverpoint seq_item_cov.apb_read_paddr[7:0] iff(seq_item_cov.READ_WRITE==READ&&seq_item_cov.PREADY) {
				bins rd_addr1 = {[0:31]};
				bins rd_addr2 = {[32:63]};
				bins rd_addr3 = {[64:95]};
				bins rd_addr4 = {[96:127]};
				bins rd_addr5 = {[128:159]};
				bins rd_addr6 = {[160:191]};
				bins rd_addr7 = {[192:223]};
				bins rd_addr8 = {[224:255]};
			}	
			data_patterns_cp: // cp on the data written in the RAM
			coverpoint seq_item_cov.apb_write_data iff(seq_item_cov.READ_WRITE==WRITE&&seq_item_cov.PREADY) {
				bins all_ones = {8'hFF};
				bins all_zeros = {8'h00};
				bins alternating_bits = {8'b1010_1010, 8'b0101_0101};
				bins random = default;
			}	
			write_slave_cp: // cp on slave selection when write
			coverpoint seq_item_cov.apb_write_paddr[8] iff(seq_item_cov.READ_WRITE==WRITE && seq_item_cov.PREADY) {
				bins slave1 = {0};
				bins slave2 = {1};
			}	
			read_slave_cp: // cp on slave selection when read
			coverpoint seq_item_cov.apb_read_paddr[8] iff(seq_item_cov.READ_WRITE==READ&&seq_item_cov.PREADY) {
				bins slave1 = {0};
				bins slave2 = {1};
			}
		endgroup

		function new(string name = "APB_coverage", uvm_component parent = null);
			super.new(name,parent);
			cvr_grp=new();
		endfunction

		function void build_phase(uvm_phase phase);
			super.build_phase(phase);
			cov_export=new("cov_export",this);
			cov_apb=new("cov_apb",this);
		endfunction

		function void connect_phase(uvm_phase phase);
			super.connect_phase(phase);
			cov_export.connect(cov_apb.analysis_export);
		endfunction

		task run_phase(uvm_phase phase);
			super.run_phase(phase);
			forever begin
				cov_apb.get(seq_item_cov);
				cvr_grp.sample();
			end
		endtask

	endclass
endpackage