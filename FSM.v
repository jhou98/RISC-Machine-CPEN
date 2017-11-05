module FSM(clk, reset, opcode, op, nsel,loada,loadb,cond,loadc,vsel,write,loads,asel,bsel,reset_pc,load_pc,addr_sel,mem_cmd,load_ir,load_addr, muxccontrol,PC_sel);
  input clk, reset; 
  input [2:0] opcode;
  input [1:0] op;
	input [2:0] cond; //Lab8
  output reg load_ir; //Lab 7 
  output reg [2:0] nsel;
  output reg loada,loadb,loadc,loads,write,asel,bsel;
  output reg load_pc,reset_pc,addr_sel,load_addr; //Lab7 addition going to program counter
  output reg [1:0] vsel;
  output reg [1:0] mem_cmd; //Lab 7 addition going into RAM 
  output reg muxccontrol; //Lab8
  output reg PC_sel; //Lab8
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
