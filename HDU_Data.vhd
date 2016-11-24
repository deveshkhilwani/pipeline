library ieee;
use ieee.std_logic_1164.all;
library work;
use work.components.all;

entity HDU_Data is
port(
	source_reg_address1: in std_logic_vector(2 downto 0);
	source_reg_address2: in std_logic_vector(2 downto 0);
	instruction_word: in std_logic_vector(15 downto 0);
	rr_mem_write: in std_logic;
	rr_z_en: in std_logic;
	rr_destination_reg_address: in std_logic_vector(2 downto 0);
	R7_en: out std_logic;
	IF_ID_en: out std_logic;
	NOP_mux_sel: out std_logic
);
end entity;

architecture arch of HDU_Data is

	signal isANZ, isLW, isLM, source1_compare,source2_compare,stall: std_logic;

begin
--data hazard stalls
c1: comparator3 port map (x=>rr_destination_reg_address, y=>source_reg_address1, equal_flag=>source1_compare);
c2: comparator3 port map (x=>rr_destination_reg_address, y=>source_reg_address2, equal_flag=>source2_compare);

isLW<=rr_mem_write and rr_z_en;
isLM<=rr_mem_write and (not rr_z_en);

i1: comparator5 port map(x(4)=>instruction_word(15), x(3)=>instruction_word(14), x(2)=>instruction_word(12), x(1)=>instruction_word(1), x(0)=>instruction_word(0), y=>"00001", equal_flag=>isANZ);

stall<=((source1_compare or source2_compare) and (isLW or isLM)) or (isANZ and isLW);


R7_en<= not stall;
IF_ID_en<= not stall;
NOP_mux_sel<= not stall;  --if NOP_MUX_sel = 0, RW,FW,MW = 000; 

end arch ; -- arch