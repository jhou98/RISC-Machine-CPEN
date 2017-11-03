`define M_NONE 2'b00
`define M_READ 2'b01
`define M_WRITE 2'b10

module switch(mem_cmd,mem_addr,totristate);
input [8:0] mem_addr;
input [1:0] mem_cmd;
output reg totristate;

always @(*)begin
case({mem_cmd,mem_addr}) //check if mem_cmd is read and mem_addr is 140
{`M_READ,9'h140}: totristate = 1'b1;
default: totristate = 1'b0;
endcase
end
endmodule