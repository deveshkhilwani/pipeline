library ieee;
use ieee.std_logic_1164.all;
library work;
use work.components.all;

entity data_forwarding_block is
port(
	source_reg_address: in std_logic_vector(2 downto 0) ;
	ex_RF_write: in std_logic ;
	ex_destination_reg_address: in std_logic_vector(2 downto 0) ;
	mem_RF_write: in std_logic ;
	mem_destination_reg_address: in std_logic_vector(2 downto 0) ;
	wb_RF_write: in std_logic ;
	wb_destination_reg_address: in std_logic_vector(2 downto 0) ;
	data_select: out std_logic_vector(2 downto 0)
	);
end entity;

architecture arch of data_forwarding_block is

	signal ex_compare,mem_compare,wb_compare,ex_to_pe,mem_to_pe,wb_to_pe: std_logic;

begin
ex_compare <= (source_reg_address(0) xnor ex_destination_reg_address(0)) and (source_reg_address(1) xnor ex_destination_reg_address(1))
				and (source_reg_address(2) xnor ex_destination_reg_address(2));
ex_to_pe <= ex_compare and ex_RF_write;

mem_compare <= (source_reg_address(0) xnor mem_destination_reg_address(0)) and (source_reg_address(1) 
				xnor mem_destination_reg_address(1)) and (source_reg_address(2) xnor mem_destination_reg_address(2));
mem_to_pe <= mem_compare and mem_RF_write;

wb_compare <= (source_reg_address(0) xnor wb_destination_reg_address(0)) and (source_reg_address(1) xnor wb_destination_reg_address(1))
				and (source_reg_address(2) xnor wb_destination_reg_address(2));
wb_to_pe <= wb_compare and wb_RF_write;

pe: priority_encoder_4to2 port map (x(3)=>ex_to_pe, x(2)=>mem_to_pe, x(1)=>wb_to_pe, x(0)=>'1', y=>data_select(1 downto 0));
data_select(2) <= source_reg_address(0) and source_reg_address(1) and source_reg_address(2);


end arch ; -- arch