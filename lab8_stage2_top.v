//Defining m_cmd
  `define M_NONE 2'b00
  `define M_READ 2'b01
  `define M_WRITE 2'b10
module lab8_stage2_top(KEY,SW,LEDR,HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,CLOCK_50);
  input [3:0] KEY;
  input [9:0] SW;
  input CLOCK_50;
  output [9:0] LEDR;
  output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
  wire N,V,Z;
  //STILL NEED MORE WIRES FOR THE REST OF LAB 7 BUT PART 1 DONE 
  //wire's connecting RAM and CPU and TriState
  wire [1:0] mem_cmd;
  wire [8:0] mem_addr; 
  wire [15:0] read_data;  
  wire e; //tri-state enabler 
  wire write; //write for RAM
  wire [15:0] dout; 
  wire totristate; //wire for switch module
  wire toloadenable; //wire for led module
  wire [15:0] write_data; //out from datapath
  cpu CPU( .clk(CLOCK_50),
	   .reset(~KEY[1]),
	   .in(read_data),
	   .out(write_data),
	   .N(N),
	   .V(V),
	   .Z(Z),
	   .mem_cmd(mem_cmd),
	   .mem_addr(mem_addr),
	   .halt(LEDR[8])
  ); //CPU module 
  
  RAM #(16,8,"lab8fig4.txt") MEM( .clk(CLOCK_50),
	  		    .read_address(mem_addr[7:0]),
			    .write_address(mem_addr[7:0]),
		    	    .write(write),
	   		    .din(write_data),
			    .dout(dout)); //RAM module 
  switch switch1(mem_cmd,mem_addr,totristate); //switch module
  LED led1(mem_cmd,mem_addr,toloadenable); //LED module

  assign e = ((mem_cmd == `M_READ)&(mem_addr[8] == 1'b0)); //enabler is the AND block 
  assign write = ((mem_cmd == `M_WRITE)&(mem_addr[8]==1'b0)); //AND block for write 
  //tri_state 
  assign read_data = e ? dout:16'bz; //So a wire dout that is in RAM 
  assign read_data = totristate ? {8'bz,SW[7:0]} :16'bz; //tri state for switch module
  vDFFE #(8) forLED(~KEY[0],toloadenable,write_data[7:0],LEDR[7:0]); //stage 3 

  assign HEX5[0] = ~Z;
  assign HEX5[6] = ~N;
  assign HEX5[3] = ~V;
endmodule 
