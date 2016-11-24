library ieee;
use ieee.std_logic_1164.all;
library work;
use work.components.all;

entity Decoder is
port(
		instruction_word: in std_logic_vector(15 downto 0);
		control_word: out std_logic_vector(17 downto 0); 
		R7d: out std_logic_vector(3 downto 0);
);
end entity;

architecture arch of Decoder is
-- x = 0
control_word<="000000000000111" when (instruction_word(15 downto 12)="0000")
			else "000000010000111" when (instruction_word(15 downto 12)="0001")
			else "000001000000101" when (instruction_word(15 downto 12)="0010")
			else "000000000010100" when (instruction_word(15 downto 12)="0011")
			else "000000100001101" when (instruction_word(15 downto 12)="0100")
			else "000000100100000" when (instruction_word(15 downto 12)="0101")	
			else "001100000001100" when (instruction_word(15 downto 12)="0110")
			else "001100001100000" when (instruction_word(15 downto 12)="0111")
			else "100000000011000" when (instruction_word(15 downto 12)="1000")
			else "000000000011000" when (instruction_word(15 downto 12)="1001")
			else "010010000000000" when (instruction_word(15 downto 12)="1100");





