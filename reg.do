#restart -f -nowave
#add wave dataIn loadEnable clk resetn dataOut

force clk 0 0, 1 50ns -repeat 100ns
force dataIn 8'd100
force resetn 1'd1
force loadEnable 1'd0
run 100ns
force loadEnable 1'd1
run 100ns
force resetn 1'd0
run 100ns