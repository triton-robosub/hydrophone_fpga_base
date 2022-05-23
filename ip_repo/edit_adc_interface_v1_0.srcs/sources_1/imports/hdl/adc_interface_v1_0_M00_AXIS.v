
`timescale 1 ns / 1 ps

	module adc_interface_v1_0_M00_AXIS #
	(
		// Users to add parameters here

		// User parameters ends
		// Do not modify the parameters beyond this line

		// Width of S_AXIS address bus. The slave accepts the read and write addresses of width C_M_AXIS_TDATA_WIDTH.
		parameter integer C_M_AXIS_TDATA_WIDTH	= 32,
		// Start count is the number of clock cycles the master will wait before initiating/issuing any transaction.
		parameter integer C_M_START_COUNT	= 32
	)
	(
		// Users to add ports here
		input wire [15:0] adc_sample,
		input wire [1:0] channel,
		input wire adc_sample_new,

		// User ports ends
		// Do not modify the ports beyond this line

		// Global ports
		input wire  M_AXIS_ACLK,
		// 
		input wire  M_AXIS_ARESETN,
		// Master Stream Ports. TVALID indicates that the master is driving a valid transfer, A transfer takes place when both TVALID and TREADY are asserted. 
		output wire  M_AXIS_TVALID,
		// TDATA is the primary payload that is used to provide the data that is passing across the interface from the master.
		output wire [C_M_AXIS_TDATA_WIDTH-1 : 0] M_AXIS_TDATA,
		// TSTRB is the byte qualifier that indicates whether the content of the associated byte of TDATA is processed as a data byte or a position byte.
		output wire [(C_M_AXIS_TDATA_WIDTH/8)-1 : 0] M_AXIS_TSTRB,
		// TLAST indicates the boundary of a packet.
		output wire  M_AXIS_TLAST,
		// TREADY indicates that the slave can accept a transfer in the current cycle.
		input wire  M_AXIS_TREADY
	);                                            
	                                                                                     
	// function called clogb2 that returns an integer which has the                      
	// value of the ceiling of the log base 2.                                           
	function integer clogb2 (input integer bit_depth);                                   
	  begin                                                                              
	    for(clogb2=0; bit_depth>0; clogb2=clogb2+1)                                      
	      bit_depth = bit_depth >> 1;                                                    
	  end                                                                                
	endfunction                           

	// Add user logic here
	reg axis_valid;
	reg[15:0] axis_data;
	reg[1:0] axis_channel;
	
    assign M_AXIS_TSTRB = {C_M_AXIS_TDATA_WIDTH{1'b1}};
    assign M_AXIS_TLAST = 0;
    assign M_AXIS_TVALID = axis_valid;
    assign M_AXIS_TDATA = {14'b0, axis_channel, axis_data};
    
    //Generate valid signal and transfers
    always @(posedge M_AXIS_ACLK) begin
        if(~M_AXIS_ARESETN) begin
            axis_valid = 0;
        end else begin
            if(adc_sample_new)
                axis_valid <= 1;
            else if(axis_valid & M_AXIS_TREADY)
                axis_valid <= 0;
            else
                axis_valid <= axis_valid;
        end
    end
    
    //Latch in ADC data
    always @(posedge M_AXIS_ACLK) begin
        if(~M_AXIS_ARESETN) begin
            axis_data <= 16'h0000;
            axis_channel <= 2'b00;
        end else begin
            if(adc_sample_new) begin
                axis_data <= adc_sample;
                axis_channel <= channel;
            end else begin
                axis_data <= axis_data;
                axis_channel <= axis_channel;
            end
        end
    end
    
	// User logic ends

	endmodule
