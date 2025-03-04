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
			next_state <= DE1;
		elsif (curr_state = DE1) then
			case opcode is
				when "0000"		=> next_state <= FE;
				when "1101" | "1111"	=> next_state <= ME;
				when "1110"		=> next_state <= DE2;
				when others		=> next_state <= EX;
			end case;
		elsif (curr_state = DE2) then
			next_state <= EX;
		elsif ((curr_state = EX) or (curr_state = ME)) then
			next_state <= FE;
		end if;
	end process;
	storage:  process(opcode, e_flag, z_flag, master_load_enable, curr_state)
	begin
		busSel <= "0000";
	        pcSel <= '0';
	        pcLd <= '0';
	        imRead <= '0';
	        dmRead <= '0';
	        dmWrite <= '0';
	        aluOp <= "00";
	        flagLd <= '0';
	        accSel <= '0';
 	        accLd <= '0';
	        dsLd <= '0';
			
		-- FETCH
		if (curr_state = FE) then
			imRead <= '1' and master_load_enable;
			pcSel <= '0';
			pcLd <= '1' and master_load_enable;
		-- DECODE 1
		elsif (curr_state = DE1) then
			if ((opcode > "0110") and not (opcode = "1101")) then
				busSel <= "0001";
				dmRead <= '1' and master_load_enable;
			end if;
		-- DECODE 2
		elsif (curr_state = DE2) then
			busSel <= "0010";
			dmRead <= '1' and master_load_enable;
		-- MEMORY
		elsif (curr_state = ME) then
			case opcode is
				when "1101" => busSel <= "0001";
				when "1111" => busSel <= "0010";
				when others => busSel <= "0000"; -- Should never happen
			end case;
			dmWrite <= '1' and master_load_enable;
		-- EXECUTE
		elsif (curr_state = EX) then
			-- BusSel
			case opcode is
				when "0001"								=> busSel <= "1000";
				when "0111" | "1000" | "1001" | "1010" | "1011" | "1100" | "1110" 	=> busSel <= "0010";
				when "0100"								=> busSel <= "0100";
				when "0011" | "0101" | "0110"						=> busSel <= "0001";
				when others								=> busSel <= "0000";
			end case;
			--PCSel
			case opcode is
				when "0100" | "0101" | "0110" 	=> pcSel <= '1';
				when others 			=> pcSel <= 'X';
			end case;
			--accSel
			case opcode is
				when "0001" | "0011" | "1100" | "1110"	=> accSel <= '1';
				when "1000" | "1001" | "1010" | "1011"	=> accSel <= '0';
				when others 				=> accSel <= 'X';
			end case;
			--aluOp
			case opcode is
				when "1000" => aluOp <= "00";
				when "1001" => aluOp <= "01";
				when "1010" => aluOp <= "10";
				when "1011" => aluOp <= "11";
				when others => aluOp <= "XX";
			end case;
			-- rest are master load enable dependant
			if (master_load_enable = '1') then
				--pcLd
				if (opcode = "0100") then
					pcLd <= '1';
				elsif ((opcode = "0101") and (e_flag = '0')) then
					pcLd <= '1';
				elsif ((opcode = "0110") and (z_flag = '1')) then
					pcLd <= '1';
				end if;
				--flagLd
				case opcode is
					when "0111" | "1000" | "1001" | "1010" |"1011"	=> flagLd <= '1';
					when others					=> flagLd <= '0';
				end case;
				--accLd
				case opcode is
					when "0001" | "0011" | "1000" | "1001" | "1010" | "1011" | "1100" | "1110"	=> accLd <= '1';
					when others									=> accLd <= '0';
				end case;
				-- dsLd
				if (opcode = "0010") then
					dsLd <= '1';
				else
					dsLd <= '0';
				end if;
			end if;
		end if;
		
	end process;
end Controller;
