onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /lab8_stage2_tb/DUT/N
add wave -noupdate /lab8_stage2_tb/DUT/V
add wave -noupdate /lab8_stage2_tb/DUT/Z
add wave -noupdate /lab8_stage2_tb/DUT/CPU/halt
add wave -noupdate /lab8_stage2_tb/DUT/CPU/next_pc
add wave -noupdate /lab8_stage2_tb/DUT/CPU/PC
add wave -noupdate /lab8_stage2_tb/DUT/CPU/FSM/state
add wave -noupdate /lab8_stage2_tb/DUT/CPU/FSM/next_state
add wave -noupdate /lab8_stage2_tb/DUT/CPU/in
add wave -noupdate /lab8_stage2_tb/DUT/CPU/out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1290 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 231
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
WaveRestoreZoom {1191 ps} {1343 ps}
