library ieee;
use ieee.std_logic_1164.all;

entity mux4to1 is
	port ( 
		w0, w1, w2, w3 : in std_logic_vector(7 downto 0);
		s : std_logic_vector(1 downto 0);
		output : out std_logic_vector(7 downto 0)
	);
end mux4to1;

architecture dataflow of mux4to1 is
begin
	with s select
		output <= w0 WHEN "00",
			  w1 WHEN "01",
			  w2 WHEN "10",
			  w3 WHEN "11",
			  "11111111" WHEN others;
end dataflow;
