library ieee;
use ieee.std_logic_1164.all;

entity reg1 is
	port (  dataIn			:IN	STD_LOGIC;
		loadEnable,clk,resetn	:IN	STD_LOGIC;
		dataOut			:OUT	STD_LOGIC
	);
end reg1;

architecture Behavior of reg1 is
begin
	process(clk, resetn)
	begin
		if resetn = '0' then
			dataOut <= '0';
		elsif (clk'EVENT and clk = '1') then
			if loadEnable = '1' then
				dataOut <= dataIn;
			end if;
		end if;
	end process;
end behavior;