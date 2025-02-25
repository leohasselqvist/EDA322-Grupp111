library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity memory is
	generic (DATA_WIDTH 		:INTEGER := 12;
		ADDR_WIDTH	 	:INTEGER := 8;
		INIT_FILE 		:STRING  := "i_memory_lab2.mif"
	);
	port (  dataIn			:IN	STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0);
		address			:IN	STD_LOGIC_VECTOR(ADDR_WIDTH-1 DOWNTO 0);
		writeEn,clk,readEn	:IN	STD_LOGIC;
		dataOut			:OUT	STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0)
	);
end memory;

architecture Behavior of memory is


type MEMORY_ARRAY is ARRAY (0 TO (2**ADDR_WIDTH)-1) OF STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0);	

impure function init_memory_wfile(mif_file_name : in string) return MEMORY_ARRAY is
    file mif_file : text open read_mode is mif_file_name;
    variable mif_line : line;
    variable temp_bv : bit_vector(DATA_WIDTH-1 downto 0);
    variable temp_mem : MEMORY_ARRAY;
begin
    for i in MEMORY_ARRAY'range loop
        readline(mif_file, mif_line);
        read(mif_line, temp_bv);
        temp_mem(i) := to_stdlogicvector(temp_bv);
    end loop;
    return temp_mem;
end function;


signal I_mem : MEMORY_ARRAY := init_memory_wfile(INIT_FILE);
begin
	process(clk)
	begin
		if ((clk'EVENT and clk = '1')) then
			if (readEn = '1') then
				dataOut <= I_mem(to_integer(unsigned(address)));
			end if;
			if (writeEn = '1') then
				I_mem(to_integer(unsigned(address))) <= dataIn;
			end if;
		end if;
	end process;
end behavior;