library ieee;
use ieee.std_logic_1164.all;
library work;
use work.components.all;

entity Decoder is
port(
		instruction_word: in std_logic_vector(15 downto 0);
		control_word: out std_logic_vector(19 downto 0); 
		Rs1: out std_logic_vector(2 downto 0); 
		Rs2: out std_logic_vector(2 downto 0); 
		Rd: out std_logic_vector(2 downto 0)
	);
end entity;

architecture arch of Decoder is
-- x = 0

signal c1,c2,ID_select, RR_select, d1,d2,d3,EX_select_1,EX_select_2,LW_select,LM_select :std_logic; 
signal If_R7_Ra,If_R7_Rb,If_R7_Rc,If_R7_LM :std_logic;
signal R7d_select_ID, R7d_select_RR, R7d_select_EX, R7d_select_MEM :std_logic; 

begin
control_word(19)<='1' when instruction_word(15 downto 12) = "0111";
control_word(18)<='1' when instruction_word(15 downto 12) = "0110";
control_word(17 downto 3)<=      "000000000000111" when (instruction_word(15 downto 12)="0000")
							else "000000010000111" when (instruction_word(15 downto 12)="0001")
							else "000001000000101" when (instruction_word(15 downto 12)="0010")
							else "000000000010100" when (instruction_word(15 downto 12)="0011")
							else "000000100001101" when (instruction_word(15 downto 12)="0100")
							else "000000100100000" when (instruction_word(15 downto 12)="0101")	
							else "001100000001100" when (instruction_word(15 downto 12)="0110")
							else "001100001100000" when (instruction_word(15 downto 12)="0111")
							else "100000000011000" when (instruction_word(15 downto 12)="1000")
							else "000000000011000" when (instruction_word(15 downto 12)="1001")
							else "010010000000000" when (instruction_word(15 downto 12)="1100")
			;
c1<= '1' when instruction_word(15 downto 12) ="0011" else '0';
c2<= '1' when instruction_word(15 downto 12) ="1000" else '0';
ID_select<= c1 or c2; 

RR_select<= '1' when instruction_word(15 downto 12) ="1001" else '0';

d1<= '1' when instruction_word(15 downto 12) ="1100" else '0'; --BEQ 
d2<= '1' when instruction_word(15 downto 12) ="0000" else '0'; -- ADD 
d3<= '1' when instruction_word(15 downto 12) ="0010" else '0'; --NAND 
EX_select_1<= d2 or d3; -- All arithmetic operations without Immediate 

EX_select_2<= '1' when instruction_word(15 downto 12) ="0001" else '0'; --ADI 

LW_select<='1' when instruction_word(15 downto 12) ="0100" else '0';
LM_select<='1' when instruction_word(15 downto 12) ="0110" else '0';

If_R7_Ra<= '1' when instruction_word(11 downto 9) ="111" else '0'; -- LHI, LW 
If_R7_Rb<= '1' when instruction_word(8 downto 6) ="111" else '0'; -- ADI
If_R7_Rc<= '1' when instruction_word(5 downto 3) ="111" else '0'; -- All Arithmetic operations 
If_R7_LM<= '1' when instruction_word(7) ='1' else '0';

R7d_select_ID<= (c1 and If_R7_Ra) or c2 ; 
R7d_select_RR<= (RR_select);
R7d_select_MEM<= (LW_select and If_R7_Ra) or (If_R7_LM and LM_select);
R7d_select_EX<= (EX_select_1 and If_R7_Rc) or d1 or ( EX_select_2 and If_R7_Rb);


control_word(2 downto 0)<=  "001" when R7d_select_ID ='1' else 
      						  "011" when R7d_select_EX ='1' else 
						      "010" when R7d_select_RR ='1' else 
						      "100" when R7d_select_MEM ='1' else 
						      "000" ; 

--Deciding Rs1, Rs2 and Rd 
Rs1<= instruction_word(11 downto 9) when EX_select_1='1' else  -- All arithmetic operations without Immediate 
      instruction_word(11 downto 9) when EX_select_2='1' else  -- ADI 
      instruction_word(8 downto 6) when LW_select='1' else -- LW 
      instruction_word(11 downto 9) when LM_select='1' else -- LM 
      instruction_word(11 downto 9) when d1='1' else -- BEQ 
      instruction_word(8 downto 6) when instruction_word(15 downto 12) ="1001" else -- JLR
      instruction_word(11 downto 9) when instruction_word(15 downto 12) ="0101" else -- SW
      "000";


Rs2<= instruction_word(8 downto 6) when EX_select_1='1' else 
      instruction_word(8 downto 6) when d1='1' else 
      instruction_word(8 downto 6) when instruction_word(15 downto 12) ="0101" else-- SW
      instruction_word(11 downto 9) when LM_select='1' else -- LM
      instruction_word(11 downto 9) when instruction_word(15 downto 12) = "0111" else--SM 
      "000";



Rd<=instruction_word(5 downto 3) when EX_select_1='1' else 
    instruction_word(8 downto 6) when EX_select_2='1' else 
    instruction_word(11 downto 9) when ID_select='1' else --LHI and JAL have no Rs1 and Rs2 
    instruction_word(11 downto 9) when LW_select='1' else 
    instruction_word(11 downto 9) when instruction_word(15 downto 12) ="1001" else-- JLR
    "000";


 -- ADD mux for SM and LM instructions for the PE outputs 
    

end arch;











