library ieee;
use ieee.std_logic_1164.all;

library work;
use work.chacc_pkg.all;

entity proc_controller is
    port (
        clk: in std_logic;
        resetn: in std_logic;
        master_load_enable: in std_logic;
        opcode: in std_logic_vector(3 downto 0);
        e_flag: in std_logic;
        z_flag: in std_logic;

       	busSel: out std_logic_vector(3 downto 0);
        pcSel: out std_logic;
        pcLd: out std_logic;
        imRead: out std_logic;
        dmRead: out std_logic;
        dmWrite: out std_logic;
        aluOp: out std_logic_vector(1 downto 0);
        flagLd: out std_logic;
        accSel: out std_logic;
        accLd: out std_logic;
        dsLd: out std_logic
    );
end proc_controller;



library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.uniform;
use ieee.math_real.floor;

architecture mock_controller of proc_controller is

    signal full_mock : std_logic_vector(10 downto 0);

begin



process(clk, resetn)
    variable seed1_a, seed2_a, seed1_b, seed2_b : positive := 1;
    variable a_real, b_real : real := 0.0;
    variable a_int, b_int : integer := 0;
begin

    if resetn /= '1' then

        seed1_a := 1;
        seed2_a := 7;
        seed1_b := 12;
        seed2_b := 3;

        full_mock <= (others => '0');
        busSel <= (others => '0');    

    elsif rising_edge(clk) then

        busSel <= (others => '0');


        uniform( seed1_a, seed2_a, a_real );
        uniform( seed1_b, seed2_b, b_real );

        a_int := integer(floor(a_real * real(2**11)));
        b_int := integer(floor(b_real * 4.0));

        full_mock <= std_logic_vector( to_unsigned( a_int, full_mock'LENGTH ) );
        busSel(b_int) <= '1';
    end if;

end process;

pcSel <= full_mock(0);
pcLd <= full_mock(1);
imRead <= '1';
dmRead <= '1';
dmWrite <= full_mock(4);
aluOp <= full_mock(6 downto 5);
flagLd <= full_mock(7);
accSel <= full_mock(8);
accLd <= full_mock(9);
dsLd <= full_mock(10);


end mock_controller;
