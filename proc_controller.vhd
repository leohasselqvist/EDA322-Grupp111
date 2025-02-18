library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

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

architecture Controller of proc_controller is
	TYPE state_type IS (FE,DE1,DE2,EX,ME);
	signal curr_state : state_type;
	signal next_state : state_type;
	begin
	state_reg : process(clk, master_load_enable, resetn)   -- Process for state register (NOT FETCH)
	begin
		if resetn = '0' then
			curr_state <= FE;  -- If reset, go back to fetch
		elsif (clk'EVENT and clk = '1') then
			if master_load_enable = '1' then
				curr_state <= next_state;
			end if;
		end if;
	end process state_reg;
	combinational:  process(opcode, curr_state)  -- Process to decide next state (ALSO NOT FETCH)
	begin
		if (curr_state = FE) then
			case opcode is
				when "0001" | "0011" | "0100" | "0101" | "0110" 			   => next_state <= EX;
				when "0111" | "1000" | "1001" | "1010" | "1011" | "1100" | "1110" | "1111" => next_state <= DE1;
				when "1101"								   => next_state <= ME;
				when others								   => next_state <= FE;
			end case;
		elsif (curr_state = DE1) then
			case opcode is
				when "1110"							=> next_state <= DE2;
				when "0111" | "1000" | "1001" | "1010" | "1011" | "1100"	=> next_state <= EX;
				when "1111"							=> next_state <= ME;
				when others							=> next_state <= FE;
			end case;
		elsif (curr_state = DE2) then
			next_state <= EX;
		elsif ((curr_state = EX) or (curr_state = ME)) then
			next_state <= FE;
		end if;
	end process;
	storage:  process(opcode, e_flag)
	begin
		-- FETCH
		if (curr_state = FE) then
			imRead <= '1' and master_load_enable;
			pcSel <= '0';
			pcLd <= '1' and master_load_enable;
		elsif (curr_state = DE1) then
			if ((opcode > "0110") and not (opcode = "1110")) then
				busSel <= "0001";
				dmRead <= '1' and master_load_enable;
			end if;
		elsif (curr_state = DE2) then
			busSel <= "0010";
			dmRead <= '1' and master_load_enable;
		elsif (curr_state = ME) then
			case opcode is
				when "1101" => busSel <= "0001";
				when "1111" => busSel <= "0010";
				when others => busSel <= "0000"; -- Should never happen
			end case;
			dmWrite <= '1' and master_load_enable;
		elsif (curr_state = EX) then
			-- BusSel
			case opcode is
				when "0001"								=> busSel <= "1000";
				when "0111" | "1000" | "1001" | "1010" | "1011" | "1100" | "1110" 	=> busSel <= "0010";
				when "0100"								=> busSel <= "0100";
				when "0011" | "0101" | "0110"						=> busSel <= "0001";
				when others								=> busSel <= "0000";
			end case;
		end if;
		
	end process;
end Controller;
