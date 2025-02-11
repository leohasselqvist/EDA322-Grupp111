#restart -f -nowave
#add wave ain bout


force ain 8'b00000001
run 50ns
force ain 8'b00000010
run 50ns
force ain 8'b10000000
run 50ns