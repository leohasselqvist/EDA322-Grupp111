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
        bussOut     : out STD_LOGIC_VECTOR(7 downto 0)
        
    );
end entity proc_bus;

architecture Behavior of proc_bus is
begin 
    process (imDataOut, dmDataOut, accOut, extIn, bussSel)
    begin
        if bussSel(0) = '1' then
            bussOut <= imDataOut;
        elsif bussSel(1) = '1' then
            bussOut <= dmDataOut;
        elsif bussSel(2) = '1' then
            bussOut <= accOut;
        elsif bussSel(3) = '1' then
            bussOut <= extIn;
	else
	    bussOut <= "00000000";
        end if;
    end process;
end architecture Behavior;
