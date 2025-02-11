library ieee;
use ieee.std_logic_1164.all;

entity regn is
	generic (N : INTEGER := 8);
	port (  dataIn			:IN	STD_LOGIC_VECTOR(N-1 DOWNTO 0);
		loadEnable,clk,resetn	:IN	STD_LOGIC;
		dataOut			:OUT	STD_LOGIC_VECTOR(N-1 DOWNTO 0)
	);
end regn;

architecture Behavior of regn is
begin
	process(clk, resetn)
	begin
		if resetn = '0' then
			dataOut <= (others => '0');
		elsif (clk'EVENT and clk = '1') then
			if loadEnable = '1' then
				dataOut <= dataIn;
			end if;
		end if;
	end process;
end behavior;