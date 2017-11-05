//Defining m_cmd
  `define M_NONE 2'b00
  `define M_READ 2'b01
  `define M_WRITE 2'b10
module lab8_top(KEY,SW,LEDR,HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,CLOCK_50);
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
  
  RAM #(16,8,"lab8fig2.txt") MEM( .clk(CLOCK_50),
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

// The sseg module below can be used to display the value of datpath_out on
// the hex LEDS the input is a 4-bit value representing numbers between 0 and
// 15 the output is a 7-bit value that will print a hexadecimal digit.  You
// may want to look at the code in Figure 7.20 and 7.21 in Dally but note this
// code will not work with the DE1-SoC because the order of segments used in
// the book is not the same as on the DE1-SoC (see comments below).
endmodule

module sseg(in,segs);
  input [3:0] in;
  output reg [6:0] segs;

  // NOTE: The code for sseg below is not complete: You can use your code from
  // Lab4 to fill this in or code from someone else's Lab4.  
  //
  // IMPORTANT:  If you *do* use someone else's Lab4 code for the seven
  // segment display you *need* to state the following three things in
  // a file README.txt that you submit with handin along with this code: 
  //
  //   1.  First and last name of student providing code
  //   2.  Student number of student providing code
  //   3.  Date and time that student provided you their code
  //
  // You must also (obviously!) have the other student's permission to use
  // their code.
  //
  // To do otherwise is considered plagiarism.
  //
  // One bit per segment. On the DE1-SoC a HEX segment is illuminated when
  // the input bit is 0. Bits 6543210 correspond to:
  //
  //    0000
  //   5    1
  //   5    1
  //    6666
  //   4    2
  //   4    2
  //    3333
  //
  // Decimal value | Hexadecimal symbol to render on (one) HEX display
  //             0 | 0
  //             1 | 1
  //             2 | 2
  //             3 | 3
  //             4 | 4
  //             5 | 5
  //             6 | 6
  //             7 | 7
  //             8 | 8
  //             9 | 9
  //            10 | A
  //            11 | b
  //            12 | C
  //            13 | d
  //            14 | E
  //            15 | F

 //Defining the values for the HEX outputs from 0,1,2,3....taken from lab 5 by Jack Hou
  `define H0 7'b1000000 
  `define H1 7'b1111001
  `define H2 7'b0100100
  `define H3 7'b0110000
  `define H4 7'b0011001
  `define H5 7'b0010010
  `define H6 7'b0000010
  `define H7 7'b1111000
  `define H8 7'b0000000
  `define H9 7'b0010000
  `define HA 7'b0001000
  `define Hb 7'b0000011
  `define HC 7'b1000110
  `define Hd 7'b0100001
  `define HE 7'b0000110
  `define HF 7'b0001110
  
  always @(*)begin
    case(in)//so for various cases the hex will output different values 
	4'b0000: segs = `H0;
        4'b0001: segs = `H1;
        4'b0010: segs = `H2;
        4'b0011: segs = `H3;
        4'b0100: segs = `H4;
        4'b0101: segs = `H5;
	4'b0110: segs = `H6;
	4'b0111: segs = `H7;
	4'b1000: segs = `H8;
	4'b1001: segs = `H9;
	4'b1010: segs = `HA;
	4'b1011: segs = `Hb;
	4'b1100: segs = `HC;
	4'b1101: segs = `Hd;
	4'b1110: segs = `HE;
 	default: segs = `HF;  // this will output "F" 
    endcase
  end
endmodule
