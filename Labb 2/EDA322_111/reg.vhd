library ieee;
use ieee.std_logic_1164.all;

entity regn is
	generic (N : INTEGER := 8);
	port (  D		:IN	STD_LOGIC_VECTOR(N-1 DOWNTO 0);
		Enable,Clock	:IN	STD_LOGIC;
		Q		:OUT	STD_LOGIC_VECTOR(N-1 DOWNTO 0)
	);
end regn;

architecture Behavior of regn is
begin
	process(Clock)
	begin
		if (Clock'EVENT and Clock = '1') then
			if Enable = '1' then
				Q <= D;
			end if;
		end if;
	end process;
end behavior;