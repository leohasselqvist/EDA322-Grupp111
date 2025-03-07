library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;
use IEEE.NUMERIC_STD.all;

entity alu_wRCA is
    port(
        alu_inA, alu_inB: in std_logic_vector(7 downto 0);
        alu_op: in std_logic_vector(1 downto 0);
        alu_out: out std_logic_vector(7 downto 0);
        C: out std_logic;
        E: out std_logic;
        Z: out std_logic
    );
end alu_wRCA;

architecture Structural of alu_wRCA is
	signal aAdd: std_logic_vector(7 downto 0);
	signal bAdd: std_logic_vector(7 downto 0);
	signal outAnd: std_logic_vector(7 downto 0);
	signal aAnd: std_logic_vector(7 downto 0);
	signal bAnd: std_logic_vector(7 downto 0);
	signal s: std_logic_vector(7 downto 0);
	signal cin: std_logic;
	signal aRol: std_logic_vector(7 downto 0);
	signal outRol: std_logic_vector(7 downto 0);
	signal zCheck: std_logic_vector(7 downto 0);
	signal bRol: std_logic_vector(2 downto 0);
	begin
		aAnd <= alu_inA;
		bAnd <= alu_inB;
		outAnd <= aAnd and bAnd;
		
		aRol <= alu_inA;
		bRol <= alu_inB(2 downto 0);
		rol_o: entity work.rotateleft(Dataflow)
			port map (
				ain => aRol,
				bin => bRol,
				bout => outRol
			);

		aAdd <= alu_inA;
		bAdd <= not(alu_inB) when (alu_op(0) = '1') else alu_inB;
		cin <= alu_op(0);
		rca_0: entity work.rca(Structural)
			port map (
				a => aAdd,
				b => bAdd,
				cin => cin,
				cout => C,
				s => s
			);
		mux: entity work.mux4to1(Dataflow)
			port map (
				w0 => outRol,
				w1 => outAnd,
				w2 => s,
				w3 => s,
				s => alu_op,
				output => zCheck
			);
		cmp: entity work.cmp(Dataflow)
			port map (
				a => alu_inA,
				b => alu_inB,
				e => E
			);
		Z <= '1' when zCheck = "00000000" else '0';
		alu_out <= zCheck;
	end Structural;
	