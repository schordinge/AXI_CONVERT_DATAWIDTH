onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb/dut0/m_axi/rvalid
add wave -noupdate /tb/dut0/m_axi/rdata
add wave -noupdate /tb/dut0/m_axi/rid
add wave -noupdate /tb/dut0/m_axi/rlast
add wave -noupdate /tb/dut0/m_axi/rready
add wave -noupdate /tb/dut0/m_axi/rresp
add wave -noupdate /tb/dut0/s_axi/rvalid
add wave -noupdate /tb/dut0/s_axi/rdata
add wave -noupdate /tb/dut0/s_axi/rid
add wave -noupdate /tb/dut0/s_axi/rlast
add wave -noupdate /tb/dut0/s_axi/rready
add wave -noupdate /tb/dut0/s_axi/rresp
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {746 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 392
configure wave -valuecolwidth 217
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
configure wave -timelineunits ns
update
WaveRestoreZoom {630 ns} {775 ns}
