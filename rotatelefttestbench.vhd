library ieee;
use ieee.std_logic_1164.all;

entity rotatelefttestbench is
end rotatelefttestbench;

architecture Behavior of rotatelefttestbench is
signal ain1 : std_logic_vector(7 downto 0) := "10101010";
signal ain2 : std_logic_vector(7 downto 0) := "00001111";
signal bin1 : std_logic_vector(2 downto 0) := "001";
signal bin2 : std_logic_vector(2 downto 0) := "100";
signal bout1 : std_logic_vector(7 downto 0);
signal bout2 : std_logic_vector(7 downto 0);
signal boutCorr1 : std_logic_vector(7 downto 0) := "01010101";
signal boutCorr2 : std_logic_vector(7 downto 0) := "11110000";
signal test1 : std_logic;
signal test2 : std_logic;
begin
	rol_1: entity work.rotateleft(Dataflow)
			port map (
				ain => ain1,
				bin => bin1,
				bout => bout1
			);
	rol_2: entity work.rotateleft(Dataflow)
			port map (
				ain => ain2,
				bin => bin2,
				bout => bout2
			);
	
	cmp1: entity work.cmp(Dataflow)
			port map (
				a => bout1,
				b => boutCorr1,
				e => test1
			);
	cmp2: entity work.cmp(Dataflow)
			port map (
				a => bout2,
				b => boutCorr2,
				e => test2
			);
	process
	begin
		wait for 30 ns;
		assert((test2 = '1') and (test1 = '1')) report "bruh it doesnt work, skibidi error" severity error;
		wait;
	end process;
end Behavior;