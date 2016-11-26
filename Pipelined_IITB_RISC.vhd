library ieee;
use ieee.std_logic_1164.all;
library work;
use work.components.all;

entity Pipelined_IITB_RISC is
port(
		clk: in std_logic;
		reset: in std_logic
	);
end entity;
	
architecture arch of Pipelined_IITB_RISC is

	signal PC_MUX1_sel, CZ_depend: std_logic_vector(1 downto 0);
	signal PC_MUX2_sel:std_logic;
	signal	R7_ID: std_logic_vector(15 downto 0);
	signal	R7_RR: std_logic_vector(15 downto 0);
	signal	R7_EX: std_logic_vector(15 downto 0);
	signal	R7_MEM: std_logic_vector(15 downto 0);
	signal	PC_plus1, alu_out, mem_out, alu_a_input, alu_b_input, LMSM_memaddress_out: std_logic_vector(15 downto 0);
	signal	PC: std_logic_vector(15 downto 0);
	signal	IW, WB_MUX_out: std_logic_vector(15 downto 0);
	signal IF_ID_in,new_IF_ID_in: std_logic_vector(48 downto 0);
	signal IF_ID_out: std_logic_vector(48 downto 0);
	signal IF_flush, ID_flush1, ID_flush, RR_flush, EX_flush: std_logic;
	signal IF_ID_en: std_logic:='1';
	signal ID_RR_en, RR_EX_en, EX_MEM_en, MEM_WB_en: std_logic :='1';
    signal PE_Flag:  std_logic;
    signal control_word, pipelined_control_word:  std_logic_vector(14 downto 0);
    signal PE_out:  std_logic_vector(7 downto 0);
    signal Rs1:  std_logic_vector(2 downto 0);
    signal Rs2:  std_logic_vector(2 downto 0);
    signal Rd, WB_Rd:  std_logic_vector(2 downto 0);
    signal SE6:  std_logic_vector(15 downto 0);
    signal ID_MUX, EX_FWD, EX_FWD_signal, MEM_FWD, WB_FWD:  std_logic_vector(15 downto 0);--EX_FWD is output of EX stage
    signal NOP_MUX_sel, is_LMSM, is_load_type, rr_mem_read: std_logic;
    signal data_select1, data_select2: std_logic_vector(2 downto 0);
    signal R7_write: std_logic:='1';
	signal id_rr_out, id_rr_in, new_ID_RR_in: std_logic_vector(82 downto 0);
	signal RR_control_out: std_logic_vector(13 downto 0);
	signal EX_control_out: std_logic_vector(9 downto 0);
	signal MEM_control_out: std_logic_vector(7 downto 0);
	signal flush_assign: std_logic_vector(3 downto 0); 
	signal RR_EX_in, RR_EX_out, new_RR_EX_in: std_logic_vector(97 downto 0);
	signal EX_MEM_out, EX_MEM_in, new_EX_MEM_in: std_logic_vector(46 downto 0);
	signal MEM_WB_out, MEM_WB_in, new_MEM_WB_in: std_logic_vector(25 downto 0);
	signal c_out, z_out, nop_bit, updated_z_flag, new_RF_write: std_logic;
	signal global_flag_out, new_flag_write: std_logic_vector(1 downto 0);

	constant if_id_c0: std_logic_vector(48 downto 0):=(others=>'1') ;
	constant id_rr_c0: std_logic_vector(82 downto 0):=(others=>'0') ;
	constant rr_ex_c0: std_logic_vector(97 downto 0):=(others=>'0') ;
	constant ex_mem_c0: std_logic_vector(46 downto 0):=(others=>'0') ;
	constant mem_wb_c0: std_logic_vector(25 downto 0):=(others=>'0') ;
	constant c0: std_logic_vector(15 downto 0):=(others=>'0');


