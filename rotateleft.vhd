library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;
use IEEE.NUMERIC_STD.all;

entity rotateleft is
    port(   
    	    ain: in   std_logic_vector (7 downto 0);
	    bin: in    std_logic_vector(2 downto 0);
    	    bout: out  std_logic_vector (7 downto 0)
   	);
end rotateleft;

architecture Dataflow of rotateleft is
begin
	bout <= ain(7-to_integer(unsigned(bin)) downto 0) & ain(7 downto 7-to_integer(unsigned(bin))+1);
end Dataflow;
