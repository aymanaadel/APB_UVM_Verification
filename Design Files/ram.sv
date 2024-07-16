module ram(
    input  PCLK, PRESETn, PSEL, PWRITE, PENABLE,
    input [7:0] PWDATA,
    input [7:0] PADDR,
    output reg PREADY,
    output reg[7:0] PRDATA
);

reg [7:0] mem [255:0];

always@(posedge PCLK, negedge PRESETn) begin
    if(!PRESETn) begin
         PRDATA<=0; PREADY<=0;
    end
    else if(PSEL && PENABLE==1) begin
        if(PWRITE==1) begin // write
             mem[PADDR]<=PWDATA; PREADY<=1;
        end 
		else if(PWRITE==0) begin // read
             PRDATA<=mem[PADDR];
             PREADY<=1;
        end
    end 
    else
    	PREADY<=0;
end

endmodule