begin
	--PCMUX: 
	Fetch: I_Fetch port map(PC_MUX1_sel=>PC_MUX1_sel, PC_MUX2_sel=>PC_MUX2_sel, R7_ID=>R7_ID, R7_RR=>R7_RR,reset=>reset,clk=>clk,
								R7_EX=>R7_EX, R7_MEM=>R7_MEM, PC_plus1=>PC_plus1, PC=>PC, IW=>IW, R7_write=>R7_write); --IF Stage
	
	IF_ID_in(48 downto 33)<=IW; IF_ID_in(32 downto 17)<=PC_plus1; IF_ID_in(16 downto 1)<=PC; IF_ID_in(0)<=IF_flush; --input to IF/ID Register
 	
	new_IF_ID_in <= if_id_c0 when reset='1' else IF_ID_in;
	IF_ID: DataRegister generic map(data_width=>49) port map(Din=>new_IF_ID_in , Dout=>IF_ID_out , Enable=>IF_ID_en , clk=>clk); --IF/ID register

	-----------------------------------------------------------------------------------------------------------------------------------------------

	Decode: ID port map (IW=>IF_ID_out(48 downto 33), PC=>IF_ID_out(16 downto 1), PE_Flag=>PE_Flag, PE_input_sel=>ID_RR_out(0), PE_input=>ID_RR_out(65 downto 58),
							 control_word=>control_word, PE_out=>PE_out, Rs1=>Rs1, Rs2=>Rs2, Rd=>Rd, SE6=>SE6, ID_MUX=>ID_MUX, is_LMSM=>is_LMSM, CZ_depend=>CZ_depend); --decoder
	
	ID_flush<=ID_flush1 or IF_flush; --flush logic. To flush when flush was asserted in IF or ID.
	
	NOP_Staller: generic_staller generic map(data_width=>15) port map(control_word=>control_word, pipelined_control_word=>pipelined_control_word, NOP_MUX_sel=>NOP_MUX_sel, flush=>ID_flush);
--for debugging only
	--pipelined_control_word <= control_word;
--for debugging only

	-- When ID_flush = 1 or NOP_MUX_sel=0 then new control word = all 0s;
	ID_RR_in(82 downto 81)<=CZ_depend;
	ID_RR_in(80 downto 66)<=pipelined_control_word; ID_RR_in(65 downto 58)<=PE_out;ID_RR_in(57 downto 55)<=Rs1;
							ID_RR_in(54 downto 52)<=Rs2;ID_RR_in(51 downto 49)<=Rd;ID_RR_in(48 downto 33)<=SE6;
							ID_RR_in(32 downto 17)<=ID_MUX;ID_RR_in(16 downto 1)<=IF_ID_out(32 downto 17);--PC_plus1
							ID_RR_in(0)<=is_LMSM; 
	--input to ID/RR Register
	new_ID_RR_in <= id_rr_c0 when reset='1' else ID_RR_in;
	ID_RR: DataRegister generic map(data_width=>83) port map(Din=>new_ID_RR_in , Dout=>ID_RR_out , Enable=>ID_RR_en , clk=>clk); --ID/RR register


	HDU_Ctrl: HDU_Control port map (ID_R7d=>pipelined_control_word(2 downto 0), RR_R7d=>RR_control_out(2 downto 0), EX_R7d=>EX_control_out(2 downto 0),
									MEM_R7d=>MEM_control_out(2 downto 0), PC_MUX2_sel=>PC_MUX2_sel, PC_MUX1_sel=>PC_MUX1_sel, flush_assign=>flush_assign);
--for debugging only
	--flush_assign(3 downto 0)<="0000";
	--PC_MUX1_sel<="00";
	--PC_MUX2_sel<='0';
