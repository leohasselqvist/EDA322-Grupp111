library ieee;
use ieee.std_logic_1164.all;

entity EDA322_processor is
    generic (dInitFile : string := "d_memory_lab2.mif";
             iInitFile : string := "i_memory_lab2.mif");
    port(
        clk                : in  std_logic;
        resetn             : in  std_logic;
        master_load_enable : in  std_logic;
        extIn              : in  std_logic_vector(7 downto 0);
        pc2seg             : out std_logic_vector(7 downto 0);
        imDataOut2seg      : out std_logic_vector(11 downto 0);
        dmDataOut2seg      : out std_logic_vector(7 downto 0);
        aluOut2seg         : out STD_LOGIC_VECTOR(7 downto 0);
        acc2seg            : out std_logic_vector(7 downto 0);
        busOut2seg         : out std_logic_vector(7 downto 0);
        ds2seg             : out std_logic_vector(7 downto 0)
    );
end EDA322_processor;

architecture Structural of EDA322_processor is
	signal bussOut: std_logic_vector(7 downto 0);
	signal pcSel: std_logic;
	signal pcLd: std_logic;
	signal imRead: std_logic;
	signal bussSel: std_logic_vector(3 downto 0);
	signal imDataOut: std_logic_vector(11 downto 0);
	signal opcode: std_logic_vector(3 downto 0);
	signal imVar: std_logic_vector(7 downto 0);

	signal pcIncrOut: std_logic_vector(7 downto 0);
	signal jumpAddr: std_logic_vector(7 downto 0);
	signal nextPC: std_logic_vector(7 downto 0);
	signal pcOut: std_logic_vector(7 downto 0);
	signal bussOutExtend: std_logic_vector(7 downto 0);
	signal bussOutComp: std_logic_vector(7 downto 0);

	signal dmRead: std_logic;
	signal dmWrite: std_logic;
	signal aluOp: std_logic_vector(1 downto 0);
	signal accSel: std_logic;
	signal accLd: std_logic;
	signal flagLd: std_logic;
	signal dsLd: std_logic;
	
	signal accMuxOut: std_logic_vector(7 downto 0);
	signal accOut: std_logic_vector(7 downto 0);
	signal dmDataOut: std_logic_vector(7 downto 0);
	signal aluOut: std_logic_vector(7 downto 0);
	signal E: std_logic;
	signal C: std_logic;
	signal Z: std_logic;
	signal EregOut: std_logic;
	signal CregOut: std_logic;
	signal ZregOut: std_logic;
	begin
		
		iMemory: entity work.memory(Behavior)
			generic map (
				INIT_FILE => iInitFile
			)
			port map(
				readEn => imRead,
				dataOut => imDataOut,
				address => pcOut,
				dataIn => "111111111111",
				writeEn => '0',
				clk => clk
			);
		imDataOut2seg <= imDataOut;
		opcode <= imDataOut(11 downto 8);
		imVar <= imDataOut(7 downto 0);
		faTop: entity work.rca(Structural)
			port map(
				a => pcOut,
				b => "00000001",
				cin => '0',
				s => pcIncrOut
			);
		bussOutExtend <= ("0" & bussOut(6 downto 0));
		bussOutComp <= not(bussOutExtend) when (bussOut(7) = '1') else bussOutExtend;
		faBot: entity work.rca(Structural)
			port map(
				a => pcOut,
				b => bussOutComp,
				cin => bussOut(7),
				s => jumpAddr
			);
		
		
		pcMux: entity work.mux2(Dataflow)
			port map (
				s => pcSel,
				i0 => pcIncrOut,
				i1 => jumpAddr,
				o => nextPC
			);
		pcReg: entity work.regn(Behavior)
			port map (
				dataIn => nextPC,
				loadEnable => pcLd,
				dataOut => pcOut,
				clk => clk,
				resetn => '1'
			);




		dMemory: entity work.memory(Behavior)
			generic map (
				DATA_WIDTH => 8,
				INIT_FILE => dInitFile
			)
			port map(
				readEn => dmRead,
				writeEn => dmWrite,
				address => bussOut,
				dataIn => accOut,
				dataOut => dmDataOut,
				clk => clk
			);
		dmDataOut2seg <= dmDataOut;
		
		alu: entity work.alu_wRCA(Structural)
			port map(
				alu_inA => accOut,
				alu_inB => bussOut,
				alu_op => aluOp,
				alu_out => aluOut,
				E => E,
				C => C,
				Z => Z
			);
		aluOut2seg <= aluOut;

		accMux: entity work.mux2(Dataflow)
			port map (
				s => accSel,
				i0 => aluOut,
				i1 => bussOut,
				o => accMuxOut
			);
		accReg: entity work.regn(Behavior)
			port map (
				dataIn => accMuxOut,
				loadEnable => accLd,
				dataOut => accOut,
				clk => clk,
				resetn => '1'
			);
		acc2seg <= accOut;

		dsReg: entity work.regn(Behavior)
			port map (
				dataIn => accOut,
				loadEnable => dsLd,
				dataOut => ds2seg,
				clk => clk,
				resetn => '1'
			);
		
		
		Ereg: entity work.reg1(Behavior)
			port map (
				dataIn => E,
				loadEnable => flagLd,
				dataOut => EregOut,
				clk => clk,
				resetn => '1'
			);
		Creg: entity work.reg1(Behavior)
			port map (
				dataIn => C,
				loadEnable => flagLd,
				dataOut => CregOut,
				clk => clk,
				resetn => '1'
			);
		Zreg: entity work.reg1(Behavior)
			port map (
				dataIn => Z,
				loadEnable => flagLd,
				dataOut => ZregOut,
				clk => clk,
				resetn => '1'
			);
		


		internalBuss: entity work.proc_bus(Behavior)
			port map (
				imDataOut => imVar,
				dmDataOut => dmDataOut,
				accOut => accOut,
				extIn => extIn,
				bussSel => bussSel,
				bussOut => bussOut
			);
		busOut2seg <= bussOut;
		
		controller: entity work.proc_controller
			port map(
				clk => clk,
				resetn => resetn,
				master_load_enable => master_load_enable,
				opcode => opcode,
				e_flag => EregOut,
				z_flag => ZregOut,


				busSel => bussSel,
				pcSel => pcSel,
				pcLd => pcLd,
				imRead => imRead,
				dmRead => dmRead,
 				dmWrite => dmWrite,
				aluOp => aluOp,
				flagLd => flagLd,
				accSel => accSel,
				accLd => accLd,
				dsLd => dsLd
			);
	end Structural;
	