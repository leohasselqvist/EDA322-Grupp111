library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity EDA322_processor is
    port (
        clk                 : in  STD_LOGIC;
        resetn              : in  STD_LOGIC;
        master_load_enable  : in  STD_LOGIC;
        extIn               : in  STD_LOGIC_VECTOR(7 downto 0);
        pc2seg              : out STD_LOGIC_VECTOR(7 downto 0);
        imDataOut2seg       : out STD_LOGIC_VECTOR(11 downto 0);
        aluOut2seg          : out STD_LOGIC_VECTOR(7 downto 0);
        dmDataOut2seg       : out STD_LOGIC_VECTOR(7 downto 0);
        acc2seg             : out STD_LOGIC_VECTOR(7 downto 0);
        ds2seg              : out STD_LOGIC_VECTOR(7 downto 0);
        busOut2seg          : out STD_LOGIC_VECTOR(7 downto 0)
    );
end entity EDA322_processor;

architecture Structural of EDA322_processor is
    signal pcOut, nextPC, jumpAddr, pcIncrOut   : STD_LOGIC_VECTOR(7 downto 0);
    signal imDataOut                            : STD_LOGIC_VECTOR(11 downto 0);
    signal imDataOut_LSB                        : STD_LOGIC_VECTOR(7 downto 0);
    signal dmDataOut                            : STD_LOGIC_VECTOR(7 downto 0);
    signal accOut, aluOut                       : STD_LOGIC_VECTOR(7 downto 0);
    signal busOut                               : STD_LOGIC_VECTOR(7 downto 0);
    signal busSel                               : STD_LOGIC_VECTOR(3 downto 0);
    signal pcSel, pcLd, imRead                  : STD_LOGIC;
    signal dmRead, dmWrite, accLd               : STD_LOGIC;
    signal accSel, dsLd                         : STD_LOGIC;
    signal aluOp                                : STD_LOGIC_VECTOR(1 downto 0);