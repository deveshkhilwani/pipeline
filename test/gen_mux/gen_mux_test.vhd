library ieee;
use ieee.std_logic_1164.all;
library std;
use std.textio.all;
use ieee.numeric_std.all;

entity gen_mux_test is
end entity;
architecture Behave of gen_mux_test is
  component generic_mux_2to1 is
  generic(data_width:integer);
   port(
  input0: in std_logic_vector(data_width-1 downto 0) ;    --selct is '0'
  input1: in std_logic_vector(data_width-1 downto 0) ;    --selct is '1'
  output0: out std_logic_vector(data_width-1 downto 0) ;
  select_signal: in std_logic);
  end component;

  signal length: integer:=2 ;
  signal x,y,z: std_logic_vector(length-1 downto 0) := (others=>'0');
  signal s: std_logic_vector(0 downto 0):="0";

  function to_string(x: string) return string is
      variable ret_val: string(1 to x'length);
      alias lx : string (1 to x'length) is x;
  begin  
      ret_val := lx;
      return(ret_val);
  end to_string;
  
  function to_bite(x: std_logic) return bit is
	variable b: bit;
  begin
	if (x='1') then
		b:='1';
	else
		b:='0';
	end if;
	return(b);
  end to_bite;

begin
  process 
    variable err_flag : boolean := false;
    File INFILE: text open read_mode is "gen_tracefile.txt";
    FILE OUTFILE: text  open write_mode is "gen_outputs.txt";

    ---------------------------------------------------
    -- edit the next two lines to customize
    --variable operation: bit_vector ( 1 downto 0);
    variable length_in_binary: bit_vector ( 3 downto 0);
    variable input_vector_1: bit_vector ( length-1 downto 0);
    variable input_vector_2: bit_vector ( length-1 downto 0);
    variable select_vector: bit_vector (0 downto 0);
    variable output_vector: bit_vector ( length-1 downto 0);
    ----------------------------------------------------
    variable INPUT_LINE: Line;
    variable OUTPUT_LINE: Line;
    variable LINE_COUNT: integer := 0;
    
  begin
   
    while not endfile(INFILE) loop 
          LINE_COUNT := LINE_COUNT + 1;
	
	  readLine (INFILE, INPUT_LINE);
	  read (INPUT_LINE, length_in_binary);
          LINE_COUNT := LINE_COUNT + 1;
    length <= to_integer(unsigned(to_stdlogicvector(length_in_binary)));

    readLine (INFILE, INPUT_LINE);
	  read (INPUT_LINE, input_vector_1);
    read (INPUT_LINE, input_vector_2);
    read (INPUT_LINE, select_vector);
    read (INPUT_LINE, output_vector);
             --write(OUTPUT_LINE, length);
             --writeline(OUTFILE, OUTPUT_LINE);

          --------------------------------------
          -- from input-vector to DUT inputs
	  --o <= to_stdlogicvector(operation);
    --length <= to_integer(unsigned(to_stdlogicvector(length_in_binary)));
	  x <= to_stdlogicvector(input_vector_1);
	  y <= to_stdlogicvector(input_vector_2);
	  s <= to_stdlogicvector(select_vector);
          --------------------------------------


	  -- let circuit respond.
          wait for 5 ns;

          --------------------------------------
	  -- check outputs.
             write(OUTPUT_LINE, LINE_COUNT);
             write(OUTPUT_LINE,to_string(" length is "));
             write(OUTPUT_LINE,length);
             write(OUTPUT_LINE,to_string(" inputs are "));
             write(OUTPUT_LINE,input_vector_1);
             write(OUTPUT_LINE,to_string(" of length "));
             write(OUTPUT_LINE,input_vector_1'length);
             write(OUTPUT_LINE,input_vector_2);
             write(OUTPUT_LINE,to_string(" "));
             write(OUTPUT_LINE,select_vector);
             write(OUTPUT_LINE,to_string(" required value is "));
             write(OUTPUT_LINE,output_vector);
             write(OUTPUT_LINE,to_string(" obtained value is "));
       write(OUTPUT_LINE, to_bitvector(z));
       --write(OUTPUT_LINE, output_vector);
             writeline(OUTFILE, OUTPUT_LINE);
	  if (z /= to_stdlogicvector(output_vector)) then
             write(OUTPUT_LINE,to_string("ERROR: in line "));
             write(OUTPUT_LINE, LINE_COUNT);
             write(OUTPUT_LINE,to_string(" length is "));
             write(OUTPUT_LINE,length);
             write(OUTPUT_LINE,to_string(" inputs are "));
             write(OUTPUT_LINE,input_vector_1);
             write(OUTPUT_LINE,to_string(" "));
             write(OUTPUT_LINE,input_vector_2);
             write(OUTPUT_LINE,to_string(" "));
             write(OUTPUT_LINE,select_vector);
             write(OUTPUT_LINE,to_string(" required value is "));
             write(OUTPUT_LINE,output_vector);
             write(OUTPUT_LINE,to_string(" obtained value is "));
	     write(OUTPUT_LINE, to_bitvector(z));
	     --write(OUTPUT_LINE, output_vector);
             writeline(OUTFILE, OUTPUT_LINE);
             err_flag := true;
          end if;
          --------------------------------------
    end loop;

    assert (err_flag) report "SUCCESS, all tests passed." severity note;
    assert (not err_flag) report "FAILURE, some tests failed." severity error;

    wait;
  end process;

  dut: generic_mux_2to1 generic map(data_width=>length) port map(input0=>x, input1=>y,output0=>z,select_signal=> s(0));
             
end Behave;