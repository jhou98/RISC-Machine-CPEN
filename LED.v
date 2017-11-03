`define M_NONE 2'b00
`define M_READ 2'b01
`define M_WRITE 2'b10

module LED(mem_cmd,mem_addr,toloadenable);
input [8:0] mem_addr;
input [1:0] mem_cmd;
output reg toloadenable;

always @(*)begin
case({mem_cmd,mem_addr}) //check if mem_cmd is read and mem_addr is 140
{`M_WRITE,9'h100}: toloadenable = 1'b1;
default: toloadenable = 1'b0;
endcase
end
endmodule