--for debugging only

	IF_flush<=flush_assign(3);
	ID_flush1<=flush_assign(2);
	RR_flush<=flush_assign(1);
	EX_flush<=flush_assign(0);

	rr_mem_read <= (not id_rr_out(73)) and (ID_RR_out(72));
	HDU_d: HDU_Data port map(source_reg_address1=>Rs1, source_reg_address2=>Rs2, instruction_word=>IF_ID_out(48 downto 33), rr_mem_read=>rr_mem_read,
		   rr_z_en=>ID_RR_out(69), PE_Flag=>PE_Flag, rr_destination_reg_address=>ID_RR_out(51 downto 49), R7_en=>R7_write, IF_ID_en=>IF_ID_en, NOP_MUX_sel=>NOP_MUX_sel);
	-----------------------------------------------------------------------------------------------------------------------------------------------
	FW1: data_forwarding_block port map(source_reg_address=>ID_RR_out(57 downto 55), ex_RF_write=>RR_EX_out(73),--RF_write
										ex_destination_reg_address=>RR_EX_out(35 downto 33),--Rd
										mem_RF_write=>EX_MEM_out(26), mem_destination_reg_address=>EX_MEM_out(2 downto 0),RR_d3_mux_sel=>ID_RR_out(73 downto 72),
										wb_RF_write=>new_RF_write, wb_destination_reg_address=>MEM_WB_out(20 downto 18), data_select=>data_select1);

	
	FW2: data_forwarding_block port map(source_reg_address=>ID_RR_out(54 downto 52), ex_RF_write=>RR_EX_out(73),
										ex_destination_reg_address=>RR_EX_out(35 downto 33),RR_d3_mux_sel=>ID_RR_out(73 downto 72),
										mem_RF_write=>EX_MEM_out(26), mem_destination_reg_address=>EX_MEM_out(2 downto 0), 
										wb_RF_write=>new_RF_write, wb_destination_reg_address=>MEM_WB_out(20 downto 18), data_select=>data_select2);

	Flag_FW: flag_forwarding_block port map(ex_flag_en=>RR_EX_out(72 downto 71), mem_flag_en=>EX_MEM_out(25 downto 24), wb_flag_en=>MEM_WB_out(22 downto 21),
											ex_flag_value(1)=>c_out, ex_flag_value(0)=>z_out,
											mem_flag_value(1)=>MEM_WB_in(1), mem_flag_value(0)=>MEM_WB_in(0), wb_flag_value=>MEM_WB_out(17 downto 16),global_flag_value=>global_flag_out, CZ_dependence=>ID_RR_out(82 downto 81),
											nop_bit=>nop_bit); 

	RR_Staller: generic_staller generic map (data_width=>14) port map(control_word=>ID_RR_out(79 downto 66), pipelined_control_word=>RR_control_out, NOP_MUX_sel=>nop_bit, flush=>RR_flush); --NOP dependent only on flush bit here
--for debugging only
	--RR_control_out<= ID_RR_out(79 downto 66);
--for debugging only

	RRead: RR port map (RF_write=>new_RF_write, reg_file_A1=>ID_RR_out(57 downto 55), reg_file_A2=>ID_RR_out(54 downto 52), reg_file_A3=>WB_Rd, 
						reg_file_D3=>WB_FWD, ex_data=>EX_FWD, mem_data=>MEM_FWD, wb_data=>WB_FWD, incremented_PC=>ID_RR_out(16 downto 1), 
						input1_mux_sel=>data_select1, input2_mux_sel=>data_select2, is_LMSM=>RR_EX_out(16),--is_LMSM
						LMSM_memaddress_in=>RR_EX_out(15 downto 0), --RA+1
						alu_a_input=>alu_a_input,
						alu_b_input=>alu_b_input, LMSM_memaddress_out=>LMSM_memaddress_out,reset=>reset,clk=>clk);
 --whether to make NOP or not for CZ dependent
	RR_EX_in(97 downto 82)<=ID_RR_out(32 downto 17);--LHI
	RR_EX_in(81 downto 68)<=RR_control_out; RR_EX_in(67 downto 52)<=alu_a_input;--Rs1
							RR_EX_in(51 downto 36)<=alu_b_input;--Rs2
							RR_EX_in(35 downto 33)<=ID_RR_out(51 downto 49);--Rd
							RR_EX_in(32 downto 17)<=ID_RR_out(48 downto 33);--SE6
							RR_EX_in(16)<=ID_RR_out(0);--is_LMSM
							RR_EX_in(15 downto 0)<=LMSM_memaddress_out;--RA+1
	--input to RR/EX Register
	new_RR_EX_in <= rr_ex_c0 when reset='1' else RR_EX_in;
	RR_EX: DataRegister generic map(data_width=>98) port map(Din=>new_RR_EX_in , Dout=>RR_EX_out , Enable=>RR_EX_en , clk=>clk); --ID/RR register

--------------------------------------------------------------------------------------------------------------------------------------------------------

	Execute: EX port map (Rs1=>RR_EX_out(67 downto 52), Rs2=>RR_EX_out(51 downto 36), SE_6=>RR_EX_out(32 downto 17), alu_a_sel=>RR_EX_out(79), 
						alu_b_sel=>RR_EX_out(78), alu_op=>RR_EX_out(81 downto 80), alu_out=>alu_out, c_out=>c_out, z_out=>z_out);
	
	CZ_Staller: generic_staller generic map (data_width=>10) port map(control_word=>RR_EX_out(77 downto 68), pipelined_control_word=>EX_control_out, NOP_MUX_sel=>'1', flush=>EX_flush);
