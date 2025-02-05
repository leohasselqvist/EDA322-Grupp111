library ieee;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity proc_bus is
    port (
        imDataOut   : in STD_LOGIC_VECTOR(7 downto 0);
        dmDataOut   : in STD_LOGIC_VECTOR(7 downto 0);
        accOut      : in STD_LOGIC_VECTOR(7 downto 0);
        extIn       : in STD_LOGIC_VECTOR(7 downto 0);
        bussSel     : in STD_LOGIC_VECTOR(3 downto 0);
        bussOut     : out STD_LOGIC_VECTOR(7 downto 0);
        
    );
end entity proc_bus;

architecture Behavioral of proc_bus is
begin 
    process (imDataOut, dmDataOut, accOut, extIn, busSel)
    begin
        busOut <= (others => '0');

        if busSel(0) = '1' then
            busOut <= imDataOut
        elsif busSel(1) = '1' then
            busOut <= dmDataOut
        elsif busSel(2) = '1' then
            busOut <= accOut
        elsif busSel(3) = '1' then
            busOut <= extIn
        end if;
    end process;
end architecture Behavioral;
