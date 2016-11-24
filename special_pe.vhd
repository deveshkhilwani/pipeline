library ieee;
use ieee.std_logic_1164.all;
library work;
use work.components.all;

entity priority_encoder is
   port(input: in std_logic_vector(7 downto 0);
   	from_reg: in std_logic_vector(7 downto 0) ;
	input_sel,clk: in std_logic;

   	to_reg: out std_logic_vector(7 downto 0);
	output: out std_logic_vector(2 downto 0);
	flag: out std_logic);
end entity;

architecture arrange of priority_encoder is
  signal y,a,modified_input:std_logic_vector(7 downto 0);
  signal select_reg_out,select_reg_in: std_logic_vector(0 downto 0) ;
  signal s:std_logic_vector(2 downto 0);
  signal x0,x1,x2,x3,x4,x5,x6,x7: std_logic;

begin

x0<=a(0); x1<=a(1); x2<=a(2); x3<=a(3); x4<=a(4); x5<=a(5); x6<=a(6); x7<=a(7);
s(0) <= ( x1 and not x0 ) or
 ( x3 and not x2 and not x1 and not x0 ) or
( x5 and not x4 and not x3 and not x2 and
 not x1 and not x0 ) or
( x7 and not x6 and not x5 and not x4
 and not x3 and not x2 and not x1
and not x0 );

s(1) <= ( x2 and not x1 and not x0 ) or
( x3 and not x2 and not x1 and not x0 ) or
 ( x6 and not x5 and not x4 and not x3 and
not x2 and not x1 and not x0 ) or
 ( x7 and not x6 and not x5 and not x4 and
not x3 and not x2 and not x1 and not x0 ) ;

s(2) <= ( x4 and not x3 and not x2 and
not x1 and not x0 ) or
 ( x5 and not x4 and not x3 and not x2 and
not x1 and not x0 ) or
 ( x6 and not x5 and not x4 and not x3
and not x2 and not x1 and not x0 ) or
 ( x7 and not x6 and not x5 and not x4 and not x3
and not x2 and not x1 and not x0 ) ;


	--x(1)<= (a(2) and (not(a(1)) and (not(a(0))

	output(2) <= s(2);
	output(1) <= s(1);
	output(0) <= s(0);

	flag <= modified_input(0) or modified_input(1) or modified_input(2) or modified_input(3) or modified_input(4)
			 or modified_input(5) or modified_input(6) or modified_input(7);

	y(7) <= a(6) or a(5) or a(4) or a(3) or a(2) or a(1) or a(0);
	y(6) <= a(5) or a(4) or a(3) or a(2) or a(1) or a(0);
	y(5) <= a(4) or a(3) or a(2) or a(1) or a(0);
	y(4) <= a(3) or a(2) or a(1) or a(0);
	y(3) <= a(2) or a(1) or a(0);
	y(2) <= a(1) or a(0);
	y(1) <= a(0);
	y(0) <= '0';
	modified_input <= a and y;
--y(i) is '0' if y(0) to y(i-1) are all '0'
--Thus, modified_input(i) is unchanged if there is at least one less significant position with a '1'
	a<=from_reg when select_reg_out="1" else
		input;
	to_reg <= modified_input;

	select_reg_in(0) <= input_sel;
	store: DataRegister generic map(data_width=>1) port map(Din=>select_reg_in , Dout=>select_reg_out , Enable=>'1' , clk=>clk);

end arrange;





