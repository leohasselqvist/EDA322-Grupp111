restart -f -nowave    	
view signals wave 
add wave address writeEn readEn dataIn clk dataOut


force clk 0 0, 1 50ns -repeat 100ns

force dataIn b"11111111"
force writeEn 0
force address b"00000010"
force readEn 0
run 100ns
force writeEn 1
run 100ns
force readEn 1
run 100ns