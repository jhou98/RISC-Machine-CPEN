onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /lab8_stage2_tb/DUT/CPU/halt
add wave -noupdate /lab8_stage2_tb/DUT/CPU/next_pc
add wave -noupdate /lab8_stage2_tb/DUT/CPU/PC
add wave -noupdate /lab8_stage2_tb/DUT/CPU/reset_pc
add wave -noupdate /lab8_stage2_tb/DUT/CPU/FSM/state
add wave -noupdate /lab8_stage2_tb/DUT/CPU/FSM/next_state
add wave -noupdate /lab8_stage2_tb/DUT/CPU/in
add wave -noupdate /lab8_stage2_tb/DUT/CPU/out
add wave -noupdate /lab8_stage2_tb/DUT/CPU/opcode
add wave -noupdate {/lab8_stage2_tb/DUT/MEM/mem[25]}
add wave -noupdate /lab8_stage2_tb/DUT/CPU/FSM/reset
add wave -noupdate /lab8_stage2_tb/DUT/CPU/DP/REGFILE/R7
add wave -noupdate /lab8_stage2_tb/DUT/CPU/DP/REGFILE/R6
add wave -noupdate /lab8_stage2_tb/DUT/CPU/DP/REGFILE/R5
add wave -noupdate /lab8_stage2_tb/DUT/CPU/DP/REGFILE/R4
add wave -noupdate /lab8_stage2_tb/DUT/CPU/DP/REGFILE/R3
add wave -noupdate /lab8_stage2_tb/DUT/CPU/DP/REGFILE/R2
add wave -noupdate /lab8_stage2_tb/DUT/CPU/DP/REGFILE/R1
add wave -noupdate /lab8_stage2_tb/DUT/CPU/DP/REGFILE/R0
add wave -noupdate /lab8_stage2_tb/DUT/CPU/DP/writenum
add wave -noupdate /lab8_stage2_tb/DUT/CPU/DP/readnum
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1299 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 309
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {1598 ps} {1727 ps}
