.main clear
quit -sim

vlib work
vmap work work


#Compile all design modules#
switch $argc {
    echo "== useage:  do run.do [seed] [wave.do] " 
    0  {
        set TB tb.sv
        set WAVEDO wave.do
       }
    1  {
        set TB tb.sv
        set WAVEDO $1
        }   
    default {echo "ERROR! Too many arguments!"
             abort}
    }

#$XILINX variable must be set
set SEED 0

vlog -novopt -incr -sv -work work  ../rtl/*.v
vlog -novopt -incr -sv -work work  ../rtl/*.sv
vlog -novopt -incr -sv -work work  ./simlib/*.v
vlog -novopt -incr -sv -work work  ./simlib/*.sv
vlog -novopt -incr -sv -work work  ./*.sv
vlog -novopt -incr -sv -work work +define+SEED=$SEED $TB
vlog -work work -refresh -force_refresh
#Load the design. Use required libraries.#
vsim -L simprims_ver -L unisims_ver -L unimacro_ver  work.glbl -t ns -novopt +notimingchecks -suppress 3015,3722,3009  work.tb 
onerror {resume}
#Log all the objects in design. These will appear in .wlf file#
#This helps in viewing all signals of the design instead of
#re-running the simulation for viewing the signals.
#Uncomment below line to log all objects in the design.
log -r /*


#Change radix to Hexadecimal#
radix hex
#radix decimal

if { [file exists "$WAVEDO"] == 1} {do $WAVEDO}
run -all