library ieee;
use ieee.std_logic_1164.all;
library work;
use work.components.all;

entity flag_forwarding_block is
  port (
	ex_flag_en: in std_logic_vector (1 downto 0);		--carry_enable is the significant bit
	mem_flag_en: in std_logic_vector (1 downto 0);
	wb_flag_en: in std_logic_vector (1 downto 0);

	ex_flag_value: in std_logic_vector(1 downto 0) ;	--carry_flag is the significant bit
	mem_flag_value: in std_logic_vector(1 downto 0) ;
	wb_flag_value: in std_logic_vector(1 downto 0) ;
	global_flag_vlaue: in std_logic_vector(1 downto 0) ;

	cz_dependence: in std_logic_vector(1 downto 0) ;	--carry_enable is the significant bit
	nop_bit: out std_logic 								--nop_bit is cleared when we have to convert to nop
  ) ;
end entity ; -- flag_forward_block

architecture arch of flag_forwarding_block is

	signal c_select, z_select: std_logic_vector(1 downto 0) ;
	signal c_mux_out, z_mux_out: std_logic_vector(0 downto 0) ;

begin

pe_c: priority_encoder_4to2 port map (x(3)=>ex_flag_en(1), x(2)=>mem_flag_en(1), x(1)=>wb_flag_en(1), x(0)=>'1',y=>c_select);
pe_z: priority_encoder_4to2 port map (x(3)=>ex_flag_en(0), x(2)=>mem_flag_en(0), x(1)=>wb_flag_en(0), x(0)=>'1',y=>z_select);

c_mux: generic_mux_4to1 generic map(1) port map (global_flag_vlaue(1 downto 1), wb_flag_value(1 downto 1), mem_flag_value(1 downto 1),
												ex_flag_value(1 downto 1), c_mux_out, c_select);
z_mux: generic_mux_4to1 generic map(1) port map (global_flag_vlaue(0 downto 0), wb_flag_value(0 downto 0), mem_flag_value(0 downto 0),
												ex_flag_value(0 downto 0), z_mux_out, z_select);

nop_bit <= not((cz_dependence(1) and (not c_mux_out(0))) or (cz_dependence(0) and (not z_mux_out(0))));

end architecture ; -- arch