--for debugging only
	--EX_control_out <= RR_EX_out(77 downto 68);
--for debugging only

	EX_MEM_in(46 downto 31)<=RR_EX_out(67 downto 52);
	EX_MEM_in(30 downto 21)<=EX_control_out;--ControlWord
	--EX_MEM_in(68 downto 53)<=RR_EX_out(97 downto 82);--LHI or PC+IMM
	--EX_MEM_in(52 downto 37)<=RR_EX_out(15 downto 0); --RA+1
	--EX_MEM_in(36 downto 21)<=alu_out;
	EX_MEM_in(20 downto 5)<=EX_FWD;
	EX_MEM_in(4)<=c_out;
	EX_MEM_in(3)<=z_out;
	--EX_MEM_in(18 downto 3)<=RR_EX_out(67 downto 52);--Rs1
	EX_MEM_in(2 downto 0)<=RR_EX_out(35 downto 33); --Rd

	EX_FWD_MUX: mux_4to1 port map(input0=>alu_out, input1=>alu_out, input2=>RR_EX_out(97 downto 82), input3=>RR_EX_out(67 downto 52), output0=>EX_FWD_signal, select_signal=>EX_control_out(7 downto 6));
	EX_FWD_MUX2: mux_2to1 port map(input0=>EX_FWD_signal, input1=>RR_EX_out(15 downto 0), output0=>EX_FWD, select_signal=>RR_EX_out(16));
	--input to EX/MEM Register
	new_EX_MEM_in <= ex_mem_c0 when reset='1' else EX_MEM_in;
	EX_MEM: DataRegister generic map(data_width=>47) port map(Din=>new_EX_MEM_in , Dout=>EX_MEM_out , Enable=>EX_MEM_en , clk=>clk); --ID/RR register

--------------------------------------------------------------------------------------------------------------------------------------------------------
	is_load_type<=(not EX_MEM_out(28)) and EX_MEM_out(27);

	Memory: MEM port map(Rs1=>EX_MEM_out(46 downto 31), mem_address_sel=>EX_MEM_out(30), mem_in=>EX_MEM_out(20 downto 5), mem_write=>EX_MEM_out(29), mem_out=>mem_out, clk=>clk, z_flag_in=>EX_MEM_out(3), z_enable=>EX_MEM_out(24),
						 is_load_type=>is_load_type,
						 updated_z_flag=>updated_z_flag);


	MEM_Staller: generic_staller generic map (data_width=>8) port map(control_word=>EX_MEM_out(28 downto 21), pipelined_control_word=>MEM_control_out, NOP_MUX_sel=>'1', flush=>reset); --NOP dependent only on reset bit here
--for debugging only
	--MEM_control_out <= EX_MEM_out(28 downto 24);
--for debugging only

	MEM_FWD_MUX: mux_2to1 port map(input0=>EX_MEM_out(20 downto 5),--alu_out or shifted or Rs1
									 input1=>mem_out, output0=>MEM_FWD, select_signal=>is_load_type);

	 
	MEM_WB_in(25 downto 21)<=MEM_control_out(7 downto 3); MEM_WB_in(20 downto 18)<=EX_MEM_out(2 downto 0);--Rd
	MEM_WB_in(17 downto 2)<=MEM_FWD; --D3
	MEM_WB_in(1)<=EX_MEM_out(4); MEM_WB_in(0)<=updated_z_flag;

	new_MEM_WB_in <= mem_wb_c0 when reset='1' else MEM_WB_in;
	MEM_WB: DataRegister generic map(data_width=>26) port map(Din=>new_MEM_WB_in , Dout=>MEM_WB_out , Enable=>MEM_WB_en , clk=>clk); --MEM/WB register

--------------------------------------------------------------------------------------------------------------------------------------------------------

	new_RF_write <= MEM_WB_out(23)	and (not reset);
	new_flag_write(1) <= MEM_WB_out(22) and (not reset);
	new_flag_write(0) <= MEM_WB_out(21) and (not reset);

	Write_Back: WB port map (flag_out(1)=>MEM_WB_out(1), flag_out(0)=>MEM_WB_out(0),clk=>clk,reset=>reset, global_flag_out=>global_flag_out,
							 flag_write=>new_flag_write);

	WB_FWD<=MEM_WB_out(17 downto 2);
	WB_RD<=MEM_WB_out(20 downto 18);


end architecture ; -- arch