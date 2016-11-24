library std;
library ieee;
use ieee.std_logic_1164.all;

package components is

    component priority_encoder_4to2 is
        port(
            x : in  std_logic_vector(3 downto 0);
            y : out std_logic_vector(1 downto 0)
            );
    end component;

    component comparator3 is
    	port(
			x: in std_logic_vector(2 downto 0) ;
			y: in std_logic_vector(2 downto 0);
			equal_flag: out std_logic
			);
    end component;

     component comparator5 is
    	port(
			x: in std_logic_vector(4 downto 0) ;
			y: in std_logic_vector(4 downto 0);
			equal_flag: out std_logic
			);
    end component;

    component DataRegister is
        generic (data_width:integer);
        port (Din: in std_logic_vector(data_width-1 downto 0);
              Dout: out std_logic_vector(data_width-1 downto 0);
              clk, enable: in std_logic);
    end component;

    component mux_4to1 is
      port (
        input1: in std_logic_vector(15 downto 0) ;
        input2: in std_logic_vector(15 downto 0) ;
        input3: in std_logic_vector(15 downto 0) ;
        input0: in std_logic_vector(15 downto 0) ;
        output0: out std_logic_vector(15 downto 0) ;
        select_signal: out std_logic_vector(1 downto 0)
      ) ;
    end component ; -- mux_4to1
    component mux_2to1 is
      port (
        input1: in std_logic_vector(15 downto 0) ;
        input0: in std_logic_vector(15 downto 0) ;
        output0: out std_logic_vector(15 downto 0) ;
        select_signal: in std_logic
      ) ;
    end component ; -- mux_4to1


end package;  -- components 
