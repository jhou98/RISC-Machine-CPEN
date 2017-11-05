module FSM(clk, reset, opcode, op, nsel,loada,loadb,loadc,vsel,write,loads,asel,bsel,reset_pc,load_pc,addr_sel,mem_cmd,load_ir,load_addr, muxccontrol);
  input clk, reset; 
  input [2:0] opcode;
  input [1:0] op;
  output reg load_ir; //Lab 7 
  output reg [2:0] nsel;
  output reg loada,loadb,loadc,loads,write,asel,bsel;
  output reg load_pc,reset_pc,addr_sel,load_addr; //Lab7 addition going to program counter
  output reg [1:0] vsel;
  output reg [1:0] mem_cmd; //Lab 7 addition going into RAM 
	output reg muxccontrol;
  wire [3:0] state;
  reg [3:0] next_state;
  
  //State encoding for the FSM circuit 
  `define RESET 4'b0000 //RESET STATE
  `define S1 4'b0001
  `define S2 4'b0010
  `define S3 4'b0011
  `define S4 4'b0100
  `define S5 4'b1010
  `define S6 4'b1011
   //New states for Lab 7
  `define IF1 4'b0101
  `define IF2 4'b0110
  `define UpdatePC 4'b0111
  `define S0 4'b1000 //Decode State
  `define HALT 4'b1001
  //Defining m_cmd
  `define M_NONE 2'b00
  `define M_READ 2'b01
  `define M_WRITE 2'b10

  assign state =  reset ? `RESET:next_state;
  //Check reset state
  always @(posedge clk) begin
    casex({reset,opcode,op,state})
	{6'b1xxxxx,`RESET}: {nsel, next_state,loada,loadb,loadc,vsel,write,loads,asel,bsel,reset_pc,load_pc,addr_sel,load_ir,mem_cmd,load_addr} 
				= {3'b000,`IF1,1'b0,1'b0,1'b0,2'b00,1'b0,1'b0,1'b0,1'b0,1'b1,1'b1,1'b0,1'b0,`M_NONE,1'b0}; //reset state!
	{6'b0xxxxx,`IF1}: {nsel,next_state,loada,loadb,loadc,vsel,write,loads,asel,bsel,reset_pc,load_pc,addr_sel,load_ir,mem_cmd,load_addr}
				= {3'b000,`IF2,1'b0,1'b0,1'b0,2'b00,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b0,`M_READ,1'b0}; //Waiting state IF1 --> IF2
	{6'b0xxxxx,`IF2}: {next_state,reset_pc,load_pc,addr_sel,load_ir,mem_cmd}
				= {`UpdatePC,1'b0,1'b0,1'b1,1'b1,`M_READ}; //IF2 (all other outputs are reset from IF1 state so don't need to worry about, IF2 --> UpdatePC
        {6'b0xxxxx,`UpdatePC}: {next_state,reset_pc,load_pc,addr_sel,load_ir,mem_cmd}
				= {`S0,1'b0,1'b1,1'b0,1'b0,`M_NONE}; //Now we set next state to S0 aka decode state and it will determine next step based on opcode and ALU/op
        {6'b011010,`S0}: {nsel, next_state,loada,loadb,loadc,vsel,write,loads,asel,bsel,load_pc,load_ir} 
				= {3'b001,`S1,1'b0,1'b0,1'b0,2'b10,1'b1,1'b0,1'b0,1'b0,1'b0,1'b0}; //s is set to 1, opcode = 110, op = 10, then we write (note, all S0 states have load_pc = 1'b0)
	{6'b011010,`S1}: {nsel, next_state,loada,loadb,loadc,vsel,write,loads,asel,bsel} 
				= {3'b000,`IF1,1'b0,1'b0,1'b0,2'b00,1'b0,1'b0,1'b0,1'b0}; //now we are done writing so we go back to IF1 state 
        {6'b011000,`S0}: {nsel, next_state,loada,loadb,loadc,vsel,write,loads,asel,bsel,load_pc} 
				= {13'b100,`S1,1'b0,1'b1,1'b0,2'b10,1'b0,1'b0,1'b0,1'b0,1'b0}; //this is for Mov Rm value into Rd with shift, so start by placing Rm into b
	{6'b011000,`S1}: {nsel,next_state,loada,loadb,loadc,vsel,write,loads,asel,bsel}
				= {3'b000,`S2,1'b0,1'b0,1'b1,2'b00,1'b0,1'b0,1'b1,1'b0}; //now we store the value into C
	{6'b011000,`S2}: {nsel,next_state,loada,loadb,loadc,vsel,write,loads,asel,bsel}
				= {3'b010,`S3,1'b0,1'b0,1'b0,2'b00,1'b1,1'b0,1'b0,1'b0}; //now write to register Rd
	{6'b011000,`S3}: {nsel,next_state,loada,loadb,loadc,vsel,write,loads,asel,bsel}
				= {3'b000,`IF1,1'b0,1'b0,1'b0,2'b00,1'b0,1'b0,1'b0,1'b0}; //back to IF1 state 
	{6'b010100,`S0}: {nsel,next_state,loada,loadb,loadc,vsel,write,loads,asel,bsel,load_pc,load_ir}
				= {3'b001,`S1,1'b1,1'b0,1'b0,2'b10,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}; //This is for addition, place Rn to RegA
	{6'b010100,`S1}: {nsel,next_state,loada,loadb,loadc,vsel,write,loads,asel,bsel}
				= {3'b100,`S2,1'b0,1'b1,1'b0,2'b10,1'b0,1'b0,1'b0,1'b0}; //Now set RegA to Rm
	{6'b010100,`S2}: {nsel,next_state,loada,loadb,loadc,vsel,write,loads,asel,bsel}
				= {3'b000,`S3,1'b0,1'b0,1'b1,2'b00,1'b0,1'b0,1'b0,1'b0}; //Now we set it to RegC
	{6'b010100,`S3}: {nsel,next_state,loada,loadb,loadc,vsel,write,loads,asel,bsel}
				= {3'b010,`S4,1'b0,1'b0,1'b0,2'b00,1'b1,1'b0,1'b0,1'b0}; //Now we write it to Rd 
	{6'b010100,`S4}: {nsel,next_state,loada,loadb,loadc,vsel,write,loads,asel,bsel}
				= {3'b000,`IF1,1'b0,1'b0,1'b0,2'b00,1'b0,1'b0,1'b0,1'b0}; //Now we go back to IF1
	{6'b010101,`S0}: {nsel,next_state,loada,loadb,loadc,vsel,write,loads,asel,bsel,load_pc,load_ir}
				= {3'b001,`S1,1'b1,1'b0,1'b0,2'b10,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}; //This is for CMP, put Rn into RegA
	{6'b010101,`S1}: {nsel,next_state,loada,loadb,loadc,vsel,write,loads,asel,bsel}
				= {3'b100,`S2,1'b0,1'b1,1'b0,2'b10,1'b0,1'b0,1'b0,1'b0}; //Place Rm into RegB
	{6'b010101,`S2}: {nsel,next_state,loada,loadb,loadc,vsel,write,loads,asel,bsel}
				= {3'b000,`S3,1'b0,1'b0,1'b0,2'b00,1'b0,1'b1,1'b0,1'b0}; //Now do the subtraction
   	{6'b010101,`S3}: {nsel,next_state,loada,loadb,loadc,vsel,write,loads,asel,bsel}
				= {3'b000,`IF1,1'b0,1'b0,1'b0,2'b00,1'b0,1'b0,1'b0,1'b0}; //Now back to IF1 state 
	{6'b010110,`S0}: {nsel,next_state,loada,loadb,loadc,vsel,write,loads,asel,bsel,load_pc,load_ir}
				= {3'b001,`S1,1'b1,1'b0,1'b0,2'b10,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}; //This is for AND, put Rn into RegA
	{6'b010110,`S1}: {nsel,next_state,loada,loadb,loadc,vsel,write,loads,asel,bsel}
				= {3'b100,`S2,1'b0,1'b1,1'b0,2'b10,1'b0,1'b0,1'b0,1'b0}; //Now place Rm into RegB
	{6'b010110,`S2}: {nsel,next_state,loada,loadb,loadc,vsel,write,loads,asel,bsel}
				= {3'b000,`S3,1'b0,1'b0,1'b1,2'b00,1'b0,1'b0,1'b0,1'b0}; //Now we place the ANDed result into RegC
	{6'b010110,`S3}: {nsel,next_state,loada,loadb,loadc,vsel,write,loads,asel,bsel}
				= {3'b010,`S4,1'b0,1'b0,1'b0,2'b00,1'b1,1'b0,1'b0,1'b0}; //Place the value in RegC into Rd
	{6'b010110,`S4}: {nsel,next_state,loada,loadb,loadc,vsel,write,loads,asel,bsel}
				= {3'b000,`IF1,1'b0,1'b0,1'b0,2'b00,1'b0,1'b0,1'b0,1'b0}; //Go back to IF1 state 
	{6'b010111,`S0}: {nsel,next_state,loada,loadb,loadc,vsel,write,loads,asel,bsel,load_pc,load_ir}
				= {3'b100,`S1,1'b0,1'b1,1'b0,2'b10,1'b0,1'b0,1'b1,1'b0,1'b0,1'b0}; //MVN, so set RegB to value of Rm
	{6'b010111,`S1}: {nsel,next_state,loada,loadb,loadc,vsel,write,loads,asel,bsel}
				= {3'b000,`S2,1'b0,1'b0,1'b1,2'b00,1'b0,1'b0,1'b1,1'b0}; //Place the new value into RegC
	{6'b010111,`S2}: {nsel,next_state,loada,loadb,loadc,vsel,write,loads,asel,bsel}
				= {3'b010,`S3,1'b0,1'b0,1'b0,2'b00,1'b1,1'b0,1'b0,1'b0}; //Place that value into Rd
	{6'b010111,`S3}: {nsel,next_state,loada,loadb,loadc,vsel,write,loads,asel,bsel}
				= {3'b000,`IF1,1'b0,1'b0,1'b0,2'b00,1'b0,1'b0,1'b0,1'b0}; //go back to IF1 state 
	{6'b001100,`S0}: {nsel,next_state,loada,loadb,loadc,vsel,write,loads,asel,bsel,load_pc,load_ir}
				= {3'b001,`S1,1'b1,1'b0,1'b0,2'b10,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}; //LDR start, READ Rn into RegA
	{6'b001100,`S1}: {nsel,next_state,loada,loadb,loadc,vsel,write,loads,asel,bsel}
				= {3'b000,`S2,1'b0,1'b0,1'b1,2'b00,1'b0,1'b0,1'b0,1'b1}; //ADD sx(im5) to b and store Addition into C
	{6'b001100,`S2}: {next_state,load_addr} = {`S3,1'b1}; //Set load_addr to 1 so it takes datapath_out 
	{6'b001100,`S3}: {next_state,addr_sel,mem_cmd} = {`S4,1'b0,`M_READ}; //set addr_sel to 0 to chose the Data Address, mem_cmd to READ
	{6'b001100,`S4}: {nsel,next_state,loada,loadb,loadc,vsel,write,loads,asel,bsel,load_addr}
				= {3'b010,`S5,1'b0,1'b0,1'b0,2'b11,1'b1,1'b0,1'b0,1'b0,1'b0}; //Set Register Rd to mdata and go back to IF1 state 
	{6'b001100,`S5}: {nsel,next_state,loada,loadb,loadc,vsel,write,loads,asel,bsel,addr_sel,mem_cmd}
				= {3'b000,`IF1,1'b0,1'b0,1'b0,2'b00,1'b0,1'b0,1'b0,1'b0,1'b1,`M_NONE}; // Go back to IF1	
	{6'b010000,`S0}: {nsel,next_state,loada,loadb,loadc,vsel,write,loads,asel,bsel,load_pc,load_ir}
				= {3'b001,`S1,1'b1,1'b0,1'b0,2'b10,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}; //STR, READ Rn into RegA
	{6'b010000,`S1}: {nsel,next_state,loada,loadb,loadc,vsel,write,loads,asel,bsel}
				= {3'b000,`S2,1'b0,1'b0,1'b1,2'b00,1'b0,1'b0,1'b0,1'b1}; //ADD sx(im5) to b and store Addition into C
	{6'b010000,`S2}: {next_state,load_addr} = {`S3,1'b1}; //Set load_addr to 1 so it takes datapath_out 
        {6'b010000,`S3}: {next_state,load_addr} = {`S4,1'b0}; //Set load_addr to 0, signal kept between data address and MUX
        {6'b010000,`S4}: {nsel,next_state,loada,loadb,loadc,vsel,write,loads,asel,bsel,load_pc}
				= {3'b010,`S5,1'b0,1'b1,1'b0,2'b00,1'b0,1'b0,1'b0,1'b0,1'b0}; //STR, READ Rd into RegB
	{6'b010000,`S5}: {nsel,next_state,loada,loadb,loadc,vsel,write,loads,asel,bsel}
				= {3'b000,`S6,1'b0,1'b0,1'b1,2'b00,1'b0,1'b0,1'b1,1'b0}; //store in C (datapath_out)
	{6'b010000,`S6}: {next_state,addr_sel,mem_cmd} = {`IF1,1'b0,`M_WRITE}; //set addr_sel to 0 to chose the Data Address, mem_cmd to WRITE, then go back
	{6'b011100,`S0}: {next_state,load_pc,load_ir} = {`HALT,1'b0,1'b0}; //if HALT 
	{6'b0xxxxx,`HALT}: {next_state} = {`HALT}; //stay at HALT until reset = 1 
        {6'b1xxxxx,`HALT}: {next_state} = {`RESET};
	default: {nsel,next_state,loada,loadb,loadc,vsel,write,loads,asel,bsel,reset_pc,load_pc,addr_sel,load_ir,mem_cmd}
				= {3'b000,`RESET,1'b0,1'b0,1'b0,2'b00,1'b0,1'b0,1'b0,1'b0,1'b1,1'b1,1'b0,1'b0,`M_NONE}; //default sends it back to RESET state 
   endcase
  end
endmodule 
