restart -f 
view signals wave 
add wave imDataOut dmDataOut accOut extIn bussOut bussSel I_mem

force imDataOut b"10101010"
force dmDataOut b"00110011"
force accOut b"11000110"
force extIn b"11111111"
force bussSel b"0000"
run 100ns
force bussSel b"0001"
run 100ns
force bussSel b"0010"
run 100ns
force bussSel b"0100"
run 100ns
force bussSel b"1000"
run 100ns
