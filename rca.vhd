library ieee;
use ieee.std_logic_1164.all;

entity rca is
    port(
        a, b: in std_logic_vector(7 downto 0);
        cin: in std_logic;
        cout: out std_logic;
        s: out std_logic_vector(7 downto 0)
    );
end rca;

architecture Structural of rca is
	component fa is
		port( 
			a, b, cin : in std_logic;
			s, cout : out std_logic 
		);
	end component;
	signal c: std_logic_vector(8 downto 0);
	begin
		
		c(0) <= cin;
		g1: for n in 0 to 7 generate
			FA_n : fa port map (a(n), b(n), c(n), s(n), c(n+1));
		end generate;
		cout <= c(8);
	end Structural;